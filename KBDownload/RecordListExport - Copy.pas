unit RecordListExport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseWorkbook, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
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
  Vcl.Menus, Vcl.ImgList, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, RzCmboBx,
  RzPanel, RzButton, cxSSheet, DataRecordList;

type
  TfmRecordListExport = class(TfmBaseWorkbook)
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
var
  i: Integer;
begin
  inherited Create(AOwner);
  FRecordList := ARecordList;
  FCaption := ACaption;
  for i := 0 to (FRecordList.FieldCount - 1) do
  begin
    FCaptionList.Add(FRecordList.FieldCaptions[i]);
  end;
  Self.Caption := ACaption;
  LoadData;
end;

procedure TfmRecordListExport.LoadData;
var
  LSheetRow :Integer;
  i: Integer;
begin
  InsertFieldHeaders(0, 0);
  LSheetRow := 1;
  for i := 0 to (FRecordList.Count - 1) do
  begin
    InsertDataRow(0, LSheetRow, i, FRecordList);
    Inc( LSheetRow );
  end;
end;

end.
