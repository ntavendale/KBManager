object fmMain: TfmMain
  Left = 618
  Top = 360
  Caption = 'Licence File Viewer'
  ClientHeight = 672
  ClientWidth = 1179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  Menu = menMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object RzGroupBox1: TRzGroupBox
    Left = 0
    Top = 0
    Width = 1179
    Height = 177
    Align = alTop
    Caption = 'Licence Signing Key'
    TabOrder = 0
    object vgSigningKey: TcxVerticalGrid
      Left = 1
      Top = 19
      Width = 1177
      Height = 157
      Align = alClient
      OptionsView.RowHeaderWidth = 173
      TabOrder = 0
      Version = 1
    end
  end
  object gbComponents: TRzGroupBox
    Left = 0
    Top = 177
    Width = 1179
    Height = 495
    Align = alClient
    Caption = 'Licenced Components'
    TabOrder = 1
    object gLicence: TcxGrid
      Left = 1
      Top = 19
      Width = 1177
      Height = 475
      Align = alClient
      TabOrder = 0
      object tvLicence: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        OnCustomDrawPartBackground = tvLicenceCustomDrawPartBackground
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = '0'
            Kind = skCount
            Position = spFooter
            Column = colLicenseID
          end
          item
            Kind = skCount
            Position = spFooter
            Column = colQuantity
          end
          item
            Kind = skCount
            Column = colQuantity
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Kind = skCount
            Column = colQuantity
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.Footer = True
        object colLicenseID: TcxGridColumn
          Caption = 'LicenseID'
          Width = 96
        end
        object colLicenseType: TcxGridColumn
          Caption = 'License Type'
          Width = 253
        end
        object colSignature: TcxGridColumn
          Caption = 'Signature'
          Width = 95
        end
        object colLicencedTo: TcxGridColumn
          Caption = 'Licenced To'
          Width = 189
        end
        object colMasterLicenseID: TcxGridColumn
          Caption = 'Master'
          Width = 61
        end
        object colDateUpdated: TcxGridColumn
          Caption = 'Updated'
          Width = 155
        end
        object colExpires: TcxGridColumn
          Caption = 'Expires'
          Width = 161
        end
        object colVersion: TcxGridColumn
          Caption = 'Version'
          Width = 68
        end
        object colQuantity: TcxGridColumn
          Caption = 'Quantity'
          Width = 72
        end
      end
      object lvLicence: TcxGridLevel
        GridView = tvLicence
      end
    end
  end
  object odLicenceFile: TOpenDialog
    DefaultExt = '.lic'
    Filter = 'Licence File (*.lic)|*.lic|All Files (*.*)|*.*'
    Left = 264
    Top = 144
  end
  object menMain: TMainMenu
    Left = 312
    Top = 72
    object menFile: TMenuItem
      Caption = 'File'
      object miOpen: TMenuItem
        Caption = 'Open Licence File'
        OnClick = miOpenClick
      end
      object miExit: TMenuItem
        Caption = 'Exit'
      end
    end
  end
end
