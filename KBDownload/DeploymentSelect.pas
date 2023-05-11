unit DeploymentSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SingleRecordLookupUnbound, cxGraphics,
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
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid, RzButton,
  RzPanel, Vcl.StdCtrls, Vcl.Mask, RzEdit, Vcl.ExtCtrls, System.UITypes,
  KB.Deployment, dxSkinOffice2016Colorful, dxSkinOffice2016Dark, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, dxSkinTheBezier,
  dxDateRanges, cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TDeploymentList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Refresh;
    property Deployments: TDeploymentList read FList;
  end;

  TfmDeploymentSelect = class(TfmSingleRecordLookupUnbound)
    colID: TcxGridColumn;
    colLicenceID: TcxGridColumn;
    colGuid: TcxGridColumn;
    colAuthorised: TcxGridColumn;
    colName: TcxGridColumn;
  private
    { Private declarations }
    function GetMasterLicenceID: Integer;
    function GetName: String;
  protected
    { Protected declarations }
    function GetPrimaryKey: Integer; override;
    procedure LoadGrid;
    procedure UnloadGrid;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AFormMode: Integer; AShowNewEditDelete: Boolean); override;
    destructor Destroy; override;
    property MasterLicenceID: Integer read GetMasterLicenceID;
    property Name: String read GetName;
  end;

implementation

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
constructor TGridDataSource.Create;
begin
  inherited Create;
  FList := TDeploymentList.GetAll;
  if nil = FList then
    FList := TDeploymentList.Create;
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

  LCloumnIndex :=  Integer(AItemHandle);
  case LCloumnIndex of
    0: Result := LRec.DeploymentID;
    1: Result := LRec.MasterLicenseID;
    2: Result := LRec.Name;
    3: Result := LRec.Fingerprint;
    4: Result := LRec.IsAuthorized;
  end;
end;

procedure TGridDataSource.Refresh;
begin
  FList.Free;
  FList := TDeploymentList.GetAll;
  if nil = FList then
    FList := TDeploymentList.Create;
end;

constructor TfmDeploymentSelect.Create(AOwner: TComponent; AFormMode: Integer; AShowNewEditDelete: Boolean);
begin
  inherited Create(AOwner, AFormMode, AShowNewEditDelete);
  LoadSort(tvData, 'DeploymentSelect');
  LoadGrid;
end;

destructor TfmDeploymentSelect.Destroy;
begin
  SaveSort(tvData, 'DeploymentSelect');
  UnloadGrid;
  inherited Destroy;
end;

function TfmDeploymentSelect.GetMasterLicenceID: Integer;
begin
  Result := tvData.DataController.Values[tvData.DataController.FocusedRecordIndex, colLicenceID.Index];
end;

function TfmDeploymentSelect.GetName: String;
begin
  Result := tvData.DataController.Values[tvData.DataController.FocusedRecordIndex, colName.Index];
end;

function TfmDeploymentSelect.GetPrimaryKey: Integer;
var
  LIndex: Integer;
begin
  Result := -1;
  LIndex := tvData.DataController.FocusedRecordIndex;
  if LIndex < 0 then
  begin
    MessageDlg('You must select a record.', mtError, [mbOK], 0);
    EXIT;
  end;
  Result := tvData.DataController.Values[tvData.DataController.FocusedRecordIndex, colID.Index];
end;

procedure TfmDeploymentSelect.LoadGrid;
var
  LDataSource: TGridDataSource;
begin
  Screen.Cursor := crHourglass;
  tvData.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvData.DataController.CustomDataSource) then
    begin
      LDataSource := TGridDataSource(tvData.DataController.CustomDataSource);
      tvData.DataController.CustomDataSource := nil;
      LDataSource.Free;
    end;

    tvData.DataController.BeginFullUpdate;
    try
      LDataSource := TGridDataSource.Create;
      tvData.DataController.CustomDataSource := LDataSource;
    finally
      tvData.DataController.EndFullUpdate;
    end;
  finally
    tvData.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmDeploymentSelect.UnloadGrid;
var
  LDataSource: TGridDataSource;
begin
  if (nil <> tvData.DataController.CustomDataSource) then
  begin
    LDataSource := TGridDataSource(tvData.DataController.CustomDataSource);
    tvData.DataController.CustomDataSource := nil;
    LDataSource.Free;
  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
end.
