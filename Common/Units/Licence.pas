unit Licence;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  WinApi.Ole2, Xml.XMLIntf, Xml.XMLDoc, Vcl.FileCtrl, System.IOUtils,
  System.DateUtils;

const
  MASTER = 1; //master license
  MARC = 2;//event/paltform manager license
  MEDIATOR_SOFTWARE = 3;//software mediator license
  SYSTEMMONITOR = 4;//agent license for pro version (introduced in 5.0)
  MESSAGESOURCE = 5;//limited message source license
  MEDIATOR_APPLIANCE = 6;//appliance mediator license
  UNLIMITEDMESSAGESOURCE_SOFTWARE = 7;//appliance unlimited message source license
  UNLIMITEDMESSAGESOURCE_APPLIANCE = 8;//software unlimited message source license
  SYSTEMMONITORBASIC = 9;//agent license for basic version (introduced in 5.0)
  GEOLOCATIONIPRESOLUTION = 10;//enables geolocational ip resolution for all log managers/Data Processor & Indexer
  ADVANCEDINTELLIGENCEENGINE = 11;//Advanced Intelligence (AI) Engine license (introduced in 5.1.x patch and 6.0)
  NETWORKMONITOR = 12;//Network monitor full functionality license (introduced in 6.3)
  LMMESSAGEPERSECOND = 13;//Data Processor & Indexer Messages per second license (introduced in 6.4)
  DEPLOYMENTMESSAGESPERSECOND = 14; //Deployment-wide messages per second license (introduced in 6.4)

type
  TSCLicenceSigningKey = class
  protected
    FLicenceSigningKeyID : Integer;
    FPublicKey: String;
    FP: String;
    FQ: String;
    FG: String;
  public
    constructor Create; overload;
    constructor Create(ASCLicenceSigningKey: TSCLicenceSigningKey); overload;
    property LicenceSigningKeyID: Integer read FLicenceSigningKeyID write FLicenceSigningKeyID;
    property PublicKey: String read FPublicKey write FPublicKey;
    property P: String read FP write FP;
    property Q: String read FQ write FQ;
    property G: String read FG write FG;
  end;

  TSCLicence = class
  protected
    FLicenceID: Integer;
    FLicenceSigningKeyID: Integer;
    FLicenceType: Integer;
    FExpirationDate: TDateTime;
    FSignature: String;
    FLicensedTo: String;
    FComponentID: Integer;
    FMasterLicenceID: Integer;
    FDateUpdated: TDateTime;
    FMajorVersion: Integer;
    FMinorVersion: Integer;
    FQuantity: Integer;
  public
    constructor Create; overload;
    constructor Create(ASCLicence: TSCLicence); overload;
    class function LicenceTypeString(ALicenceType: Integer): String;
    property LicenceID: Integer read FLicenceID write FLicenceID;
    property LicenceSigningKeyID: Integer read FLicenceSigningKeyID write FLicenceSigningKeyID;
    property LicenseType: Integer read FLicenceType write FLicenceType;
    property ExpirationDate: TDateTime read FExpirationDate write FExpirationDate;
    property Signature: String read FSignature write FSignature;
    property LicensedTo: String read FLicensedTo write FLicensedTo;
    property ComponentID: Integer read FComponentID write FComponentID;
    property MasterLicenceID: Integer read FMasterLicenceID write FMasterLicenceID;
    property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
    property MajorVersion: Integer read FMajorVersion write FMajorVersion;
    property MinorVersion: Integer read FMinorVersion write FMinorVersion;
    property Quantity: Integer read FQuantity write FQuantity;
  end;

  TSCLicences = class
  protected
    FSCLicenceSigningKey: TSCLicenceSigningKey;
    FList: TObjectList<TSCLicence>;
    function GetCount: Integer;
    function GetListitem(AIndex: Integer): TSCLicence;
    procedure SetListitem(AIndex: Integer; AValue: TSCLicence);
    procedure DecodeFromXmlDoc(AXMLDocument: IXMLDocument);
  public
    constructor Create; overload;
    constructor Create(ASCLicences: TSCLicences); overload;
    destructor Destroy; override;
    procedure Add(AValue: TSCLicence);
    procedure Delete(AIndex: Integer);
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(AFileName: String);
    property Count: Integer read GetCount;
    property SCLicenceSigningKey: TSCLicenceSigningKey read FSCLicenceSigningKey;
    property Licences[AIndex: Integer]: TSCLicence read GetListItem write SetListItem; default;
  end;

implementation

