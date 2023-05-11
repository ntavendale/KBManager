unit RptItem;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, DBLoginSettings,
  CommonFunctions, FireDAC.Stan.Option, System.Generics.Collections;

type
  TRptItem = class
    protected
      FRptItemID: Integer;
      FRptFolderID: Integer;
      FItemType: Integer;
      FModified: TDateTime;
      FDeleted: TDateTime;
      FReportName: String;
      FReportSize: Integer;
      FReportTemplate: TMemoryStream;
    public
      constructor Create; overload; virtual;
      constructor Create(ARptItem: TRptItem); overload; virtual;
      destructor Destroy; override;
      procedure LoadTemplate;
      procedure Save;
      procedure SaveDetail;
      class function GetNextRptItemID: Integer;
      property RptItemID: Integer read FRptItemID write FRptItemID;
      property RptFolderID: Integer read FRptFolderID write FRptFolderID;
      property ItemType: Integer read FItemType write FItemType;
      property Modified: TDateTime read FModified write FModified;
      property Deleted: TDateTime read FDeleted write FDeleted;
      property ReportName: String read FReportName write FReportName;
      property ReportSize: Integer read FReportSize write FReportSize;
      property ReportTemplate: TMemoryStream read FReportTemplate;
  end;

  TRptItemList = class
    protected
      FList: TObjectList<TRptItem>;
      function GetCount: Integer;
      function GetRptItem(AIndex: Integer): TRptItem;
      class function GetInitialSQL: TStringList;
      class function CreateRptItem(ADataSet: TDataSet): TRptItem;
    public
      constructor Create; overload; virtual;
      constructor Create(ARptItemList: TRptItemList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ARptItem: TRptItem);
      class function GetSingleInstance(ARptItemID: Integer): TRptItem;
      class function GetAll: TRptItemList;
      class function GetAllInFolder(AFolderID: Integer): TRptItemList;
      property Count: Integer read GetCount;
      property RptItem[AIndex: Integer]: TRptItem read GetRptItem; default;
  end;

implementation

constructor TRptItem.Create;
begin
  FRptItemID := 0;
  FRptFolderID := 0;
  FItemType := 0;
  FModified := -1.00;
  FDeleted := -1.00;
  FReportName := '';
  FReportSize := 0;
  FReportTemplate := TMemoryStream.Create;
end;

constructor TRptItem.Create(ARptItem: TRptItem);
begin
  FRptItemID := ARptItem.RptItemID;
  FRptFolderID := ARptItem.RptFolderID;
  FItemType := ARptItem.ItemType;
  FModified := ARptItem.Modified;
  FDeleted := ARptItem.Deleted;
  FReportName := ARptItem.ReportName;
  FReportSize := ARptItem.ReportSize;
  FReportTemplate := TMemoryStream.Create;
  FReportTemplate.LoadFromStream(ARptItem.ReportTemplate);
end;

destructor TRptItem.Destroy;
begin
  FReportTemplate.Free;
  inherited Destroy;
end;

procedure TRptItem.LoadTemplate;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSettings: TDBLoginSettings;
  LStream: TStream;
begin
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
      LQuery.SQL.Add('Select ReportTemplate from RptItem Where RptItemID=' + IntToStr(FRptItemID) + ' ');
      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        LQuery.First;
        LStream := LQuery.CreateBlobStream(LQuery.Fields[0], bmRead);
        try
          FReportTemplate.Clear;
          FReportTemplate.LoadFromStream(LStream);
        finally
          LStream.Free;
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

