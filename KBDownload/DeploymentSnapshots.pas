unit DeploymentSnapshots;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxEdit, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxNavigator, cxGridCustomTableView, cxGridTableView,
  cxGridCustomView, cxInplaceContainer, cxVGrid, cxClasses, cxGridLevel, cxGrid,
  dxCore, DateUtils, System.UITypes, KB.Deployment, KB.Snapshot, RecordListExport,
  Vcl.Menus, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, KBModule, AgentsByOS, Vcl.ExtCtrls,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinTheBezier, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TSnapshotList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(ADeploymentID: Integer);
    destructor Destroy; override;
    property Snapshots: TSnapshotList read FList;
  end;

  TModulesDataSource = class(TcxCustomDataSource)
  private
    FList: TKBModuleList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AModuleXML: String);
    destructor Destroy; override;
    property KBModules: TKBModuleList read FList;
  end;

  TAgentsByOSDataSource = class(TcxCustomDataSource)
  private
    FList: TAgentsByOSList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AModuleXML: String);
    destructor Destroy; override;
    property AgentsByOS: TAgentsByOSList read FList;
  end;

  TFIMAgentsByOSDataSource = class(TcxCustomDataSource)
  private
    FList: TAgentsByOSList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AModuleXML: String);
    destructor Destroy; override;
    property AgentsByOS: TAgentsByOSList read FList;
  end;

  TfmDeploymentSnapshots = class(TForm)
    lvSnapshots: TcxGridLevel;
    gSnapshots: TcxGrid;
    tvSnapshots: TcxGridTableView;
    colID: TcxGridColumn;
    colSnapshotTime: TcxGridColumn;
    colEMDB: TcxGridColumn;
    colCoreVersion: TcxGridColumn;
    colCreated: TcxGridColumn;
    ppmSnapShots: TPopupMenu;
    ppmiExportToExcel: TMenuItem;
    Panel1: TPanel;
    cxVerticalGrid1: TcxVerticalGrid;
    erActiveLogSources: TcxEditorRow;
    erActiveHosts: TcxEditorRow;
    erActivePersons: TcxEditorRow;
    erActiveUsers: TcxEditorRow;
    erLogsCollected: TcxEditorRow;
    erLogsIdentitifed: TcxEditorRow;
    erLogsOnline: TcxEditorRow;
    erEvents: TcxEditorRow;
    gSnapshotDetails: TcxGrid;
    tvKBModules: TcxGridTableView;
    colModuleID: TcxGridColumn;
    colModuleName: TcxGridColumn;
    colModuleVersion: TcxGridColumn;
    lvKBModules: TcxGridLevel;
    lvAgentsByOS: TcxGridLevel;
    tvAgentsByOS: TcxGridTableView;
    colOS: TcxGridColumn;
    coOSVersion: TcxGridColumn;
    colAgentCount: TcxGridColumn;
    lvFIMAgentsByOS: TcxGridLevel;
    tvFIMAgentsByOS: TcxGridTableView;
    colFIMOS: TcxGridColumn;
    colFIMOSVersion: TcxGridColumn;
    colFIMAgentCount: TcxGridColumn;
    procedure tvSnapshotsCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure ppmiExportToExcelClick(Sender: TObject);
  private
    { Private declarations }
    FDeployment: TDeployment;
    procedure LoadGrid(ADeploymentID: Integer);
    procedure ClearGrid;
    procedure LoadKBModuleGrid(AXml: String);
    procedure ClearKBModuleGrid;
    procedure LoadAgentsByOSGrid(AXml: String);
    //procedure ClearAgentsByOSGrid;
    procedure LoadFIMAgentsByOSGrid(AXml: String);
    //procedure ClearFIMAgentsByOSGrid;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ADeployment: TDeployment); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
{$REGION 'TGridDataSource'}
constructor TGridDataSource.Create(ADeploymentID: Integer);
begin
  FList := TSnapshotList.GetAllForDeployment(ADeploymentID);
  if nil = FList then
    FList := TSnapshotList.Create;
end;

destructor TGridDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TGridDataSource.GetRecordCount: Integer;
begin
  if nil = FList then
    Result := 0
  else
    Result := FList.Count;
end;

function TGridDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TSnapshot;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.SnapshotID;
    1: Result := TTimeZone.Local.ToLocalTime(LRec.SnapshotTime);
    2: Result := LRec.EmdbVersion;
    3: Result := LRec.CoreVersion;
    4: Result := TTimeZone.Local.ToLocalTime(LRec.Created);
  end;
