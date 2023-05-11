object fmKBPackages: TfmKBPackages
  Left = 541
  Top = 270
  Caption = 'KB Packages'
  ClientHeight = 618
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 18
  object gbSearch: TRzGroupBox
    Left = 0
    Top = 0
    Width = 1000
    Height = 57
    Align = alTop
    Caption = 'Search....'
    TabOrder = 0
    object ebSearch: TRzEdit
      Left = 1
      Top = 19
      Width = 998
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
  object gKBPackages: TcxGrid
    Left = 0
    Top = 57
    Width = 1000
    Height = 561
    Align = alClient
    PopupMenu = ppmKBPackage
    TabOrder = 1
    object tvKBPackages: TcxGridTableView
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
      OptionsSelection.HideFocusRectOnExit = False
      OptionsSelection.UnselectFocusedRecordOnExit = False
      OptionsView.GroupByBox = False
      object colID: TcxGridColumn
        Visible = False
      end
      object colCoreVersion: TcxGridColumn
        Caption = 'Core Version'
        Width = 88
      end
      object colName: TcxGridColumn
        Caption = 'Name'
        Width = 314
      end
      object colCreated: TcxGridColumn
        Caption = 'Created'
        Width = 163
      end
      object colModified: TcxGridColumn
        Caption = 'Modified'
        Width = 159
      end
      object colModifiedBy: TcxGridColumn
        Caption = 'Modified By'
        Width = 235
      end
    end
    object lvKBPackages: TcxGridLevel
      GridView = tvKBPackages
    end
  end
  object ppmKBPackage: TPopupMenu
    Left = 344
    Top = 224
    object ppmiNewKB: TMenuItem
      Caption = 'New KB Package'
      OnClick = ppmiNewKBClick
    end
    object ppmiLoad: TMenuItem
      Caption = 'Update KB Package'
      OnClick = ppmiLoadClick
    end
    object ppmiSaveKB: TMenuItem
      Caption = 'Save KB To File System'
      OnClick = ppmiSaveKBClick
    end
  end
  object odKB: TOpenDialog
    DefaultExt = '*.lkb'
    Filter = 'LogRhtyhm Knowledge Base (*.lkb)|*.lkb|All Files (*.*)|*.*'
    Left = 464
    Top = 192
  end
  object sdKB: TSaveDialog
    DefaultExt = '*.lkb'
    Filter = 'LogRhtyhm Knowledge Base (*.lkb)|*.lkb|All Files (*.*)|*.*'
    Left = 488
    Top = 288
  end
end
