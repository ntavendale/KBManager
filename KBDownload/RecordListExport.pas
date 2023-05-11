unit RecordListExport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SpreadsheetBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxCore, dxCoreClasses, dxHashUtils,
  dxSpreadSheetCore, dxSpreadSheetCoreHistory, dxSpreadSheetPrinting,
  dxSpreadSheetFormulas, dxSpreadSheetFunctions, dxSpreadSheetGraphics,
  dxSpreadSheetClasses, dxSpreadSheetTypes, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxBarBuiltInMenu, System.ImageList,
  Vcl.ImgList, dxSpreadSheet, RzButton, RzPanel, Vcl.ExtCtrls,
  DataRecordList, dxSpreadSheetConditionalFormatting,
  dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers,
  dxSpreadSheetHyperlinks, dxSpreadSheetUtils, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark;

type
  TfmRecordListExport = class(TfmSpreadSheetBase)
  private
    { Private declarations }
    FRecordList: TDataRecordList;
    FCaption: String;
    procedure LoadData;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACaption: String; ARecordList: TDataRecordList); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TfmRecordListExport.Create(AOwner: TComponent; ACaption: String; ARecordList: TDataRecordList);
begin
  inherited Create(AOwner, ACaption);
  FRecordList := ARecordList;
  FCaption := ACaption;
  Self.Caption := ACaption;
  LoadData;
end;

procedure TfmRecordListExport.LoadData;
var
  i, j: Integer;
  LSheet: TdxSpreadSheetTableView;
  LRow: TdxSpreadsheetTableRow;
  LCell: TdxSpreadsheetCell;
begin
  LSheet := TdxSpreadSheetTableView(WorkBook.Sheets[0]);
  LSheet.BeginUpdate;
  try
    LRow := LSheet.Rows.CreateItem(LSheet.Rows.Count);
    for i := 0 to (FRecordList.FieldCount - 1) do
    begin
      LCell := LRow.CreateCell(LRow.CellCount);
      LCell.AsString := FRecordList.FieldCaptions[i];
    end;

    for i := 0 to (FRecordList.Count - 1) do
    begin
      LRow := LSheet.Rows.CreateItem(LSheet.Rows.Count);
      for j := 0 to (FRecordList.FieldCount - 1) do
      begin
        LCell := LRow.CreateCell(LRow.CellCount);
        LCell.AsString := FRecordList.FieldData[i, j];
      end;
    end;
  finally
    LSheet.EndUpdate;
  end;
end;

end.
