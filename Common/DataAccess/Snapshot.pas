unit Snapshot;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils,
  System.Generics.Collections, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Option, DB,
  Settings, CommonFunctions, DBLoginSettings, DataServices, DataRecordList,
  AgentsByOS, KBModule, BusinessObject;

type
  TSnapshot = class(TBusinessObject)
    protected
      FSnapshotID: Integer;
      FCreated: TDateTime;
      FModified: TDateTime;
      FModifier: String;
      FDeploymentID: Integer;
      FMasterLicenseID: Integer;
      FSnapshotTime: TDateTime;
      FClientVersion: String;
      FEmdbVersion: String;
      FCoreVersion: String;
      FFingerprint: String;
      FActiveLogSources: Integer;
      FActiveHosts: Integer;
      FActivePersons: Integer;
      FActiveUsers: Integer;
      FLogsCollected: Int64;
      FLogsIdentified: Int64;
      FLogsOnline: Int64;
      FEvents: Int64;
      FCountEventData: Int64;
      FCountEventsForwarded: Int64;
      FCountEventsAIEngine: Int64;
      FCountAlarms: Int64;
      FCountDeduplicatedLogs: Int64;
      FCountCollectors: Integer;
      FEnabledKBModules: String;
      FAgentsByOS: String;
      FFIMAgentsByOS: String;
      FRTFIMAgentsByOS: String;
      FPMAgentsByOS: String;
      FNCMAgentsByOS: String;
      FUAMAgentsByOS: String;
      FDLDAgentsByOS: String;
      FAgentsByOSList: TAgentsByOSList;
      FFIMAgentsByOSList: TAgentsByOSList;
      FRTFIMAgentsByOSList: TAgentsByOSList;
      FPMAgentsByOSList: TAgentsByOSList;
      FKBModulesList: TKBModuleList;
    public
      constructor Create; overload; virtual;
      constructor Create(ASnapshot: TSnapshot); overload; virtual;
      destructor Destroy; override;
      procedure Save;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      property SnapshotID: Integer read FSnapshotID write FSnapshotID;
      property Created: TDateTime read FCreated write FCreated;
      property Modified: TDateTime read FModified write FModified;
      property Modifier: String read FModifier write FModifier;
      property DeploymentID: Integer read FDeploymentID write FDeploymentID;
      property MasterLicenseID: Integer read FMasterLicenseID write FMasterLicenseID;
      property SnapshotTime: TDateTime read FSnapshotTime write FSnapshotTime;
      property ClientVersion: String read FClientVersion write FClientVersion;
      property EmdbVersion: String read FEmdbVersion write FEmdbVersion;
      property CoreVersion: String read FCoreVersion write FCoreVersion;
      property Fingerprint: String read FFingerprint write FFingerprint;
      property ActiveLogSources: Integer read FActiveLogSources write FActiveLogSources;
      property ActiveHosts: Integer read FActiveHosts write FActiveHosts;
      property ActivePersons: Integer read FActivePersons write FActivePersons;
      property ActiveUsers: Integer read FActiveUsers write FActiveUsers;
      property LogsCollected: Int64 read FLogsCollected write FLogsCollected;
      property LogsIdentified: Int64 read FLogsIdentified write FLogsIdentified;
      property LogsOnline: Int64 read FLogsOnline write FLogsOnline;
      property Events: Int64 read FEvents write FEvents;
      property CountEventData: Int64 read FCountEventData write FCountEventData;
      property CountEventsForwarded: Int64 read FCountEventsForwarded write FCountEventsForwarded;
      property CountEventsAIEngine: Int64 read FCountEventsAIEngine write FCountEventsAIEngine;
      property CountAlarms: Int64 read FCountAlarms write FCountAlarms;
      property CountDeduplicatedLogs: Int64 read FCountDeduplicatedLogs write FCountDeduplicatedLogs;
      property CountCollectors: Integer read FCountCollectors write FCountCollectors;
      property EnabledKBModules: String read FEnabledKBModules write FEnabledKBModules;
      property AgentsByOS: String read FAgentsByOS write FAgentsByOS;
      property FIMAgentsByOS: String read FFIMAgentsByOS write FFIMAgentsByOS;
      property RTFIMAgentsByOS: String read FRTFIMAgentsByOS write FRTFIMAgentsByOS;
      property PMAgentsByOS: String read FPMAgentsByOS write FPMAgentsByOS;
      property NCMAgentsByOS: String read FNCMAgentsByOS write FNCMAgentsByOS;
      property UAMAgentsByOS: String read FUAMAgentsByOS write FUAMAgentsByOS;
      property DLDAgentsByOS: String read FDLDAgentsByOS write FDLDAgentsByOS;
      property AgentsByOSList: TAgentsByOSList read FAgentsByOSList write FAgentsByOSList;
      property KBModulesList: TKBModuleList read FKBModulesList write FKBModulesList;
      property FIMAgentsByOSList: TAgentsByOSList read FFIMAgentsByOSList write FFIMAgentsByOSList;
      property RTFIMAgentsByOSList: TAgentsByOSList read FRTFIMAgentsByOSList write FRTFIMAgentsByOSList;
      property PMAgentsByOSList: TAgentsByOSList read FPMAgentsByOSList write FPMAgentsByOSList;
  end;

  TSnapshotList = class(TDataRecordList)
    protected
      FList: TObjectList<TSnapshot>;
      function GetCount: Integer; override;
      function GetSnapshot(AIndex: Integer): TSnapshot;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant;  override;
      class function GetOSByVerParamTable: TFDMemTable;
      class function GetKBModulesParamTable: TFDMemTable;
      class function GetInitialSQL: TStringList;
      class function CreateSnapshot(ADataSet: TDataSet): TSnapshot;
    public
      constructor Create; overload; virtual;
      constructor Create(ASnapshotList: TSnapshotList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ASnapshot: TSnapshot);
      procedure SubmitAgentsByOSVersion;
      procedure SubmitFIMAgentsByOSVersion;
      procedure SubmitRTFIMAgentsByOSVersion;
      procedure SubmitPMAgentsByOSVersion;
      procedure SubmitKBModules;
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetAllForDeployment(ADeploymentID: Integer): TSnapshotList;
      class function GetAllMostRecent: TSnapshotList;
      property Snapshot[AIndex: Integer]: TSnapshot read GetSnapshot; default;
  end;

