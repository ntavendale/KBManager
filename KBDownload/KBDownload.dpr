program KBDownload;

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  Vcl.Forms,
  System.SysUtils,
  Vcl.FileCtrl,
  System.IOUtils,
  Main in 'Main.pas' {fmMain},
  CommonFunctions in '..\Common\Units\CommonFunctions.pas',
  CryptoAPI in '..\Common\Units\CryptoAPI.pas',
  Wcrypt2 in '..\Common\Units\Wcrypt2.pas',
  KB.LoginSettings in '..\Common\Units\KB.LoginSettings.pas',
  IAmABigBoy in 'IAmABigBoy.pas' {fmBigBoy},
  DBSettings in 'DBSettings.pas' {fmDBSettings},
  Deployments in 'Deployments.pas' {fmDeployments},
  KB.Deployment in 'DataAccess\KB.Deployment.pas',
  DataServices in '..\Common\DataObjects\DataServices.pas',
  DeploymentEdit in 'DeploymentEdit.pas' {fmDeploymentEdit},
  KB.KBPackage in 'DataAccess\KB.KBPackage.pas',
  KB.Release in 'DataAccess\KB.Release.pas',
  Releases in 'Releases.pas' {fmReleases},
  DeploymentSnapshots in 'DeploymentSnapshots.pas' {fmDeploymentSnapshots},
  ReleaseEdit in 'ReleaseEdit.pas' {fmReleaseEdit},
  KBPackages in 'KBPackages.pas' {fmKBPackages},
  KB.Settings in 'DataAccess\KB.Settings.pas',
  KB.StatList in 'DataAccess\KB.StatList.pas',
  StatLists in 'StatLists.pas' {fmStatLists},
  KB.DeploymentStats in 'DataAccess\KB.DeploymentStats.pas',
  DataRecordList in '..\Common\Units\DataRecordList.pas',
  ServerSettings in 'ServerSettings.pas' {fmServerSettings},
  KB.Snapshot in 'DataAccess\KB.Snapshot.pas',
  SpreadsheetBase in '..\Common\Forms\SpreadsheetBase.pas' {fmSpreadSheetBase},
  RecordListExport in 'RecordListExport.pas' {fmRecordListExport},
  SingleRecordLookupUnbound in '..\Common\Forms\SingleRecordLookupUnbound.pas' {fmSingleRecordLookupUnbound},
  DeploymentSelect in 'DeploymentSelect.pas' {fmDeploymentSelect},
  KB.KBModule in 'DataAccess\KB.KBModule.pas',
  KB.AgentsByOS in 'DataAccess\KB.AgentsByOS.pas',
  DateRangeSelect in '..\Common\Forms\DateRangeSelect.pas' {fmSelectDateRange},
  SnapshotDataPrep in 'SnapshotDataPrep.pas' {fmSnapshotDataPrep},
  KBPackageEdit in 'KBPackageEdit.pas' {fmKBPackageEdit},
  KBPackageSelect in 'KBPackageSelect.pas' {fmKBPackageSelect},
  FullAppPassword in 'FullAppPassword.pas' {fmFullAppPassword},
  FullApplication in 'FullApplication.pas' {fmUseFullApplication},
  KBVersion in 'KBVersion.pas',
  BusinessObject in '..\Common\Units\BusinessObject.pas',
  LRLicense.SCLicense in 'DataAccess\LRLicense.SCLicense.pas',
  LRLicense.LoginSettings in '..\Common\Units\LRLicense.LoginSettings.pas',
  DownloadEnable in 'DownloadEnable.pas' {fmDownloadEnable},
  KB.LoginTest in 'DataAccess\KB.LoginTest.pas';

{$R *.res}

function IntializeDataFolder: Boolean;
var
  LDataDir: String;
begin
  LDataDir := IncludeTrailingPathDelimiter(GetCommonAppDataDir) + 'BastardSoftware\KBDownload';
  if not (System.SysUtils.DirectoryExists(LDataDir)) then
    TDirectory.CreateDirectory(LDataDir);
  Result := TRUE;
  TKBLoginSettings.DefaultFileName := LDataDir + '\Settings.ini';
  TLRLicenseLoginSettings.DefaultFileName := LDataDir + '\Settings.ini';
end;

begin
  IntializeDataFolder;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.



