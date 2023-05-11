unit IAmABigBoy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.StdCtrls, RzEdit;

type
  TfmBigBoy = class(TForm)
    Label1: TLabel;
    btnYes: TRzBitBtn;
    btnNo: TRzBitBtn;
    RzMemo1: TRzMemo;
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
  private
    { Private declarations }
    FUserOK: Boolean;
  public
    { Public declarations }
    property UserOK: Boolean read FUserOK;
  end;

implementation

{$R *.dfm}

procedure TfmBigBoy.btnNoClick(Sender: TObject);
begin
  FUserOK := FALSE;
  Close;
end;

procedure TfmBigBoy.btnYesClick(Sender: TObject);
begin
  FUserOK := TRUE;
  Close;
end;

end.
