unit FullApplication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzLabel, Vcl.Mask, RzEdit,
  RzButton, System.UITypes, System.IniFiles, KB.LoginSettings, CryptoAPI, CommonFunctions,
  RzRadChk;

type
  TfmUseFullApplication = class(TForm)
    RzLabel1: TRzLabel;
    ebPassword: TRzEdit;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    ckbRemember: TRzCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    function GetCurrentPassword: String;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TfmUseFullApplication.GetCurrentPassword: String;
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

procedure TfmUseFullApplication.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: btnOK.Click;
    VK_ESCAPE: btnCancel.Click;
  end;
end;

procedure TfmUseFullApplication.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmUseFullApplication.btnOKClick(Sender: TObject);
begin
  if GetCurrentPassword <> ebPassword.Text then
  begin
    MessageDlg('Invalid Password!', mtError, [mbOK], 0);
    EXIT;
  end;
  if ckbRemember.Checked then
  begin
    SetRegistryString('KBDownload', GetMachineGUID, 'T');
  end;
  ModalResult := mrOK;
end;

end.
