unit KB.Deployment;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, KB.LoginSettings,
  CommonFunctions, FireDAC.Stan.Option, System.Generics.Collections,
  BusinessObject, DataServices, DataRecordList;

type
  TDeployment = class(TBusinessObject)
    protected
      FDeploymentID: Integer;
      FCreated: TDateTime;
      FModified: TDateTime;
      FModifier: String;
      FMasterLicenseID: Integer;
      FName: String;
      FIsAuthorized: Boolean;
      FFingerprint: String;
      FEnforceFingerprint: Boolean;
      FRequireSnapshot: Boolean;
      FDoNotSign: Boolean;
    public
      constructor Create; overload; virtual;
      constructor Create(ADeployment: TDeployment); overload; virtual;
      procedure Save;
      procedure ClearFingerPrint;
      procedure EnableDownloads;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      property DeploymentID: Integer read FDeploymentID write FDeploymentID;
      property Created: TDateTime read FCreated write FCreated;
      property Modified: TDateTime read FModified write FModified;
      property Modifier: String read FModifier write FModifier;
      property MasterLicenseID: Integer read FMasterLicenseID write FMasterLicenseID;
      property Name: String read FName write FName;
      property IsAuthorized: Boolean read FIsAuthorized write FIsAuthorized;
      property Fingerprint: String read FFingerprint write FFingerprint;
      property EnforceFingerprint: Boolean read FEnforceFingerprint write FEnforceFingerprint;
      property RequireSnapshot: Boolean read FRequireSnapshot write FRequireSnapshot;
      property DoNotSign: Boolean read FDoNotSign write FDoNotSign;
  end;

  TDeploymentList = class(TDataRecordList)
    protected
      FList: TObjectList<TDeployment>;
      function GetCount: Integer; override;
      function GetDeployment(AIndex: Integer): TDeployment;
      class function GetInitialSQL: TStringList;
      class function CreateDeployment(ADataSet: TDataSet): TDeployment;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant;  override;
    public
      constructor Create; overload; virtual;
      constructor Create(ADeploymentList: TDeploymentList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ADeployment: TDeployment);
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetSingleInstance(ADeploymentID: Integer): TDeployment;
      class function GetAll: TDeploymentList;
      class function GetAllForLicenceIDList(ALinceceIDList: TArray<Integer>): TDeploymentList;
      class procedure CancelAuthorisation(ADeploymentIDList: TArray<Integer>);
      property Deployment[AIndex: Integer]: TDeployment read GetDeployment; default;
  end;

implementation

{$REGION 'TDeployment'}
constructor TDeployment.Create;
begin
  FDeploymentID := 0;
  FCreated := -1.00;
  FModified := -1.00;
  FModifier := '';
  FMasterLicenseID := 0;
  FName := '';
  FIsAuthorized := FALSE;
  FFingerprint := '';
  FEnforceFingerprint := TRUE;
  FRequireSnapshot := FALSE;
  FDoNotSign := FALSE;
end;

constructor TDeployment.Create(ADeployment: TDeployment);
begin
  FDeploymentID := ADeployment.DeploymentID;
  FCreated := ADeployment.Created;
  FModified := ADeployment.Modified;
  FModifier := ADeployment.Modifier;
  FMasterLicenseID := ADeployment.MasterLicenseID;
  FName := ADeployment.Name;
  FIsAuthorized := ADeployment.IsAuthorized;
  FFingerprint := ADeployment.Fingerprint;
  FEnforceFingerprint := ADeployment.EnforceFingerprint;
  FRequireSnapshot := ADeployment.RequireSnapshot;
  FDoNotSign := ADeployment.DoNotSign;
end;

procedure TDeployment.Save;
var
  LConnection: TFDConnection;
  LSettings: TKBLoginSettings;
  LUpsert: TFDStoredProc;
  LUser, LDomain: String;
