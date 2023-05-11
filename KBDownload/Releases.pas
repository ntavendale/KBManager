unit Releases;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxClasses, cxGridCustomView, cxGrid, Vcl.StdCtrls, Vcl.Mask, RzEdit,
  Vcl.ExtCtrls, RzPanel, dxCore, DateUtils, CommonFunctions, KB.Release, ReleaseEdit,
  Vcl.Menus, System.UITypes, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, KBPackageSelect, KBVersion, dxSkinTheBezier,
  dxDateRanges, cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TReleaseList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Releases: TReleaseList read FList;
  end;

  TfmReleases = class(TForm)
    gbSearch: TRzGroupBox;
    ebSearch: TRzEdit;
    gReleases: TcxGrid;
    tvReleases: TcxGridTableView;
    lvReleases: TcxGridLevel;
    colVersion: TcxGridColumn;
    colCreated: TcxGridColumn;
    colModified: TcxGridColumn;
    colCoreVersion: TcxGridColumn;
    colID: TcxGridColumn;
    ppmReleases: TPopupMenu;
    ppmiNew: TMenuItem;
    ppmiEdit: TMenuItem;
    colModifier: TcxGridColumn;
    ppmiUpdateKBPackage: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ebSearchChange(Sender: TObject);
    procedure ebSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ppmiNewClick(Sender: TObject);
    procedure ppmiEditClick(Sender: TObject);
    procedure ppmiUpdateKBPackageClick(Sender: TObject);
    procedure ppmReleasesPopup(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSort(AGridTableView: TcxGridTableView);
    procedure SaveSort(AGridTableView: TcxGridTableView);
    procedure CompareReecord(ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2, AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure LoadGrid;
    procedure ClearGrid;
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
constructor TGridDataSource.Create;
begin
  FList := TReleaseList.GetAll;
  if nil = FList then
    FList := TReleaseList.Create;
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
begin
  Result := NULL;
  var LRecordIndex := Integer(ARecordHandle);
  var LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  var LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.ReleaseID;
    1: Result := LRec.EmdbVersion;
    2: Result := TTimeZone.Local.ToLocalTime(LRec.Created);
    3: Result := TTimeZone.Local.ToLocalTime(LRec.Modified);
    4: Result := LRec.Modifier;
    5: Result := LRec.CoreVersion;
  end;
end;

constructor TfmReleases.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadSort(tvReleases);
  LoadGrid;
end;

destructor TfmReleases.Destroy;
begin
  SaveSort(tvReleases);
  ClearGrid;
  inherited Destroy;
end;


procedure TfmReleases.LoadSort(AGridTableView: TcxGridTableView);
begin
  var LSortList := TStringList.Create;
  try
    LSortList.Delimiter := ',';
    var LSortOrderList := TStringList.Create;
    try
      LSortOrderList.Delimiter := ',';
      LSortList.DelimitedText := GetFormKey('Releases', 'LastSort');
      LSortOrderList.DelimitedText := GetFormKey('Releases', 'LastSortOrder');
      if (not (0 = LSortList.Count)) and (not (0 = LSortOrderList.Count)) then
      begin
        var LAllColumnsExist := TRUE;
        for var i := 0 to (LSortList.Count - 1) do
          LAllColumnsExist := LAllColumnsExist and (StrToIntDef(LSortList[i], -1) >= 0) and (StrToIntDef(LSortList[i], -1) < AGridTableView.ColumnCount);

        LAllColumnsExist := LAllColumnsExist and (LSortOrderList.Count = LSortList.Count);
        if LAllColumnsExist then
        begin
          for var i := 0 to (LSortList.Count - 1) do
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

procedure TfmReleases.SaveSort(AGridTableView: TcxGridTableView);
var
  i: Integer;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortOrderList := TStringList.Create;
    try
      SetFormKey('Releases', 'LastSort', '');
      SetFormKey('Releases', 'LastSortOrder', '');
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
      SetFormKey('Releases', 'LastSort', LSortList.DelimitedText);
      SetFormKey('Releases', 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmReleases.CompareReecord(ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2, AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  LVer1, LVer2: TKBVersion;
begin
  try
    if 1 <> AItemIndex then
    begin
      if V1 < V2 then Compare := -1
      else if V1 = V2 then Compare := 0
      else Compare := 1;
    end else
    begin
        LVer1 := String(V1);
        LVer2 := String(V2);
        if LVer1 < LVer2 then Compare := -1
        else if LVer1 = LVer2 then Compare := 0
        else Compare := 1;
    end;
  except

  end;
end;

procedure TfmReleases.LoadGrid;
var
  LDS: TGridDataSource;
begin
  tvReleases.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvReleases.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvReleases.DataController.CustomDataSource);
      tvReleases.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvReleases.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create;
      tvReleases.DataController.CustomDataSource := LDS;
      tvReleases.DataController.OnCompare := CompareReecord;
    finally
      tvReleases.DataController.EndFullUpdate;
    end;
  finally
    tvReleases.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmReleases.ClearGrid;
var
  LDS: TGridDataSource;
begin
  tvReleases.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvReleases.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvReleases.DataController.CustomDataSource);
      tvReleases.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvReleases.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmReleases.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmReleases.ebSearchChange(Sender: TObject);
var
  recIndex, rowIndex: Integer;
  LColIndex, i: Integer;
begin
  inherited;
  LColIndex := -1;
  for i := 0 to (tvReleases.ColumnCount - 1) do
  begin
    if (soNone <> tvReleases.Columns[i].SortOrder) and (0 = tvReleases.Columns[i].SortIndex) then
    begin
      LColIndex := i;
      BREAK;
    end;
  end;

  if -1 = LColIndex  then
    EXIT;

  recIndex := tvReleases.DataController.FindRecordIndexByText(1, LColIndex, ebSearch.Text, true, true, true);
  rowIndex := tvReleases.DataController.GetRowIndexByRecordIndex(recIndex, True);
  tvReleases.Controller.FocusedRowIndex := rowIndex;
end;

procedure TfmReleases.ebSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    case key of
      VK_UP: tvReleases.Controller.FocusedRowIndex := tvReleases.Controller.FocusedRowIndex - 1;
      VK_DOWN: tvReleases.Controller.FocusedRowIndex := tvReleases.Controller.FocusedRowIndex + 1;
    end;
  except
  end;
end;

procedure TfmReleases.ppmiNewClick(Sender: TObject);
var
  fm: TfmReleaseEdit;
begin
  fm := TfmReleaseEdit.Create(nil, -1);
  try
    if (mrOK = fm.ShowModal) then
      LoadGrid;
  finally
    fm.Free;
  end;
end;

procedure TfmReleases.ppmiEditClick(Sender: TObject);
var
  LReleaseID: Integer;
  fm: TfmReleaseEdit;
begin
  if 0 = tvReleases.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  LReleaseID := tvReleases.DataController.Values[tvReleases.Controller.SelectedRecords[0].RecordIndex, colID.Index];
  fm := TfmReleaseEdit.Create(nil, LReleaseID);
  try
    if (mrOK = fm.ShowModal) then
    LoadGrid;
  finally
    fm.Free;
  end;
end;

procedure TfmReleases.ppmiUpdateKBPackageClick(Sender: TObject);
var
  fm: TfmKBPackageSelect;
  LCoreVer, LEMDBVer: TKBVersion;
  LContinue: Boolean;
  LUser, LDomain, LPackageUUID: String;
  i, LRecordIndex, LSelCount, LUpdateCount: Integer;
begin
  if 0 = tvReleases.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;

  LContinue := FALSE;
  fm := TfmKBPackageSelect.Create(nil);
  try
    if mrOK = fm.ShowModal then
    begin
      LPackageUUID := fm.KBPackageUID;
      LCoreVer := fm.KBPackageVersion;
      LContinue := TRUE;
    end;
  finally
    fm.Free;
  end;

  if not LContinue then
    EXIT;

  Screen.Cursor := crHourglass;
  try
    for i := 0 to (tvReleases.Controller.SelectedRecordCount - 1) do
    begin
      LRecordIndex := tvReleases.Controller.SelectedRecords[i].RecordIndex;
      LEMDBVer := TGridDataSource(tvReleases.DataController.CustomDataSource).Releases[LRecordIndex].EmdbVersion;

      if (LEMDBVer >= '7.1.6') and (LCoreVer < '7.0.0') then
      begin
        MessageDlg(WARNING_7_1_6, mtError, [mbOK], 0);
        EXIT;
      end;
      if (LEMDBVer <= '7.1.5') and (LCoreVer >= '7.0.0') then
      begin
        MessageDlg(WARNING_7_1_5, mtError, [mbOK], 0);
        EXIT;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

  GetCurrentUserAndDomain(LUser, LDomain);

  Screen.Cursor := crHourglass;
  try
    LUpdateCount := 0;
    LSelCount := tvReleases.Controller.SelectedRecordCount;
    for i := 0 to (tvReleases.Controller.SelectedRecordCount - 1) do
    begin
      LRecordIndex := tvReleases.Controller.SelectedRecords[i].RecordIndex;
      TGridDataSource(tvReleases.DataController.CustomDataSource).Releases[LRecordIndex].KBPackageUID := LPackageUUID;
      TGridDataSource(tvReleases.DataController.CustomDataSource).Releases[LRecordIndex].Modifier := String.Format('%s\%s', [LDomain, LUser]);
      TGridDataSource(tvReleases.DataController.CustomDataSource).Releases[LRecordIndex].Save;
      Inc(LUpdateCount);
    end;
    LoadGrid;
  finally
    Screen.Cursor := crDefault;
  end;
  MessageDlg(String.Format('Updated %d of %d records', [LUpdateCount, LSelCount]), mtInformation, [mbOK], 0);
end;

procedure TfmReleases.ppmReleasesPopup(Sender: TObject);
begin
  ppmiNew.Visible := (tvReleases.Controller.SelectedRowCount < 2);
  ppmiEdit.Visible := (tvReleases.Controller.SelectedRowCount < 2);
end;

end.
