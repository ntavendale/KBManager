unit KBPackages;

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
  Vcl.ExtCtrls, RzPanel, dxCore, DateUtils, CommonFunctions, KB.KBPackage,
  Vcl.Menus, System.UITypes, System.IOUtils, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, KB.LoginSettings, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, Datasnap.Provider, KBPackageEdit,
  dxSkinTheBezier, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TKBPackageList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    property KBPackages: TKBPackageList read FList;
  end;
  TfmKBPackages = class(TForm)
    gbSearch: TRzGroupBox;
    ebSearch: TRzEdit;
    gKBPackages: TcxGrid;
    tvKBPackages: TcxGridTableView;
    colID: TcxGridColumn;
    lvKBPackages: TcxGridLevel;
    colCoreVersion: TcxGridColumn;
    colName: TcxGridColumn;
    colCreated: TcxGridColumn;
    colModified: TcxGridColumn;
    ppmKBPackage: TPopupMenu;
    ppmiLoad: TMenuItem;
    odKB: TOpenDialog;
    sdKB: TSaveDialog;
    ppmiSaveKB: TMenuItem;
    colModifiedBy: TcxGridColumn;
    ppmiNewKB: TMenuItem;
    procedure ebSearchChange(Sender: TObject);
    procedure ebSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ppmiLoadClick(Sender: TObject);
    procedure ppmiSaveKBClick(Sender: TObject);
    procedure ppmiNewKBClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSort(AGridTableView: TcxGridTableView);
    procedure SaveSort(AGridTableView: TcxGridTableView);
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
  FList := TKBPackageList.GetAll;
  if nil = FList then
    FList := TKBPackageList.Create;
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
  LRec: TKBPackage;
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
    0: Result := LRec.KBPackageUID;
    1: Result := LRec.CoreVersion;
    2: Result := LRec.Name;
    3: Result := TTimeZone.Local.ToLocalTime(LRec.Created);
    4: Result := TTimeZone.Local.ToLocalTime(LRec.Modified);
    5: Result := LRec.Modifier;
  end;
end;

constructor TfmKBPackages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadSort(tvKBPackages);
  LoadGrid;
end;

destructor TfmKBPackages.Destroy;
begin
  SaveSort(tvKBPackages);
  ClearGrid;
  inherited Destroy;
end;

procedure TfmKBPackages.LoadSort(AGridTableView: TcxGridTableView);
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
      LSortList.DelimitedText := GetFormKey('KBPackages', 'LastSort');
      LSortOrderList.DelimitedText := GetFormKey('KBPackages', 'LastSortOrder');
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

procedure TfmKBPackages.SaveSort(AGridTableView: TcxGridTableView);
var
  i: Integer;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortOrderList := TStringList.Create;
    try
      SetFormKey('KBPackages', 'LastSort', '');
      SetFormKey('KBPackages', 'LastSortOrder', '');
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
      SetFormKey('KBPackages', 'LastSort', LSortList.DelimitedText);
      SetFormKey('KBPackages', 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmKBPackages.LoadGrid;
var
  LDS: TGridDataSource;
begin
  tvKBPackages.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvKBPackages.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvKBPackages.DataController.CustomDataSource);
      tvKBPackages.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvKBPackages.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create;
      tvKBPackages.DataController.CustomDataSource := LDS;
    finally
      tvKBPackages.DataController.EndFullUpdate;
    end;
  finally
    tvKBPackages.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmKBPackages.ClearGrid;
var
  LDS: TGridDataSource;
begin
  tvKBPackages.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvKBPackages.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvKBPackages.DataController.CustomDataSource);
      tvKBPackages.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvKBPackages.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmKBPackages.ebSearchChange(Sender: TObject);
var
  recIndex, rowIndex: Integer;
  LColIndex, i: Integer;
begin
  inherited;
  LColIndex := -1;
  for i := 0 to (tvKBPackages.ColumnCount - 1) do
  begin
    if (soNone <> tvKBPackages.Columns[i].SortOrder) and (0 = tvKBPackages.Columns[i].SortIndex) then
    begin
      LColIndex := i;
      BREAK;
    end;
  end;

  if -1 = LColIndex  then
    EXIT;

  recIndex := tvKBPackages.DataController.FindRecordIndexByText(1, LColIndex, ebSearch.Text, true, true, true);
  rowIndex := tvKBPackages.DataController.GetRowIndexByRecordIndex(recIndex, True);
  tvKBPackages.Controller.FocusedRowIndex := rowIndex;
end;

procedure TfmKBPackages.ebSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    case key of
      VK_UP: tvKBPackages.Controller.FocusedRowIndex := tvKBPackages.Controller.FocusedRowIndex - 1;
      VK_DOWN: tvKBPackages.Controller.FocusedRowIndex := tvKBPackages.Controller.FocusedRowIndex + 1;
    end;
  except
  end;
end;

procedure TfmKBPackages.ppmiLoadClick(Sender: TObject);
var
  LFileName, LPackageName, LCoreVersion: String;
  LStream: TFileStream;
  LKBPackage: TKBPackage;
  LKBPackageUID: String;
  i: Integer;
  LUser, LDomain: String;
  fm: TfmKBPackageEdit;
  LContinue: Boolean;
