unit Deployments;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxCore,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, Vcl.StdCtrls, Vcl.Mask,
  RzEdit, DateUtils, KB.Deployment, cxCheckBox, CommonFunctions, DownloadEnable,
  Vcl.Menus, System.UITypes, DeploymentEdit, DeploymentSnapshots, RecordListExport,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinTheBezier, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxDateRanges;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TDeploymentList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(ADeploymentList: TDeploymentList);
    destructor Destroy; override;
    property Deployments: TDeploymentList read FList;
  end;
  TfmDeployments = class(TForm)
    gbSearch: TRzGroupBox;
    ebSearch: TRzEdit;
    lvDeployments: TcxGridLevel;
    gDeployments: TcxGrid;
    tvDeployments: TcxGridTableView;
    colDeploymentID: TcxGridColumn;
    colLicenceID: TcxGridColumn;
    colFinferprint: TcxGridColumn;
    colModifiedBy: TcxGridColumn;
    colModified: TcxGridColumn;
    colRequireSnapshot: TcxGridColumn;
    colEnforceFingerprint: TcxGridColumn;
    ppmDeployments: TPopupMenu;
    ppmiResetDeploymentID: TMenuItem;
    ppmiNew: TMenuItem;
    ppmiEdit: TMenuItem;
    colAuthorized: TcxGridColumn;
    ppmiSnapshots: TMenuItem;
    ppmiExport: TMenuItem;
    ppmiFilter: TMenuItem;
    odList: TOpenDialog;
    ppmiDisallow: TMenuItem;
    ppmiEnableDownloads: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ebSearchChange(Sender: TObject);
    procedure ebSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ppmiResetDeploymentIDClick(Sender: TObject);
    procedure ppmiNewClick(Sender: TObject);
    procedure ppmiEditClick(Sender: TObject);
    procedure ppmiSnapshotsClick(Sender: TObject);
    procedure ppmiExportClick(Sender: TObject);
    procedure ppmiFilterClick(Sender: TObject);
    procedure ppmDeploymentsPopup(Sender: TObject);
    procedure ppmiDisallowClick(Sender: TObject);
    procedure ppmiEnableDownloadsClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSort(AGridTableView: TcxGridTableView);
    procedure SaveSort(AGridTableView: TcxGridTableView);
    procedure LoadGrid(ADeploymentList: TDeploymentList);
    procedure ClearGrid;
    procedure CompareRecord(ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2, AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
{$REGION 'TGridDataSource'}
constructor TGridDataSource.Create(ADeploymentList: TDeploymentList);
begin
  if nil = ADeploymentList then
    FList := TDeploymentList.Create
  else
    FList := TDeploymentList.Create(ADeploymentList);
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
  LRec: TDeployment;
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
    0: Result := LRec.DeploymentID;
    1: Result := LRec.MasterLicenseID;
    2: Result := LRec.Fingerprint;
    3: Result := TTimeZone.Local.ToLocalTime(LRec.Modified);
    4: Result := LRec.Modifier;
    5: Result := LRec.RequireSnapshot;
    6: Result := LRec.EnforceFingerprint;
    7: Result := LRec.IsAuthorized;
  end;
end;
{$ENDREGION}

constructor TfmDeployments.Create(AOwner: TComponent);
var
  LDeploymentList: TDeploymentList;
begin
  inherited Create(AOwner);
  LoadSort(tvDeployments);
  LDeploymentList := TDeploymentList.GetAll;
  try
    LoadGrid(LDeploymentList);
    tvDeployments.OptionsSelection.MultiSelect := FALSE;
  finally
    LDeploymentList.Free;
  end;
end;

destructor TfmDeployments.Destroy;
begin
  SaveSort(tvDeployments);
  ClearGrid;
  inherited Destroy;
end;

procedure TfmDeployments.LoadSort(AGridTableView: TcxGridTableView);
var
  i: Integer;
  LAllColumnsExist: Boolean;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortList.Delimiter := ',';
    LSortOrderList := TStringList.Create;
    try
      LSortOrderList.Delimiter := ',';
      LSortList.DelimitedText := GetFormKey('Deployments', 'LastSort');
      LSortOrderList.DelimitedText := GetFormKey('Deployments', 'LastSortOrder');
      LAllColumnsExist := TRUE;
      if (not (0 = LSortList.Count)) and (not (0 = LSortOrderList.Count)) then
      begin
        for i := 0 to (LSortList.Count - 1) do
          LAllColumnsExist := LAllColumnsExist and (StrToIntDef(LSortList[i], -1) >= 0) and (StrToIntDef(LSortList[i], -1) < AGridTableView.ColumnCount);

        LAllColumnsExist := LAllColumnsExist and (LSortOrderList.Count = LSortList.Count);
        if LAllColumnsExist then
        begin
          for i := 0 to (LSortList.Count - 1) do
            AGridTableView.Columns[StrToIntDef(LSortList[i], -1)].SortOrder := TdxSortOrder(StrToIntDef(LSortOrderList[i], 0));
        end;
      end else
      begin
        AGridTableView.Columns[1].SortOrder := TdxSortOrder(1);
      end;
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmDeployments.SaveSort(AGridTableView: TcxGridTableView);
var
  i: Integer;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortOrderList := TStringList.Create;
    try
      SetFormKey('Deployments', 'LastSort', '');
      SetFormKey('Deployments', 'LastSortOrder', '');
      //Pre Size  Lists
      for i := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[i].SortOrder then
        begin
          LSortList.Append('');
          LSortOrderList.Append('');
        end;
      end;
      for i := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[i].SortOrder then
        begin
          LSortList[AGridTableView.Columns[i].SortIndex] := IntToStr(i);
          LSortOrderList[AGridTableView.Columns[i].SortIndex] := IntToStr(Integer(AGridTableView.Columns[i].SortOrder));
        end;
      end;
      LSortList.Delimiter := ',';
      LSortOrderList.Delimiter := ',';
      Assert(LSortList.Count = LSortOrderList.Count);
      SetFormKey('Deployments', 'LastSort', LSortList.DelimitedText);
      SetFormKey('Deployments', 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmDeployments.LoadGrid(ADeploymentList: TDeploymentList);
var
  LDS: TGridDataSource;
begin
  tvDeployments.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvDeployments.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvDeployments.DataController.CustomDataSource);
      tvDeployments.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvDeployments.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create(ADeploymentList);
      tvDeployments.DataController.CustomDataSource := LDS;
      tvDeployments.DataController.OnCompare := CompareRecord;
    finally
      tvDeployments.DataController.EndFullUpdate;
    end;
  finally
    tvDeployments.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeployments.ClearGrid;
var
  LDS: TGridDataSource;
begin
  tvDeployments.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvDeployments.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvDeployments.DataController.CustomDataSource);
      tvDeployments.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvDeployments.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeployments.CompareRecord(ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2, AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  LLicence1, LLicence2: Integer;
begin
  try
    if 1 <> AItemIndex then
    begin
      if V1 < V2 then Compare := -1
      else if V1 = V2 then Compare := 0
      else Compare := 1;
    end else
    begin
        LLicence1 := Integer(V1);
        LLicence2 := Integer(V2);
        if LLicence1 < LLicence2 then Compare := -1
        else if LLicence1 = LLicence2 then Compare := 0
        else Compare := 1;
    end;
  except

  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmDeployments.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmDeployments.ebSearchChange(Sender: TObject);
var
  recIndex, rowIndex: Integer;
  LColIndex, i: Integer;
begin
  inherited;
  LColIndex := -1;
  for i := 0 to (tvDeployments.ColumnCount - 1) do
  begin
    if (soNone <> tvDeployments.Columns[i].SortOrder) and (0 = tvDeployments.Columns[i].SortIndex) then
    begin
      LColIndex := i;
      BREAK;
    end;
  end;

  if -1 = LColIndex  then
    EXIT;

  recIndex := tvDeployments.DataController.FindRecordIndexByText(1, LColIndex, ebSearch.Text, true, true, true);
  rowIndex := tvDeployments.DataController.GetRowIndexByRecordIndex(recIndex, True);
  tvDeployments.Controller.FocusedRowIndex := rowIndex;
end;

procedure TfmDeployments.ebSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    case key of
      VK_UP: tvDeployments.Controller.FocusedRowIndex := tvDeployments.Controller.FocusedRowIndex - 1;
      VK_DOWN: tvDeployments.Controller.FocusedRowIndex := tvDeployments.Controller.FocusedRowIndex + 1;
    end;
  except
  end;
end;

procedure TfmDeployments.ppmiResetDeploymentIDClick(Sender: TObject);
begin
  if 1 <> tvDeployments.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;

  var i := tvDeployments.Controller.SelectedRecords[0].RecordIndex;
  var LDeployment := TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[i];

  if nil = LDeployment then
    EXIT;

  LDeployment.ClearFingerPrint;

  MessageDlg('Deployment ID Reset For Licence ' + IntToStr(LDeployment.MasterLicenseID), mtInformation, [mbOK], 0);
  var LDeploymentList := TDeploymentList.GetAll;
  try
    LoadGrid(LDeploymentList);
    tvDeployments.OptionsSelection.MultiSelect := FALSE;
  finally
    LDeploymentList.Free;
  end;
end;

procedure TfmDeployments.ppmiEnableDownloadsClick(Sender: TObject);
begin
  if 1 <> tvDeployments.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;

  var i := tvDeployments.Controller.SelectedRecords[0].RecordIndex;
  var LDeployment := TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[i];

  var fm := TfmDownloadEnable.Create(nil, LDeployment.MasterLicenseID);
  try
    if mrOK <> fm.ShowModal then
      EXIT; //will still free form
  finally
    fm.Free;
  end;

  LDeployment.EnableDownloads;

  MessageDlg(String.Format('Master Licence ID %d is now authorised for downloads.', [LDeployment.MasterLicenseID]), mtInformation, [mbOK], 0);

  var LDeploymentList := TDeploymentList.GetAll;
  try
    LoadGrid(LDeploymentList);
    tvDeployments.OptionsSelection.MultiSelect := FALSE;
  finally
    LDeploymentList.Free;
  end;
end;

procedure TfmDeployments.ppmiNewClick(Sender: TObject);
var
  fm: TfmDeploymentEdit;
  LDeploymentList: TDeploymentList;
begin
  fm := TfmDeploymentEdit.Create(nil, -1);
  try
    if mrOK =fm.ShowModal then
    begin
      LDeploymentList := TDeploymentList.GetAll;
      try
        LoadGrid(LDeploymentList);
        tvDeployments.OptionsSelection.MultiSelect := FALSE;
      finally
        LDeploymentList.Free;
      end;
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmDeployments.ppmiEditClick(Sender: TObject);
var
  fm: TfmDeploymentEdit;
  LDeploymentID: Integer;
  LDeploymentList: TDeploymentList;
begin
  if 0 = tvDeployments.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  LDeploymentID := tvDeployments.DataController.Values[tvDeployments.Controller.SelectedRecords[0].RecordIndex, colDeploymentID.Index];

  fm := TfmDeploymentEdit.Create(nil, LDeploymentID);
  try
    if mrOK =fm.ShowModal then
    begin
      LDeploymentList := TDeploymentList.GetAll;
      try
        LoadGrid(LDeploymentList);
        tvDeployments.OptionsSelection.MultiSelect := FALSE;
      finally
        LDeploymentList.Free;
      end;
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmDeployments.ppmiSnapshotsClick(Sender: TObject);
var
  fm: TfmDeploymentSnapshots;
  LDeploymentID: Integer;
  LDeployment: TDeployment;
  i: Integer;
begin
  LDeployment := nil;
  if 0 = tvDeployments.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  LDeploymentID := tvDeployments.DataController.Values[tvDeployments.Controller.SelectedRecords[0].RecordIndex, colDeploymentID.Index];
  for i := 0 to (TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments.Count - 1) do
  begin
    if LDeploymentID = TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[i].DeploymentID then
      LDeployment := TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[i];
  end;

  fm := TfmDeploymentSnapshots.Create(nil, LDeployment);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TfmDeployments.ppmiExportClick(Sender: TObject);
var
  fm: TfmRecordListExport;
begin
  fm := TfmRecordListExport.Create(nil, 'Deployments Export', TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TfmDeployments.ppmiFilterClick(Sender: TObject);
var
  LFileLines: TStringList;
  LLicenceID, LOldLen: Integer;
  LLicenceIDs: TArray<Integer>;
  i: Integer;
  LDeploymentList: TDeploymentList;
begin
  if not odList.Execute then
    EXIT;
  LFileLines := TStringList.Create;
  try
    LFileLines.LoadFromFile(odList.FileName);
    for i := 0 to (LFileLines.Count - 1) do
    begin
      try
        LLicenceID := StrToInt(LFileLines[i]);
        LOldLen := Length(LLicenceIDs);
        SetLength(LLicenceIDs, LOldLen + 1);
        LLicenceIDs[LOldLen] := LLicenceID;
      except
      end;
    end;
  finally
    LFileLines.Free;
  end;

  LDeploymentList := TDeploymentList.GetAllForLicenceIDList(LLicenceIDs);
  try
    LoadGrid(LDeploymentList);
    tvDeployments.OptionsSelection.MultiSelect := TRUE;
  finally
    LDeploymentList.Free;
  end;
end;

procedure TfmDeployments.ppmDeploymentsPopup(Sender: TObject);
begin
  ppmiDisallow.Visible := tvDeployments.OptionsSelection.MultiSelect;
  ppmiNew.Visible := not tvDeployments.OptionsSelection.MultiSelect;
  ppmiEdit.Visible := not tvDeployments.OptionsSelection.MultiSelect;
  ppmiResetDeploymentID.Visible := not tvDeployments.OptionsSelection.MultiSelect;
  ppmiSnapshots.Visible := not tvDeployments.OptionsSelection.MultiSelect;
end;

procedure TfmDeployments.ppmiDisallowClick(Sender: TObject);
var
  i, LIndex, LLen: Integer;
  LLicenceIDs: TArray<Integer>;
  LDeploymentIDs: TArray<Integer>;
  LDeploymentList: TDeploymentList;
begin
  if 0 = tvDeployments.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;

  for i := 0 to (TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments.Count - 1) do
  begin
    LLen := Length(LLicenceIDs);
    SetLength(LLicenceIDs, LLen + 1);
    LLicenceIDs[LLen] := TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[i].MasterLicenseID;
  end;

  for i := 0 to (tvDeployments.Controller.SelectedRecordCount - 1) do
  begin
    LIndex := tvDeployments.Controller.SelectedRecords[i].RecordIndex;
    LLen := Length(LDeploymentIDs);
    SetLength(LDeploymentIDs, LLen + 1);
    LDeploymentIDs[LLen] := TGridDataSource(tvDeployments.DataController.CustomDataSource).Deployments[LIndex].DeploymentID;
  end;

  TDeploymentList.CancelAuthorisation(LDeploymentIDs);
  LDeploymentList := TDeploymentList.GetAllForLicenceIDList(LLicenceIDs);
  try
    LoadGrid(LDeploymentList);
    tvDeployments.OptionsSelection.MultiSelect := TRUE;
  finally
    LDeploymentList.Free;
  end;
end;

end.
