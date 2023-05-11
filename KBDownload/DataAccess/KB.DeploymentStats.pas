unit KB.DeploymentStats;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB,
  KB.LoginSettings, FireDAC.Stan.Option, System.Generics.Collections, DataServices,
  BusinessObject, CommonFunctions, DataRecordList;

type
  TDeploymentStats = class(TBusinessObject)
    protected
      FDeploymentStatsID: Integer;
      FDeploymentID: Integer;
      FStatDate: TDateTime;
      FUpdateChecks: Integer;
      FDownloads: Integer;
    public
      constructor Create; overload; virtual;
      constructor Create(ADeploymentStats: TDeploymentStats); overload; virtual;
      procedure Save;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      property DeploymentStatsID: Integer read FDeploymentStatsID write FDeploymentStatsID;
      property DeploymentID: Integer read FDeploymentID write FDeploymentID;
      property StatDate: TDateTime read FStatDate write FStatDate;
      property UpdateChecks: Integer read FUpdateChecks write FUpdateChecks;
      property Downloads: Integer read FDownloads write FDownloads;
  end;

  TDeploymentStatsList = class(TDataRecordList)
    protected
      FList: TObjectList<TDeploymentStats>;
      function GetCount: Integer; override;
      function GetDeploymentStats(AIndex: Integer): TDeploymentStats;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant;  override;
      class function GetInitialSQL: TStringList;
      class function CreateDeploymentStats(ADataSet: TDataSet): TDeploymentStats;
    public
      constructor Create; overload; virtual;
      constructor Create(ADeploymentStatsList: TDeploymentStatsList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ADeploymentStats: TDeploymentStats);
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetAll: TDeploymentStatsList;
      class function GetAllForDeployment(ADeploymentID: Integer): TDeploymentStatsList;
      property DeploymentStats[AIndex: Integer]: TDeploymentStats read GetDeploymentStats; default;
  end;

implementation

{$REGION 'TDeploymentStats'}
constructor TDeploymentStats.Create;
begin
  FDeploymentStatsID := 0;
  FDeploymentID := 0;
  FStatDate := -1.00;
  FUpdateChecks := 0;
  FDownloads := 0;
end;

constructor TDeploymentStats.Create(ADeploymentStats: TDeploymentStats);
begin
  FDeploymentStatsID := ADeploymentStats.DeploymentStatsID;
  FDeploymentID := ADeploymentStats.DeploymentID;
  FStatDate := ADeploymentStats.StatDate;
  FUpdateChecks := ADeploymentStats.UpdateChecks;
  FDownloads := ADeploymentStats.Downloads;
end;

procedure TDeploymentStats.Save;
var
  LConnection: TFDConnection;
  LSettings: TKBLoginSettings;
  LUpsert: TFDStoredProc;
begin
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LUpsert := TFDStoredProc.Create(nil);
    try
      LUpsert.FetchOptions.Items := LUpsert.FetchOptions.Items - [fiMeta];
      LUpsert.StoredProcName := 'dbo.UpdateDeploymentStats';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@DeploymentStatsID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@DeploymentID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@StatDate', ftDateTime, -1, ptInput);
      LUpsert.Params.Add('@UpdateChecks', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Downloads', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@NextDeploymentStatsID', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@DeploymentStatsID').AsInteger := FDeploymentStatsID;
      LUpsert.Params.ParamByName('@DeploymentID').AsInteger := FDeploymentID;
      LUpsert.Params.ParamByName('@StatDate').AsDateTime := FStatDate;
      LUpsert.Params.ParamByName('@UpdateChecks').AsInteger := FUpdateChecks;
      LUpsert.Params.ParamByName('@Downloads').AsInteger := FDownloads;

      LUpsert.ExecProc;

      FDeploymentStatsID := LUpsert.Params.ParamByName('@NextDeploymentStatsPK').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TDeploymentStats.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('deploymentStatsId', TJsonNumber.Create(FDeploymentStatsID));
  Result.AddPair('deploymentId', TJsonNumber.Create(FDeploymentID));
  Result.AddPair('statDate', DateToISO8601(FStatDate));
  Result.AddPair('updateChecks', TJsonNumber.Create(FUpdateChecks));
  Result.AddPair('downloads', TJsonNumber.Create(FDownloads));
end;

procedure TDeploymentStats.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['downloads'] then
    FDownloads := AObject.Values['downloads'].Value.ToInteger;
  if nil <> AObject.Values['updateChecks'] then
    FUpdateChecks := AObject.Values['updateChecks'].Value.ToInteger;
  if nil <> AObject.Values['statDate'] then
    FStatDate := ISO8601ToDate(AObject.Values['statDate'].Value);
  if nil <> AObject.Values['deploymentId'] then
    FDeploymentID := AObject.Values['deploymentId'].Value.ToInteger;
  if nil <> AObject.Values['deploymentStatsId'] then
    FDeploymentStatsID := AObject.Values['deploymentStatsId'].Value.ToInteger;
end;
{$ENDREGION}

{$REGION 'TDeploymentStatsList'}
function TDeploymentStatsList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDeploymentStatsList.GetDeploymentStats(AIndex: Integer): TDeploymentStats;
begin
  Result := FList[AIndex];
end;

function TDeploymentStatsList.GetFieldCount: Integer;
begin
  Result := 5;
end;

function TDeploymentStatsList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'DeploymentStatsID';
  1: Result := 'DeploymentID';
  2: Result := 'StatDate';
  3: Result := 'UpdateChecks';
  4: Result := 'Downloads';
  end;
end;

function TDeploymentStatsList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].DeploymentStatsID;
  1: Result := Flist[ARecord].DeploymentID;
  2: Result := Flist[ARecord].StatDate;
  3: Result := Flist[ARecord].UpdateChecks;
  4: Result := Flist[ARecord].Downloads;
  end;
