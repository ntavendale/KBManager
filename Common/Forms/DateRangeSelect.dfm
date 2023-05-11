object fmSelectDateRange: TfmSelectDateRange
  Left = 532
  Top = 372
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Select Date Range'
  ClientHeight = 108
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 18
  object RzLabel1: TRzLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 18
    Caption = 'Date From'
  end
  object RzLabel2: TRzLabel
    Left = 232
    Top = 8
    Width = 46
    Height = 18
    Caption = 'Date To'
  end
  object dteDateFrom: TRzDateTimeEdit
    Left = 8
    Top = 32
    Width = 185
    Height = 26
    EditType = etDate
    FrameStyle = fsBump
    FrameVisible = True
    TabOrder = 0
  end
  object dteDateTo: TRzDateTimeEdit
    Left = 232
    Top = 32
    Width = 185
    Height = 26
    EditType = etDate
    FrameStyle = fsBump
    FrameVisible = True
    TabOrder = 1
  end
  object btnOK: TRzBitBtn
    Left = 261
    Top = 75
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TRzBitBtn
    Left = 342
    Top = 75
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
