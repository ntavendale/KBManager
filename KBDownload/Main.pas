unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  RzButton, Vcl.ImgList, Vcl.ExtCtrls, RzPanel, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, Data.DB, FireDAC.Comp.Client,
  KB.LoginSettings, DataServices, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.ImageList, RzStatus;

type
  TfmMain = class(TForm)
    menMain: TMainMenu;
    menFile: TMenuItem;
    miDBSettings: TMenuItem;
    tbMain: TRzToolbar;
    ilMain: TImageList;
    btnDeployments: TRzToolButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    btnReleases: TRzToolButton;
    btnPackages: TRzToolButton;
    btnStatLists: TRzToolButton;
    btnServerSettings: TRzToolButton;
    miDeploymentSelect: TMenuItem;
    viMain: TRzVersionInfo;
    procedure miDBSettingsClick(Sender: TObject);
    procedure btnDeploymentsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnReleasesClick(Sender: TObject);
    procedure btnPackagesClick(Sender: TObject);
    procedure btnStatListsClick(Sender: TObject);
    procedure btnServerSettingsClick(Sender: TObject);
    procedure miDeploymentSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FReportsVisible: Boolean;
    function UserOKToRun: Boolean;
    procedure CloseMDIChildren;
    procedure OpenForm(AFormIndex: Integer);
  public
    { Public declarations }
    constructor Create(AOWner: TComponent); override;
  end;

var
  fmMain: TfmMain;

implementation

uses
  IAmABigBoy, DBSettings, Deployments, Releases, KBPackages, StatLists,
  ServerSettings, CommonFunctions, DeploymentSelect, SnapshotDataPrep,
  FullAppPassword, FullApplication, KB.LoginTest;

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
constructor TfmMain.Create(AOWner: TComponent);
begin
  inherited Create(AOWner);
  FReportsVisible := FALSE;
  if not UserOKToRun then
    Application.Terminate
  else
  begin
    var LUser, LDomain: String;
    GetCurrentUserAndDomain(LUser, LDomain);
    Self.Caption := String.Format('KB Download DDA Prototype %s (%s\%s)', [viMain.FileVersion, LDomain, LUser]);
  end;
end;

function TfmMain.UserOKToRun: Boolean;
begin
  var fm := TfmBigBoy.Create(nil);
  try
    fm.ShowModal;
    Result := fm.UserOK;
  finally
    fm.Free;
  end;
end;

procedure TfmMain.CloseMDIChildren;
begin
  for var i := (fmMain.MDIChildCount - 1) downto 0 do
    fmMain.MDIChildren[i].Close;
end;

procedure TfmMain.OpenForm(AFormIndex: Integer);
begin
  if not ((0 <= AFormIndex) and (AFormIndex <= 3)) then
    EXIT;
  var LForm: TForm := nil;
  CloseMDIChildren;
  try
    Screen.Cursor := crHourglass;
    LockWindowUpdate(fmMain.Handle); //Locks Main Form to prevent flashing while
    case AFormIndex of
      0: LForm := TfmDeployments.Create(nil);
      1: LForm := TfmReleases.Create(nil);
      2: LForm := TfmKBPackages.Create(nil);
      3: LForm := TfmStatLists.Create(nil);
    end;
    LForm.BorderIcons := [];
    LForm.WindowState := wsMaximized;
    LForm.Show;
  finally
    Screen.Cursor := crDefault;
    LockWindowUpdate(0);//Feeding 0 to function unlocks the locked window
  end;
  SetRegistryString('MainApp', 'LastForm', IntToStr(AFormIndex));
end;

{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmMain.miDBSettingsClick(Sender: TObject);
begin
  var fm := TfmDBSettings.Create(nil);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TfmMain.btnDeploymentsClick(Sender: TObject);
begin
  OpenForm(0);
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMDIChildren;
end;

procedure TfmMain.btnReleasesClick(Sender: TObject);
begin
  OpenForm(1);
end;

procedure TfmMain.btnPackagesClick(Sender: TObject);
begin
  OpenForm(2);
end;

procedure TfmMain.btnStatListsClick(Sender: TObject);
begin
  OpenForm(3);
end;

procedure TfmMain.btnServerSettingsClick(Sender: TObject);
var
  fm: TfmServerSettings;
begin
  fm := TfmServerSettings.Create(nil);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TfmMain.miDeploymentSelectClick(Sender: TObject);
begin
  var fm := TfmSnapshotDataPrep.Create(nil);
  try
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  if not TKBLoginTest.CanLogIn then
  begin
    MessageDlg('DB Login Failure. Check settings', mtError, [mbOK], 0);
    EXIT;
  end;
  btnDeployments.Down := FALSE;
  btnReleases.Down := FALSE;
  btnPackages.Down := FALSE;
  btnStatLists.Down := FALSE;
  var LFormIndex := StrToIntDef(GetRegistryString('MainApp', 'LastForm'), -1);
  OpenForm(LFormIndex);
  case LFormIndex of
    0: btnDeployments.Down := TRUE;
    1: btnReleases.Down := TRUE;
    2: btnPackages.Down := TRUE;
    3: btnStatLists.Down := TRUE;
  end;
end;

end.
