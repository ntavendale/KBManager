object fmReleases: TfmReleases
  Left = 768
  Top = 353
  Caption = 'Releases'
  ClientHeight = 618
  ClientWidth = 973
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 18
  object gbSearch: TRzGroupBox
    Left = 0
    Top = 0
    Width = 973
    Height = 57
    Align = alTop
    Caption = 'Search....'
    TabOrder = 0
    object ebSearch: TRzEdit
      Left = 1
      Top = 19
      Width = 971
      Height = 26
      Text = ''
      Align = alTop
      FrameStyle = fsBump
      FrameVisible = True
      TabOrder = 0
      OnChange = ebSearchChange
      OnKeyDown = ebSearchKeyDown
    end
  end
  object gReleases: TcxGrid
    Left = 0
    Top = 57
    Width = 973
    Height = 561
    Align = alClient
    PopupMenu = ppmReleases
    TabOrder = 1
    object tvReleases: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.HideFocusRectOnExit = False
      OptionsSelection.UnselectFocusedRecordOnExit = False
      OptionsView.GroupByBox = False
      object colID: TcxGridColumn
        Visible = False
      end
      object colVersion: TcxGridColumn
        Caption = 'Version'
        Width = 123
      end
      object colCreated: TcxGridColumn
        Caption = 'Created'
        Width = 178
      end
      object colModified: TcxGridColumn
        Caption = 'Modified'
        Width = 199
      end
      object colModifier: TcxGridColumn
        Caption = 'Last Updated By'
        Width = 220
      end
      object colCoreVersion: TcxGridColumn
        Caption = 'Core Version'
        Width = 159
      end
    end
    object lvReleases: TcxGridLevel
      GridView = tvReleases
    end
  end
  object ppmReleases: TPopupMenu
    OnPopup = ppmReleasesPopup
    Left = 184
    Top = 176
    object ppmiNew: TMenuItem
      Caption = 'New'
      OnClick = ppmiNewClick
    end
    object ppmiEdit: TMenuItem
      Caption = 'Edit'
      OnClick = ppmiEditClick
    end
    object ppmiUpdateKBPackage: TMenuItem
      Caption = 'Update KB Package'
      OnClick = ppmiUpdateKBPackageClick
    end
  end
end
