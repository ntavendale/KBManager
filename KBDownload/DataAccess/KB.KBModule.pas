unit KB.KBModule;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  System.Win.ComObj, WinApi.MSXML,  Xml.Win.msxmldom, Xml.XmlIntf, Xml.XMLDoc,
  BusinessObject, DataRecordList;

type
  TKBModule = class(TBusinessObject)
    protected
      FKBModuleID: Integer;
      FLatestVersion: String;
      FName: String;
    public
      constructor Create; overload; virtual;
      constructor Create(AKBModule: TKBModule); overload; virtual;
      function ToJsonObject: TJsonObject; override;
      procedure FromJsonObject(AObject: TJsonObject); override;
      class function CreateFromJsonObject(AObject: TJsonObject): TKBModule;
      property KBModuleID: Integer read FKBModuleID write FKBModuleID;
      property LatestVersion: String read FLatestVersion write FLatestVersion;
      property Name: String read FName write FName;
  end;

  TKBModuleList = class(TDataRecordList)
    protected
      FList: TObjectList<TKBModule>;
      function GetCount: Integer; override;
      function GetKBModule(AIndex: Integer): TKBModule;
      function GetFieldCount: Integer; override;
      function GetFieldCaption(AIndex: Integer): String; override;
      function GetFieldData(ARecord, AIndex: Integer): Variant;  override;
      class function GetKBModuleFromXmlNode(AXmlNode: IXmlNode): TKBModule;
    public
      constructor Create; overload; virtual;
      constructor Create(AKBModuleList: TKBModuleList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(AKBModule: TKBModule);
      function ToJsonArray: TJsonArray; override;
      procedure FromJsonArray(AArray: TJsonArray); override;
      class function GetAll(AXml: String): TKBModuleList;
      property KBModule[AIndex: Integer]: TKBModule read GetKBModule; default;
  end;


implementation

{$REGION 'TKBModule'}
constructor TKBModule.Create;
begin
  FKBModuleID := 0;
  FLatestVersion := '';
  FName := '';
end;

constructor TKBModule.Create(AKBModule: TKBModule);
begin
  FKBModuleID := AKBModule.KBModuleID;
  FLatestVersion := AKBModule.LatestVersion;
  FName := AKBModule.Name;
end;

function TKBModule.ToJsonObject: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('kbModuleId', TJsonNumber.Create(FKBModuleID));
  Result.AddPair('latestVersion', FLatestVersion);
  Result.AddPair('name', FName);
end;

procedure TKBModule.FromJsonObject(AObject: TJsonObject);
begin
  if nil <> AObject.Values['name'] then
    FName := AObject.Values['name'].Value;
  if nil <> AObject.Values['latestVersion'] then
    FLatestVersion := AObject.Values['latestVersion'].Value;
  if nil <> AObject.Values['kbModuleId'] then
    FKBModuleID := AObject.Values['kbModuleId'].Value.ToInteger;
end;

class function TKBModule.CreateFromJsonObject(AObject: TJsonObject): TKBModule;
begin
  Result := TKBModule.Create;
  Result.FromJsonObject(AObject);
end;
{$ENDREGION}

{$REGION 'TKBModuleList'}
constructor TKBModuleList.Create;
begin
  inherited Create;
  FList := TObjectList<TKBModule>.Create(TRUE);
end;

constructor TKBModuleList.Create(AKBModuleList: TKBModuleList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TKBModule>.Create(TRUE);
  for i := 0 to (AKBModuleList.Count - 1) do
    FList.Add(TKBModule.Create(AKBModuleList[i]));
end;

destructor TKBModuleList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TKBModuleList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TKBModuleList.GetKBModule(AIndex: Integer): TKBModule;
begin
  Result := FList[AIndex];
end;

function TKBModuleList.GetFieldCount: Integer;
begin
  Result := 3;
end;

function TKBModuleList.GetFieldCaption(AIndex: Integer): String;
begin
  case AIndex of
  0: Result := 'KBModuleID';
  1: Result := 'Version';
  2: Result := 'Name';
  end;
end;

function TKBModuleList.GetFieldData(ARecord, AIndex: Integer): Variant;
begin
  case AIndex of
  0: Result := Flist[ARecord].KBModuleID;
  1: Result := Flist[ARecord].LatestVersion;
  2: Result := Flist[ARecord].Name;
  end;
end;

class function TKBModuleList.GetKBModuleFromXmlNode(AXmlNode: IXmlNode): TKBModule;
begin
  Result := TKBModule.Create;
  if AXmlNode.HasAttribute('KBModuleID') then
  begin
    try
      Result.KBModuleID := AXmlNode.Attributes['KBModuleID'];
    except
      Result.KBModuleID := 0;
    end;
  end;
  if AXmlNode.HasAttribute('LatestVersion') then
  begin
    try
      Result.LatestVersion := AXmlNode.Attributes['LatestVersion'];
    except
      Result.LatestVersion := '';
    end;
  end;

  if AXmlNode.HasAttribute('Name') then
  begin
    try
      Result.Name := AXmlNode.Attributes['Name'];
    except
      Result.Name := '';
    end;
  end;
end;

procedure TKBModuleList.Clear;
begin
  FList.Clear;
end;

procedure TKBModuleList.Add(AKBModule: TKBModule);
begin
  FList.Add(AKBModule);
end;

function TKBModuleList.ToJsonArray: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  for i := 0 to (FList.Count - 1) do
    Result.AddElement(FList[i].ToJsonObject);
end;

procedure TKBModuleList.FromJsonArray(AArray: TJsonArray);
var
  LVal : TJsonValue;
  LListItem: TKBModule;
begin
  FList.Clear;
  for LVal in AArray do
  begin
    LListItem := TKBModule.Create;
    LListItem.FromJsonObject(LVal As TJsonObject);
    FList.Add(LListItem);
  end;
end;

class function TKBModuleList.GetAll(AXml: String): TKBModuleList;
var
  LXml: IXMLDocument;
  LNode: IXMLNode;
  i: Integer;
  LRec: TKBModule;
begin
  Result := TKBModuleList.Create;
  if '' = Trim(AXml) then
    EXIT;
  LXml :=  NewXMLDocument;
  LXml.Encoding := 'utf-8';
  LXml.LoadFromXML(AXml);
  for i := 0 to (LXml.DocumentElement.ChildNodes.Count - 1) do
  begin
    LNode := LXml.DocumentElement.ChildNodes[i];
    LRec := GetKBModuleFromXmlNode(LNode);
    Result.Add(LRec);
  end;
end;
{$ENDREGION}

end.
