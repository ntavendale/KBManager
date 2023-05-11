unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.IOUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  CommonFunctions, Licence, Vcl.Menus, Vcl.ExtCtrls, RzPanel, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxEdit,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxSkinsCore,
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
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxInplaceContainer, cxVGrid, cxDataStorage,
  cxCustomData, cxFilter, cxData, cxNavigator, dxDateRanges, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid;

type
  TLicenceGridDataSource = class(TcxCustomDataSource)
  private
    FList: TSCLicences;
  protected
    function GetRecordCount: Integer; override;
    function GetItemHandle(AItemIndex: Integer): TcxDataItemHandle; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AList: TSCLicences); overload;
    destructor Destroy; override;
    property List: TSCLicences read FList;
  end;

  TfmMain = class(TForm)
    odLicenceFile: TOpenDialog;
    menMain: TMainMenu;
    menFile: TMenuItem;
    miOpen: TMenuItem;
    miExit: TMenuItem;
    RzGroupBox1: TRzGroupBox;
    gbComponents: TRzGroupBox;
    vgSigningKey: TcxVerticalGrid;
    lvLicence: TcxGridLevel;
    gLicence: TcxGrid;
    tvLicence: TcxGridTableView;
    colLicenseID: TcxGridColumn;
    colLicenseType: TcxGridColumn;
    colSignature: TcxGridColumn;
    colLicencedTo: TcxGridColumn;
    colMasterLicenseID: TcxGridColumn;
    colDateUpdated: TcxGridColumn;
    colVersion: TcxGridColumn;
    colExpires: TcxGridColumn;
    colQuantity: TcxGridColumn;
    procedure miOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvLicenceCustomDrawPartBackground(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxCustomGridCellViewInfo;
      var ADone: Boolean);
  private
    { Private declarations }
    FSCLicences: TSCLicences;
    function GetLicences: TSCLicences;
    procedure LoadGrid(AList: TSCLicences);
    procedure LoadSigningKeyDetail(AKey: TSCLicenceSigningKey);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{$REGION 'TLicenceGridDataSource'}
constructor TLicenceGridDataSource.Create(AList: TSCLicences);
begin
  FList := TSCLicences.Create(AList);
end;

destructor TLicenceGridDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TLicenceGridDataSource.GetRecordCount: Integer;
begin
  Result := FList.Count;
end;

function TLicenceGridDataSource.GetItemHandle(AItemIndex: Integer): TcxDataItemHandle;
var
  LGridColumn: TcxCustomGridTableItem;
begin
  LGridColumn := TcxCustomGridTableItem(DataController.GetItem(AItemIndex));
  Result := TcxDataItemHandle(LGridColumn.ID);
end;

function TLicenceGridDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TSCLicence;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);

  LRec := FList[LRecordIndex];

  LCloumnIndex := Integer(AItemHandle);

  if (nil <> LRec) then
  begin
    case LCloumnIndex of
      0: Result := LRec.LicenceID;
      1: Result := TSCLicence.LicenceTypeString(LRec.LicenseType);
      2: Result := LRec.Signature;
      3: Result := LRec.LicensedTo;
      4: if LRec.MasterLicenceID > -1 then Result := LRec.MasterLicenceID else Result := Null;
      5: Result := DateTimeToStr(LRec.DateUpdated);
      6: if LRec.ExpirationDate < 1.00 then Result := String.Empty else Result := DateTimeToStr(LRec.ExpirationDate);
      7: Result := String.Format('%d.%d',[LRec.MajorVersion, LRec.MinorVersion]);
      8: Result := LRec.Quantity;
    end;
  end;
end;
{$ENDREGION}

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSCLicences := nil;
end;

destructor TfmMain.Destroy;
begin
  if nil <> FSCLicences then
    FSCLicences.Free;
  inherited Destroy;
end;

function TfmMain.GetLicences: TSCLicences;
begin
  Result := nil;

  odLicenceFile.InitialDir := GetRegistryString('LicenceViewer','LastLicFileFolder');
  if not odLicenceFile.Execute then
    EXIT;
  Result := TSCLicences.Create;
  Result.LoadFromFile(odLicenceFile.FileName);
  SetRegistryString('LicenceViewer','LastLicFileFolder', ExtractFileDir(odLicenceFile.FileName))
end;

procedure TfmMain.LoadGrid(AList: TSCLicences);
var
  LDS: TLicenceGridDataSource;
begin
  tvLicence.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvLicence.DataController.CustomDataSource) then
    begin
      LDS := TLicenceGridDataSource(tvLicence.DataController.CustomDataSource);
      tvLicence.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvLicence.DataController.BeginFullUpdate;
    try
      LDS := TLicenceGridDataSource.Create(AList);
      tvLicence.DataController.CustomDataSource := LDS;
    finally
      tvLicence.DataController.EndFullUpdate;
    end;
  finally
    tvLicence.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.LoadSigningKeyDetail(AKey: TSCLicenceSigningKey);
var
  myCat : TcxCategoryRow;
  myRow : TcxEditorRow;
begin
  vgSigningKey.BeginUpdate;
  try
    vgSigningKey.ClearRows;

    myCat := vgSigningKey.Add( TcxCategoryRow ) As TcxCategoryRow;
    myCat.Properties.Caption := 'Licence Signing Key';

    myRow := vgSigningKey.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'ID';
    myRow.Properties.DataBinding.ValueTypeClass := TcxIntegerValueType;
    if nil <> AKey then
      myRow.Properties.Value := AKey.LicenceSigningKeyID;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgSigningKey.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Public Key';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    if nil <> AKey then
      myRow.Properties.Value := AKey.PublicKey;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgSigningKey.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'P';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    if nil <> AKey then
      myRow.Properties.Value := AKey.P;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgSigningKey.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Q';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    if nil <> AKey then
      myRow.Properties.Value := AKey.Q;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgSigningKey.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'G';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    if nil <> AKey then
      myRow.Properties.Value := AKey.G;
    myRow.Properties.Options.Editing := FALSE;
  finally
    vgSigningKey.EndUpdate;
  end;
end;

procedure TfmMain.miOpenClick(Sender: TObject);
var
  LNew, LTemp: TSCLicences;
begin
  Screen.Cursor := crHourglass;
  try
    LNew := GetLicences;
    if nil = LNew then
      EXIT;
    LTemp := FSCLicences;
    FSCLicences := LNew;
    LTemp.Free;

    LoadSigningKeyDetail(FSCLicences.SCLicenceSigningKey);
    LoadGrid(FSCLicences);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.tvLicenceCustomDrawPartBackground(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxCustomGridCellViewInfo; var ADone: Boolean);
var
  AText: String;
begin
  if AViewInfo is TcxGridFooterViewInfo then
  begin
    with ACanvas do
    begin
      Font.Color := clMaroon;
      Font.Size := 13;
      Font.Style := [fsBold];
      FillRect(TcxGridFooterViewInfo(AViewInfo).Bounds, clBtnFace);

      AText := 'Total Licence Count';
      DrawTexT(AText, AViewInfo.Bounds, taLeftJustify, vaCenter, False, True);
    end;
    ADone := True;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    FSCLicences := GetLicences;
    if nil <> FSCLicences then
      LoadSigningKeyDetail(FSCLicences.SCLicenceSigningKey)
    else
      LoadSigningKeyDetail(nil);
    LoadGrid(FSCLicences);
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