{$REGION 'TSCLicenceSigningKey'}
constructor TSCLicenceSigningKey.Create;
begin
  FLicenceSigningKeyID := -1;
  FPublicKey := String.Empty;
  FP := String.Empty;
  FQ := String.Empty;
  FG := String.Empty;
end;

constructor TSCLicenceSigningKey.Create(ASCLicenceSigningKey: TSCLicenceSigningKey);
begin
  FLicenceSigningKeyID := ASCLicenceSigningKey.LicenceSigningKeyID;
  FPublicKey := ASCLicenceSigningKey.PublicKey;
  FP := ASCLicenceSigningKey.P;
  FQ := ASCLicenceSigningKey.Q;
  FG := ASCLicenceSigningKey.G;
end;
{$ENDREGION}

{$REGION 'TSCLicence'}
constructor TSCLicence.Create;
begin
  FLicenceID := -1;
  FLicenceSigningKeyID := -1;
  FLicenceType := -1;
  FExpirationDate := 0.00;
  FSignature := String.Empty;
  FLicensedTo := String.Empty;
  FComponentID := -1;
  FMasterLicenceID := -1;
  FDateUpdated := 0.00;
  FMajorVersion := -1;
  FMinorVersion := -1;
  FQuantity := -1;
end;

constructor TSCLicence.Create(ASCLicence: TSCLicence);
begin
  FLicenceID := ASCLicence.LicenceID;
  FLicenceSigningKeyID := ASCLicence.LicenceSigningKeyID;
  FLicenceType := ASCLicence.LicenseType;
  FExpirationDate := ASCLicence.ExpirationDate;
  FSignature := ASCLicence.Signature;
  FLicensedTo := ASCLicence.LicensedTo;
  FComponentID := ASCLicence.ComponentID;
  FMasterLicenceID := ASCLicence.MasterLicenceID;
  FDateUpdated := ASCLicence.DateUpdated;
  FMajorVersion := ASCLicence.MajorVersion;
  FMinorVersion := ASCLicence.MinorVersion;
  FQuantity := ASCLicence.Quantity;
end;

class function TSCLicence.LicenceTypeString(ALicenceType: Integer): String;
begin
  Result := 'None';
  case ALicenceType of
    MASTER: Result := 'Master';
    MARC: Result := 'Event/Paltform Manager';
    MEDIATOR_SOFTWARE: Result := 'Software Mediator';
    SYSTEMMONITOR: Result := 'Agent Pro';
    MESSAGESOURCE: Result := 'Limited Message Source';
    MEDIATOR_APPLIANCE: Result := 'Appliance Mediator';
    UNLIMITEDMESSAGESOURCE_SOFTWARE: Result := 'Software Unlimited Message Source';
    UNLIMITEDMESSAGESOURCE_APPLIANCE: Result := 'Appliance Unlimited Message Source';
    SYSTEMMONITORBASIC: Result := 'Agent Basic';
    GEOLOCATIONIPRESOLUTION: Result := 'Geolocational IP Resolution';
    ADVANCEDINTELLIGENCEENGINE: Result := 'Advanced Intelligence (AI) Engine';
    NETWORKMONITOR: Result := 'Network Monitor';
    LMMESSAGEPERSECOND: Result := 'Data Processor & Indexer Messages Per Second';
    DEPLOYMENTMESSAGESPERSECOND: Result := 'Deployment-wide Messages Per Second';
  end;
end;
{$ENDREGION}

{$REGION 'TSCLicences'}
constructor TSCLicences.Create;
begin
  FSCLicenceSigningKey := TSCLicenceSigningKey.Create;
  FList := TObjectList<TSCLicence>.Create(TRUE);
end;

constructor TSCLicences.Create(ASCLicences: TSCLicences);
var
  i: Integer;
begin
  FSCLicenceSigningKey := TSCLicenceSigningKey.Create(ASCLicences.SCLicenceSigningKey);
  FList := TObjectList<TSCLicence>.Create(TRUE);
  for i := 0 to (ASCLicences.Count - 1) do
    FList.Add( TSCLicence.Create(ASCLicences[i]) );
end;

destructor TSCLicences.Destroy;
begin
  FList.Free;
  FSCLicenceSigningKey.Free;
  inherited Destroy;
end;

function TSCLicences.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSCLicences.GetListItem(AIndex: Integer): TSCLicence;
begin
  Result := FList[AIndex];
end;

procedure TSCLicences.SetListItem(AIndex: Integer; AValue: TSCLicence);
begin
  FList[AIndex] := AValue;
end;

procedure TSCLicences.DecodeFromXmlDoc(AXMLDocument: IXMLDocument);
var
  LNode, LSubNode: IXMLNode;
  LLicence: TSClicence;
  i, j: Integer;
