unit DBSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit, RzLabel,
  RzButton, RzRadChk, RzSpnEdt, RzPanel, Vcl.ExtCtrls;

type
  TfmDBSettings = class(TForm)
    RzPanel1: TRzPanel;
    gbLicenseDBSettings: TRzGroupBox;
    RzLabel1: TRzLabel;
    ebLicenseUserName: TRzEdit;
    ebLicensePassword: TRzEdit;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    ebLicenseDBName: TRzEdit;
    ebLicenseHost: TRzEdit;
    ckbLicenseWindowsAuth: TRzCheckBox;
    RzLabel2: TRzLabel;
    RzPanel2: TRzPanel;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    gbKBDBSettings: TRzGroupBox;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    ebKBUserName: TRzEdit;
    ebKBPassword: TRzEdit;
    ebKBDBName: TRzEdit;
    ebKBHost: TRzEdit;
    ckbKBWindowsAuth: TRzCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ckbLicenseWindowsAuthClick(Sender: TObject);
    procedure ckbKBWindowsAuthClick(Sender: TObject);
  private
    { Private declarations }
    FUser: String;
    FDomain: String;
    procedure LoadKBSettings;
    procedure SaveKBSettings;
    procedure LoadLicenseSettings;
    procedure SaveLicenseSettings;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  KB.LoginSettings, LRLicense.LoginSettings, CommonFunctions;

{$R *.dfm}

constructor TfmDBSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadKBSettings;
  LoadLicenseSettings;
end;

procedure TfmDBSettings.LoadKBSettings;
begin
  GetCurrentUserAndDomain(FUser, FDomain);
  var LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    ebKBUserName.Text := LSettings.UserName;
    ebKBPassword.Text := LSettings.Password;
    ebKBDBName.Text := LSettings.Database;
    ebKBHost.Text := LSettings.Host;
    ckbKBWindowsAuth.Checked := LSettings.WindowsAuthentication;
    if ckbKBWindowsAuth.Checked then
    begin
      ebKBUserName.Text := FDomain + '\' + FUser;
      ebKBUserName.Enabled := FALSE;
      ebKBPassword.Text := '';
      ebKBPassword.Enabled := FALSE;
    end;
  finally
    LSettings.Free;
  end;
end;

procedure TfmDBSettings.SaveKBSettings;
begin
  var LSettings := TKBLoginSettings.Create;
  try
    LSettings.UserName := Trim(ebKBUserName.Text);
    LSettings.Password := ebKBPassword.Text;
    LSettings.Database := Trim(ebKBDBName.Text);
    LSettings.Host := Trim(ebKBHost.Text);
    LSettings.WindowsAuthentication := ckbKBWindowsAuth.Checked;
    if LSettings.WindowsAuthentication then
    begin
      LSettings.UserName := String.Empty;
      LSettings.Password := '';
    end;
    LSettings.Save;
  finally
    LSettings.Free;
  end;
end;

procedure TfmDBSettings.LoadLicenseSettings;
begin
  GetCurrentUserAndDomain(FUser, FDomain);
  var LSettings := TLRLicenseLoginSettings.Create;
  try
    LSettings.Load;
    ebLicenseUserName.Text := LSettings.UserName;
    ebLicensePassword.Text := LSettings.Password;
    ebLicenseDBName.Text := LSettings.Database;
    ebLicenseHost.Text := LSettings.Host;
    ckbLicenseWindowsAuth.Checked := LSettings.WindowsAuthentication;
    if ckbLicenseWindowsAuth.Checked then
    begin
      ebLicenseUserName.Text := FDomain + '\' + FUser;
      ebLicenseUserName.Enabled := FALSE;
      ebLicensePassword.Text := '';
      ebLicensePassword.Enabled := FALSE;
    end;
  finally
    LSettings.Free;
  end;
end;

procedure TfmDBSettings.SaveLicenseSettings;
begin
  var LSettings := TLRLicenseLoginSettings.Create;
  try
    LSettings.UserName := Trim(ebLicenseUserName.Text);
    LSettings.Password := ebLicensePassword.Text;
    LSettings.Database := Trim(ebLicenseDBName.Text);
    LSettings.Host := Trim(ebLicenseHost.Text);
    LSettings.WindowsAuthentication := ckbLicenseWindowsAuth.Checked;
    if LSettings.WindowsAuthentication then
    begin
      LSettings.UserName := String.Empty;
      LSettings.Password := '';
    end;
    LSettings.Save;
  finally
    LSettings.Free;
  end;
end;

procedure TfmDBSettings.btnOKClick(Sender: TObject);
begin
  SaveKBSettings;
  SaveLicenseSettings;
  MessageDlg('Application must be restarted for settings to taske affect.', mtInformation, [mbOK], 0);
  ModalResult := mrOK;
end;

procedure TfmDBSettings.ckbKBWindowsAuthClick(Sender: TObject);
begin
  if ckbKBWindowsAuth.Checked then
  begin
    ebKBUserName.Text := FDomain + '\' + FUser;
    ebKBUserName.Enabled := FALSE;
    ebKBPassword.Text := '';
    ebKBPassword.Enabled := FALSE;
  end else
  begin
    ebKBUserName.Enabled := TRUE;
    ebKBPassword.Enabled := TRUE;
  end;
end;

procedure TfmDBSettings.ckbLicenseWindowsAuthClick(Sender: TObject);
begin
  if ckbLicenseWindowsAuth.Checked then
  begin
    ebLicenseUserName.Text := FDomain + '\' + FUser;
    ebLicenseUserName.Enabled := FALSE;
    ebLicensePassword.Text := '';
    ebLicensePassword.Enabled := FALSE;
  end else
  begin
    ebLicenseUserName.Enabled := TRUE;
    ebLicensePassword.Enabled := TRUE;
  end;
end;

procedure TfmDBSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
