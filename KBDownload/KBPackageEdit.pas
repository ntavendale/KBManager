unit KBPackageEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit, RzLabel, KB.KBPackage,
  RzButton;

type
  TfmKBPackageEdit = class(TForm)
    RzLabel1: TRzLabel;
    ebCoreVersion: TRzEdit;
    RzLabel2: TRzLabel;
    lbPackageUID: TRzLabel;
    ebPackageName: TRzEdit;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    lbCreated: TRzLabel;
    lbModified: TRzLabel;
    lbModifiedBy: TRzLabel;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FKBPackage: TKBPackage;
    procedure ObjectToForm;
    procedure FormToObject;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AKBPackage: TKBPackage = nil); reintroduce;
    destructor Destroy; override;
    property KBPackage: TKBPackage read FKBPackage;
  end;

implementation

{$R *.dfm}

constructor TfmKBPackageEdit.Create(AOwner: TComponent; AKBPackage: TKBPackage = nil);
begin
  inherited Create(AOwner);
  if nil = AKBPackage then
    FKBPackage := TKBPackage.Create
  else
    FKBPackage := TKBPackage.Create(AKBPackage);
  ObjectToForm;
end;

destructor TfmKBPackageEdit.Destroy;
begin
  FKBPackage.Free;
  inherited Destroy;
end;

procedure TfmKBPackageEdit.ObjectToForm;
begin
  lbPackageUID.Caption := FKBPackage.KBPackageUID;
  ebCoreVersion.Text := FKBPackage.CoreVersion;
  ebPackageName.Text := FKBPackage.Name;
  if FKBPackage.Created < 1.00 then
    lbCreated.Caption := ''
  else
    lbCreated.Caption := DateTimeToStr(FKBPackage.Created);

  if FKBPackage.Modified < 1.00 then
    lbModified.Caption := ''
  else
    lbModified.Caption := DateTimeToStr(FKBPackage.Modified);
  lbModifiedBy.Caption := FKBPackage.Modifier;
end;

procedure TfmKBPackageEdit.FormToObject;
begin
  FKBPackage.CoreVersion := ebCoreVersion.Text;
  FKBPackage.Name := ebPackageName.Text;
end;

procedure TfmKBPackageEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmKBPackageEdit.btnOKClick(Sender: TObject);
begin
  FormToObject;
  ModalResult := mrOK;
end;

end.
