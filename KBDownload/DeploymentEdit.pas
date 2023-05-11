unit DeploymentEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, KB.Deployment, Vcl.StdCtrls, Vcl.Mask,
  RzEdit, RzLabel, RzButton, RzRadChk, System.UITypes, DateUtils;

type
  TfmDeploymentEdit = class(TForm)
    RzLabel1: TRzLabel;
    neMasterLicenceID: TRzNumericEdit;
    RzLabel2: TRzLabel;
    ebCustomerName: TRzEdit;
    ckbRequireSnapshot: TRzCheckBox;
    ckbDoNotSign: TRzCheckBox;
    ckbEnforceFingerprint: TRzCheckBox;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    lbCreated: TRzLabel;
    lbModified: TRzLabel;
    lbLastModifiedBy: TRzLabel;
    ckbAuthorized: TRzCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FDeployment: TDeployment;
    procedure ObjectToForm;
    procedure FormToObject;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ADeploymentID: Integer); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

constructor TfmDeploymentEdit.Create(AOwner: TComponent; ADeploymentID: Integer);
begin
  inherited Create(AOwner);
  FDeployment := TDeploymentList.GetSingleInstance(ADeploymentID);
  if nil = FDeployment then
    FDeployment := TDeployment.Create
  else
    neMasterLicenceID.ReadOnly := TRUE;
  ObjectToForm;
end;

destructor TfmDeploymentEdit.Destroy;
begin
  FDeployment.Free;
  inherited Destroy;
end;

procedure TfmDeploymentEdit.ObjectToForm;
begin
  neMasterLicenceID.IntValue := FDeployment.MasterLicenseID;
  ebCustomerName.Text := FDeployment.Name;
  ckbRequireSnapshot.Checked := FDeployment.RequireSnapshot;
  ckbDoNotSign.Checked := FDeployment.DoNotSign;
  ckbEnforceFingerprint.Checked := FDeployment.EnforceFingerprint;
  ckbAuthorized.Checked := FDeployment.IsAuthorized;
  if FDeployment.Created > 2.00 then
    lbCreated.Caption := DateTimeToStr(TTimeZone.Local.ToLocalTime(FDeployment.Created))
  else
    lbCreated.Caption := '';

  if FDeployment.Modified > 2.00 then
    lbModified.Caption := DateTimeToStr(TTimeZone.Local.ToLocalTime(FDeployment.Modified))
  else
    lbModified.Caption := '';

  lbLastModifiedBy.Caption := FDeployment.Modifier;
end;

procedure TfmDeploymentEdit.FormToObject;
begin
  FDeployment.MasterLicenseID := neMasterLicenceID.IntValue;
  FDeployment.Name := Trim(ebCustomerName.Text);
  FDeployment.RequireSnapshot := ckbRequireSnapshot.Checked;
  FDeployment.DoNotSign := ckbDoNotSign.Checked;
  FDeployment.EnforceFingerprint := ckbEnforceFingerprint.Checked;
  FDeployment.IsAuthorized := ckbAuthorized.Checked;
end;

procedure TfmDeploymentEdit.btnOKClick(Sender: TObject);
begin
  FormToObject;
  if 0 = FDeployment.MasterLicenseID then
  begin
    MessageDlg('Master Licence ID cannot be 0.', mtError, [mbOK], 0);
    EXIT;
  end;
  FDeployment.Save;
  ModalResult := mrOK;
end;

procedure TfmDeploymentEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
