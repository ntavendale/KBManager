object fmDBSettings: TfmDBSettings
  Left = 519
  Top = 328
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DB Settings'
  ClientHeight = 414
  ClientWidth = 460
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
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 379
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 24
    ExplicitWidth = 504
    ExplicitHeight = 321
    object gbLicenseDBSettings: TRzGroupBox
      Left = 0
      Top = 193
      Width = 460
      Height = 185
      Align = alTop
      Caption = 'LRLicense Database Settings'
      TabOrder = 1
      ExplicitTop = 0
      ExplicitWidth = 520
      object RzLabel1: TRzLabel
        Left = 7
        Top = 91
        Width = 68
        Height = 18
        Caption = 'User Name'
      end
      object RzLabel3: TRzLabel
        Left = 230
        Top = 29
        Width = 57
        Height = 18
        Caption = 'DB Name'
      end
      object RzLabel4: TRzLabel
        Left = 7
        Top = 29
        Width = 28
        Height = 18
        Caption = 'Host'
      end
      object RzLabel2: TRzLabel
        Left = 230
        Top = 93
        Width = 59
        Height = 18
        Caption = 'Password'
      end
      object ebLicenseUserName: TRzEdit
        Left = 7
        Top = 115
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 2
      end
      object ebLicensePassword: TRzEdit
        Left = 230
        Top = 117
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        PasswordChar = '*'
        TabOrder = 3
      end
      object ebLicenseDBName: TRzEdit
        Left = 230
        Top = 53
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 1
      end
      object ebLicenseHost: TRzEdit
        Left = 7
        Top = 53
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 0
      end
      object ckbLicenseWindowsAuth: TRzCheckBox
        Left = 7
        Top = 155
        Width = 200
        Height = 20
        Caption = 'Use Windows  Authentication'
        HotTrack = True
        State = cbUnchecked
        TabOrder = 4
        OnClick = ckbLicenseWindowsAuthClick
      end
    end
    object gbKBDBSettings: TRzGroupBox
      Left = 0
      Top = 0
      Width = 460
      Height = 193
      Align = alTop
      Caption = 'KB Database Settings'
      TabOrder = 0
      object RzLabel5: TRzLabel
        Left = 7
        Top = 91
        Width = 68
        Height = 18
        Caption = 'User Name'
      end
      object RzLabel6: TRzLabel
        Left = 230
        Top = 29
        Width = 57
        Height = 18
        Caption = 'DB Name'
      end
      object RzLabel7: TRzLabel
        Left = 7
        Top = 29
        Width = 28
        Height = 18
        Caption = 'Host'
      end
      object RzLabel8: TRzLabel
        Left = 230
        Top = 93
        Width = 59
        Height = 18
        Caption = 'Password'
      end
      object ebKBUserName: TRzEdit
        Left = 7
        Top = 115
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 2
      end
      object ebKBPassword: TRzEdit
        Left = 230
        Top = 117
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        PasswordChar = '*'
        TabOrder = 3
      end
      object ebKBDBName: TRzEdit
        Left = 230
        Top = 53
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 1
      end
      object ebKBHost: TRzEdit
        Left = 7
        Top = 53
        Width = 209
        Height = 26
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 0
      end
      object ckbKBWindowsAuth: TRzCheckBox
        Left = 7
        Top = 159
        Width = 200
        Height = 20
        Caption = 'Use Windows  Authentication'
        HotTrack = True
        State = cbUnchecked
        TabOrder = 4
        OnClick = ckbKBWindowsAuthClick
      end
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 379
    Width = 460
    Height = 35
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 1
    ExplicitTop = 396
    object btnOK: TRzBitBtn
      Left = 288
      Top = 6
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TRzBitBtn
      Left = 369
      Top = 6
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
