unit MsgSourceType;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, CommonFunctions,
  FireDAC.Stan.Option, System.Generics.Collections, DataServices,
  DBSettings;

type
  TRecordType = (rtNA = 0, rtSystem = 1, rtUser = 1000000000);
  TIsMST = (mstGroup = 0, mstPublic = 1, mstSystem = 2);
  TLogInterface = (liNotApplicable = 0, liSyslog = 1, liNetflow = 2, liASCIIFlatFile = 3,
                   liWindowsEventLog = 4, (*interface is used for all .net supported pre 2008/vista sources*)
                   liLogRhythmFileMonitor = 5, liUniversalDatabaseLogAdapter = 6,
                   liCheckpointFirewall = 7, liCheckpointLogServer = 8, liCiscoSDEE = 9,
                   liWindowsVistaEventLog = 10, (*interface is used for Vista/2008 sources,*)
                   liDataLossDefender = 11, liUserActivityMonitor = 12, liSNMPTrapReceiver = 13,
                   liProcessMonitor = 14, liNetworkConnectionMonitor = 15, liQualysVulnerabilitySource = 16,
                   lisFlow = 17, liNetAppEventLog = 18, liNessusVulnerabilitySource = 19,
                   liNeXposeVulnerabilitySource = 20, liMetasploitPenetrationSource = 21,
                   lieStreamerSource = 22, liRetinaSource = 23, liRetinaCsSource = 24,
                   liCheckpointFirewallAuditLog = 25, liAIEEvents = 26, liRegistryIntegrityMonitor = 27,
                   liWindowsVistaEventLogSlim = 28, liIP360VulnerabilitySource = 29,
                   liAWSCloudTrailSource = 30, liCradlePointSource = 31, liAWSCloudWatchSource = 32,
                   liAWSS3Source =33, liAWSCloudConfig = 34, liSalesforceSource = 35,
                   liOktaSource = 36, liNessusCloudSource = 37, liBoxSource = 38,
                   liOffice365Source = 39, liTenableSecurityCenterSource = 40,
                   liAWSCloudTrailS3Source = 41);
  TLogInterfaceSupported = ( lisSyslog = 1, lisNetflow = 2, lisSNMPTrapReceiver = 13, lissFlow = 17);

  TMsgSourceType = class
    protected
      FMsgSourceTypeID: Integer;
      FName: String;
      FFullName: String;
      FAbbreviation: String;
      FShortDesc: String;
      FLongDesc: String;
      FParentMsgSourceTypeID: Integer;
      FIsMST: Byte;
      FDateUpdated: TDateTime;
      FMsgSourceFormat: Integer;
      FRecordStatus: Byte;
      FHostWizDefaults: TStream;
      function GetNextID(ARecordType :TRecordType): Integer;
    public
      constructor Create; overload; virtual;
      constructor Create(AMsgSourceType: TMsgSourceType); overload; virtual;
      destructor Destroy; override;
      procedure Save;
      property MsgSourceTypeID: Integer read FMsgSourceTypeID write FMsgSourceTypeID;
      property Name: String read FName write FName;
      property FullName: String read FFullName write FFullName;
      property Abbreviation: String read FAbbreviation write FAbbreviation;
      property ShortDesc: String read FShortDesc write FShortDesc;
      property LongDesc: String read FLongDesc write FLongDesc;
      property ParentMsgSourceTypeID: Integer read FParentMsgSourceTypeID write FParentMsgSourceTypeID;
      property IsMST: Byte read FIsMST write FIsMST;
      property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
      property MsgSourceFormat: Integer read FMsgSourceFormat write FMsgSourceFormat;
      property RecordStatus: Byte read FRecordStatus write FRecordStatus;
      property HostWizDefaults: TStream read FHostWizDefaults;
  end;

  TMsgSourceTypeList = class
    protected
      FList: TObjectList<TMsgSourceType>;
      function GetCount: Integer;
      function GetMsgSourceType(AIndex: Integer): TMsgSourceType;
      class function GetInitialSQL: TStringList;
      class function CreateMsgSourceType(ADataSet: TDataSet): TMsgSourceType;
    public
      constructor Create; overload; virtual;
      constructor Create(AMsgSourceTypeList: TMsgSourceTypeList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(AMsgSourceType: TMsgSourceType);
      class function GetAll: TMsgSourceTypeList;
      property Count: Integer read GetCount;
      property MsgSourceType[AIndex: Integer]: TMsgSourceType read GetMsgSourceType; default; 
  end;

implementation

constructor TMsgSourceType.Create;
begin
  FMsgSourceTypeID := 0;
  FName := '';
  FFullName := '';
  FAbbreviation := '';
  FShortDesc := '';
  FLongDesc := '';
  FParentMsgSourceTypeID := 0;
  FIsMST := 0;
  FDateUpdated := -1.00;
  FMsgSourceFormat := 0;
  FRecordStatus := 0;
  FHostWizDefaults := TMemoryStream.Create;
end;

constructor TMsgSourceType.Create(AMsgSourceType: TMsgSourceType);
begin
  FMsgSourceTypeID := AMsgSourceType.MsgSourceTypeID;
  FName := AMsgSourceType.Name;
  FFullName := AMsgSourceType.FullName;
  FAbbreviation := AMsgSourceType.Abbreviation;
  FShortDesc := AMsgSourceType.ShortDesc;
  FLongDesc := AMsgSourceType.LongDesc;
  FParentMsgSourceTypeID := AMsgSourceType.ParentMsgSourceTypeID;
  FIsMST := AMsgSourceType.IsMST;
  FDateUpdated := AMsgSourceType.DateUpdated;
  FMsgSourceFormat := AMsgSourceType.MsgSourceFormat;
  FRecordStatus := AMsgSourceType.RecordStatus;

  FHostWizDefaults := TMemoryStream.Create;
  AMsgSourceType.HostWizDefaults.Seek(0,0);
  FHostWizDefaults.CopyFrom(AMsgSourceType.HostWizDefaults, AMsgSourceType.HostWizDefaults.Size);
end;

destructor TMsgSourceType.Destroy;
begin
  FHostWizDefaults.Free;
  inherited Destroy;
end;

function TMsgSourceType.GetNextID(ARecordType :TRecordType): Integer;
begin
  var LQueryString := String.Empty;

  var LConnection := TDataServices.GetConnection('LR', TDBSettings.UserName, TDBSettings.Password, TDBSettings.Database, TDBSettings.Server, TDBSettings.WindwosAuth);
  try
    var LNext := TFDQuery.Create(nil);
    try
      LNext.SQL.Add( String.Format('Select (Max(MsgSourceTypeID) + 1) As NextMsgSourceTypeID From MsgSourceType Where MsgSourceTypeID >=%d', [Integer(ARecordType)]) );
      LNext.Connection := LConnection;
      LConnection.Open;
      LNext.Open;
      Result := LNext.Fields[0].AsInteger;
      LNext.Close;
      LConnection.Close;
    finally
      LNext.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

procedure TMsgSourceType.Save;
begin
  var LConnection := TDataServices.GetConnection('LR', TDBSettings.UserName, TDBSettings.Password, TDBSettings.Database, TDBSettings.Server, TDBSettings.WindwosAuth);

  try
    var LUpdate := TFDQuery.Create(nil);
    try
      if FMsgSourceTypeID <> 0 then
      begin
        LUpdate.SQL.Add('Update MsgSourceType Name=@Name, ');
        LUpdate.SQL.Add('FullName=@FullName, ');
        LUpdate.SQL.Add('Abbreviation=@Abbreviation, ');
        LUpdate.SQL.Add('ShortDesc=@ShortDesc, ');
        LUpdate.SQL.Add('LongDesc=@LongDesc, ');
        LUpdate.SQL.Add('ParentMsgSourceTypeID=@ParentMsgSourceTypeID, ');
        LUpdate.SQL.Add('IsMST=@IsMST, ');
        LUpdate.SQL.Add('DateUpdated=@DateUpdated, ');
        LUpdate.SQL.Add('MsgSourceFormat=@MsgSourceFormat, ');
        LUpdate.SQL.Add('RecordStatus=@RecordStatus, ');
        LUpdate.SQL.Add('HostWizDefaults=@HostWizDefaults ');
        LUpdate.SQL.Add('Where MsgSourceTypeID=@MsgSourceTypeID ');
      end else
      begin
        LUpdate.SQL.Add('Insert Into MsgSourceType (MsgSourceTypeID, ');
        LUpdate.SQL.Add('Name, ');
        LUpdate.SQL.Add('FullName, ');
        LUpdate.SQL.Add('Abbreviation, ');
        LUpdate.SQL.Add('ShortDesc, ');
        LUpdate.SQL.Add('LongDesc, ');
        LUpdate.SQL.Add('ParentMsgSourceTypeID, ');
        LUpdate.SQL.Add('IsMST, ');
        LUpdate.SQL.Add('DateUpdated, ');
        LUpdate.SQL.Add('MsgSourceFormat, ');
        LUpdate.SQL.Add('RecordStatus, ');
        LUpdate.SQL.Add('HostWizDefaults) ');

        LUpdate.SQL.Add('Values (@MsgSourceTypeID, ');
        LUpdate.SQL.Add('@Name, ');
        LUpdate.SQL.Add('@FullName, ');
        LUpdate.SQL.Add('@Abbreviation, ');
        LUpdate.SQL.Add('@ShortDesc, ');
        LUpdate.SQL.Add('@LongDesc, ');
        LUpdate.SQL.Add('@ParentMsgSourceTypeID, ');
        LUpdate.SQL.Add('@IsMST, ');
        LUpdate.SQL.Add('@DateUpdated, ');
        LUpdate.SQL.Add('@MsgSourceFormat, ');
        LUpdate.SQL.Add('@RecordStatus, ');
        LUpdate.SQL.Add('@HostWizDefaults) ');
      end;

      LUpdate.Params.Clear;
      LUpdate.Params.Add('@MsgSourceTypeID', ftInteger, -1, ptInput);
      LUpdate.Params.Add('@Name', ftString, 100, ptInput);
      LUpdate.Params.Add('@FullName', ftString, 100, ptInput);
      LUpdate.Params.Add('@Abbreviation', ftString, 20, ptInput);
      LUpdate.Params.Add('@ShortDesc', ftString, 255, ptInput);
      LUpdate.Params.Add('@LongDesc', ftString, 2000, ptInput);
      LUpdate.Params.Add('@ParentMsgSourceTypeID', ftInteger, -1, ptInput);
      LUpdate.Params.Add('@IsMST', ftInteger, -1, ptInput);
      LUpdate.Params.Add('@DateUpdated', ftDateTime, -1, ptInput);
      LUpdate.Params.Add('@MsgSourceFormat', ftInteger, -1, ptInput);
      LUpdate.Params.Add('@RecordStatus', ftInteger, -1, ptInput);
      LUpdate.Params.Add('@HostWizDefaults', ftStream, -1, ptInput);

      LUpdate.Connection := LConnection;
      LConnection.Connected := TRUE;

      if FMsgSourceTypeID <> 0 then
        LUpdate.Params.ParamByName('@MsgSourceTypeID').AsInteger := FMsgSourceTypeID
      else
        //LProc.Params.ParamByName('@MsgSourceTypeID').Clear;
      if '' <> Trim(FName) then
        LUpdate.Params.ParamByName('@Name').AsString := FName
      else
        LUpdate.Params.ParamByName('@Name').Clear;
      if '' <> Trim(FFullName) then
        LUpdate.Params.ParamByName('@FullName').AsString := FFullName
      else
        LUpdate.Params.ParamByName('@FullName').Clear;
      if '' <> Trim(FAbbreviation) then
        LUpdate.Params.ParamByName('@Abbreviation').AsString := FAbbreviation
      else
        LUpdate.Params.ParamByName('@Abbreviation').Clear;
      if '' <> Trim(FShortDesc) then
        LUpdate.Params.ParamByName('@ShortDesc').AsString := FShortDesc
      else
        LUpdate.Params.ParamByName('@ShortDesc').Clear;
      if '' <> Trim(FLongDesc) then
        LUpdate.Params.ParamByName('@LongDesc').AsString := FLongDesc
      else
        LUpdate.Params.ParamByName('@LongDesc').Clear;
      if FParentMsgSourceTypeID > 0 then
        LUpdate.Params.ParamByName('@ParentMsgSourceTypeID').AsInteger := FParentMsgSourceTypeID
      else
        LUpdate.Params.ParamByName('@ParentMsgSourceTypeID').Clear;
      LUpdate.Params.ParamByName('@IsMST').AsInteger := FIsMST;
      if FDateUpdated > 2.00 then
        LUpdate.Params.ParamByName('@DateUpdated').AsDateTime := FDateUpdated
      else
        LUpdate.Params.ParamByName('@DateUpdated').Clear;
      if FMsgSourceFormat > 0 then
        LUpdate.Params.ParamByName('@MsgSourceFormat').AsInteger := FMsgSourceFormat
      else
        LUpdate.Params.ParamByName('@MsgSourceFormat').Clear;
      LUpdate.Params.ParamByName('@RecordStatus').AsInteger := FRecordStatus;
      if 0 = HostWizDefaults.Size then
        LUpdate.Params.ParamByName('@HostWizDefaults').Clear
      else
      begin
        FHostWizDefaults.Seek(0, soFromBeginning);
        LUpdate.Params.ParamByName('@HostWizDefaults').AsStream.CopyFrom(FHostWizDefaults, FHostWizDefaults.Size);
      end;


      LUpdate.ExecSQL;

    finally
      LConnection.Connected := FALSE;
      LUpdate.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TMsgSourceTypeList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMsgSourceTypeList.GetMsgSourceType(AIndex: Integer): TMsgSourceType;
begin
  Result := FList[AIndex];
end;

class function TMsgSourceTypeList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select MsgSourceType.MsgSourceTypeID, ');
  Result.Add('MsgSourceType.Name, ');
  Result.Add('MsgSourceType.FullName, ');
  Result.Add('MsgSourceType.Abbreviation, ');
  Result.Add('MsgSourceType.ShortDesc, ');
  Result.Add('MsgSourceType.LongDesc, ');
  Result.Add('MsgSourceType.ParentMsgSourceTypeID, ');
  Result.Add('MsgSourceType.IsMST, ');
  Result.Add('MsgSourceType.DateUpdated, ');
  Result.Add('MsgSourceType.MsgSourceFormat, ');
  Result.Add('MsgSourceType.RecordStatus, ');
  Result.Add('MsgSourceType.HostWizDefaults ');
  Result.Add('From MsgSourceType ');
end;

class function TMsgSourceTypeList.CreateMsgSourceType(ADataSet: TDataSet): TMsgSourceType;
begin
  Result := TMsgSourceType.Create;
  Result.MsgSourceTypeID := ADataSet.Fields[0].AsInteger;
  Result.Name := ADataSet.Fields[1].AsString;
  Result.FullName := ADataSet.Fields[2].AsString;
  Result.Abbreviation := ADataSet.Fields[3].AsString;
  Result.ShortDesc := ADataSet.Fields[4].AsString;
  Result.LongDesc := ADataSet.Fields[5].AsString;
  Result.ParentMsgSourceTypeID := ADataSet.Fields[6].AsInteger;
  Result.IsMST := ADataSet.Fields[7].AsInteger;
  Result.DateUpdated := ADataSet.Fields[8].AsDateTime;
  Result.MsgSourceFormat := ADataSet.Fields[9].AsInteger;
  Result.RecordStatus := ADataSet.Fields[10].AsInteger;
end;

constructor TMsgSourceTypeList.Create;
begin
  inherited Create;
  FList := TObjectList<TMsgSourceType>.Create(TRUE);
end;

constructor TMsgSourceTypeList.Create(AMsgSourceTypeList: TMsgSourceTypeList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TMsgSourceType>.Create(TRUE);
  for i := 0 to (AMsgSourceTypeList.Count - 1) do 
    FList.Add(TMsgSourceType.Create(AMsgSourceTypeList[i]));
end;

destructor TMsgSourceTypeList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TMsgSourceTypeList.Clear;
begin
  FList.Clear;
end;

procedure TMsgSourceTypeList.Add(AMsgSourceType: TMsgSourceType);
begin
  FList.Add(AMsgSourceType);
end;

class function TMsgSourceTypeList.GetAll: TMsgSourceTypeList;
begin
  Result := TMsgSourceTypeList.Create;

  var LConn := TDataServices.GetConnection('LR', TDBSettings.UserName, TDBSettings.Password, TDBSettings.Database, TDBSettings.Server, TDBSettings.WindwosAuth);
  try
    var LQuery := TFDQuery.Create(nil);
    try
      var LSQL := GetInitialSQL;
      try
        for var i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
        LQuery.Connection := LConn;
        LConn.Open;
        LQuery.OpenOrExecute;
        LQuery.First;
        while not LQuery.EOF do
        begin
          Result.Add( CreateMsgSourceType(LQuery) );
          LQuery.Next;
        end;
      finally
        LSQL.Free;
      end;
    finally
      LQuery.Free;
    end;
  finally
    LConn.Free;
  end;
end;

end.
