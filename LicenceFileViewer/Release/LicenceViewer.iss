[Setup]
; Required by Inno=
AppName=Licence File Viewer
#define ver GetFileVersion(".\LicenceFileViewer.exe")
AppVersion={#ver}
DefaultDirName={pf}\BastardSoftware

; Optional by Inno=
AppVerName=LicenceFileViewer {#ver}
DefaultGroupName=Licence File Viewer
OutputBaseFilename=LicenceFileViewerSetup
PrivilegesRequired=admin
LicenseFile=EULA.rtf
SetupLogging=yes
UninstallFilesDir={app}\uninstall
AppCopyright=Copyright © Bastard Software 2019
; SetupIconFile=TheIcon.ico
; VersionInfo values for file properties=
VersionInfoCompany=BastardSoftware
VersionInfoCopyright=© Bastard Software 2019
VersionInfoVersion={#ver}
VersionInfoProductVersion={#ver}
VersionInfoProductName=Licence File Viewer
; WizardImageFile=WizardImage.bmp

; "ArchitecturesAllowed=x64" specifies that Setup cannot run on
; anything but x64.
ArchitecturesAllowed=x64
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
ArchitecturesInstallIn64BitMode=x64

[Files]
; ***** App files *****:
Source: ".\LicenceFileViewer.exe"; DestDir: "{app}"

[Icons]
Name: {commonprograms}\Bastard Software\Licence File Viewer; Filename: {app}\LicenceFileViewer.exe; WorkingDir: {app}


[Code]
var
  g_bCopyInstLog: Boolean;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssDone) then
    g_bCopyInstLog := True;
end;

procedure DeinitializeSetup();
begin
  if (g_bCopyInstLog) then
    FileCopy(ExpandConstant('{log}'), ExpandConstant('{app}\') + ExtractFileName(ExpandConstant('{log}')), True)
end;