begin
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
    LUser := LSettings.UserName;
  finally
    LSettings.Free;
  end;

  try
    GetCurrentUserAndDomain(LUser, LDomain);
    LUser := LDomain + '\' + LUser;
  except
    //Do Nothing since we will have the db login as User Name
  end;

  try
    LUpsert := TFDStoredProc.Create(nil);
    try
      LUpsert.FetchOptions.Items := LUpsert.FetchOptions.Items - [fiMeta];
      LUpsert.StoredProcName := 'dbo.UpdateDeployment';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@DeploymentID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Modifier', ftString, 50, ptInput);
      LUpsert.Params.Add('@MasterLicenseID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Name', ftString, 255, ptInput);
      LUpsert.Params.Add('@IsAuthorized', ftBoolean, -1, ptInput);
      LUpsert.Params.Add('@Fingerprint', ftString, 255, ptInput);
      LUpsert.Params.Add('@RequireSnapshot', ftBoolean, -1, ptInput);
      LUpsert.Params.Add('@DoNotSign', ftBoolean, -1, ptInput);
      LUpsert.Params.Add('@NextDeploymentID', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@DeploymentID').AsInteger := FDeploymentID;
      LUpsert.Params.ParamByName('@Modifier').AsString := LUser;
      LUpsert.Params.ParamByName('@MasterLicenseID').AsInteger := FMasterLicenseID;
      if '' <> Trim(FName) then
        LUpsert.Params.ParamByName('@Name').AsString := FName
      else
        LUpsert.Params.ParamByName('@Name').Clear;
      LUpsert.Params.ParamByName('@IsAuthorized').AsBoolean := FIsAuthorized;
      if '' <> Trim(FFingerprint) then
        LUpsert.Params.ParamByName('@Fingerprint').AsString := FFingerprint
      else
        LUpsert.Params.ParamByName('@Fingerprint').Clear;

      LUpsert.Params.ParamByName('@RequireSnapshot').AsBoolean := FRequireSnapshot;
      LUpsert.Params.ParamByName('@DoNotSign').AsBoolean := FDoNotSign;

      LUpsert.ExecProc;

      FDeploymentID := LUpsert.Params.ParamByName('@NextDeploymentID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

procedure TDeployment.ClearFingerPrint;
var
  LConnection: TFDConnection;
  LSettings: TKBLoginSettings;
  LProc: TFDStoredProc;
  LUser, LDomain: String;
begin
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
    LUser := LSettings.UserName;
  finally
    LSettings.Free;
  end;

  try
    GetCurrentUserAndDomain(LUser, LDomain);
    LUser := LDomain + '\' + LUser;
  except
    //Do Nothing since we will have the db login as User Name
  end;

  try
    LProc := TFDStoredProc.Create(nil);
    try
      LProc.FetchOptions.Items := LProc.FetchOptions.Items - [fiMeta];
      LProc.StoredProcName := 'dbo.ClearFingerPrint';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LProc.Params.Add('@DeploymentID', ftInteger, -1, ptInput);
      LProc.Params.Add('@Modifier', ftString, 50, ptInput);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;

      LProc.Params.ParamByName('@DeploymentID').AsInteger := FDeploymentID;
      LProc.Params.ParamByName('@Modifier').AsString := LUser;
      LProc.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

procedure TDeployment.EnableDownloads;
var
  LConnection: TFDConnection;
  LSettings: TKBLoginSettings;
  LProc: TFDStoredProc;
  LUser, LDomain: String;
begin
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
    LUser := LSettings.UserName;
  finally
    LSettings.Free;
  end;

  try
    GetCurrentUserAndDomain(LUser, LDomain);
    LUser := LDomain + '\' + LUser;
  except
    //Do Nothing since we will have the db login as User Name
  end;

  try
    LProc := TFDStoredProc.Create(nil);
    try
      LProc.FetchOptions.Items := LProc.FetchOptions.Items - [fiMeta];
      LProc.StoredProcName := 'dbo.EnableDownloads';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LProc.Params.Add('@DeploymentID', ftInteger, -1, ptInput);
      LProc.Params.Add('@Modifier', ftString, 50, ptInput);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;

      LProc.Params.ParamByName('@DeploymentID').AsInteger := FDeploymentID;
      LProc.Params.ParamByName('@Modifier').AsString := LUser;
      LProc.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TDeployment.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('deploymentId', TJsonNumber.Create(FDeploymentID));
  Result.AddPair('created', DateToISO8601(FCreated));
  Result.AddPair('modified', DateToISO8601(FModified));
  Result.AddPair('modifier', FModifier);
  Result.AddPair('masterLicenseId', TJsonNumber.Create(FMasterLicenseID));
  Result.AddPair('name', FName);
  Result.AddPair('isAuthorized', TJsonBool.Create(FIsAuthorized));
  Result.AddPair('fingerprint', FFingerprint);
  Result.AddPair('requireSnapshot', TJsonBool.Create(FRequireSnapshot));
end;

procedure TDeployment.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['deploymentId'] then
    FDeploymentID := AObject.Values['deploymentId'].Value.ToInteger;
  if nil <> AObject.Values['created'] then
    FCreated := ISO8601ToDate(AObject.Values['created'].Value);
  if nil <> AObject.Values['modified'] then
    FCreated := ISO8601ToDate(AObject.Values['modified'].Value);
  if nil <> AObject.Values['modifier'] then
    FModifier := AObject.Values['modifier'].Value;
  if nil <> AObject.Values['masterLicenseId'] then
    FMasterLicenseID := AObject.Values['masterLicenseId'].Value.ToInteger;
  if nil <> AObject.Values['name'] then
    FName := AObject.Values['name'].Value;
  if nil <> AObject.Values['isAuthorized'] then
    FIsAuthorized := AObject.Values['isAuthorized'].Value.ToBoolean;
  if nil <> AObject.Values['fingerprint'] then
    FFingerprint := AObject.Values['fingerprint'].Value;
  if nil <> AObject.Values['enforceFingerprint'] then
    FEnforceFingerprint := AObject.Values['enforceFingerprint'].Value.ToBoolean;
end;
{$ENDREGION}

{$REGION 'TDeploymentList'}
constructor TDeploymentList.Create;
begin
  inherited Create;
  FList := TObjectList<TDeployment>.Create(TRUE);
end;

constructor TDeploymentList.Create(ADeploymentList: TDeploymentList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TDeployment>.Create(TRUE);
  for i := 0 to (ADeploymentList.Count - 1) do
    FList.Add(TDeployment.Create(ADeploymentList[i]));
end;

destructor TDeploymentList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TDeploymentList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDeploymentList.GetDeployment(AIndex: Integer): TDeployment;
begin
  Result := FList[AIndex];
end;

function TDeploymentList.GetFieldCount: Integer;
begin
  Result := 11;
end;

function TDeploymentList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'Deployment ID';
  1: Result := 'Created';
  2: Result := 'Modified';
  3: Result := 'Modified By';
  4: Result := 'Master Licence ID';
  5: Result := 'Name';
  6: Result := 'Download Allowed';
  7: Result := 'GUID';
  8: Result := 'Enforce Fingerprint';
  9: Result := 'Require Snapshot';
  10: Result := 'Do Not Sign';
  end;
end;

function TDeploymentList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].DeploymentID;
  1: Result := Flist[ARecord].Created;
  2: Result := Flist[ARecord].Modified;
  3: Result := Flist[ARecord].Modifier;
  4: Result := Flist[ARecord].MasterLicenseID;
  5: Result := Flist[ARecord].Name;
  6: Result := Flist[ARecord].IsAuthorized;
  7: Result := Flist[ARecord].Fingerprint;
  8: Result := Flist[ARecord].EnforceFingerprint;
  9: Result := Flist[ARecord].RequireSnapshot;
  10: Result := Flist[ARecord].DoNotSign;
  end;
end;

class function TDeploymentList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select Deployment.DeploymentID, ');
  Result.Add('Deployment.Created, ');
  Result.Add('Deployment.Modified, ');
  Result.Add('Deployment.Modifier, ');
  Result.Add('Deployment.MasterLicenseID, ');
  Result.Add('Deployment.Name, ');
  Result.Add('Deployment.IsAuthorized, ');
  Result.Add('Deployment.Fingerprint, ');
  Result.Add('Deployment.EnforceFingerprint, ');
  Result.Add('Deployment.RequireSnapshot ');
//  Result.Add('Deployment.DoNotSign ');
  Result.Add('From Deployment ');
end;

class function TDeploymentList.CreateDeployment(ADataSet: TDataSet): TDeployment;
begin
  Result := TDeployment.Create;
  Result.DeploymentID := ADataSet.Fields[0].AsInteger;
  Result.Created := ADataSet.Fields[1].AsDateTime;
  Result.Modified := ADataSet.Fields[2].AsDateTime;
  Result.Modifier := ADataSet.Fields[3].AsString;
  Result.MasterLicenseID := ADataSet.Fields[4].AsInteger;
  Result.Name := ADataSet.Fields[5].AsString;
  Result.IsAuthorized := ADataSet.Fields[6].AsBoolean;
  Result.Fingerprint := ADataSet.Fields[7].AsString;
  Result.EnforceFingerprint := ADataSet.Fields[8].AsBoolean;
  Result.RequireSnapshot := ADataSet.Fields[9].AsBoolean;
//  Result.DoNotSign := ADataSet.Fields[10].AsBoolean;
end;

procedure TDeploymentList.Clear;
begin
  FList.Clear;
end;

procedure TDeploymentList.Add(ADeployment: TDeployment);
begin
  FList.Add(ADeployment);
end;

function TDeploymentList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TDeploymentList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LDeployment: TDeployment;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LDeployment := TDeployment.Create;
    LDeployment.FromJsonObject(LVal As TJsonObject);
    FList.Add(LDeployment);
  end;
end;

class function TDeploymentList.GetSingleInstance(ADeploymentID: Integer): TDeployment;
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
      LSQL.Add('Where Deployment.DeploymentID=' + IntToStr(ADeploymentID) + ' ');
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
        Result := CreateDeployment(LQuery);
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

class function TDeploymentList.GetAll: TDeploymentList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TKBLoginSettings;
  LRecord: TDeployment;
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
        Result := TDeploymentList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateDeployment(LQuery);
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

class function TDeploymentList.GetAllForLicenceIDList(ALinceceIDList: TArray<Integer>): TDeploymentList;
var
  LConnection: TFDConnection;
  LStoredProc: TFDStoredProc;
  LicenceIDTable: TFDMemTable;
  i: Integer;
  LSettings: TKBLoginSettings;
  LRecord: TDeployment;
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
    LicenceIDTable := TFDMemTable.CREATE(nil);
    LicenceIDTable.FieldDefs.Add('MasterLicenseID', ftInteger);
    LicenceIDTable.Active := TRUE;
    for i := 0 to (Length(ALinceceIDList) -1) do
    begin
      LicenceIDTable.Append;
      LicenceIDTable.Fields[0].AsInteger := ALinceceIDList[i];
    end;

    LStoredProc := TFDStoredProc.Create(nil);
    try
      LStoredProc.FetchOptions.Items := LStoredProc.FetchOptions.Items - [fiMeta];
      LStoredProc.StoredProcName := 'GetDeploymentsForLicenseIDs';
      LStoredProc.Params.Clear;
      LStoredProc.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LStoredProc.Connection := LConnection;
      with LStoredProc.Params.ADD('@MasterLicenseIDList', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'MasterLicence_TableType';
        AsDataSet := LicenceIDTable;
      end;

      LConnection.Open;
      LStoredProc.Open;
      if not LStoredProc.IsEmpty then
      begin
        Result := TDeploymentList.Create;
        LStoredProc.First;
        while not LStoredProc.EOF do
        begin
          LRecord := CreateDeployment(LStoredProc);
          Result.Add(LRecord);
          LStoredProc.Next;
        end;
      end;
    finally
      LStoredProc.Close;
      LStoredProc.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;

class procedure TDeploymentList.CancelAuthorisation(ADeploymentIDList: TArray<Integer>);
var
  LConnection: TFDConnection;
  LStoredProc: TFDStoredProc;
  DeploymentIDTable: TFDMemTable;
  i: Integer;
  LSettings: TKBLoginSettings;
begin
  LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    DeploymentIDTable := TFDMemTable.CREATE(nil);
    DeploymentIDTable.FieldDefs.Add('DeploymentID', ftInteger);
    DeploymentIDTable.Active := TRUE;
    for i := 0 to (Length(ADeploymentIDList) -1) do
    begin
      DeploymentIDTable.Append;
      DeploymentIDTable.Fields[0].AsInteger := ADeploymentIDList[i];
    end;

    LStoredProc := TFDStoredProc.Create(nil);
    try
      LStoredProc.FetchOptions.Items := LStoredProc.FetchOptions.Items - [fiMeta];
      LStoredProc.StoredProcName := 'DisableDeploymentsForLicenseIDs';
      LStoredProc.Params.Clear;
      LStoredProc.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LStoredProc.Connection := LConnection;
      with LStoredProc.Params.ADD('@DeploymnetIDList', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'DeploymnetID_TableType';
        AsDataSet := DeploymentIDTable;
      end;

      LConnection.Open;
      LStoredProc.ExecProc;
    finally
      LStoredProc.Close;
      LStoredProc.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;
{$ENDREGION}


end.
