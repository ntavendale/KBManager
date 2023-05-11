unit FullAppPassword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit, RzLabel,
  RzButton, System.IniFiles, System.UITypes, KB.LoginSettings, CryptoAPI;

type
  TfmFullAppPassword = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    ebOldPassword: TRzEdit;
    ebNewPassword: TRzEdit;
    RzLabel3: TRzLabel;
    ebNewPasswordConfirm: TRzEdit;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    function GetCurrentPassword: String;
    procedure SetNewPassword(ANewPassword: String);
    function CompareOK: Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TfmFullAppPassword.GetCurrentPassword: String;
var
  LIni: TIniFile;
  LPasswd: String;
begin
  Result := 'invalidPassword';
  LPasswd := String.Empty;
  if not FileExists(TKBLoginSettings.DefaultFileName) then
    EXIT;

  LIni := TIniFile.Create(TKBLoginSettings.DefaultFileName);
  try
    if 0 = TCryptoAPI.aesDecryptString(LIni.ReadString('AppSeetings', 'Password', ''), LPasswd) then
    begin
      Result := LPasswd;
    end;
  finally
    LIni.Free;
  end;
end;

procedure TfmFullAppPassword.SetNewPassword(ANewPassword: String);
var
  LIni: TIniFile;
  LPasswd: String;
begin
  LPasswd := String.Empty;
  if not FileExists(TKBLoginSettings.DefaultFileName) then
    EXIT;

  LIni := TIniFile.Create(TKBLoginSettings.DefaultFileName);
  try
    if 0 = TCryptoAPI.aesEncryptString(ANewPassword, LPasswd) then
    begin
      LIni.WriteString('AppSeetings', 'Password', LPasswd)
    end;
  finally
    LIni.Free;
  end;
end;

function TfmFullAppPassword.CompareOK: Boolean;
var
  LCurrent: String;
begin
  Result := FALSE;
  LCurrent := GetCurrentPassword;
  if LCurrent <> ebOldPassword.Text then
  begin
    MessageDlg('Old Password is incorrect!', mtError, [mbOK], 0);
    EXIT;
  end;

  if (ebNewPassword.Text <> String.Empty) then
  begin
    MessageDlg('New Password cannot be empty!', mtError, [mbOK], 0);
    EXIT;
  end;

  if (ebNewPassword.Text <> ebNewPasswordConfirm.Text) then
  begin
    MessageDlg('New Password does not match confirmation!', mtError, [mbOK], 0);
    EXIT;
  end;
  Result := TRUE;
end;

procedure TfmFullAppPassword.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN: btnOK.Click;
  VK_ESCAPE: btnCancel.Click;
  end;
end;

procedure TfmFullAppPassword.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmFullAppPassword.btnOKClick(Sender: TObject);
begin
  if CompareOK then
  begin
    SetNewPassword(ebNewPassword.Text);
    ModalResult := mrOK;
  end;
end;

end.