implementation
{$REGION 'TSnapshot'}
constructor TSnapshot.Create;
begin
  FSnapshotID := 0;
  FCreated := -1.00;
  FModified := -1.00;
  FModifier := '';
  FDeploymentID := 0;
  FMasterLicenseID := 0;
  FSnapshotTime := -1.00;
  FClientVersion := '';
  FEmdbVersion := '';
  FCoreVersion := '';
  FFingerprint := '';
  FActiveLogSources := 0;
  FActiveHosts := 0;
  FActivePersons := 0;
  FActiveUsers := 0;
  FCountCollectors := 0;
  FEnabledKBModules := '';
  FAgentsByOS := '';
  FFIMAgentsByOS := '';
  FRTFIMAgentsByOS := '';
  FPMAgentsByOS := '';
  FNCMAgentsByOS := '';
  FUAMAgentsByOS := '';
  FDLDAgentsByOS := '';
  FAgentsByOSList := TAgentsByOSList.Create;
  FFIMAgentsByOSList := TAgentsByOSList.Create;
  FRTFIMAgentsByOSList := TAgentsByOSList.Create;
  FPMAgentsByOSList := TAgentsByOSList.Create;
  FKBModulesList := TKBModuleList.Create;

end;

constructor TSnapshot.Create(ASnapshot: TSnapshot);
begin
  FSnapshotID := ASnapshot.SnapshotID;
  FCreated := ASnapshot.Created;
  FModified := ASnapshot.Modified;
  FModifier := ASnapshot.Modifier;
  FDeploymentID := ASnapshot.DeploymentID;
  FMasterLicenseID := ASnapshot.MasterLicenseID;
  FSnapshotTime := ASnapshot.SnapshotTime;
  FClientVersion := ASnapshot.ClientVersion;
  FEmdbVersion := ASnapshot.EmdbVersion;
  FCoreVersion := ASnapshot.CoreVersion;
  FFingerprint := ASnapshot.Fingerprint;
  FActiveLogSources := ASnapshot.ActiveLogSources;
  FActiveHosts := ASnapshot.ActiveHosts;
  FActivePersons := ASnapshot.ActivePersons;
  FActiveUsers := ASnapshot.ActiveUsers;
  FLogsCollected := ASnapshot.LogsCollected;
  FLogsIdentified := ASnapshot.LogsIdentified;
  FLogsOnline := ASnapshot.LogsOnline;
  FEvents := ASnapshot.Events;
  FCountEventData := ASnapshot.CountEventData;
  FCountEventsForwarded := ASnapshot.CountEventsForwarded;
  FCountEventsAIEngine := ASnapshot.CountEventsAIEngine;
  FCountAlarms := ASnapshot.CountAlarms;
  FCountDeduplicatedLogs := ASnapshot.CountDeduplicatedLogs;
  FCountCollectors := ASnapshot.CountCollectors;
  FEnabledKBModules := ASnapshot.EnabledKBModules;
  FAgentsByOS := ASnapshot.AgentsByOS;
  FFIMAgentsByOS := ASnapshot.FIMAgentsByOS;
  FRTFIMAgentsByOS := ASnapshot.RTFIMAgentsByOS;
  FPMAgentsByOS := ASnapshot.PMAgentsByOS;
  FNCMAgentsByOS := ASnapshot.NCMAgentsByOS;
  FUAMAgentsByOS := ASnapshot.UAMAgentsByOS;
  FDLDAgentsByOS := ASnapshot.DLDAgentsByOS;
  FAgentsByOSList := TAgentsByOSList.Create(ASnapshot.AgentsByOSList);
  FFIMAgentsByOSList := TAgentsByOSList.Create(ASnapshot.FIMAgentsByOSList);
  FRTFIMAgentsByOSList := TAgentsByOSList.Create(ASnapshot.RTFIMAgentsByOSList);
  FPMAgentsByOSList := TAgentsByOSList.Create(ASnapshot.PMAgentsByOSList);
  FKBModulesList := TKBModuleList.Create(ASnapshot.KBModulesList);
end;

destructor TSnapshot.Destroy;
begin
  FAgentsByOSList.Free;
  FFIMAgentsByOSList.Free;
  FPMAgentsByOSList.Free;
  FKBModulesList.Free;
  FRTFIMAgentsByOSList.Free;
  inherited Destroy;
end;

procedure TSnapshot.Save;
var
  LConnection: TFDConnection;
  LSettings: TDBLoginSettings;
  LUpsert: TFDStoredProc;
  LUser: String;
