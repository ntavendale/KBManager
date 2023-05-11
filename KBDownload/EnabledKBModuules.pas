unit EnabledKBModuules;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.Win.ComObj,
  WinApi.MSXML,  Xml.Win.msxmldom, Xml.XMLDoc, DataRecordList;

type
  TKBModule = class
    protected
      FKBModuleID: Integer;
      FLatestVersion: String;
      FName: String;
    public
      constructor Create; overload; virtual;
      constructor Create(AKBModule: TKBModule); overload; virtual;
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
    public
      constructor Create; overload; virtual;
      constructor Create(AKBModuleList: TKBModuleList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(AKBModule: TKBModule);
      class function GetAll(AXml: String): TKBModuleList;
      property Count: Integer read GetCount;
      property KBModule[AIndex: Integer]: TKBModule read GetKBModule; default;
  end;


implementation

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
  0: Result := 'KBModule ID';
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

procedure TKBModuleList.Clear;
begin
  FList.Clear;
end;

procedure TKBModuleList.Add(AKBModule: TKBModule);
begin
  FList.Add(AKBModule);
end;

class function TKBModuleList.GetAll(AXml: String): TKBModuleList;
var
  LXml: IXMLDOMDocument;
  node: IXMLDomNode;
  i: Integer;
begin
  LXml := NewXmlDocument;
  LXml.loadXML(Axml);
  for i := 0 to (LXml.documentElement.childNodes.length - 1) do
  begin

  end;
end;

end.
