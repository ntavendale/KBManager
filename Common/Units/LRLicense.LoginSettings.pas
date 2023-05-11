unit LRLicense.LoginSettings;

interface

uses
  System.SysUtils, System.Classes, System.INIFiles, System.JSON,
  CryptoAPI;

type
  TLRLicenseLoginSettings = class
  private
    class var FIniFile: String;
    class var FUserName: String;
    class var FPassword: String;
    class var FDatabase: String;
    class var FHost: String;
    class var FWindowsAuthentication: Boolean;
    class var FConnectionName: String;
    class var FDefaultFileName: String;
  public
    constructor Create(AIniFileName: String = ''); virtual;
    procedure Load;
    procedure Save;
    class procedure LoadFromJsonString(AJsonString: String);
    class property UserName: String read FUserName write FUserName;
    class property Password: String read FPassword write FPassword;
    class property Database: String read FDatabase write FDatabase;
    class property Host: String read FHost write FHost;
    class property WindowsAuthentication: Boolean read FWindowsAuthentication write FWindowsAuthentication;
    class property ConnectionName: String read FConnectionName write FConnectionName;
    class property DefaultFileName: String read FDefaultFileName write FDefaultFileName;
  end;

implementation

constructor TLRLicenseLoginSettings.Create(AIniFileName: String = '');
begin
  inherited Create;
  FIniFile := AIniFileName;
  if '' = FIniFile then
    FIniFile := FDefaultFileName;
end;

procedure TLRLicenseLoginSettings.Load;
begin
  if not FileExists(FIniFile) then
    EXIT;

  var LIniFile := TIniFile.Create(FIniFile);
  try
    var LSection := 'LRLicenseLogin';
    FUserName := LIniFile.ReadString(LSection, 'UserName', '');
    var LPassword := Trim(LIniFile.ReadString(LSection, 'Password', ''));
    if '' <> LPassword then
      TCryptoAPI.aesDecryptString(LIniFile.ReadString(LSection, 'Password', ''), LPassword);
    FPassword := LPassword;
    FDatabase := LIniFile.ReadString(LSection, 'Database', '');
    FHost := LIniFile.ReadString(LSection, 'Host', '');
    FWindowsAuthentication := LIniFile.ReadBool(LSection, 'WindowsAuth', FALSE);
  finally
    LIniFile.Free;
  end;
end;

procedure TLRLicenseLoginSettings.Save;
begin
  var LIniFile := TIniFile.Create(FIniFile);
  try
    var LSection := 'LRLicenseLogin';
    LIniFile.WriteString(LSection, 'UserName', FUserName);
    var LPassword := String.Empty;
    if '' <> Trim(FPassword) then
      TCryptoAPI.aesEncryptString(FPassword, LPassword)
    else
      LPassword := '';
    LIniFile.WriteString(LSection, 'Password', LPassword);
    LIniFile.WriteString(LSection, 'Database', FDatabase);
    LIniFile.WriteString(LSection, 'Host', FHost);
    LIniFile.WriteBool(LSection, 'WindowsAuth', FWindowsAuthentication);
  finally
    LIniFile.Free;
  end;
end;

class procedure TLRLicenseLoginSettings.LoadFromJsonString(AJsonString: String);
var
  LJson: TJsonObject;
  LPassword: String;
begin
  LJson := TJsonObject.ParseJSONValue(AJsonString) as TJsonObject;
  try
    if nil <> LJson.Values['host'] then
      FHost := LJson.Values['host'].Value;
    if nil <> LJson.Values['database'] then
      FDatabase := LJson.Values['database'].Value;
    if nil <> LJson.Values['userName'] then
      FUserName := LJson.Values['userName'].Value;
    if nil <> LJson.Values['password'] then
    begin
      TCryptoAPI.aesDecryptString(LJson.Values['password'].Value, LPassword);
      FPassword := LPassword;
    end;
  finally
    LJson.Free;
  end;
end;

end.