begin
  GetCurrentUserAndDomain(LUser, LDomain);
  if 0 = tvKBPackages.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  LKBPackage := nil;
  LKBPackageUID := tvKBPackages.DataController.Values[tvKBPackages.Controller.SelectedRecords[0].RecordIndex, colID.Index];

  for i := 0 to (TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages.Count - 1) do
  begin
    if LKBPackageUID = TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages[i].KBPackageUID then
      LKBPackage := TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages[i];
  end;

  if nil = LKBPackage then
    EXIT;

  if odKB.Execute then
    LFileName := odKB.FileName
  else
    EXIT;

  LPackageName := TPath.GetFileNameWithoutExtension(LFileName);
  LCoreVersion := StringReplace(LPackageName,'LogRhythmKB_', '', [rfReplaceAll]);

  LKBPackage.Modifier := LDomain + '\' + LUser;
  LKBPackage.CoreVersion := LCoreVersion;
  LKBPackage.Name := TPath.GetFileName(LFileName);

  LContinue := FALSE;

  fm := TfmKBPackageEdit.Create(nil, LKBPackage);
  try
    if mrOK = fm.ShowModal then
    begin
      LKBPackage.CoreVersion := fm.KBPackage.CoreVersion;
      LKBPackage.Name := fm.KBPackage.Name;
      LContinue := TRUE;
    end;
  finally
    fm.Free;
  end;

  if not LContinue then
    EXIT;

  Screen.Cursor := crHourglass;
  try
    LStream := TFileStream.Create(LFileName, fmOpenRead);
    try
      LKBPackage.FileContents.LoadFromStream(LStream);
      LKBPackage.Save;
      LKBPackage.FileContents.Clear;
      MessageDlg('Package contents updated.', mtInformation, [mbOK], 0);
    finally
      LStream.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TfmKBPackages.ppmiSaveKBClick(Sender: TObject);
var
  LFileName: String;
  LStream: TFileStream;
  LKBPackage: TKBPackage;
  LKBPackageUID: String;
  i: Integer;
begin
  if 0 = tvKBPackages.Controller.SelectedRowCount then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  LKBPackage := nil;
  LKBPackageUID := tvKBPackages.DataController.Values[tvKBPackages.Controller.SelectedRecords[0].RecordIndex, colID.Index];

  for i := 0 to (TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages.Count - 1) do
  begin
    if LKBPackageUID = TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages[i].KBPackageUID then
      LKBPackage := TGridDataSource(tvKBPackages.DataController.CustomDataSource).KBPackages[i];
  end;

  if nil = LKBPackage then
    EXIT;

  if sdKB.Execute then
    LFileName := sdKB.FileName
  else
    EXIT;

  Screen.Cursor := crHourglass;
  try
    LStream := TFileStream.Create(LFileName, fmOpenWrite or fmCreate);
    try
      LKBPackage.LoadFileContents;
      LKBPackage.FileContents.Seek(0, soFromBeginning);
      LStream.CopyFrom(LKBPackage.FileContents, LKBPackage.FileContents.Size);
      LKBPackage.FileContents.Clear;
      MessageDlg(String.Format('Package contents saved to %s', [LFileName]), mtInformation, [mbOK], 0);
      LoadGrid;
    finally
      LStream.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmKBPackages.ppmiNewKBClick(Sender: TObject);
var
  fm: TfmKBPackageEdit;
  LFileName, LPackageName, LCoreVersion: String;
  LStream: TFileStream;
  LKBPackage: TKBPackage;
  LUser, LDomain: String;
  LContinue: Boolean;
begin
  GetCurrentUserAndDomain(LUser, LDomain);

  LContinue := FALSE;

  if odKB.Execute then
    LFileName := odKB.FileName
  else
    EXIT;

  LKBPackage := TKBPackage.Create;
  try
    LPackageName := TPath.GetFileNameWithoutExtension(LFileName);
    LCoreVersion := StringReplace(LPackageName,'LogRhythmKB_', '', [rfReplaceAll]);

    LKBPackage.Modifier := String.Format('%s\%s', [LDomain, LUser]);
    LKBPackage.CoreVersion := LCoreVersion;
    LKBPackage.Name := TPath.GetFileName(LFileName);

    fm := TfmKBPackageEdit.Create(nil, LKBPackage);
    try
      if mrOK = fm.ShowModal then
      begin
        LKBPackage.CoreVersion := fm.KBPackage.CoreVersion;
        LKBPackage.Name := fm.KBPackage.Name;
        LContinue := TRUE;
      end;
    finally
      fm.Free;
    end;

    if LContinue then
    begin
      Screen.Cursor := crHourglass;
      try
        LStream := TFileStream.Create(LFileName, fmOpenRead);
        try
          LKBPackage.FileContents.LoadFromStream(LStream);
          LKBPackage.Save;
          LKBPackage.FileContents.Clear;
          MessageDlg('Package contents uploaded.', mtInformation, [mbOK], 0);
          LoadGrid;
        finally
          LStream.Free;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    LKBPackage.Free;
  end;
end;

end.

