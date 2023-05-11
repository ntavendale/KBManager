unit StatList;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils, Data.DB,
  System.Generics.Collections, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Option,
  DBLoginSettings, CommonFunctions, DataServices, DataRecordList, BusinessObject;

type
  TStatList = class(TBusinessObject)
    protected
      FStatListID: Integer;
      FCreated: TDateTime;
      FModified: TDateTime;
      FModifier: String;
      FCurKBDownloads: Integer;
    public
      constructor Create; overload; virtual;
      constructor Create(AStatList: TStatList); overload; virtual;
      procedure Save;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      property StatListID: Integer read FStatListID write FStatListID;
      property Created: TDateTime read FCreated write FCreated;
      property Modified: TDateTime read FModified write FModified;
      property Modifier: String read FModifier write FModifier;
      property CurKBDownloads: Integer read FCurKBDownloads write FCurKBDownloads;
  end;

  TStatListList = class(TDataRecordList)
    protected
      FList: TObjectList<TStatList>;
      function GetCount: Integer; override;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant; override;
      function GetStatList(AIndex: Integer): TStatList;
      class function GetInitialSQL: TStringList;
      class function CreateStatList(ADataSet: TDataSet): TStatList;
    public
      constructor Create; overload; virtual;
      constructor Create(AStatListList: TStatListList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(AStatList: TStatList);
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetAll: TStatListList;
      property StatList[AIndex: Integer]: TStatList read GetStatList; default;
  end;

implementation

{$REGION 'TStatList'}
constructor TStatList.Create;
begin
  FStatListID := 0;
  FCreated := -1.00;
  FModified := -1.00;
  FModifier := '';
  FCurKBDownloads := 0;
end;

constructor TStatList.Create(AStatList: TStatList);
begin
  FStatListID := AStatList.StatListID;
  FCreated := AStatList.Created;
  FModified := AStatList.Modified;
  FModifier := AStatList.Modifier;
  FCurKBDownloads := AStatList.CurKBDownloads;
end;

procedure TStatList.Save;
var
  LConnection: TFDConnection;
  LSettings: TDBLoginSettings;
  LUpsert: TFDStoredProc;
  LUserName: String;
begin
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
    LUserName := LSettings.UserName;
  finally
    LSettings.Free;
  end;

  try
    LUpsert := TFDStoredProc.Create(nil);
    try
      LUpsert.FetchOptions.Items := LUpsert.FetchOptions.Items - [fiMeta];
      LUpsert.StoredProcName := 'dbo.UpdateStatList';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@StatListID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Modifier', ftString, 50, ptInput);
      LUpsert.Params.Add('@CurKBDownloads', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@NextStatListPK', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@StatListID').AsInteger := FStatListID;
      LUpsert.Params.ParamByName('@Modifier').AsString := LUserName;
      LUpsert.Params.ParamByName('@CurKBDownloads').AsInteger := FCurKBDownloads;
      LUpsert.ExecProc;

      FStatListID := LUpsert.Params.ParamByName('@NextStatListID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TStatList.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('statListId', TJsonNumber.Create(FStatListID));
  Result.AddPair('created', DateToISO8601(FCreated));
  Result.AddPair('modified', DateToISO8601(FModified));
  Result.AddPair('modifier', FModifier);
  Result.AddPair('curKbDownloads', TJsonNumber.Create(FCurKBDownloads));
end;

procedure TStatList.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['curKbDownloads'] then
    FCurKBDownloads := AObject.Values['curKbDownloads'].Value.ToInteger;
  if nil <> AObject.Values['modifier'] then
    FModifier := AObject.Values['modifier'].Value;
  if nil <> AObject.Values['modified'] then
    FModified := ISO8601ToDate(AObject.Values['modified'].Value);
  if nil <> AObject.Values['created'] then
    FCreated := ISO8601ToDate(AObject.Values['created'].Value);
  if nil <> AObject.Values['statListId'] then
    FStatListID := AObject.Values['statListId'].Value.ToInteger;
end;
{$ENDREGION}

{$REGION 'TStatListList'}
function TStatListList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TStatListList.GetFieldCount: Integer;
begin
  Result := 5;
end;

function TStatListList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'StatListId';
  1: Result := 'Created';
  2: Result := 'Modified';
  3: Result := 'Modifier';
  4: Result := 'CurrentKBDownloads';
  end;
end;

function TStatListList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := FList[ARecord].StatListID;
  1: Result := FList[ARecord].Created;
  2: Result := FList[ARecord].Modified;
  3: Result := FList[ARecord].Modifier;
  4: Result := FList[ARecord].CurKBDownloads;
  end;
end;

function TStatListList.GetStatList(AIndex: Integer): TStatList;
begin
  Result := FList[AIndex];
end;

class function TStatListList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select StatList.StatListID, ');
  Result.Add('StatList.Created, ');
  Result.Add('StatList.Modified, ');
  Result.Add('StatList.Modifier, ');
  Result.Add('StatList.CurKBDownloads ');
  Result.Add('From StatList ');
end;

class function TStatListList.CreateStatList(ADataSet: TDataSet): TStatList;
begin
  Result := TStatList.Create;
  Result.StatListID := ADataSet.Fields[0].AsInteger;
  Result.Created := ADataSet.Fields[1].AsDateTime;
  Result.Modified := ADataSet.Fields[2].AsDateTime;
  Result.Modifier := ADataSet.Fields[3].AsString;
  Result.CurKBDownloads := ADataSet.Fields[4].AsInteger;
end;

constructor TStatListList.Create;
begin
  inherited Create;
  FList := TObjectList<TStatList>.Create(TRUE);
end;

constructor TStatListList.Create(AStatListList: TStatListList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TStatList>.Create(TRUE);
  for i := 0 to (AStatListList.Count - 1) do 
    FList.Add(TStatList.Create(AStatListList[i]));
end;

destructor TStatListList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TStatListList.Clear;
begin
  FList.Clear;
end;

procedure TStatListList.Add(AStatList: TStatList);
begin
  FList.Add(AStatList);
end;

function TStatListList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TStatListList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LListItem: TStatList;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LListItem := TStatList.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TStatListList.GetAll: TStatListList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TStatList;
begin
  Result := nil;
  LRecord := nil;
  LSettings := TDBLoginSettings.Create;
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
        Result := TStatListList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateStatList(LQuery);
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
