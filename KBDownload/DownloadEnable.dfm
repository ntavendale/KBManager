object fmDownloadEnable: TfmDownloadEnable
  Left = 0
  Top = 0
  Caption = 'Enable Download'
  ClientHeight = 289
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 18
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 258
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 0
    ExplicitHeight = 300
    object pnUserMessage: TRzPanel
      Left = 0
      Top = 0
      Width = 670
      Height = 49
      Align = alTop
      BorderOuter = fsNone
      TabOrder = 0
      object lbEnable: TRzLabel
        Left = 8
        Top = 8
        Width = 54
        Height = 18
        Caption = 'lbEnable'
      end
    end
    object gbLicenseDetail: TRzGroupBox
      Left = 0
      Top = 49
      Width = 670
      Height = 209
      Align = alClient
      Caption = 'License Detail'
      TabOrder = 1
      ExplicitTop = 89
      ExplicitHeight = 211
      object vgLicense: TcxVerticalGrid
        Left = 1
        Top = 19
        Width = 668
        Height = 189
        Align = alClient
        OptionsView.RowHeaderWidth = 194
        Styles.OnGetContentStyle = vgLicenseStylesGetContentStyle
        TabOrder = 0
        ExplicitHeight = 191
        Version = 1
      end
    end
  end
  object pnButtons: TRzPanel
    Left = 0
    Top = 258
    Width = 670
    Height = 31
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 1
    ExplicitTop = 300
    object RzPanel3: TRzPanel
      Left = 504
      Top = 0
      Width = 166
      Height = 31
      Align = alRight
      BorderOuter = fsNone
      TabOrder = 0
      object btnOK: TRzButton
        Left = 6
        Top = 2
        Caption = '&OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TRzButton
        Left = 87
        Top = 2
        Caption = '&Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
  object srGrid: TcxStyleRepository
    Left = 120
    Top = 153
    PixelsPerInch = 96
    object styeExpired: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clDefault
      Font.Height = -15
      Font.Name = 'Calibri'
      Font.Style = []
      TextColor = clRed
    end
  end
end
