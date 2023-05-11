unit LRLicense.SCLicense;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.Stan.Intf, FireDAC.DatS,  FireDAC.DApt.Intf,
  FireDAC.DApt, DB, FireDAC.Stan.Option, System.Generics.Collections,
  LRLicense.LoginSettings, DataServices, CommonFunctions, DataRecordList,
  BusinessObject;

type
  TSCLicense = class(TBusinessObject)
  protected
    FLicenseID: Integer;
    FLicenseType: Integer;
    FExpirationDate: TDateTime;
    FSignature: String;
    FLicensedTo: String;
    FComponentID: Integer;
    FMasterLicenseID: Integer;
    FLicenseSigningKeyID: Integer;
    FDateUpdated: TDateTime;
    FMajorVersion: Integer;
    FMinorVersion: Integer;
    FQuantity: Integer;
  public
    constructor Create; overload; virtual;
    constructor Create(ASCLicense: TSCLicense); overload; virtual;
    function ToJsonObject: TJsonObject; override;
    procedure FromJsonObject(AObject: TJsonObject); override;
    property LicenseID: Integer read FLicenseID write FLicenseID;
    property LicenseType: Integer read FLicenseType write FLicenseType;
    property ExpirationDate: TDateTime read FExpirationDate write FExpirationDate;
    property Signature: String read FSignature write FSignature;
    property LicensedTo: String read FLicensedTo write FLicensedTo;
    property ComponentID: Integer read FComponentID write FComponentID;
    property MasterLicenseID: Integer read FMasterLicenseID write FMasterLicenseID;
    property LicenseSigningKeyID: Integer read FLicenseSigningKeyID write FLicenseSigningKeyID;
    property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
    property MajorVersion: Integer read FMajorVersion write FMajorVersion;
    property MinorVersion: Integer read FMinorVersion write FMinorVersion;
    property Quantity: Integer read FQuantity write FQuantity;
  end;

  TSCLicenseList = class(TDataRecordList)
  protected
    FList: TObjectList<TSCLicense>;
    function GetCount: Integer; override;
    function GetFieldCount: Integer; override;
    function GetFieldCaption(AIndex: Integer): String; override;
    function GetFieldData(ARecord, AIndex: Integer): Variant; override;
    function GetListItem(AIndex: Integer): TSCLicense;
    class function GetInitialSQL: TStringList;
    class function CreateSCLicense(ADataSet: TDataSet): TSCLicense;
  public
    constructor Create; overload; virtual;
    constructor Create(ASettingsList: TSCLicenseList); overload; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(AValue: TSCLicense);
    function ToJsonArray: TJsonArray; override;
    procedure FromJsonArray(AArray: TJsonArray); override;
    class function GetAll(AMasterLicenseID: Integer): TSCLicenseList;
    property Settings[AIndex: Integer]: TSCLicense read GetListItem; default;
  end;

implementation

{$REGION 'TSCLicense'}
constructor TSCLicense.Create;
begin
  FLicenseID := 0;
  FLicenseType := 0;
  FExpirationDate := 0.00;
  FSignature := String.Empty;
  FLicensedTo := String.Empty;
  FComponentID := 0;
  FMasterLicenseID := 0;
  FLicenseSigningKeyID := 0;
  FDateUpdated := 0.00;
  FMajorVersion := 0;
  FMinorVersion := 0;
  FQuantity := 0;
end;

constructor TSCLicense.Create(ASCLicense: TSCLicense);
begin
  FLicenseID := ASCLicense.LicenseID;
  FLicenseType := ASCLicense.LicenseType;
  FExpirationDate := ASCLicense.ExpirationDate;
  FSignature := ASCLicense.Signature;
  FLicensedTo := ASCLicense.LicensedTo;
  FComponentID := ASCLicense.ComponentID;
  FMasterLicenseID := ASCLicense.MasterLicenseID;
  FLicenseSigningKeyID := ASCLicense.LicenseSigningKeyID;
  FDateUpdated := ASCLicense.DateUpdated;
  FMajorVersion := ASCLicense.MajorVersion;
  FMinorVersion := ASCLicense.MinorVersion;
  FQuantity := ASCLicense.Quantity;
end;