begin
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
    LUser := LSettings.UserName;
  finally
    LSettings.Free;
  end;

  try
    LUpsert := TFDStoredProc.Create(nil);
    try
      LUpsert.FetchOptions.Items := LUpsert.FetchOptions.Items - [fiMeta];
      LUpsert.StoredProcName := 'PatientData_UpdateSnapshot';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@SnapshotID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Created', ftDateTime, -1, ptInput);
      LUpsert.Params.Add('@Modified', ftDateTime, -1, ptInput);
      LUpsert.Params.Add('@Modifier', ftString, 50, ptInput);
      LUpsert.Params.Add('@DeploymentID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@MasterLicenseID', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@SnapshotTime', ftDateTime, -1, ptInput);
      LUpsert.Params.Add('@ClientVersion', ftString, 20, ptInput);
      LUpsert.Params.Add('@EmdbVersion', ftString, 20, ptInput);
      LUpsert.Params.Add('@CoreVersion', ftString, 20, ptInput);
      LUpsert.Params.Add('@Fingerprint', ftString, 255, ptInput);
      LUpsert.Params.Add('@ActiveLogSources', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@ActiveHosts', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@ActivePersons', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@ActiveUsers', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@CountCollectors', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@EnabledKBModules', ftString, -1, ptInput);
      LUpsert.Params.Add('@AgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@FIMAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@RTFIMAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@PMAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@NCMAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@UAMAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@DLDAgentsByOS', ftString, -1, ptInput);
      LUpsert.Params.Add('@NextSnapshotPK', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@SnapshotID').AsInteger := FSnapshotID;
      LUpsert.Params.ParamByName('@Created').AsDateTime := FCreated;
      LUpsert.Params.ParamByName('@Modified').AsDateTime := FModified;
      LUpsert.Params.ParamByName('@Modifier').AsString := FModifier;
      LUpsert.Params.ParamByName('@DeploymentID').AsInteger := FDeploymentID;
      LUpsert.Params.ParamByName('@MasterLicenseID').AsInteger := FMasterLicenseID;
      LUpsert.Params.ParamByName('@SnapshotTime').AsDateTime := FSnapshotTime;
      LUpsert.Params.ParamByName('@ClientVersion').AsString := FClientVersion;
      LUpsert.Params.ParamByName('@EmdbVersion').AsString := FEmdbVersion;
      LUpsert.Params.ParamByName('@CoreVersion').AsString := FCoreVersion;
      LUpsert.Params.ParamByName('@Fingerprint').AsString := FFingerprint;
      LUpsert.Params.ParamByName('@ActiveLogSources').AsInteger := FActiveLogSources;
      LUpsert.Params.ParamByName('@ActiveHosts').AsInteger := FActiveHosts;
      LUpsert.Params.ParamByName('@ActivePersons').AsInteger := FActivePersons;
      LUpsert.Params.ParamByName('@ActiveUsers').AsInteger := FActiveUsers;
      LUpsert.Params.ParamByName('@CountCollectors').AsInteger := FCountCollectors;
      LUpsert.Params.ParamByName('@EnabledKBModules').AsString := FEnabledKBModules;
      LUpsert.Params.ParamByName('@AgentsByOS').AsString := FAgentsByOS;
      LUpsert.Params.ParamByName('@FIMAgentsByOS').AsString := FFIMAgentsByOS;
      LUpsert.Params.ParamByName('@RTFIMAgentsByOS').AsString := FRTFIMAgentsByOS;
      LUpsert.Params.ParamByName('@PMAgentsByOS').AsString := FPMAgentsByOS;
      LUpsert.Params.ParamByName('@NCMAgentsByOS').AsString := FNCMAgentsByOS;
      LUpsert.Params.ParamByName('@UAMAgentsByOS').AsString := FUAMAgentsByOS;
      LUpsert.Params.ParamByName('@DLDAgentsByOS').AsString := FDLDAgentsByOS;

      LUpsert.ExecProc;

      FSnapshotID := LUpsert.Params.ParamByName('@NextSnapshotPK').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TSnapshot.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('snapshotId', TJsonNumber.Create(FSnapshotID));
  Result.AddPair('created', DateToISO8601(FCreated));
  Result.AddPair('modified', DateToISO8601(FModified));
  Result.AddPair('modifier', FModifier);
  Result.AddPair('deploymentId', TJsonNumber.Create(FDeploymentID));
  Result.AddPair('masterLicenseId', TJsonNumber.Create(FMasterLicenseID));
  Result.AddPair('snapshotTime', DateToISO8601(FSnapshotTime));
  Result.AddPair('clientVersion', FClientVersion);
  Result.AddPair('emdbVersion', FEmdbVersion);
  Result.AddPair('coreVersion', FCoreVersion);
  Result.AddPair('fingerprint', FFingerprint);
  Result.AddPair('activeLogSources', TJsonNumber.Create(FActiveLogSources));
  Result.AddPair('activeHosts', TJsonNumber.Create(FActiveHosts));
  Result.AddPair('activePersons', TJsonNumber.Create(FActivePersons));
  Result.AddPair('activeUsers', TJsonNumber.Create(FActiveUsers));
  Result.AddPair('logsCollected', TJsonNumber.Create(FLogsCollected));
  Result.AddPair('logsIdentified', TJsonNumber.Create(FLogsIdentified));
  Result.AddPair('logsOnline', TJsonNumber.Create(FLogsOnline));
  Result.AddPair('events', TJsonNumber.Create(FEvents));
  Result.AddPair('countEventData', TJsonNumber.Create(FCountEventData));
  Result.AddPair('countEventsForwarded', TJsonNumber.Create(FCountEventsForwarded));
  Result.AddPair('countEventsAiEngine', TJsonNumber.Create(FCountEventsAIEngine));
  Result.AddPair('countAlarms', TJsonNumber.Create(FCountAlarms));
  Result.AddPair('countDeduplicatedLogs', TJsonNumber.Create(FCountDeduplicatedLogs));
  Result.AddPair('countCollectors', TJsonNumber.Create(FCountCollectors));
  Result.AddPair('enabledKbModules', FEnabledKBModules);
  Result.AddPair('agentsByOs', FAgentsByOS);
  Result.AddPair('fimAgentsByOs', FFIMAgentsByOS);
  Result.AddPair('rtFimAgentsByOs', FRTFIMAgentsByOS);
  Result.AddPair('pmAgentsByOs', FPMAgentsByOS);
  Result.AddPair('ncmAgentsByOs', FNCMAgentsByOS);
  Result.AddPair('uamAgentsByOs', FUAMAgentsByOS);
  Result.AddPair('dldAgentsByOs', FDLDAgentsByOS);
  Result.AddPair('agentsByOsList', FAgentsByOSList.ToJsonArray);
  Result.AddPair('fimAgentsByOsList', FFIMAgentsByOSList.ToJsonArray);
  Result.AddPair('rtFimAgentsByOsList', FRTFIMAgentsByOSList.ToJsonArray);
  Result.AddPair('pmAgentsByOsList', FPMAgentsByOSList.ToJsonArray);
  Result.AddPair('kbModulesList', FKBModulesList.ToJsonArray);
end;

procedure TSnapshot.FromJsonObject(AObject: TJsonObject);
var
  LArray: TJsonArray;
  LValue: TJsonValue;
begin
  FKBModulesList.Clear;
  LArray := AObject.Values['kbModulesList'] As TJsonArray;
  if LArray <> nil then
  begin
    for LValue in LArray do
      FKBModulesList.Add(TKBModule.CreateFromJsonObject(LValue as TJsonObject));
  end;

  FPMAgentsByOSList.Clear;
  LArray := AObject.Values['pmAgentsByOsList'] As TJsonArray;
  if LArray <> nil then
  begin
    for LValue in LArray do
      FPMAgentsByOSList.Add(TAgentsByOS.CreateFromJsonObject(LValue as TJsonObject));
  end;

  FRTFIMAgentsByOSList.Clear;
  LArray := AObject.Values['rtFimAgentsByOsList'] As TJsonArray;
  if LArray <> nil then
  begin
    for LValue in LArray do
      FRTFIMAgentsByOSList.Add(TAgentsByOS.CreateFromJsonObject(LValue as TJsonObject));
  end;

  FFIMAgentsByOSList.Clear;
  LArray := AObject.Values['fimAgentsByOsList'] As TJsonArray;
  if LArray <> nil then
  begin
    for LValue in LArray do
      FFIMAgentsByOSList.Add(TAgentsByOS.CreateFromJsonObject(LValue as TJsonObject));
  end;

  FAgentsByOSList.Clear;
  LArray := AObject.Values['agentsByOsList'] As TJsonArray;
  if LArray <> nil then
  begin
    for LValue in LArray do
      FAgentsByOSList.Add(TAgentsByOS.CreateFromJsonObject(LValue as TJsonObject));
  end;

  if nil <> AObject.Values['dldAgentsByOs'] then
    FDLDAgentsByOS := AObject.Values['dldAgentsByOs'].Value;
  if nil <> AObject.Values['uamAgentsByOs'] then
    FUAMAgentsByOS := AObject.Values['uamAgentsByOs'].Value;
  if nil <> AObject.Values['ncmAgentsByOs'] then
    FNCMAgentsByOS := AObject.Values['ncmAgentsByOs'].Value;
  if nil <> AObject.Values['pmAgentsByOs'] then
    FPMAgentsByOS := AObject.Values['pmAgentsByOs'].Value;
  if nil <> AObject.Values['rtFimAgentsByOs'] then
    FRTFIMAgentsByOS := AObject.Values['rtFimAgentsByOs'].Value;
  if nil <> AObject.Values['fimAgentsByOs'] then
    FFIMAgentsByOS := AObject.Values['fimAgentsByOs'].Value;
  if nil <> AObject.Values['agentsByOs'] then
    FAgentsByOS := AObject.Values['agentsByOs'].Value;
  if nil <> AObject.Values['enabledKbModules'] then
    FEnabledKBModules := AObject.Values['enabledKbModules'].Value;
  if nil <> AObject.Values['countCollectors'] then
    FCountCollectors := AObject.Values['countCollectors'].Value.ToInteger;
  if nil <> AObject.Values['countDeduplicatedLogs'] then
    FCountDeduplicatedLogs := AObject.Values['countDeduplicatedLogs'].Value.ToInteger;
  if nil <> AObject.Values['countAlarms'] then
    FCountAlarms := AObject.Values['countAlarms'].Value.ToInteger;
  if nil <> AObject.Values['countEventsAiEngine'] then
    FCountEventsAIEngine := AObject.Values['FCountEventsAiEngine'].Value.ToInteger;
  if nil <> AObject.Values['countEventsForwarded'] then
    FCountEventsAIEngine := AObject.Values['countEventsForwarded'].Value.ToInteger;
  if nil <> AObject.Values['countEventData'] then
    FCountEventData := AObject.Values['countEventData'].Value.ToInteger;
  if nil <> AObject.Values['events'] then
    FEvents := AObject.Values['events'].Value.ToInteger;
  if nil <> AObject.Values['logsOnline'] then
    FLogsOnline := AObject.Values['logsOnline'].Value.ToInteger;
  if nil <> AObject.Values['logsIdentified'] then
    FLogsIdentified := AObject.Values['logsIdentified'].Value.ToInteger;
  if nil <> AObject.Values['logsCollected'] then
    FLogsCollected := AObject.Values['logsCollected'].Value.ToInteger;
  if nil <> AObject.Values['activeUsers'] then
    FActiveUsers := AObject.Values['activeUsers'].Value.ToInteger;
  if nil <> AObject.Values['activePersons'] then
    FActivePersons := AObject.Values['activePersons'].Value.ToInteger;
  if nil <> AObject.Values['activeHosts'] then
    FActiveHosts := AObject.Values['activeHosts'].Value.ToInteger;
  if nil <> AObject.Values['activeLogSources'] then
    FActiveLogSources := AObject.Values['activeLogSources'].Value.ToInteger;
  if nil <> AObject.Values['fingerprint'] then
    FFingerprint := AObject.Values['fingerprint'].Value;
  if nil <> AObject.Values['coreVersion'] then
    FCoreVersion := AObject.Values['coreVersion'].Value;
  if nil <> AObject.Values['emdbVersion'] then
    FEmdbVersion := AObject.Values['emdbVersion'].Value;
  if nil <> AObject.Values['clientVersion'] then
    FClientVersion := AObject.Values['clientVersion'].Value;
  if nil <> AObject.Values['snapshotTime'] then
    FSnapshotTime := ISO8601ToDate(AObject.Values['snapshotTime'].Value);
  if nil <> AObject.Values['masterLicenseId'] then
    FMasterLicenseID := AObject.Values['masterLicenseId'].Value.ToInteger;
  if nil <> AObject.Values['deploymentId'] then
    FDeploymentID := AObject.Values['deploymentId'].Value.ToInteger;
  if nil <> AObject.Values['modifier'] then
    FModifier := AObject.Values['modifier'].Value;
  if nil <> AObject.Values['modified'] then
    FModified := ISO8601ToDate(AObject.Values['modified'].Value);
  if nil <> AObject.Values['created'] then
    FCreated := ISO8601ToDate(AObject.Values['created'].Value);
  if nil <> AObject.Values['snapshotId'] then
    FSnapshotID := AObject.Values['snapshotId'].Value.ToInteger;
end;
{$ENDREGION}

{$REGION 'TSnapshotList'}
constructor TSnapshotList.Create;
begin
  inherited Create;
  FList := TObjectList<TSnapshot>.Create(TRUE);
end;

constructor TSnapshotList.Create(ASnapshotList: TSnapshotList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TSnapshot>.Create(TRUE);
  for i := 0 to (ASnapshotList.Count - 1) do
    FList.Add(TSnapshot.Create(ASnapshotList[i]));
end;

destructor TSnapshotList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TSnapshotList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSnapshotList.GetSnapshot(AIndex: Integer): TSnapshot;
begin
  Result := FList[AIndex];
end;

function TSnapshotList.GetFieldCount: Integer;
begin
  Result := 33;
end;

function TSnapshotList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'Snapshot ID';
  1: Result := 'Created';
  2: Result := 'Modified';
  3: Result := 'Modified By';
  4: Result := 'Deployment ID';
  5: Result := 'Master Licence ID';
  6: Result := 'Snapshot Time';
  7: Result := 'Client Version';
  8: Result := 'EMDB Version';
  9: Result := 'Core Version';
  10: Result := 'Fingerprint';
  11: Result := 'Active Sources';
  12: Result := 'Active Hosts';
  13: Result := 'Active Persons';
  14: Result := 'Active Users';
  15: Result := 'Logs Collected';
  16: Result := 'Logs Identified';
  17: Result := 'Logs Online';
  18: Result := 'Events';
  19: Result := 'CountEventData';
  20: Result := 'CountEventsForwarded';
  21: Result := 'CountEventsAIEngine';
  22: Result := 'CountAlarms';
  23: Result := 'CountDeduplicatedLogs';
  24: Result := 'CountCollectors';
  25: Result := 'EnabledKBModules';
  26: Result := 'AgentsByOS';
  27: Result := 'FIMAgentsByOS';
  28: Result := 'RTFIMAgentsByOS';
  29: Result := 'PMAgentsByOS';
  30: Result := 'NCMAgentsByOS';
  31: Result := 'UAMAgentsByOS';
  32: Result := 'DLDAgentsByOS';
  end;
end;

function TSnapshotList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].FSnapshotID;
  1: Result := Flist[ARecord].Created;
  2: Result := Flist[ARecord].Modified;
  3: Result := Flist[ARecord].Modifier;
  4: Result := Flist[ARecord].DeploymentID;
  5: Result := Flist[ARecord].MasterLicenseID;
  6: Result := Flist[ARecord].SnapshotTime;
  7: Result := Flist[ARecord].ClientVersion;
  8: Result := Flist[ARecord].EMDBVersion;
  9: Result := Flist[ARecord].CoreVersion;
  10: Result := Flist[ARecord].Fingerprint;
  11: Result := Flist[ARecord].ActiveLogSources;
  12: Result := Flist[ARecord].ActiveHosts;
  13: Result := Flist[ARecord].ActivePersons;
  14: Result := Flist[ARecord].ActiveUsers;
  15: Result := Flist[ARecord].LogsCollected;
  16: Result := Flist[ARecord].LogsIdentified;
  17: Result := Flist[ARecord].LogsOnline;
  18: Result := Flist[ARecord].Events;
  19: Result := Flist[ARecord].CountEventData;
  20: Result := Flist[ARecord].CountEventsForwarded;
  21: Result := Flist[ARecord].CountEventsAIEngine;
  22: Result := Flist[ARecord].CountAlarms;
  23: Result := Flist[ARecord].CountDeduplicatedLogs;
  24: Result := Flist[ARecord].CountCollectors;
  25: Result := Flist[ARecord].EnabledKBModules;
  26: Result := Flist[ARecord].AgentsByOS;
  27: Result := Flist[ARecord].FIMAgentsByOS;
  28: Result := Flist[ARecord].RTFIMAgentsByOS;
  29: Result := Flist[ARecord].PMAgentsByOS;
  30: Result := Flist[ARecord].NCMAgentsByOS;
  31: Result := Flist[ARecord].UAMAgentsByOS;
  32: Result := Flist[ARecord].DLDAgentsByOS;
  end;
end;

procedure TSnapshotList.Clear;
begin
  FList.Clear;
end;

procedure TSnapshotList.Add(ASnapshot: TSnapshot);
begin
  FList.Add(ASnapshot);
end;

procedure TSnapshotList.SubmitAgentsByOSVersion;
var
  LTemp: TFDMemTable;
  LConnection: TFDConnection;
  LBulkInsert: TFDStoredProc;
  i, j: Integer;
  LSettings: TDBLoginSettings;
begin
  LTemp := GetOSByVerParamTable;
  for i := 0 to (FList.Count - 1) do
  begin
    if FList[i].AgentsByOSList.Count > 0 then
    begin
      for j := 0 to (FList[i].AgentsByOSList.Count - 1) do
      begin
        LTemp.Append;
        LTemp.FieldByName('SnapshotID').AsInteger := FList[i].SnapshotID;
        LTemp.FieldByName('OS').AsString := FList[i].AgentsByOSList[j].OSName;
        LTemp.FieldByName('OSVersion').AsString := FList[i].AgentsByOSList[j].OSVersion;
        LTemp.FieldByName('AgentCount').AsInteger := FList[i].AgentsByOSList[j].AgentCount;
      end;
    end;
  end;

  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LConnection.Connected := TRUE;
    LBulkInsert := TFDStoredProc.Create(nil);
    try
      LBulkInsert.FetchOptions.Items := LBulkInsert.FetchOptions.Items - [fiMeta];
      LBulkInsert.StoredProcName := 'UpdateOSByVersion';
      LBulkInsert.Params.Clear;
      LBulkInsert.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LBulkInsert.Connection := LConnection;
      with LBulkInsert.Params.ADD('@OSByVer', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'OSByVersion_TableType';
        AsDataSet := LTemp;
      end;
      LBulkInsert.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LBulkInsert.Free;
    end;
  finally
    LConnection.Free;
  end;

end;

procedure TSnapshotList.SubmitFIMAgentsByOSVersion;
var
  LTemp: TFDMemTable;
  LConnection: TFDConnection;
  LBulkInsert: TFDStoredProc;
  i, j: Integer;
  LSettings: TDBLoginSettings;
begin
  LTemp := GetOSByVerParamTable;
  for i := 0 to (FList.Count - 1) do
  begin
    if FList[i].AgentsByOSList.Count > 0 then
    begin
      for j := 0 to (FList[i].FIMAgentsByOSList.Count - 1) do
      begin
        LTemp.Append;
        LTemp.FieldByName('SnapshotID').AsInteger := FList[i].SnapshotID;
        LTemp.FieldByName('OS').AsString := FList[i].AgentsByOSList[j].OSName;
        LTemp.FieldByName('OSVersion').AsString := FList[i].AgentsByOSList[j].OSVersion;
        LTemp.FieldByName('AgentCount').AsInteger := FList[i].AgentsByOSList[j].AgentCount;
      end;
    end;
  end;

  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LConnection.Connected := TRUE;
    LBulkInsert := TFDStoredProc.Create(nil);
    try
      LBulkInsert.FetchOptions.Items := LBulkInsert.FetchOptions.Items - [fiMeta];
      LBulkInsert.StoredProcName := 'UpdateFIMOSByVersion';
      LBulkInsert.Params.Clear;
      LBulkInsert.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LBulkInsert.Connection := LConnection;
      with LBulkInsert.Params.ADD('@OSByVer', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'OSByVersion_TableType';
        AsDataSet := LTemp;
      end;
      LBulkInsert.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LBulkInsert.Free;
    end;
  finally
    LConnection.Free;
  end;

end;

procedure TSnapshotList.SubmitRTFIMAgentsByOSVersion;
var
  LTemp: TFDMemTable;
  LConnection: TFDConnection;
  LBulkInsert: TFDStoredProc;
  i, j: Integer;
  LSettings: TDBLoginSettings;
begin
  LTemp := GetOSByVerParamTable;
  for i := 0 to (FList.Count - 1) do
  begin
    if FList[i].AgentsByOSList.Count > 0 then
    begin
      for j := 0 to (FList[i].RTFIMAgentsByOSList.Count - 1) do
      begin
        LTemp.Append;
        LTemp.FieldByName('SnapshotID').AsInteger := FList[i].SnapshotID;
        LTemp.FieldByName('OS').AsString := FList[i].AgentsByOSList[j].OSName;
        LTemp.FieldByName('OSVersion').AsString := FList[i].AgentsByOSList[j].OSVersion;
        LTemp.FieldByName('AgentCount').AsInteger := FList[i].AgentsByOSList[j].AgentCount;
      end;
    end;
  end;

  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LConnection.Connected := TRUE;
    LBulkInsert := TFDStoredProc.Create(nil);
    try
      LBulkInsert.FetchOptions.Items := LBulkInsert.FetchOptions.Items - [fiMeta];
      LBulkInsert.StoredProcName := 'UpdateRTFIMOSByVersion';
      LBulkInsert.Params.Clear;
      LBulkInsert.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LBulkInsert.Connection := LConnection;
      with LBulkInsert.Params.ADD('@OSByVer', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'OSByVersion_TableType';
        AsDataSet := LTemp;
      end;
      LBulkInsert.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LBulkInsert.Free;
    end;
  finally
    LConnection.Free;
  end;

end;

procedure TSnapshotList.SubmitPMAgentsByOSVersion;
var
  LTemp: TFDMemTable;
  LConnection: TFDConnection;
  LBulkInsert: TFDStoredProc;
  i, j: Integer;
  LSettings: TDBLoginSettings;
begin
  LTemp := GetOSByVerParamTable;
  for i := 0 to (FList.Count - 1) do
  begin
    if FList[i].AgentsByOSList.Count > 0 then
    begin
      for j := 0 to (FList[i].PMAgentsByOSList.Count - 1) do
      begin
        LTemp.Append;
        LTemp.FieldByName('SnapshotID').AsInteger := FList[i].SnapshotID;
        LTemp.FieldByName('OS').AsString := FList[i].AgentsByOSList[j].OSName;
        LTemp.FieldByName('OSVersion').AsString := FList[i].AgentsByOSList[j].OSVersion;
        LTemp.FieldByName('AgentCount').AsInteger := FList[i].AgentsByOSList[j].AgentCount;
      end;
    end;
  end;

  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LConnection.Connected := TRUE;
    LBulkInsert := TFDStoredProc.Create(nil);
    try
      LBulkInsert.FetchOptions.Items := LBulkInsert.FetchOptions.Items - [fiMeta];
      LBulkInsert.StoredProcName := 'UpdatePMOSByVersion';
      LBulkInsert.Params.Clear;
      LBulkInsert.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LBulkInsert.Connection := LConnection;
      with LBulkInsert.Params.ADD('@OSByVer', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'OSByVersion_TableType';
        AsDataSet := LTemp;
      end;
      LBulkInsert.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LBulkInsert.Free;
    end;
  finally
    LConnection.Free;
  end;

end;

procedure TSnapshotList.SubmitKBModules;
var
  LTemp: TFDMemTable;
  LConnection: TFDConnection;
  LBulkInsert: TFDStoredProc;
  i, j: Integer;
  LSettings: TDBLoginSettings;
begin
  LTemp := GetKBModulesParamTable;
  for i := 0 to (FList.Count - 1) do
  begin
    if FList[i].KBModulesList.Count > 0 then
    begin
      for j := 0 to (FList[i].KBModulesList.Count - 1) do
      begin
        LTemp.Append;
        LTemp.FieldByName('SnapshotID').AsInteger := FList[i].SnapshotID;
        LTemp.FieldByName('KBModuleID').AsInteger := FList[i].KBModulesList[j].KBModuleID;
        LTemp.FieldByName('LatestVersion').AsString := FList[i].KBModulesList[j].LatestVersion;
        LTemp.FieldByName('ModuleName').AsString := FList[i].KBModulesList[j].Name;
      end;
    end;
  end;

  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LConnection.Connected := TRUE;
    LBulkInsert := TFDStoredProc.Create(nil);
    try
      LBulkInsert.FetchOptions.Items := LBulkInsert.FetchOptions.Items - [fiMeta];
      LBulkInsert.StoredProcName := 'UpdateInstalledKBModules';
      LBulkInsert.Params.Clear;
      LBulkInsert.Params.ADD('@RETURN_VALUE', ftInteger, -1, ptResult);
      LBulkInsert.Connection := LConnection;
      with LBulkInsert.Params.ADD('@KBModules', ftDataSet, -1, ptInput) do
      begin
        DataTypeName := 'InstalledKBModules_TableType';
        AsDataSet := LTemp;
      end;
      LBulkInsert.ExecProc;
    finally
      LConnection.Connected := FALSE;
      LBulkInsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TSnapshotList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TSnapshotList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LListItem: TSnapshot;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LListItem := TSnapshot.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TSnapshotList.GetAllForDeployment(ADeploymentID: Integer): TSnapshotList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TSnapshot;
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
      LSQL.Add(Format('Where DeploymentID=%d ', [ADeploymentID]) );
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
        Result := TSnapshotList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateSnapshot(LQuery);
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

class function TSnapshotList.GetAllMostRecent: TSnapshotList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TSnapshot;
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
      LSQL.Add('Inner Join Deployment On Snapshot.DeploymentID = Deployment.DeploymentID ');
      LSQL.Add('where Snapshot.Created in (select MAX(S.Created) from Snapshot S ');
      LSQL.Add('  where S.DeploymentID = Deployment.DeploymentID) ');
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
        Result := TSnapshotList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateSnapshot(LQuery);
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

class function TSnapshotList.GetOSByVerParamTable: TFDMemTable;
begin
  Result := TFDMemTable.CREATE(nil);
  Result.FieldDefs.Add('SnapshotID', ftInteger);
  Result.FieldDefs.Add('OS', ftString, 50);
  Result.FieldDefs.Add('OSVersion', ftString, 50);
  Result.FieldDefs.Add('AgentCount', ftInteger);
  Result.Active := TRUE;
end;

class function TSnapshotList.GetKBModulesParamTable: TFDMemTable;
begin
  Result := TFDMemTable.CREATE(nil);
  Result.FieldDefs.Add('SnapshotID', ftInteger);
  Result.FieldDefs.Add('KBModuleID', ftInteger);
  Result.FieldDefs.Add('LatestVersion', ftString, 50);
  Result.FieldDefs.Add('ModuleName', ftString, 50);
  Result.Active := TRUE;
end;

class function TSnapshotList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select Snapshot.SnapshotID, ');
  Result.Add('Snapshot.RowVer, ');
  Result.Add('Snapshot.Created, ');
  Result.Add('Snapshot.Modified, ');
  Result.Add('Snapshot.Modifier, ');
  Result.Add('Snapshot.DeploymentID, ');
  Result.Add('Snapshot.MasterLicenseID, ');
  Result.Add('Snapshot.SnapshotTime, ');
  Result.Add('Snapshot.ClientVersion, ');
  Result.Add('Snapshot.EmdbVersion, ');
  Result.Add('Snapshot.CoreVersion, ');
  Result.Add('Snapshot.Fingerprint, ');
  Result.Add('Snapshot.ActiveLogSources, ');
  Result.Add('Snapshot.ActiveHosts, ');
  Result.Add('Snapshot.ActivePersons, ');
  Result.Add('Snapshot.ActiveUsers, ');
  Result.Add('Snapshot.LogsCollected, ');
  Result.Add('Snapshot.LogsIdentified, ');
  Result.Add('Snapshot.LogsOnline, ');
  Result.Add('Snapshot.Events, ');
  Result.Add('Snapshot.CountEventData, ');
  Result.Add('Snapshot.CountEventsForwarded, ');
  Result.Add('Snapshot.CountEventsAIEngine, ');
  Result.Add('Snapshot.CountAlarms, ');
  Result.Add('Snapshot.CountDeduplicatedLogs, ');
  Result.Add('Snapshot.CountCollectors, ');
  Result.Add('Snapshot.EnabledKBModules, ');
  Result.Add('Snapshot.AgentsByOS, ');
  Result.Add('Snapshot.FIMAgentsByOS, ');
  Result.Add('Snapshot.RTFIMAgentsByOS, ');
  Result.Add('Snapshot.PMAgentsByOS, ');
  Result.Add('Snapshot.NCMAgentsByOS, ');
  Result.Add('Snapshot.UAMAgentsByOS, ');
  Result.Add('Snapshot.DLDAgentsByOS ');
  Result.Add('From Snapshot ');
end;

class function TSnapshotList.CreateSnapshot(ADataSet: TDataSet): TSnapshot;
begin
  Result := TSnapshot.Create;
  Result.SnapshotID := ADataSet.Fields[0].AsInteger;
  Result.Created := ADataSet.Fields[2].AsDateTime;
  Result.Modified := ADataSet.Fields[3].AsDateTime;
  Result.Modifier := ADataSet.Fields[4].AsString;
  Result.DeploymentID := ADataSet.Fields[5].AsInteger;
  Result.MasterLicenseID := ADataSet.Fields[6].AsInteger;
  Result.SnapshotTime := ADataSet.Fields[7].AsDateTime;
  Result.ClientVersion := ADataSet.Fields[8].AsString;
  Result.EmdbVersion := ADataSet.Fields[9].AsString;
  Result.CoreVersion := ADataSet.Fields[10].AsString;
  Result.Fingerprint := ADataSet.Fields[11].AsString;
  Result.ActiveLogSources := ADataSet.Fields[12].AsInteger;
  Result.ActiveHosts := ADataSet.Fields[13].AsInteger;
  Result.ActivePersons := ADataSet.Fields[14].AsInteger;
  Result.ActiveUsers := ADataSet.Fields[15].AsInteger;
  Result.LogsCollected := ADataSet.Fields[16].AsLargeInt;
  Result.LogsIdentified := ADataSet.Fields[17].AsLargeInt;
  Result.LogsOnline := ADataSet.Fields[18].AsLargeInt;
  Result.Events := ADataSet.Fields[19].AsLargeInt;
  Result.CountEventData := ADataSet.Fields[20].AsLargeInt;
  Result.CountEventsForwarded := ADataSet.Fields[21].AsLargeInt;
  Result.CountEventsAIEngine := ADataSet.Fields[22].AsLargeInt;
  Result.CountAlarms := ADataSet.Fields[23].AsLargeInt;
  Result.CountDeduplicatedLogs := ADataSet.Fields[24].AsLargeInt;
  Result.CountCollectors := ADataSet.Fields[25].AsInteger;
  Result.EnabledKBModules := ADataSet.Fields[26].AsString;
  Result.AgentsByOS := ADataSet.Fields[27].AsString;
  Result.FIMAgentsByOS := ADataSet.Fields[28].AsString;
  Result.RTFIMAgentsByOS := ADataSet.Fields[29].AsString;
  Result.PMAgentsByOS := ADataSet.Fields[30].AsString;
  Result.NCMAgentsByOS := ADataSet.Fields[31].AsString;
  Result.UAMAgentsByOS := ADataSet.Fields[32].AsString;
  Result.DLDAgentsByOS := ADataSet.Fields[33].AsString;
  Result.AgentsByOSList.Free;
  Result.AgentsByOSList := TAgentsByOSList.GetAll(Result.AgentsByOS);
  Result.FIMAgentsByOSList.Free;
  Result.FIMAgentsByOSList := TAgentsByOSList.GetAll(Result.RTFIMAgentsByOS);
  Result.RTFIMAgentsByOSList.Free;
  Result.RTFIMAgentsByOSList := TAgentsByOSList.GetAll(Result.RTFIMAgentsByOS);
  Result.PMAgentsByOSList.Free;
  Result.PMAgentsByOSList := TAgentsByOSList.GetAll(Result.PMAgentsByOS);
  Result.KBModulesList.Free;
  Result.KBModulesList := TKBModuleList.GetAll(Result.EnabledKBModules);
end;
{$ENDREGION}

end.