begin
  FList.Clear;
  if (AXmlDocument.DocumentElement <> nil) then
  begin
    { Traverse child nodes. }
    for i := 0 to AXmlDocument.DocumentElement.ChildNodes.Count - 1 do
    begin
      LNode := AXmlDocument.DocumentElement.ChildNodes.Get(i);
      if 'sclicensesigningkey' = LNode.NodeName.ToLower then
      begin
        for j := 0 to (LNode.ChildNodes.Count - 1) do
        begin
          LSubNode := LNode.ChildNodes.Get(j);
          if 'licensesigningkeyid' = LSubNode.NodeName.ToLower then
            FSCLicenceSigningKey.LicenceSigningKeyID := StrToInt(LSubNode.NodeValue)
          else if 'publickey' = LSubNode.NodeName.ToLower then
            FSCLicenceSigningKey.PublicKey := LSubNode.NodeValue
          else if 'p' = LSubNode.NodeName.ToLower then
            FSCLicenceSigningKey.P := LSubNode.NodeValue
          else if 'q' = LSubNode.NodeName.ToLower then
            FSCLicenceSigningKey.Q := LSubNode.NodeValue
          else if 'g' = LSubNode.NodeName.ToLower then
            FSCLicenceSigningKey.G := LSubNode.NodeValue;
        end;
      end
      else if 'sclicense' = LNode.NodeName.ToLower then
      begin
        LLicence := TSClicence.Create;
        for j := 0 to (LNode.ChildNodes.Count - 1) do
        begin
          LSubNode := LNode.ChildNodes.Get(j);
          if 'licenseid' = LSubNode.NodeName.ToLower then
            LLicence.LicenceID := LSubNode.NodeValue
          else if 'licensesigningkeyid' = LSubNode.NodeName.ToLower then
            LLicence.LicenceSigningKeyID := StrToInt(LSubNode.NodeValue)
          else if 'licensetype' = LSubNode.NodeName.ToLower then
            LLicence.LicenseType := StrToInt(LSubNode.NodeValue)
          else if 'expirationdate' = LSubNode.NodeName.ToLower then
            LLicence.ExpirationDate := ISO8601ToDate(LSubNode.NodeValue)
          else if 'signature' = LSubNode.NodeName.ToLower then
            LLicence.Signature := LSubNode.NodeValue
          else if 'licensedto' = LSubNode.NodeName.ToLower then
            LLicence.LicensedTo := LSubNode.NodeValue
          else if 'componentid' = LSubNode.NodeName.ToLower then
            LLicence.ComponentID := StrToInt(LSubNode.NodeValue)
          else if 'masterlicenseid' = LSubNode.NodeName.ToLower then
            LLicence.MasterLicenceID := StrToInt(LSubNode.NodeValue)
          else if 'dateupdated' = LSubNode.NodeName.ToLower then
          begin
            try
              LLicence.DateUpdated := ISO8601ToDate(LSubNode.NodeValue)
            except
              LLicence.DateUpdated := Date;
            end;
          end else if 'majorversion' = LSubNode.NodeName.ToLower then
            LLicence.MajorVersion := StrToInt(LSubNode.NodeValue)
          else if 'minorversion' = LSubNode.NodeName.ToLower then
            LLicence.MinorVersion := StrToInt(LSubNode.NodeValue)
          else if 'quantity' = LSubNode.NodeName.ToLower then
            LLicence.Quantity := StrToInt(LSubNode.NodeValue);
        end;
        FList.Add(LLicence);
      end;
    end;
  end;
end;

procedure TSCLicences.Add(AValue: TSCLicence);
begin
  Flist.Add(AValue);
end;

procedure TSCLicences.Delete(AIndex: Integer);
begin
  Flist.Delete(AIndex);
end;

procedure TSCLicences.LoadFromStream(AStream: TStream);
var
  LDocument: IXMLDocument;
begin
  CoInitialize(nil);
  try
    LDocument := TXMLDocument.Create(nil);
    AStream.Seek(0,0);
    LDocument.LoadFromStream(AStream); { File should exist. }

    DecodeFromXmlDoc(LDocument);
  finally
    CoUninitialize;
  end;
end;

procedure TSCLicences.LoadFromFile(AFileName: String);
var
  LFile: TStream;
begin
  LFile := TFileStream.Create(AFileName, fmOpenRead, fmShareDenyNone );
  try
    LoadFromStream(LFile);
  finally
    LFile.Free;
  end;
end;
{$ENDREGION}


end.
