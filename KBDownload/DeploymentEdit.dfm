object fmDeploymentEdit: TfmDeploymentEdit
  Left = 491
  Top = 348
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Deployment Edit'
  ClientHeight = 228
  ClientWidth = 635
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
    Top = 16
    Width = 108
    Height = 18
    Caption = 'Master Licence ID'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Calibri'
    Font.Style = []
    ParentFont = False
  end
  object RzLabel2: TRzLabel
    Left = 192
    Top = 16
    Width = 100
    Height = 18
    Caption = 'Customer Name'
  end
  object RzLabel3: TRzLabel
    Left = 16
    Top = 136
    Width = 53
    Height = 18
    Caption = 'Created:'
  end
  object RzLabel4: TRzLabel
    Left = 16
    Top = 152
    Width = 87
    Height = 18
    Caption = 'Last Modified:'
  end
  object RzLabel5: TRzLabel
    Left = 16
    Top = 168
    Width = 105
    Height = 18
    Caption = 'Last Modified By:'
  end
  object lbCreated: TRzLabel
    Left = 160
    Top = 136
    Width = 61
    Height = 18
    Caption = 'lbCreated'
  end
  object lbModified: TRzLabel
    Left = 160
    Top = 152
    Width = 68
    Height = 18
    Caption = 'lbModified'
  end
  object lbLastModifiedBy: TRzLabel
    Left = 160
    Top = 168
    Width = 107
    Height = 18
    Caption = 'lbLastModifiedBy'
  end
  object neMasterLicenceID: TRzNumericEdit
    Left = 16
    Top = 40
    Width = 153
    Height = 26
    FrameStyle = fsBump
    FrameVisible = True
    TabOrder = 0
    DisplayFormat = '0;(0)'
  end
  object ebCustomerName: TRzEdit
    Left = 192
    Top = 40
    Width = 425
    Height = 26
    Text = ''
    FrameStyle = fsBump
    FrameVisible = True
    MaxLength = 255
    TabOrder = 1
  end
  object ckbRequireSnapshot: TRzCheckBox
    Left = 192
    Top = 80
    Width = 128
    Height = 20
    Caption = 'Require Snapshot'
    HotTrack = True
    State = cbUnchecked
    TabOrder = 2
  end
  object ckbDoNotSign: TRzCheckBox
    Left = 360
    Top = 80
    Width = 110
    Height = 20
    Caption = 'Do Not Sign KB'
    HotTrack = True
    State = cbUnchecked
    TabOrder = 3
  end
  object ckbEnforceFingerprint: TRzCheckBox
    Left = 16
    Top = 106
    Width = 342
    Height = 20
    Caption = 'Enforce Fingerprint (Change Requires CTO Approval)'
    HotTrack = True
    ReadOnly = True
    State = cbUnchecked
    TabOrder = 4
  end
  object btnOK: TRzBitBtn
    Left = 471
    Top = 195
    Caption = 'OK'
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancel: TRzBitBtn
    Left = 552
    Top = 195
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object ckbAuthorized: TRzCheckBox
    Left = 16
    Top = 80
    Width = 121
    Height = 20
    Caption = 'Allow Download'
    HotTrack = True
    State = cbUnchecked
    TabOrder = 7
  end
end