end;
{$ENDREGION}

{$REGION 'TModulesDataSource'}
constructor TModulesDataSource.Create(AModuleXML: String);
begin
  FList := TKBModuleList.GetAll(AModuleXML);
  if nil = FList then
    FList := TKBModuleList.Create;
end;

destructor TModulesDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TModulesDataSource.GetRecordCount: Integer;
begin
  if nil = FList then
    Result := 0
  else
    Result := FList.Count;
end;

function TModulesDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TKBModule;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.KBModuleID;
    1: Result := LRec.Name;
    2: Result := LRec.LatestVersion;
  end;
end;
{$ENDREGION}

{$REGION 'TAgentsByOSDataSource'}
constructor TAgentsByOSDataSource.Create(AModuleXML: String);
begin
  FList := TAgentsByOSList.GetAll(AModuleXML);
  if nil = FList then
    FList := TAgentsByOSList.Create;
end;

destructor TAgentsByOSDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TAgentsByOSDataSource.GetRecordCount: Integer;
begin
  if nil = FList then
    Result := 0
  else
    Result := FList.Count;
end;

function TAgentsByOSDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TAgentsByOS;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.OSName;
    1: Result := LRec.OSVersion;
    2: Result := LRec.AgentCount;
  end;
end;
{$ENDREGION}

{$REGION 'TFIMAgentsByOSDataSource'}
constructor TFIMAgentsByOSDataSource.Create(AModuleXML: String);
begin
  FList := TAgentsByOSList.GetAll(AModuleXML);
  if nil = FList then
    FList := TAgentsByOSList.Create;
end;

destructor TFIMAgentsByOSDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TFIMAgentsByOSDataSource.GetRecordCount: Integer;
begin
  if nil = FList then
    Result := 0
  else
    Result := FList.Count;
end;

function TFIMAgentsByOSDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TAgentsByOS;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.OSName;
    1: Result := LRec.OSVersion;
    2: Result := LRec.AgentCount;
  end;
end;
{$ENDREGION}


constructor TfmDeploymentSnapshots.Create(AOwner: TComponent; ADeployment: TDeployment);
begin
  inherited Create(AOwner);
  FDeployment := TDeployment.Create(ADeployment);
  LoadGrid(FDeployment.DeploymentID);
  Self.Caption := 'Deployment Snapshots for Licence ID ' + IntToStr(FDeployment.MasterLicenseID);
end;

destructor TfmDeploymentSnapshots.Destroy;
begin
  ClearGrid;
  ClearKBModuleGrid;
  FDeployment.Free;
  inherited Destroy;
end;

procedure TfmDeploymentSnapshots.LoadGrid(ADeploymentID: Integer);
var
  LDS: TGridDataSource;
begin
  tvSnapshots.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvSnapshots.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvSnapshots.DataController.CustomDataSource);
      tvSnapshots.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvSnapshots.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create(ADeploymentID);
      tvSnapshots.DataController.CustomDataSource := LDS;
    finally
      tvSnapshots.DataController.EndFullUpdate;
    end;
  finally
    tvSnapshots.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeploymentSnapshots.ClearGrid;
var
  LDS: TGridDataSource;
begin
  tvSnapshots.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvSnapshots.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvSnapshots.DataController.CustomDataSource);
      tvSnapshots.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvSnapshots.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeploymentSnapshots.LoadKBModuleGrid(AXml: String);
var
  LDS: TModulesDataSource;
begin
  tvKBModules.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvKBModules.DataController.CustomDataSource) then
    begin
      LDS := TModulesDataSource(tvKBModules.DataController.CustomDataSource);
      tvKBModules.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
    if '' <> Trim(AXml) then
    begin
      tvKBModules.DataController.BeginFullUpdate;
      try
        LDS := TModulesDataSource.Create(AXml);
        tvKBModules.DataController.CustomDataSource := LDS;
      finally
        tvKBModules.DataController.EndFullUpdate;
      end;
    end;
  finally
    tvKBModules.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeploymentSnapshots.ClearKBModuleGrid;
var
  LDS: TModulesDataSource;
begin
  tvKBModules.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvKBModules.DataController.CustomDataSource) then
    begin
      LDS := TModulesDataSource(tvKBModules.DataController.CustomDataSource);
      tvKBModules.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvKBModules.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeploymentSnapshots.LoadAgentsByOSGrid(AXml: String);
