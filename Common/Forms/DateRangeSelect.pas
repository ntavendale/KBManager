unit DateRangeSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit, RzLabel,
  CommonFunctions, RzButton, System.DateUtils;

type
  TfmSelectDateRange = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    dteDateFrom: TRzDateTimeEdit;
    dteDateTo: TRzDateTimeEdit;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FDateFrom: TDateTime;
    FDateTo: TDateTime;
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property DateFrom: TDateTime read FDateFrom;
    property DateTo: TDateTime read FDateTo;
  end;

implementation

{$R *.dfm}

constructor TfmSelectDateRange.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDateFrom := Date;
  FDateTo := Date;
  LoadSettings;
end;

procedure TfmSelectDateRange.LoadSettings;
var
  LYear, LMonth, LDay: Word;
  LDate: TDateTime;
begin
  LYear := StrToIntDef(GetFormKey('DateRangeSelect', 'YearFrom'), 0);
  LMonth := StrToIntDef(GetFormKey('DateRangeSelect', 'MonthFrom'), 0);
  LDay := StrToIntDef(GetFormKey('DateRangeSelect', 'DayFrom'), 0);
  if TryEncodeDate(LYear, LMonth, LDay, LDate) then
  begin
    dteDateFrom.Date := LDate;
  end else
  begin
    dteDateFrom.Date := Date;
  end;
  LYear := StrToIntDef(GetFormKey('DateRangeSelect', 'YearTo'), 0);
  LMonth := StrToIntDef(GetFormKey('DateRangeSelect', 'MonthTo'), 0);
  LDay := StrToIntDef(GetFormKey('DateRangeSelect', 'DayTo'), 0);
  if TryEncodeDate(LYear, LMonth, LDay, LDate) then
  begin
    dteDateTo.Date := LDate;
  end else
  begin
    dteDateTo.Date := Date;
  end;
end;

procedure TfmSelectDateRange.SaveSettings;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(dteDateFrom.Date, LYear, LMonth, LDay);
  SetFormKey('DateRangeSelect', 'YearFrom', IntToStr(LYear));
  SetFormKey('DateRangeSelect', 'MonthFrom', IntToStr(LMonth));
  SetFormKey('DateRangeSelect', 'DayFrom', IntToStr(LDay));

  DecodeDate(dteDateTo.Date, LYear, LMonth, LDay);
  SetFormKey('DateRangeSelect', 'YearTo', IntToStr(LYear));
  SetFormKey('DateRangeSelect', 'MonthTo', IntToStr(LMonth));
  SetFormKey('DateRangeSelect', 'DayTo', IntToStr(LDay));
end;

procedure TfmSelectDateRange.btnOKClick(Sender: TObject);
begin
  SaveSettings;
  FDateFrom := dteDateFrom.Date;
  FDateTo := dteDateTo.Date;
  ModalResult := mrOK;
end;

procedure TfmSelectDateRange.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