end;

class function TDeploymentStatsList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select DeploymentStats.DeploymentStatsID, ');
  Result.Add('DeploymentStats.DeploymentID, ');
  Result.Add('DeploymentStats.StatDate, ');
  Result.Add('DeploymentStats.UpdateChecks, ');
  Result.Add('DeploymentStats.Downloads ');
  Result.Add('From DeploymentStats ');
end;

class function TDeploymentStatsList.CreateDeploymentStats(ADataSet: TDataSet): TDeploymentStats;
begin
  Result := TDeploymentStats.Create;
  Result.DeploymentStatsID := ADataSet.Fields[0].AsInteger;
  Result.DeploymentID := ADataSet.Fields[1].AsInteger;
  Result.StatDate := ADataSet.Fields[2].AsDateTime;
  Result.UpdateChecks := ADataSet.Fields[3].AsInteger;
  Result.Downloads := ADataSet.Fields[4].AsInteger;
end;

constructor TDeploymentStatsList.Create;
begin
  inherited Create;
  FList := TObjectList<TDeploymentStats>.Create(TRUE);
end;

constructor TDeploymentStatsList.Create(ADeploymentStatsList: TDeploymentStatsList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TDeploymentStats>.Create(TRUE);
  for i := 0 to (ADeploymentStatsList.Count - 1) do 
    FList.Add(TDeploymentStats.Create(ADeploymentStatsList[i]));
end;

destructor TDeploymentStatsList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TDeploymentStatsList.Clear;
begin
  FList.Clear;
end;

procedure TDeploymentStatsList.Add(ADeploymentStats: TDeploymentStats);
begin
  FList.Add(ADeploymentStats);
end;

function TDeploymentStatsList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TDeploymentStatsList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LListItem: TDeploymentStats;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LListItem := TDeploymentStats.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TDeploymentStatsList.GetAll: TDeploymentStatsList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TKBLoginSettings;
  LRecord: TDeploymentStats;
begin
  Result := nil;
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;
  try
    LQuery := TDataServices.GetQuery(LConnection);
    try
      LSQL := GetInitialSQL;
      try
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TDeploymentStatsList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateDeploymentStats(LQuery);
          Result.Add(LRecord);
          LQuery.Next;
        end;
      end;
    finally
      LQuery.Close;
      LQuery.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;

class function TDeploymentStatsList.GetAllForDeployment(ADeploymentID: Integer): TDeploymentStatsList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TKBLoginSettings;
  LRecord: TDeploymentStats;
begin
  Result := nil;
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;
  try
    LQuery := TDataServices.GetQuery(LConnection);
    try
      LSQL := GetInitialSQL;
      LSQL.Add('Where DeploymentStats.DeploymentID=' + IntToStr(ADeploymentID) + ' ');
      try
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TDeploymentStatsList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateDeploymentStats(LQuery);
          Result.Add(LRecord);
          LQuery.Next;
        end;
      end;
    finally
      LQuery.Close;
      LQuery.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;
{$ENDREGION}

end.
