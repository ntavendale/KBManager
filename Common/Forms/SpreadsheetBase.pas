unit SpreadsheetBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzPanel, Vcl.ExtCtrls, RzButton,
  System.ImageList, Vcl.ImgList, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxCore, dxCoreClasses, dxHashUtils, dxSpreadSheetCore,
  dxSpreadSheetCoreHistory, dxSpreadSheetPrinting, dxSpreadSheetFormulas,
  dxSpreadSheetFunctions, dxSpreadSheetGraphics, dxSpreadSheetClasses,
  dxSpreadSheetTypes, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, System.UITypes,
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
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, dxSpreadSheet,
  dxSpreadSheetConditionalFormatting, dxSpreadSheetConditionalFormattingRules,
  dxSpreadSheetContainers, dxSpreadSheetHyperlinks, dxSpreadSheetUtils,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSpreadSheetCoreFormulas,
  dxSpreadSheetCoreStyles, dxSpreadSheetCoreStrs, dxSpreadSheetStyles,
  dxSpreadSheetFormattedTextUtils, dxSkinTheBezier, DB, DBClient;

type
  TfmSpreadSheetBase = class(TForm)
    tbSpreadsheet: TRzToolbar;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    btnClose: TRzBitBtn;
    ilSpreadsheet: TImageList;
    btnOpen: TRzToolButton;
    btnSave: TRzToolButton;
    WorkBook: TdxSpreadSheet;
    odWorkBook: TOpenDialog;
    sdWorkBook: TSaveDialog;
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    function FieldToRowCell(ARow: TdxSpreadsheetTableRow; AField: TField):TdxSpreadsheetCell;
  protected
    { Protected declarations }
    procedure LoadSheetFromDataSet(ADataSet: TClientDataSet; ASheet: TdxSpreadSheetTableView);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACaption: String); reintroduce; virtual;
    procedure LoadFromDataSets(ADataSetArray: array of TClientDataSet; ASheetCaptions: array of String);
  end;

implementation

{$R *.dfm}

constructor TfmSpreadSheetBase.Create(AOwner: TComponent; ACaption: String);
begin
  inherited Create(AOwner);
  Self.Caption := ACaption;
end;

procedure TfmSpreadSheetBase.btnOpenClick(Sender: TObject);
begin
  if odWorkBook.Execute then
  begin
    WorkBook.LoadFromFile(odWorkBook.FileName);
    if WorkBook.SheetCount > 0 then
    begin
      WorkBook.ActiveSheetIndex := 0;
    end;
  end;
end;

procedure TfmSpreadSheetBase.btnSaveClick(Sender: TObject);
begin
  if sdWorkBook.Execute then
  begin
    if (not FileExists(sdWorkBook.FileName)) or (mrOK = MessageDlg('File ' + sdWorkBook.FileName + ' exists. Overwrite?', mtConfirmation, [mbOK, mbCancel], 0)) then
    begin
      WorkBook.SaveToFile(sdWorkBook.FileName);
    end;
  end;
end;

function TfmSpreadSheetBase.FieldToRowCell(ARow: TdxSpreadsheetTableRow; AField: TField):TdxSpreadsheetCell;
begin
  Result := ARow.CreateCell(ARow.CellCount);
  case AField.DataType of
    ftString, ftGuid: Result.AsString := AField.AsString;
    ftSmallint, ftInteger, ftWord, ftLongWord, ftShortint, ftByte: Result.AsInteger := AField.AsInteger;
    ftLargeint:Result.AsInteger := AField.AsLargeInt;
    ftBoolean: Result.AsBoolean := AField.AsBoolean;
    ftFloat, ftBCD, ftFMTBcd, ftExtended, ftSingle: Result.AsFloat := AField.AsFloat;
    ftCurrency: Result.AsCurrency := AField.AsCurrency;
    ftDate, ftTime, ftDateTime, ftTimeStamp: Result.AsDateTime := AField.AsDateTime;
  else
    try
      Result.AsVariant := AField.Value;
    except
      Result.AsVariant := NULL;
    end;
  end;

end;

procedure TfmSpreadSheetBase.LoadSheetFromDataSet(ADataSet: TClientDataSet; ASheet: TdxSpreadSheetTableView);
var
  i: Integer;
  LRow: TdxSpreadsheetTableRow;
  LCell: TdxSpreadsheetCell;
begin
  ASheet.BeginUpdate;
  try
    LRow := ASheet.Rows.CreateItem(ASheet.Rows.Count);
    for i := 0 to (ADataSet.Fields.Count - 1) do
    begin
      if (0 = ADataSet.Fields[i].Tag) then
      begin
        LCell := LRow.CreateCell(LRow.CellCount);
        LCell.AsString := ADataSet.Fields[i].FieldName;
      end;
    end;

    ADataSet.DisableControls;
    try
      ADataSet.First;
      while not ADataSet.EOF do
      begin
        LRow := ASheet.Rows.CreateItem(ASheet.Rows.Count);
        for i := 0 to (ADataSet.Fields.Count - 1) do
        begin
          if (0 = ADataSet.Fields[i].Tag) then
          begin
            FieldToRowCell(LRow, ADataSet.Fields[i]);
          end;
        end;
        ADataSet.Next;
      end;
      ADataSet.First;
    finally
      ADataSet.EnableControls;
    end;

  finally
    ASheet.EndUpdate;
  end;
end;

procedure TfmSpreadSheetBase.LoadFromDataSets(ADataSetArray: array of TClientDataSet; ASheetCaptions: array of String);
var
  i: Integer;
  LSheet: TdxSpreadSheetTableView;
  LDataSetCount: Integer;
begin
  if 0 = Length(ADataSetArray) then
    EXIT;

  Assert((0 = Length(ASheetCaptions)) or (Length(ADataSetArray) = Length(ASheetCaptions)));
  LDataSetCount := Length(ADataSetArray);

  for i := 0 to (LDataSetCount - 1) do
  begin
    if (0 = i) then
      LSheet := TdxSpreadSheetTableView(WorkBook.Sheets[0])
    else
      LSheet := TdxSpreadSheetTableView(WorkBook.AddSheet);
    if 0 <> Length(ASheetCaptions) then
      LSheet.Caption := ASheetCaptions[i];
    LoadSheetFromDataSet(ADataSetArray[i], LSheet);
  end;
end;

procedure TfmSpreadSheetBase.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
