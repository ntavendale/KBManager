unit KB.Release;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  System.DateUtils, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,  KB.LoginSettings,
  DataServices, CommonFunctions, DataRecordList, BusinessObject;

type
  TRelease = class(TBusinessObject)
    protected
      FReleaseID: Integer;
      FCreated: TDateTime;
      FModified: TDateTime;
      FModifier: String;
      FEmdbVersion: String;
      FKBPackageUID: String;
      FCoreVersion: String;
    public
      constructor Create; overload; virtual;
      constructor Create(ARelease: TRelease); overload; virtual;
      procedure Save;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      property ReleaseID: Integer read FReleaseID write FReleaseID;
      property Created: TDateTime read FCreated write FCreated;
      property Modified: TDateTime read FModified write FModified;
      property Modifier: String read FModifier write FModifier;
      property EmdbVersion: String read FEmdbVersion write FEmdbVersion;
      property KBPackageUID: String read FKBPackageUID write FKBPackageUID;
      property CoreVersion: String read FCoreVersion write FCoreVersion;
  end;

  TReleaseList = class(TDataRecordList)
    protected
      FList: TObjectList<TRelease>;
      function GetCount: Integer; override;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant; override;
      function GetRelease(AIndex: Integer): TRelease;
      class function GetInitialSQL: TStringList;
      class function CreateRelease(ADataSet: TDataSet): TRelease;
    public
      constructor Create; overload; virtual;
      constructor Create(AReleaseList: TReleaseList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ARelease: TRelease);
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetAll: TReleaseList;
      class function GetSingleInstance(AReleaseID: Integer): TRelease;
      property Release[AIndex: Integer]: TRelease read GetRelease; default;
  end;

implementation
{$REGION 'TRelease'}
constructor TRelease.Create;
begin
  FReleaseID := 0;
  FCreated := -1.00;
  FModified := -1.00;
  FModifier := '';
  FEmdbVersion := '';
  KBPackageUID := '';
end;

constructor TRelease.Create(ARelease: TRelease);
begin
  FReleaseID := ARelease.ReleaseID;
  FCreated := ARelease.Created;
  FModified := ARelease.Modified;
  FModifier := ARelease.Modifier;
  FEmdbVersion := ARelease.EmdbVersion;
  FKBPackageUID := ARelease.KBPackageUID;
end;

procedure TRelease.Save;
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
      LUpsert.StoredProcName := 'dbo.UpdateRelease';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@ReleaseID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Modifier', ftString, 50, ptInput);
      LUpsert.Params.Add('@EmdbVersion', ftString, 20, ptInput);
      LUpsert.Params.Add('@KBPackageUID', ftGuid, 16, ptInput);
      LUpsert.Params.Add('@NextReleaseID', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@ReleaseID').AsInteger := FReleaseID;
      LUpsert.Params.ParamByName('@Modifier').AsString := FModifier;
      LUpsert.Params.ParamByName('@EmdbVersion').AsString := FEmdbVersion;
      LUpsert.Params.ParamByName('@KBPackageUID').Value := FKBPackageUID;

      LUpsert.ExecProc;

      FReleaseID := LUpsert.Params.ParamByName('@NextReleaseID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TRelease.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('releaseId', TJsonNumber.Create(FReleaseID));
  Result.AddPair('created', DateToISO8601(FReleaseID));
  Result.AddPair('modified', DateToISO8601(FReleaseID));
  Result.AddPair('modifier', FModifier);
  Result.AddPair('emdbVersion', FEmdbVersion);
  Result.AddPair('kbPackageUid', FKBPackageUID);
end;

procedure TRelease.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['kbPackageUid'] then
    FKBPackageUID := AObject.Values['kbPackageUid'].Value;
  if nil <> AObject.Values['emdbVersion'] then
    FEmdbVersion := AObject.Values['emdbVersion'].Value;
  if nil <> AObject.Values['modifier'] then
    FModifier := AObject.Values['modifier'].Value;
  if nil <> AObject.Values['modified'] then
    FModified := ISO8601ToDate(AObject.Values['modified'].Value);
  if nil <> AObject.Values['created'] then
    FCreated := ISO8601ToDate(AObject.Values['created'].Value);
  if nil <> AObject.Values['releaseId'] then
    FReleaseID := AObject.Values['releaseId'].Value.ToInteger;
end;
{$ENDREGION}

{$REGION 'TReleaseList'}
function TReleaseList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TReleaseList.GetFieldCount: Integer;
begin
  Result := 7;
end;

function TReleaseList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'ReleaseID';
  1: Result := 'Created';
  2: Result := 'Modified';
  3: Result := 'Modifier';
  4: Result := 'EmdbVersion';
  5: Result := 'KBPackageUID';
  6: Result := 'CoreVersion';
  end;
end;

function TReleaseList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].ReleaseID;
  1: Result := Flist[ARecord].Created;
  2: Result := Flist[ARecord].Modified;
  3: Result := Flist[ARecord].Modifier;
  4: Result := Flist[ARecord].EmdbVersion;
  5: Result := Flist[ARecord].KBPackageUID;
  6: Result := Flist[ARecord].CoreVersion;
  end;
end;

function TReleaseList.GetRelease(AIndex: Integer): TRelease;
begin
  Result := FList[AIndex];
end;

class function TReleaseList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select Release.ReleaseID, ');
  Result.Add('Release.Created, ');
  Result.Add('Release.Modified, ');
  Result.Add('Release.Modifier, ');
  Result.Add('Release.EmdbVersion, ');
  Result.Add('Release.KBPackageUID, ');
  Result.Add('KBPackage.CoreVersion ');
  Result.Add('From Release ');
  Result.Add('Inner Join KBPackage on KBPackage.KBPackageUID = Release.KBPackageUID ');
end;

class function TReleaseList.CreateRelease(ADataSet: TDataSet): TRelease;
begin
  Result := TRelease.Create;
  Result.ReleaseID := ADataSet.Fields[0].AsInteger;
  Result.Created := ADataSet.Fields[1].AsDateTime;
  Result.Modified := ADataSet.Fields[2].AsDateTime;
  Result.Modifier := ADataSet.Fields[3].AsString;
  Result.EmdbVersion := ADataSet.Fields[4].AsString;
  Result.KBPackageUID := ADataSet.Fields[5].AsString;
  Result.CoreVersion := ADataSet.Fields[6].AsString;
end;

constructor TReleaseList.Create;
begin
  inherited Create;
  FList := TObjectList<TRelease>.Create(TRUE);
end;

constructor TReleaseList.Create(AReleaseList: TReleaseList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TRelease>.Create(TRUE);
  for i := 0 to (AReleaseList.Count - 1) do 
    FList.Add(TRelease.Create(AReleaseList[i]));
end;

destructor TReleaseList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TReleaseList.Clear;
begin
  FList.Clear;
end;

procedure TReleaseList.Add(ARelease: TRelease);
begin
  FList.Add(ARelease);
end;

function TReleaseList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TReleaseList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LListItem: TRelease;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LListItem := TRelease.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TReleaseList.GetSingleInstance(AReleaseID: Integer): TRelease;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TKBLoginSettings;
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
      LSQL.Add('Where Release.ReleaseID=' + IntToStr(AReleaseID) + ' ');
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
        LQuery.First;
        Result := CreateRelease(LQuery);
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

class function TReleaseList.GetAll: TReleaseList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TKBLoginSettings;
  LRecord: TRelease;
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
        Result := TReleaseList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateRelease(LQuery);
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
