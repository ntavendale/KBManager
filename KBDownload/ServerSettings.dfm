object fmServerSettings: TfmServerSettings
  Left = 401
  Top = 240
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Server Settings'
  ClientHeight = 365
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 18
  object RzLabel7: TRzLabel
    Left = 8
    Top = 199
    Width = 63
    Height = 18
    Caption = 'Certificate'
  end
  object RzLabel8: TRzLabel
    Left = 360
    Top = 226
    Width = 170
    Height = 18
    Caption = 'Max Concurrent Downloads'
  end
  object RzLabel9: TRzLabel
    Left = 16
    Top = 256
    Width = 53
    Height = 18
    Caption = 'Created:'
  end
  object RzLabel10: TRzLabel
    Left = 16
    Top = 280
    Width = 84
    Height = 18
    Caption = 'Last Updated:'
  end
  object RzLabel11: TRzLabel
    Left = 16
    Top = 304
    Width = 102
    Height = 18
    Caption = 'Last Updated By:'
  end
  object lbCreated: TRzLabel
    Left = 152
    Top = 255
    Width = 61
    Height = 18
    Caption = 'lbCreated'
  end
  object lbModified: TRzLabel
    Left = 152
    Top = 280
    Width = 68
    Height = 18
    Caption = 'lbModified'
  end
  object lbModifiedBy: TRzLabel
    Left = 152
    Top = 304
    Width = 83
    Height = 18
    Caption = 'lbModifiedBy'
  end
  object rgFTP: TRzGroupBox
    Left = 0
    Top = 0
    Width = 616
    Height = 193
    Align = alTop
    Caption = 'FTP'
    TabOrder = 0
    object pcFTP: TRzPageControl
      Left = 1
      Top = 19
      Width = 614
      Height = 173
      Hint = ''
      ActivePage = tsStaging
      Align = alClient
      TabIndex = 2
      TabOrder = 0
      FixedDimension = 24
      object tsUpload: TRzTabSheet
        Caption = 'Upload'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object RzLabel1: TRzLabel
          Left = 8
          Top = 8
          Width = 28
          Height = 18
          Caption = 'Path'
        end
        object RzLabel2: TRzLabel
          Left = 8
          Top = 64
          Width = 23
          Height = 18
          Caption = 'URL'
        end
        object ebUploadPath: TRzEdit
          Left = 8
          Top = 32
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 0
          OnChange = ebUploadPathChange
        end
        object ebUploadURL: TRzEdit
          Left = 8
          Top = 88
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 1
          OnChange = ebUploadPathChange
        end
      end
      object tsDownload: TRzTabSheet
        Caption = 'Download'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 764
        ExplicitHeight = 0
        object RzLabel3: TRzLabel
          Left = 8
          Top = 7
          Width = 28
          Height = 18
          Caption = 'Path'
        end
        object RzLabel4: TRzLabel
          Left = 8
          Top = 63
          Width = 23
          Height = 18
          Caption = 'URL'
        end
        object ebDownloadPath: TRzEdit
          Left = 8
          Top = 31
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 0
          OnChange = ebUploadPathChange
        end
        object ebDownloadURL: TRzEdit
          Left = 8
          Top = 87
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 1
          OnChange = ebUploadPathChange
        end
      end
      object tsStaging: TRzTabSheet
        Caption = 'Staging'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object RzLabel5: TRzLabel
          Left = 8
          Top = 7
          Width = 28
          Height = 18
          Caption = 'Path'
        end
        object RzLabel6: TRzLabel
          Left = 8
          Top = 63
          Width = 23
          Height = 18
          Caption = 'URL'
        end
        object ebStagingPath: TRzEdit
          Left = 8
          Top = 31
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 0
          OnChange = ebUploadPathChange
        end
        object ebStagingURL: TRzEdit
          Left = 8
          Top = 87
          Width = 593
          Height = 26
          Text = ''
          FrameStyle = fsBump
          FrameVisible = True
          TabOrder = 1
          OnChange = ebUploadPathChange
        end
      end
    end
  end
  object ebCertificate: TRzEdit
    Left = 8
    Top = 223
    Width = 337
    Height = 26
    Text = ''
    FrameStyle = fsBump
    FrameVisible = True
    TabOrder = 1
    OnChange = ebUploadPathChange
  end
  object spMaxDownloads: TRzSpinEdit
    Left = 536
    Top = 223
    Width = 47
    Height = 26
    Max = 30000.000000000000000000
    FrameStyle = fsBump
    FrameVisible = True
    TabOrder = 2
    OnChange = ebUploadPathChange
  end
  object btnSave: TRzBitBtn
    Left = 452
    Top = 332
    Caption = 'Save'
    Enabled = False
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnClose: TRzBitBtn
    Left = 533
    Top = 332
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
end
