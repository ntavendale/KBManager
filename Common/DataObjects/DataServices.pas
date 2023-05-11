unit DataServices;

interface

uses
  SysUtils, Classes, DB, FireDAC.Stan.Error, FireDAC.UI.Intf, Provider,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Comp.Client, RzTabs, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Stan.Intf, FireDAC.DApt.Intf, FireDAC.DApt, CommonFunctions;

type
  TDataServices = class
    public
      class function GetConnectionDef(ADatabaseName, AUserName, APAssword, ADatabase, AHost: String; AUseWindowsAuthentication: Boolean): String;
      class function GetConnection(ADatabaseName, AUserName, APAssword, ADatabase, AHost: String; AUseWindowsAuthentication: Boolean): TFDConnection;
      class function GetQuery(AConnection: TFDConnection): TFDQuery;
      class function GetDataProvider(AQuery: TFDQuery): TDataSetProvider;
  end;

implementation

var
  DriverLink: TFDPhysMSSQLDriverLink;

class function TDataServices.GetConnectionDef(ADatabaseName, AUserName, APAssword, ADatabase, AHost: String; AUseWindowsAuthentication: Boolean): String;
begin
  var LConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(ADatabaseName + '_Connection');

  if nil = LConnectionDef then
  begin
    var LParams := TStringList.Create;
    LParams.Add('Server=' + AHost);
    LParams.Add('Database=' + ADatabase);
    if AUseWindowsAuthentication then
    begin
      var LUser := String.Empty;
      var LDomain := String.Empty;
      GetCurrentUserAndDomain(LUser, LDomain);
      LParams.Add(String.Format('User_Name=%s\%s', [LDomain, LUser]));
      LParams.Add('Password=' + String.Empty);
      LParams.Add('OSAuthent=Yes');
    end else
    begin
      LParams.Add('User_Name=' + AUserName);
      LParams.Add('Password=' + APassword);
    end;
    FDManager.AddConnectionDef(ADatabaseName + '_Connection', 'MSSQL', LParams);
    Result := ADatabaseName + '_Connection';
  end else
  begin
    Result := LConnectionDef.Name;
  end;
end;

class function TDataServices.GetConnection(ADatabaseName, AUserName, APAssword, ADatabase, AHost: String; AUseWindowsAuthentication: Boolean): TFDConnection;
begin
  var LConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(ADatabaseName + '_Connection');
  if nil = LConnectionDef then
  begin
    var LParams := TStringList.Create;
    LParams.Add('Server=' + AHost);
    LParams.Add('Database=' + ADatabase);
    if AUseWindowsAuthentication then
    begin
      var LUser := String.Empty;
      var LDomain := String.Empty;
      GetCurrentUserAndDomain(LUser, LDomain);
      LParams.Add(String.Format('User_Name=%s\%s', [LDomain, LUser]));
      LParams.Add('Password=' + String.Empty);
      LParams.Add('OSAuthent=Yes');
    end else
    begin
      LParams.Add('User_Name=' + AUserName);
      LParams.Add('Password=' + APassword);
    end;
    FDManager.AddConnectionDef(ADatabaseName + '_Connection', 'MSSQL', LParams);
  end;

  Result := TFDConnection.Create(nil);
  Result.LoginPrompt := FALSE;
  Result.DriverName := 'MSSQL';
  Result.ConnectionDefName := ADatabaseName + '_Connection';
end;

class function TDataServices.GetQuery(AConnection: TFDConnection): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result .Connection := AConnection;
end;

class function TDataServices.GetDataProvider(AQuery: TFDQuery): TDataSetProvider;
begin
  Result := TDataSetProvider.Create(nil);
  Result.DataSet := AQuery;
end;

initialization
  //Explicitly set Native driver ver to 10.
  //If 11 (2012) installeed side by side it
  //will default to most recent version and that
  //one doe not work.
  DriverLink := TFDPhysMSSQLDriverLink.Create(nil);
  DriverLink.ODBCDriver := 'SQL SERVER NATIVE CLIENT 10.0';

finalization
  DriverLink.Free;

end.
