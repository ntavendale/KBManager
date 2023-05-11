unit DownloadEnable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.DateUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton,
  Vcl.ExtCtrls, RzPanel, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxEdit, cxDataControllerConditionalFormattingRulesManagerDialog, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, cxDataStorage,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxInplaceContainer, cxVGrid,
  LRLicense.SCLicense, Vcl.StdCtrls, RzLabel, RzEdit, cxClasses;

type
  TfmDownloadEnable = class(TForm)
    RzPanel1: TRzPanel;
    pnButtons: TRzPanel;
    pnUserMessage: TRzPanel;
    RzPanel3: TRzPanel;
    btnOK: TRzButton;
    btnCancel: TRzButton;
    gbLicenseDetail: TRzGroupBox;
    vgLicense: TcxVerticalGrid;
    lbEnable: TRzLabel;
    srGrid: TcxStyleRepository;
    styeExpired: TcxStyle;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure vgLicenseStylesGetContentStyle(Sender: TObject;
      AEditProp: TcxCustomEditorRowProperties; AFocused: Boolean;
      ARecordIndex: Integer; var AStyle: TcxStyle);
  private
    { Private declarations }
    FMasterLicenseID: Integer;
    FExpirationDate: TDateTime;
    procedure LoadLicenseDetail;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; MasterLicenseID: Integer); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TfmDownloadEnable.Create(AOwner: TComponent; MasterLicenseID: Integer);
begin
  inherited Create(AOwner);
  FMasterLicenseID := MasterLicenseID;
  FExpirationDate := IncDay(Date, 1);
  lbEnable.Caption := String.Format('Enable Downloads For Master License ID %d?', [FMasterLicenseID]);
  LoadLicenseDetail;
end;

procedure TfmDownloadEnable.LoadLicenseDetail;
begin
  var LLicenses := TSCLicenseList.GetAll(FMasterLicenseID);
  if nil = LLicenses then
    EXIT;
  try
    for var i := 0 to (LLicenses.Count - 1) do
    begin
      if 2 <> LLicenses[i].LicenseType then
        CONTINUE;
      var myRow := vgLicense.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Master LicenseID';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := LLicenses[i].MasterLicenseID.ToString;
      myRow.Properties.Options.Editing := FALSE;

      myRow := vgLicense.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Version';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := String.Format('%d.%d', [LLicenses[i].MajorVersion, LLicenses[i].MinorVersion]);
      myRow.Properties.Options.Editing := FALSE;

      myRow := vgLicense.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Issued';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := DateToStr(LLicenses[i].DateUpdated);
      myRow.Properties.Options.Editing := FALSE;

      myRow := vgLicense.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Issued To';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := LLicenses[i].LicensedTo;
      myRow.Properties.Options.Editing := FALSE;

      myRow := vgLicense.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Expires';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;

      if LLicenses[i].ExpirationDate > 1.0 then
      begin
        FExpirationDate := LLicenses[i].ExpirationDate;
        myRow.Properties.Value := DateToStr(LLicenses[i].ExpirationDate);
      end
      else
      begin
        FExpirationDate := IncDay(Date, 1);
        myRow.Properties.Value := String.Empty;
      end;
      myRow.Properties.Options.Editing := FALSE;
      BREAK;
    end;
  finally
    LLicenses.Free;
  end;
end;

procedure TfmDownloadEnable.vgLicenseStylesGetContentStyle(Sender: TObject;
  AEditProp: TcxCustomEditorRowProperties; AFocused: Boolean;
  ARecordIndex: Integer; var AStyle: TcxStyle);
begin
  if (0 = ARecordIndex) then
  begin
    if (FExpirationDate < IncDay(Date, 1)) then
      AStyle := styeExpired;
  end;
end;

procedure TfmDownloadEnable.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmDownloadEnable.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