var
  LDS: TAgentsByOSDataSource;
begin
  tvAgentsByOS.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvAgentsByOS.DataController.CustomDataSource) then
    begin
      LDS := TAgentsByOSDataSource(tvAgentsByOS.DataController.CustomDataSource);
      tvAgentsByOS.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
    if '' <> Trim(AXml) then
    begin
      tvAgentsByOS.DataController.BeginFullUpdate;
      try
        LDS := TAgentsByOSDataSource.Create(AXml);
        tvAgentsByOS.DataController.CustomDataSource := LDS;
      finally
        tvAgentsByOS.DataController.EndFullUpdate;
      end;
    end;
  finally
    tvAgentsByOS.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

{
procedure TfmDeploymentSnapshots.ClearAgentsByOSGrid;
var
  LDS: TAgentsByOSDataSource;
begin
  tvAgentsByOS.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvAgentsByOS.DataController.CustomDataSource) then
    begin
      LDS := TAgentsByOSDataSource(tvAgentsByOS.DataController.CustomDataSource);
      tvAgentsByOS.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvAgentsByOS.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
}
procedure TfmDeploymentSnapshots.LoadFIMAgentsByOSGrid(AXml: String);
var
  LDS: TFIMAgentsByOSDataSource;
begin
  tvFIMAgentsByOS.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvAgentsByOS.DataController.CustomDataSource) then
    begin
      LDS := TFIMAgentsByOSDataSource(tvFIMAgentsByOS.DataController.CustomDataSource);
      tvFIMAgentsByOS.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
    if '' <> Trim(AXml) then
    begin
      tvFIMAgentsByOS.DataController.BeginFullUpdate;
      try
        LDS := TFIMAgentsByOSDataSource.Create(AXml);
        tvFIMAgentsByOS.DataController.CustomDataSource := LDS;
      finally
        tvFIMAgentsByOS.DataController.EndFullUpdate;
      end;
    end;
  finally
    tvFIMAgentsByOS.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
{
procedure TfmDeploymentSnapshots.ClearFIMAgentsByOSGrid;
var
  LDS: TFIMAgentsByOSDataSource;
begin
  tvFIMAgentsByOS.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvFIMAgentsByOS.DataController.CustomDataSource) then
    begin
      LDS := TFIMAgentsByOSDataSource(tvFIMAgentsByOS.DataController.CustomDataSource);
      tvFIMAgentsByOS.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvFIMAgentsByOS.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
}
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmDeploymentSnapshots.tvSnapshotsCellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  LSnapshotID: Integer;
  LSnapshot: TSnapshot;
  i: Integer;
begin
  LSnapshot := nil;
  if 0 = tvSnapshots.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;

  LSnapshotID := tvSnapshots.DataController.Values[tvSnapshots.Controller.SelectedRecords[0].RecordIndex, colID.Index];
  for i := 0 to (TGridDataSource(tvSnapshots.DataController.CustomDataSource).Snapshots.Count - 1) do
  begin
    if LSnapshotID = TGridDataSource(tvSnapshots.DataController.CustomDataSource).Snapshots[i].SnapshotID then
      LSnapshot := TGridDataSource(tvSnapshots.DataController.CustomDataSource).Snapshots[i];
  end;
  if nil = LSnapshot then EXIT;

  erActiveLogSources.Properties.Value := LSnapshot.ActiveLogSources;
  erActiveHosts.Properties.Value := LSnapshot.ActiveHosts;
  erActivePersons.Properties.Value := LSnapshot.ActivePersons;
  erActiveUsers.Properties.Value := LSnapshot.ActiveUsers;
  erLogsCollected.Properties.Value := LSnapshot.LogsCollected;
  erLogsIdentitifed.Properties.Value := LSnapshot.LogsIdentified;
  erLogsOnline.Properties.Value := LSnapshot.LogsOnline;
  erEvents.Properties.Value := LSnapshot.Events;

  LoadKBModuleGrid(LSnapshot.EnabledKBModules);
  LoadAgentsByOSGrid(LSnapshot.AgentsByOS);
  LoadFIMAgentsByOSGrid(LSnapshot.FIMAgentsByOS);
end;

procedure TfmDeploymentSnapshots.ppmiExportToExcelClick(Sender: TObject);
var
  fm: TfmRecordListExport;
begin
  fm := TfmRecordListExport.Create(nil, 'Snapshots Export', TGridDataSource(tvSnapshots.DataController.CustomDataSource).Snapshots);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

end.