function TSCLicense.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('licenseId', TJsonNumber.Create(FLicenseID));
  Result.AddPair('licenseType', TJsonNumber.Create(FLicenseType));
  if FExpirationDate > 1.00 then
    Result.AddPair('expirationDate', FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', FExpirationDate));
  Result.AddPair('signature', FSignature);
  Result.AddPair('licensedTo', FLicensedTo);
  Result.AddPair('componentId', TJsonNumber.Create(FComponentID));
  if FMasterLicenseID > 0 then
    Result.AddPair('masterLicenseId', TJsonNumber.Create(FMasterLicenseID));
  Result.AddPair('licenseSigningKeyId', TJsonNumber.Create(FLicenseSigningKeyID));
  if FDateUpdated > 1.00 then
    Result.AddPair('dateUpdated', FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', FDateUpdated));
  Result.AddPair('majorVersion', TJsonNumber.Create(majorVersion));
  Result.AddPair('minorVersion', TJsonNumber.Create(FMinorVersion));
  Result.AddPair('quantity', TJsonNumber.Create(FQuantity));
end;

procedure TSCLicense.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['licenseId'] then
  begin
    try
      FLicenseID := AObject.Values['licenseId'].Value.ToInteger;
    except
      FLicenseID := 0;
    end;
  end;
  if nil <> AObject.Values['licenseType'] then
  begin
    try
      FLicenseType := AObject.Values['licenseType'].Value.ToInteger;
    except
      FLicenseType := 0;
    end;
  end;
  if nil <> AObject.Values['expirationDate'] then
  begin
    try
      var LDaterStr := AObject.Values['expirationDate'].Value;
      FExpirationDate := EncodeDateTime(LDaterStr.Substring(0, 4).ToInteger, LDaterStr.Substring(5, 2).ToInteger, LDaterStr.Substring(8, 2).ToInteger, LDaterStr.Substring(11, 2).ToInteger, LDaterStr.Substring(14, 2).ToInteger, LDaterStr.Substring(17, 2).ToInteger, LDaterStr.Substring(20, 3).ToInteger);
    except
      FLicenseType := 0;
    end;
  end;
  if nil <> AObject.Values['signature'] then
    FSignature := AObject.Values['signature'].Value;
  if nil <> AObject.Values['licensedTo'] then
    FLicensedTo := AObject.Values['licensedTo'].Value;
  if nil <> AObject.Values['componentId'] then
  begin
    try
      FComponentID := AObject.Values['componentId'].Value.ToInteger;
    except
      FComponentID := 0;
    end;
  end;
  if nil <> AObject.Values['masterLicenseId'] then
  begin
    try
      FMasterLicenseID := AObject.Values['masterLicenseId'].Value.ToInteger;
    except
      FMasterLicenseID := 0;
    end;
  end;
  if nil <> AObject.Values['licenseSigningKeyId'] then
  begin
    try
      FLicenseSigningKeyID := AObject.Values['licenseSigningKeyId'].Value.ToInteger;
    except
      FLicenseSigningKeyID := 0;
    end;
  end;
  if nil <> AObject.Values['dateUpdated'] then
  begin
    try
      var LDaterStr := AObject.Values['dateUpdated'].Value;
      FDateUpdated := EncodeDateTime(LDaterStr.Substring(0, 4).ToInteger, LDaterStr.Substring(5, 2).ToInteger, LDaterStr.Substring(8, 2).ToInteger, LDaterStr.Substring(11, 2).ToInteger, LDaterStr.Substring(14, 2).ToInteger, LDaterStr.Substring(17, 2).ToInteger, LDaterStr.Substring(20, 3).ToInteger);
    except
      FLicenseType := 0;
    end;
  end;
  if nil <> AObject.Values['majorVersion'] then
  begin
    try
      FMajorVersion := AObject.Values['majorVersion'].Value.ToInteger;
    except
      FMajorVersion := 0;
    end;
  end;
  if nil <> AObject.Values['minorVersion'] then
  begin
    try
      FMinorVersion := AObject.Values['minorVersion'].Value.ToInteger;
    except
      FMinorVersion := 0;
    end;
  end;
  if nil <> AObject.Values['quantity'] then
  begin
    try
      FQuantity := AObject.Values['quantity'].Value.ToInteger;
    except
      FQuantity := 0;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'TSCLicenseList'}
constructor TSCLicenseList.Create;
begin
  FList := TObjectList<TSCLicense>.Create(TRUE);
end;

constructor TSCLicenseList.Create(ASettingsList: TSCLicenseList);
begin
  FList := TObjectList<TSCLicense>.Create(TRUE);
  for var i := 0 to (ASettingsList.Count - 1) do
  begin
    FList.Add(TSCLicense.Create(ASettingsList[i]));
  end;
end;

destructor TSCLicenseList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TSCLicenseList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSCLicenseList.GetFieldCount: Integer;
begin
  Result := 12;
end;

function TSCLicenseList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'LicenseID';
  1: Result := 'LicenseType';
  2: Result := 'ExpirationDate';
  3: Result := 'Signature';
  4: Result := 'LicensedTo';
  5: Result := 'ComponentID';
  6: Result := 'MasterLicenseID';
  7: Result := 'LicenseSigningKeyID';
  8: Result := 'DateUpdated';
  9: Result := 'MajorVersion';
  10: Result := 'MinorVersion';
  11: Result := 'Quantity';
  end;
end;

function TSCLicenseList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].LicenseID;
  1: Result := Flist[ARecord].LicenseType;
  2: Result := Flist[ARecord].ExpirationDate;
  3: Result := Flist[ARecord].Signature;
  4: Result := Flist[ARecord].LicensedTo;
  5: Result := Flist[ARecord].ComponentID;
  6: Result := Flist[ARecord].MasterLicenseID;
  7: Result := Flist[ARecord].LicenseSigningKeyID;
  8: Result := Flist[ARecord].DateUpdated;
  9: Result := Flist[ARecord].MajorVersion;
  10: Result := Flist[ARecord].MajorVersion;
  11: Result := Flist[ARecord].Quantity;
  end;
