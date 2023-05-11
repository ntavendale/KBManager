unit ReleaseEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit,
  RzLabel, RzCmboBx, KB.Release, KB.KBPackage, RzButton, System.UITypes,
  CommonFunctions, KBVersion;

type
  TfmReleaseEdit = class(TForm)
    RzLabel1: TRzLabel;
    ebEMDBVersion: TRzEdit;
    RzLabel2: TRzLabel;
    cbPackageList: TRzComboBox;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    lbl715Warning: TRzLabel;
    lbl716Warning: TRzLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FRelease: TRelease;
    FList: TKBPackageList;
    procedure PopulateKBCombo;
    procedure ObjectToForm;
    procedure FormToObject;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AReleaseID: Integer); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
constructor TfmReleaseEdit.Create(AOwner: TComponent; AReleaseID: Integer);
begin
  inherited Create(AOwner);

  lbl715Warning.Caption := WARNING_7_1_5;
  lbl716Warning.Caption := WARNING_7_1_6;

  FRelease := TReleaseList.GetSingleInstance(AReleaseID);
  if nil = FRelease then
    FRelease := TRelease.Create;
  FList := TKBPackageList.GetAll('Order By KBPackage.CoreVersion Desc ');
  PopulateKBCombo;
  ObjectToForm;
end;

destructor TfmReleaseEdit.Destroy;
begin
  if nil <> FList then
    FList.Free;
  FRelease.Free;
  inherited Destroy;
end;

procedure TfmReleaseEdit.PopulateKBCombo;
var
  i: Integer;
begin
  if nil = FList then
    EXIT;

  cbPackageList.Items.Clear;
  cbPackageList.Values.Clear;
  for i := 0 to (FList.Count - 1) do
    cbPackageList.AddItemValue(FList[i].Name + '(' + FList[i].CoreVersion + ')', FList[i].KBPackageUID);
end;

procedure TfmReleaseEdit.ObjectToForm;
begin
  ebEMDBVersion.Text := FRelease.EmdbVersion;
  cbPackageList.ItemIndex := cbPackageList.Values.IndexOf(FRelease.KBPackageUID);
end;

procedure TfmReleaseEdit.FormToObject;
begin
  FRelease.EmdbVersion := Trim(ebEMDBVersion.Text);
  FRelease.KBPackageUID := cbPackageList.Value;
  FRelease.CoreVersion := FList[cbPackageList.ItemIndex].CoreVersion;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmReleaseEdit.btnOKClick(Sender: TObject);
var
  LUser, LDomain: String;
  LEMDBVer, LCoreVer: TKBVersion;
begin
  GetCurrentUserAndDomain(LUser, LDomain);
  FormToObject;
  if '' = Trim(FRelease.EmdbVersion) then
  begin
    MessageDlg('You must enter an EMDB version.', mtError, [mbOK], 0);
    EXIT;
  end;
  if '' = Trim(FRelease.KBPackageUID) then
  begin
    MessageDlg('You must select a KB Package.', mtError, [mbOK], 0);
    EXIT;
  end;

  try
    LEMDBVer := FRelease.EmdbVersion;
  except
    MessageDlg(string.Format('Invalid EMDB Version format: %s', [FRelease.EmdbVersion]), mtError, [mbOK], 0);
  end;

  try
    LCoreVer := FRelease.CoreVersion;
  except
    MessageDlg(string.Format('Invalid EMDB Version format: %s', [FRelease.EmdbVersion]), mtError, [mbOK], 0);
  end;

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


  FRelease.Modifier := String.Format('%s\%s', [LDomain, LUser]);
  FRelease.Save;
  ModalResult := mrOK;
end;

procedure TfmReleaseEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
