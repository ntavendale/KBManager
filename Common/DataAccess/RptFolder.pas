unit RptFolder;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, DBLoginSettings,
  CommonFunctions, FireDAC.Stan.Option, System.Generics.Collections;

type
  TRptFolder = class
    protected
      FRptFolderID: Integer;
      FRptFolderName: String;
      FParentID: Integer;
    public
      constructor Create; overload; virtual;
      constructor Create(ARptFolder: TRptFolder); overload; virtual;
      procedure Save;
      class function GetNextRptFolderID: Integer;
      property RptFolderID: Integer read FRptFolderID write FRptFolderID;
      property RptFolderName: String read FRptFolderName write FRptFolderName;
      property ParentID: Integer read FParentID write FParentID;
  end;

  TRptFolderList = class
    protected
      FList: TObjectList<TRptFolder>;
      function GetCount: Integer;
      function GetRptFolder(AIndex: Integer): TRptFolder;
      class function GetInitialSQL: TStringList;
      class function CreateRptFolder(ADataSet: TDataSet): TRptFolder;
    public
      constructor Create; overload; virtual;
      constructor Create(ARptFolderList: TRptFolderList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ARptFolder: TRptFolder);
      class function GetAll: TRptFolderList;
      class function GetAllInFolder(AFolderID: Integer): TRptFolderList;
      property Count: Integer read GetCount;
      property RptFolder[AIndex: Integer]: TRptFolder read GetRptFolder; default;
  end;

implementation

constructor TRptFolder.Create;
begin
  FRptFolderID := 0;
  FRptFolderName := '';
  FParentID := 0;
end;

constructor TRptFolder.Create(ARptFolder: TRptFolder);
begin
  FRptFolderID := ARptFolder.RptFolderID;
  FRptFolderName := ARptFolder.RptFolderName;
  FParentID := ARptFolder.ParentID;
end;

procedure TRptFolder.Save;
var
  LConnection: TFDConnection;
  LSettings: TDBLoginSettings;
  LProc: TFDStoredProc;
begin
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LProc := TFDStoredProc.Create(nil);
    try
      LProc.FetchOptions.Items := LProc.FetchOptions.Items - [fiMeta];
      LProc.StoredProcName := 'UpdateRptFolder';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LProc.Params.Add('@RptFolderID', ftInteger, -1, ptInput);
      LProc.Params.Add('@RptFolderName', ftString, 50, ptInput);
      LProc.Params.Add('@ParentID', ftInteger, -1, ptInput);
      LProc.Params.Add('@NextRptFolderID', ftInteger, -1, ptOutput);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;

      if FRptFolderID > 0 then
        LProc.Params.ParamByName('@RptFolderID').AsInteger := FRptFolderID
      else
        LProc.Params.ParamByName('@RptFolderID').Clear;
      if '' <> Trim(FRptFolderName) then
        LProc.Params.ParamByName('@RptFolderName').AsString := FRptFolderName
      else
        LProc.Params.ParamByName('@RptFolderName').Clear;
      if FParentID > 0 then
        LProc.Params.ParamByName('@ParentID').AsInteger := FParentID
      else
        LProc.Params.ParamByName('@ParentID').Clear;

      LProc.ExecProc;

      FRptFolderID := LProc.Params.ParamByName('@NextRptFolderID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

class function TRptFolder.GetNextRptFolderID: Integer;
var
  LConnection: TFDConnection;
  LSettings: TDBLoginSettings;
  LProc: TFDStoredProc;
begin
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    LProc := TFDStoredProc.Create(nil);
    try
      LProc.FetchOptions.Items := LProc.FetchOptions.Items - [fiMeta];
      LProc.StoredProcName := 'GetNewRptFolderID';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;
      LProc.ExecProc;
      Result := LProc.Params[0].AsInteger;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TRptFolderList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TRptFolderList.GetRptFolder(AIndex: Integer): TRptFolder;
begin
  Result := FList[AIndex];
end;

class function TRptFolderList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select RptFolder.RptFolderID, ');
  Result.Add('RptFolder.RptFolderName, ');
  Result.Add('RptFolder.ParentID ');
  Result.Add('From RptFolder ');
end;

class function TRptFolderList.CreateRptFolder(ADataSet: TDataSet): TRptFolder;
begin
  Result := TRptFolder.Create;
  Result.RptFolderID := ADataSet.Fields[0].AsInteger;
  Result.RptFolderName := ADataSet.Fields[1].AsString;
  Result.ParentID := ADataSet.Fields[2].AsInteger;
end;

constructor TRptFolderList.Create;
begin
  inherited Create;
  FList := TObjectList<TRptFolder>.Create(TRUE);
end;

constructor TRptFolderList.Create(ARptFolderList: TRptFolderList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TRptFolder>.Create(TRUE);
  for i := 0 to (ARptFolderList.Count - 1) do
    FList.Add(TRptFolder.Create(ARptFolderList[i]));
end;

destructor TRptFolderList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TRptFolderList.Clear;
begin
  FList.Clear;
end;

procedure TRptFolderList.Add(ARptFolder: TRptFolder);
begin
  FList.Add(ARptFolder);
end;

class function TRptFolderList.GetAll: TRptFolderList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TRptFolder;
begin
  Result := nil;
  LRecord := nil;
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;
  try
    LQuery := TDataServices.GetQuery(LConnection);
    try
      LSQL := GetInitialSQL;
      try
        LSQL.Add('Order By ParentID, RptFolderName');
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TRptFolderList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateRptFolder(LQuery);
          Result.Add(LRecord);
          LQuery.Next;
        end;
      end;
    finally
      LQuery.Close;
      LQuery.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;

class function TRptFolderList.GetAllInFolder(AFolderID: Integer): TRptFolderList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TRptFolder;
begin
  Result := nil;
  LRecord := nil;
  LSettings := TDBLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('KBDL', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;
  try
    LQuery := TDataServices.GetQuery(LConnection);
    try
      LSQL := GetInitialSQL;
      try
        LSQL.Add('Where ParentID=' + IntToStr(AFolderID) + ' ');
        LSQL.Add('Order By RptFolderName');
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TRptFolderList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateRptFolder(LQuery);
          Result.Add(LRecord);
          LQuery.Next;
        end;
      end;
    finally
      LQuery.Close;
      LQuery.Free;
    end;
  finally
    LConnection.Close;
    LConnection.Free;
  end;
end;

end.

