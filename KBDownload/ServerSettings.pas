unit ServerSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, KB.Settings, Vcl.StdCtrls, Vcl.Mask,
  RzEdit, RzLabel, RzTabs, Vcl.ExtCtrls, RzPanel, RzSpnEdt, RzButton, DateUtils,
  System.UITypes;

type
  TfmServerSettings = class(TForm)
    rgFTP: TRzGroupBox;
    pcFTP: TRzPageControl;
    tsUpload: TRzTabSheet;
    tsDownload: TRzTabSheet;
    tsStaging: TRzTabSheet;
    RzLabel1: TRzLabel;
    ebUploadPath: TRzEdit;
    RzLabel2: TRzLabel;
    ebUploadURL: TRzEdit;
    RzLabel3: TRzLabel;
    ebDownloadPath: TRzEdit;
    RzLabel4: TRzLabel;
    ebDownloadURL: TRzEdit;
    RzLabel5: TRzLabel;
    ebStagingPath: TRzEdit;
    RzLabel6: TRzLabel;
    ebStagingURL: TRzEdit;
    RzLabel7: TRzLabel;
    ebCertificate: TRzEdit;
    RzLabel8: TRzLabel;
    spMaxDownloads: TRzSpinEdit;
    btnSave: TRzBitBtn;
    btnClose: TRzBitBtn;
    RzLabel9: TRzLabel;
    RzLabel10: TRzLabel;
    RzLabel11: TRzLabel;
    lbCreated: TRzLabel;
    lbModified: TRzLabel;
    lbModifiedBy: TRzLabel;
    procedure ebUploadPathChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FSettings: TSettings;
    procedure ObjectToForm;
    procedure FormToObject;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
constructor TfmServerSettings.Create(AOwner: TComponent);
var
  LSettingsList: TSettingsList;
begin
  inherited Create(AOWner);
  LSettingsList := TSettingsList.GetAll;
  try
    if 0 <> LSettingsList.Count then
      FSettings := TSettings.Create(LSettingsList[0])
    else
      FSettings := TSettings.Create;
  finally
    LSettingsList.Free;
  end;
  ObjectToForm;
  pcFTP.ActivePage := tsUpload;
  btnSave.Enabled := FALSE;
end;

destructor TfmServerSettings.Destroy;
begin
  if nil <> FSettings then
    FSettings.Free;
  inherited Destroy;
end;

procedure TfmServerSettings.ObjectToForm;
begin
  ebUploadPath.Text := FSettings.UploadPath;
  ebUploadURL.Text :=  FSettings.UploadUrl;
  ebDownloadPath.Text := FSettings.DownloadPath;
  ebDownloadURL.Text := FSettings.DownloadUrl;
  ebStagingPath.Text := FSettings.StagingPath;
  ebStagingURL.Text := FSettings.StagingUrl;
  ebCertificate.Text := FSettings.CertificateName;
  spMaxDownloads.IntValue := FSettings.MaxKBDownloads;

  lbCreated.Caption := DateTimeToStr(TTimeZone.Local.ToLocalTime(FSettings.Created));
  lbModified.Caption := DateTimeToStr(TTimeZone.Local.ToLocalTime(FSettings.Modified));
  lbModifiedBy.Caption := FSettings.Modifier;
end;

procedure TfmServerSettings.FormToObject;
begin
  FSettings.UploadPath := Trim(ebUploadPath.Text);
  FSettings.UploadUrl := Trim(ebUploadURL.Text);
  FSettings.DownloadPath := Trim(ebDownloadPath.Text);
  FSettings.DownloadUrl := Trim(ebDownloadURL.Text);
  FSettings.StagingPath := Trim(ebStagingPath.Text);
  FSettings.StagingUrl := Trim(ebStagingURL.Text);
  FSettings.CertificateName := Trim(ebCertificate.Text);
  FSettings.MaxKBDownloads := spMaxDownloads.IntValue;
end;

procedure TfmServerSettings.ebUploadPathChange(Sender: TObject);
begin
  btnSave.Enabled := TRUE;
end;

procedure TfmServerSettings.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmServerSettings.btnSaveClick(Sender: TObject);
begin
  FormToObject;
  FSettings.Save;
  MessageDlg('Settings Saved.', mtInformation, [mbOK], 0);
  ObjectToForm;
  btnSave.Enabled := FALSE;
end;

end.
