object fmKBPackageEdit: TfmKBPackageEdit
  Left = 849
  Top = 441
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'KB Package '
  ClientHeight = 228
  ClientWidth = 519
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
    Left = 16
    Top = 48
    Width = 79
    Height = 18
    Caption = 'Core Version'
  end
  object RzLabel2: TRzLabel
    Left = 16
    Top = 8
    Width = 79
    Height = 18
    Caption = 'Package UID:'
  end
  object lbPackageUID: TRzLabel
    Left = 104
    Top = 8
    Width = 84
    Height = 18
    Caption = 'lbPackageUID'
  end
  object RzLabel3: TRzLabel
    Left = 224
    Top = 48
    Width = 90
    Height = 18
    Caption = 'Package Name'
  end
  object RzLabel4: TRzLabel
    Left = 16
    Top = 112
    Width = 53
    Height = 18
    Caption = 'Created:'
  end
  object RzLabel5: TRzLabel
    Left = 16
    Top = 136
    Width = 60
    Height = 18
    Caption = 'Modified:'
  end
  object RzLabel6: TRzLabel
    Left = 16
    Top = 160
    Width = 102
    Height = 18
    Caption = 'Last Updated By:'
  end
  object lbCreated: TRzLabel
    Left = 176
    Top = 112
    Width = 61
    Height = 18
    Caption = 'lbCreated'
  end
  object lbModified: TRzLabel
    Left = 176
    Top = 136
    Width = 68
    Height = 18
    Caption = 'lbModified'
  end
  object lbModifiedBy: TRzLabel
    Left = 176
    Top = 160
    Width = 83
    Height = 18
    Caption = 'lbModifiedBy'
  end
  object ebCoreVersion: TRzEdit
    Left = 16
    Top = 72
    Width = 153
    Height = 26
    Text = ''
    TabOrder = 0
  end
  object ebPackageName: TRzEdit
    Left = 224
    Top = 72
    Width = 281
    Height = 26
    Text = ''
    TabOrder = 1
  end
  object btnOK: TRzBitBtn
    Left = 344
    Top = 195
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TRzBitBtn
    Left = 425
    Top = 195
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
