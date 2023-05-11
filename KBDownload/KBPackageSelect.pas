unit KBPackageSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.StdCtrls, RzCmboBx,
  RzLabel, System.UITypes, KB.KBPackage, CommonFunctions;

type
  TfmKBPackageSelect = class(TForm)
    RzLabel2: TRzLabel;
    cbPackageList: TRzComboBox;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    lbl715Warning: TRzLabel;
    lbl716Warning: TRzLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FKBPackageUID: String;
    FKBPackageVersion: String;
    FLIst: TKBPackageList;
    procedure PopulateKBCombo;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property KBPackageUID: String read FKBPackageUID;
    property KBPackageVersion: String read FKBPackageVersion;
  end;

implementation

{$R *.dfm}

constructor TfmKBPackageSelect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  lbl715Warning.Caption := WARNING_7_1_5;
  lbl716Warning.Caption := WARNING_7_1_6;

  FLIst := TKBPackageList.GetAll('Order By KBPackage.CoreVersion Desc ');
  PopulateKBCombo;
end;

destructor TfmKBPackageSelect.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TfmKBPackageSelect.PopulateKBCombo;
begin
  if nil = FList then
    EXIT;
  cbPackageList.Items.Clear;
  cbPackageList.Values.Clear;
  for var i := 0 to (FList.Count - 1) do
    cbPackageList.AddItemValue(FList[i].Name + '(' + FList[i].CoreVersion + ')', FList[i].KBPackageUID);
end;

procedure TfmKBPackageSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmKBPackageSelect.btnOKClick(Sender: TObject);
begin
  if -1 = cbPackageList.ItemIndex then
  begin
    MessageDlg('You must select a package.', mtError, [mbOK], 0);
    EXIT;
  end;
  FKBPackageUID := cbPackageList.Value;
  FKBPackageVersion := FList[cbPackageList.ItemIndex].CoreVersion;
  ModalResult := mrOK;
end;

end.
