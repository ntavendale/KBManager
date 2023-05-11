unit StatLists;

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
  cxClasses, cxGridCustomView, cxGrid, cxVGrid, cxInplaceContainer,
  DateUtils, dxCore, KB.StatList, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinTheBezier, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TStatListList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Stats: TStatListList read FList;
  end;
  TfmStatLists = class(TForm)
    gStatList: TcxGrid;
    tvStatList: TcxGridTableView;
    colStatListID: TcxGridColumn;
    colCreated: TcxGridColumn;
    colModified: TcxGridColumn;
    lvStatList: TcxGridLevel;
    colCreatedBy: TcxGridColumn;
    colCurrentDownloads: TcxGridColumn;
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

uses
  CommonFunctions;

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
constructor TGridDataSource.Create;
begin
  FList := TStatListList.GetAll;
  if nil = FList then
    FList := TStatListList.Create;
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
  LRec: TStatList;
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
    0: Result := LRec.StatListID;
    1: Result := TTimeZone.Local.ToLocalTime(LRec.Created);
    2: Result := LRec.Modifier;
    3: Result := TTimeZone.Local.ToLocalTime(LRec.Modified);
    4: Result := LRec.CurKBDownloads;
  end;
end;

constructor TfmStatLists.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadSort(tvStatList);
  LoadGrid;
end;

destructor TfmStatLists.Destroy;
begin
  SaveSort(tvStatList);
  ClearGrid;
  inherited Destroy;
end;

procedure TfmStatLists.LoadSort(AGridTableView: TcxGridTableView);
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
      LSortList.DelimitedText := GetFormKey('StatsLists', 'LastSort');
      LSortOrderList.DelimitedText := GetFormKey('StatsLists', 'LastSortOrder');
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

procedure TfmStatLists.SaveSort(AGridTableView: TcxGridTableView);
var
  i: Integer;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortOrderList := TStringList.Create;
    try
      SetFormKey('StatsLists', 'LastSort', '');
      SetFormKey('StatsLists', 'LastSortOrder', '');
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
      SetFormKey('StatsLists', 'LastSort', LSortList.DelimitedText);
      SetFormKey('StatsLists', 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmStatLists.LoadGrid;
var
  LDS: TGridDataSource;
begin
  tvStatList.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvStatList.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvStatList.DataController.CustomDataSource);
      tvStatList.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvStatList.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create;
      tvStatList.DataController.CustomDataSource := LDS;
    finally
      tvStatList.DataController.EndFullUpdate;
    end;
  finally
    tvStatList.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmStatLists.ClearGrid;
var
  LDS: TGridDataSource;
begin
  tvStatList.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvStatList.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvStatList.DataController.CustomDataSource);
      tvStatList.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvStatList.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}

end.