end;

function TSCLicenseList.GetListItem(AIndex: Integer): TSCLicense;
begin
  Result := FList[AIndex];
end;

class function TSCLicenseList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select SCLicense.LicenseID, ');
  Result.Add('SCLicense.LicenseType, ');
  Result.Add('SCLicense.ExpirationDate, ');
  Result.Add('SCLicense.Signature, ');
  Result.Add('SCLicense.LicensedTo, ');
  Result.Add('SCLicense.ComponentID, ');
  Result.Add('SCLicense.MasterLicenseID, ');
  Result.Add('SCLicense.LicenseSigningKeyID, ');
  Result.Add('SCLicense.DateUpdated, ');
  Result.Add('SCLicense.MajorVersion, ');
  Result.Add('SCLicense.MinorVersion, ');
  Result.Add('SCLicense.Quantity ');
  Result.Add('From SCLicense ');
  Result.Add('Where MasterLicenseID=:MasterLicenseID ');
end;

class function TSCLicenseList.CreateSCLicense(ADataSet: TDataSet): TSCLicense;
begin
  Result := TSCLicense.Create;
  Result.LicenseID := ADataSet.Fields[0].AsInteger;
  Result.LicenseType := ADataSet.Fields[1].AsInteger;
  Result.ExpirationDate := ADataSet.Fields[2].AsDateTime;
  Result.Signature := ADataSet.Fields[3].AsString;
  Result.LicensedTo := ADataSet.Fields[4].AsString;
  Result.ComponentID := ADataSet.Fields[5].AsInteger;
  Result.MasterLicenseID := ADataSet.Fields[6].AsInteger;
  Result.LicenseSigningKeyID := ADataSet.Fields[7].AsInteger;
  Result.DateUpdated := ADataSet.Fields[8].AsDateTime;
  Result.MajorVersion := ADataSet.Fields[9].AsInteger;
  Result.MinorVersion := ADataSet.Fields[10].AsInteger;
  Result.Quantity := ADataSet.Fields[11].AsInteger;
end;

procedure TSCLicenseList.Clear;
begin
  FList.Clear;
end;

procedure TSCLicenseList.Add(AValue: TSCLicense);
begin
  FList.Add(AValue);
end;

function TSCLicenseList.ToJsonArray: TJsonArray;
begin
  Result := TJsonArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TSCLicenseList.FromJsonArray(AArray: TJsonArray);
begin
  FList.Clear;
  for var LVal in AArray do
  begin
    var LListItem := TSCLicense.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TSCLicenseList.GetAll(AMasterLicenseID: Integer): TSCLicenseList;
begin
  Result := nil;
  var LConnection: TFDConnection;
  var LSettings := TLRLicenseLoginSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('SCLicense', LSettings.UserName, LSettings.Password, LSettings.Database, LSettings.Host, LSettings.WindowsAuthentication);
  finally
    LSettings.Free;
  end;

  try
    var LQuery := TDataServices.GetQuery(LConnection);
    try
      var LSQL := GetInitialSQL;
      try
        for var i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      LQuery.Params.Clear;
      LQuery.Params.Add('MasterLicenseID', ftInteger, -1, ptInput);

      LConnection.Open;

      LQuery.Params.ParamByName('MasterLicenseID').AsInteger := AMasterLicenseID;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TSCLicenseList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          var LRecord := CreateSCLicense(LQuery);
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
{$ENDREGION}

end.
