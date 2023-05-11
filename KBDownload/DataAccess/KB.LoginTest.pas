unit KB.LoginTest;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  System.DateUtils, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,  KB.LoginSettings,
  DataServices;

type
  TKBLoginTest = class
  protected
  public
    class function CanLogIn: Boolean;
  end;

implementation

class function TKBLoginTest.CanLogIn: Boolean;
begin
  var LConnection: TFDConnection;
  var LSettings := TKBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    try
      var LQuery := TDataServices.GetQuery(LConnection);
      try
        LQuery.SQL.Add('Select 1');
        LConnection.Open;
        LQuery.Open;
      finally
        LQuery.Free;
      end;
      LConnection.Connected := FALSE;
    finally
      LConnection.Free;
    end;
    Result := TRUE;
  except
    Result := FALSE;
  end;
end;

end.