procedure TRptItem.Save;
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
      LProc.StoredProcName := 'UpdateRptItem';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LProc.Params.Add('@RptItemID', ftInteger, -1, ptInput);
      LProc.Params.Add('@RptFolderID', ftInteger, -1, ptInput);
      LProc.Params.Add('@ItemType', ftInteger, -1, ptInput);
      LProc.Params.Add('@Deleted', ftDateTime, -1, ptInput);
      LProc.Params.Add('@ReportName', ftString, 50, ptInput);
      LProc.Params.Add('@ReportSize', ftInteger, -1, ptInput);
      LProc.Params.Add('@ReportTemplate', ftBlob, -1, ptInput);
      LProc.Params.Add('@NextRptItemID', ftInteger, -1, ptOutput);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;

      if FRptItemID > 0 then
        LProc.Params.ParamByName('@RptItemID').AsInteger := FRptItemID
      else
        LProc.Params.ParamByName('@RptItemID').Clear;
      if FRptFolderID > 0 then
        LProc.Params.ParamByName('@RptFolderID').AsInteger := FRptFolderID
      else
        LProc.Params.ParamByName('@RptFolderID').Clear;
      if FItemType > 0 then
        LProc.Params.ParamByName('@ItemType').AsInteger := FItemType
      else
        LProc.Params.ParamByName('@ItemType').Clear;
      if FDeleted > 2.00 then
        LProc.Params.ParamByName('@Deleted').AsDateTime := FDeleted
      else
        LProc.Params.ParamByName('@Deleted').Clear;
      if '' <> Trim(FReportName) then
        LProc.Params.ParamByName('@ReportName').AsString := FReportName
      else
        LProc.Params.ParamByName('@ReportName').Clear;
      if FReportSize > 0 then
        LProc.Params.ParamByName('@ReportSize').AsInteger := FReportSize
      else
        LProc.Params.ParamByName('@ReportSize').Clear;

      LProc.Params.ParamByName('@ReportTemplate').LoadFromStream(FReportTemplate, ftBlob);
      LProc.ExecProc;
      FRptItemID := LProc.Params.ParamByName('@NextRptItemID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

procedure TRptItem.SaveDetail;
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
      LProc.StoredProcName := 'UpdateRptItemDetail';
      LProc.Params.Clear;
      LProc.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LProc.Params.Add('@RptItemID', ftInteger, -1, ptInput);
      LProc.Params.Add('@RptFolderID', ftInteger, -1, ptInput);
      LProc.Params.Add('@ItemType', ftInteger, -1, ptInput);
      LProc.Params.Add('@Deleted', ftDateTime, -1, ptInput);
      LProc.Params.Add('@ReportName', ftString, 50, ptInput);
      LProc.Params.Add('@NextRptItemID', ftInteger, -1, ptOutput);

      LProc.Connection := LConnection;
      LConnection.Connected := TRUE;

      if FRptItemID > 0 then
        LProc.Params.ParamByName('@RptItemID').AsInteger := FRptItemID
      else
        LProc.Params.ParamByName('@RptItemID').Clear;
      if FRptFolderID > 0 then
        LProc.Params.ParamByName('@RptFolderID').AsInteger := FRptFolderID
      else
        LProc.Params.ParamByName('@RptFolderID').Clear;
      if FItemType > 0 then
        LProc.Params.ParamByName('@ItemType').AsInteger := FItemType
      else
        LProc.Params.ParamByName('@ItemType').Clear;
      if FDeleted > 2.00 then
        LProc.Params.ParamByName('@Deleted').AsDateTime := FDeleted
      else
        LProc.Params.ParamByName('@Deleted').Clear;
      if '' <> Trim(FReportName) then
        LProc.Params.ParamByName('@ReportName').AsString := FReportName
      else
        LProc.Params.ParamByName('@ReportName').Clear;
      LProc.ExecProc;
      FRptItemID := LProc.Params.ParamByName('@NextRptItemID').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LProc.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

class function TRptItem.GetNextRptItemID: Integer;
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
      LProc.StoredProcName := 'GetNewRptItemID';
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

function TRptItemList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TRptItemList.GetRptItem(AIndex: Integer): TRptItem;
begin
  Result := FList[AIndex];
end;

class function TRptItemList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select RptItem.RptItemID, ');
  Result.Add('RptItem.RptFolderID, ');
  Result.Add('RptItem.ItemType, ');
  Result.Add('RptItem.Modified, ');
  Result.Add('RptItem.Deleted, ');
  Result.Add('RptItem.ReportName, ');
  Result.Add('RptItem.ReportSize ');
  Result.Add('From RptItem ');
end;

class function TRptItemList.CreateRptItem(ADataSet: TDataSet): TRptItem;
begin
  Result := TRptItem.Create;
  Result.RptItemID := ADataSet.Fields[0].AsInteger;
  Result.RptFolderID := ADataSet.Fields[1].AsInteger;
  Result.ItemType := ADataSet.Fields[2].AsInteger;
  Result.Modified := ADataSet.Fields[3].AsDateTime;
  if not ADataSet.Fields[4].IsNull then
    Result.Deleted := ADataSet.Fields[4].AsDateTime;
  Result.ReportName := ADataSet.Fields[5].AsString;
  Result.ReportSize := ADataSet.Fields[6].AsInteger;
end;

constructor TRptItemList.Create;
begin
  inherited Create;
  FList := TObjectList<TRptItem>.Create(TRUE);
end;

constructor TRptItemList.Create(ARptItemList: TRptItemList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TRptItem>.Create(TRUE);
  for i := 0 to (ARptItemList.Count - 1) do 
    FList.Add(TRptItem.Create(ARptItemList[i]));
end;

destructor TRptItemList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TRptItemList.Clear;
begin
  FList.Clear;
end;

procedure TRptItemList.Add(ARptItem: TRptItem);
begin
  FList.Add(ARptItem);
end;

class function TRptItemList.GetSingleInstance(ARptItemID: Integer): TRptItem;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TRptItem;
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
        LSQL.Add('Where RptItemID = ' + IntToStr(ARptItemID));
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        LQuery.First;
        Result := CreateRptItem(LQuery);
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

class function TRptItemList.GetAll: TRptItemList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TRptItem;
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
        LSQL.Add('Order By RptFolderID, ReortName');
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TRptItemList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateRptItem(LQuery);
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

class function TRptItemList.GetAllInFolder(AFolderID: Integer): TRptItemList;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  LSQL: TStrings;
  i: Integer;
  LSettings: TDBLoginSettings;
  LRecord: TRptItem;
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
        LSQL.Add('Where RptFolderID=' + IntToStr(AFolderID) + ' ');
        LSQL.Add('Order By ReportName');
        for i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TRptItemList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateRptItem(LQuery);
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
