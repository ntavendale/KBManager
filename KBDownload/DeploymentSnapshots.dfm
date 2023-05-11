object fmDeploymentSnapshots: TfmDeploymentSnapshots
  Left = 302
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Deployment Snapshots'
  ClientHeight = 586
  ClientWidth = 998
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
  object gSnapshots: TcxGrid
    Left = 0
    Top = 0
    Width = 664
    Height = 586
    Align = alClient
    PopupMenu = ppmSnapShots
    TabOrder = 0
    object tvSnapshots: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellClick = tvSnapshotsCellClick
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
      object colSnapshotTime: TcxGridColumn
        Caption = 'Snapshot Time'
        Width = 199
      end
      object colEMDB: TcxGridColumn
        Caption = 'EMDB Version'
        Width = 123
      end
      object colCoreVersion: TcxGridColumn
        Caption = 'Core Version'
        Width = 145
      end
      object colCreated: TcxGridColumn
        Caption = 'Record Created'
        Width = 159
      end
    end
    object lvSnapshots: TcxGridLevel
      GridView = tvSnapshots
    end
  end
  object Panel1: TPanel
    Left = 664
    Top = 0
    Width = 334
    Height = 586
    Align = alRight
    TabOrder = 1
    object cxVerticalGrid1: TcxVerticalGrid
      Left = 1
      Top = 1
      Width = 332
      Height = 208
      Align = alTop
      OptionsView.RowHeaderWidth = 122
      TabOrder = 0
      Version = 1
      object erActiveLogSources: TcxEditorRow
        Properties.Caption = 'Active Sources'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 0
        ParentID = -1
        Index = 0
        Version = 1
      end
      object erActiveHosts: TcxEditorRow
        Properties.Caption = 'Active Hosts'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 1
        ParentID = -1
        Index = 1
        Version = 1
      end
      object erActivePersons: TcxEditorRow
        Properties.Caption = 'Active Persons'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 2
        ParentID = -1
        Index = 2
        Version = 1
      end
      object erActiveUsers: TcxEditorRow
        Properties.Caption = 'Active Users'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 3
        ParentID = -1
        Index = 3
        Version = 1
      end
      object erLogsCollected: TcxEditorRow
        Properties.Caption = 'Logs Collected'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 4
        ParentID = -1
        Index = 4
        Version = 1
      end
      object erLogsIdentitifed: TcxEditorRow
        Properties.Caption = 'Logs Identified'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 5
        ParentID = -1
        Index = 5
        Version = 1
      end
      object erLogsOnline: TcxEditorRow
        Properties.Caption = 'Logs Online'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 6
        ParentID = -1
        Index = 6
        Version = 1
      end
      object erEvents: TcxEditorRow
        Properties.Caption = 'Events'
        Properties.DataBinding.ValueType = 'String'
        Properties.Value = Null
        ID = 7
        ParentID = -1
        Index = 7
        Version = 1
      end
    end
    object gSnapshotDetails: TcxGrid
      Left = 1
      Top = 209
      Width = 332
      Height = 376
      Align = alClient
      TabOrder = 1
      LevelTabs.Style = 7
      RootLevelOptions.DetailTabsPosition = dtpTop
      object tvKBModules: TcxGridTableView
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
        object colModuleID: TcxGridColumn
          Visible = False
        end
        object colModuleName: TcxGridColumn
          Caption = 'Name'
          Width = 154
        end
        object colModuleVersion: TcxGridColumn
          Caption = 'Version'
          Width = 109
        end
      end
      object tvAgentsByOS: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        object colOS: TcxGridColumn
          Caption = 'OS'
          Width = 78
        end
        object coOSVersion: TcxGridColumn
          Caption = 'Version'
          Width = 90
        end
        object colAgentCount: TcxGridColumn
          Caption = 'Agent Count'
          Width = 97
        end
      end
      object tvFIMAgentsByOS: TcxGridTableView
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
        object colFIMOS: TcxGridColumn
          Caption = 'OS'
          Width = 78
        end
        object colFIMOSVersion: TcxGridColumn
          Caption = 'Version'
          Width = 90
        end
        object colFIMAgentCount: TcxGridColumn
          Caption = 'Agent Count'
          Width = 97
        end
      end
      object lvKBModules: TcxGridLevel
        Caption = 'KB Modules'
        GridView = tvKBModules
      end
      object lvAgentsByOS: TcxGridLevel
        Caption = 'Agents By OS'
        GridView = tvAgentsByOS
      end
      object lvFIMAgentsByOS: TcxGridLevel
        Caption = 'FIM Agents By OS'
        GridView = tvFIMAgentsByOS
      end
    end
  end
  object ppmSnapShots: TPopupMenu
    Left = 296
    Top = 200
    object ppmiExportToExcel: TMenuItem
      Caption = 'Export To Excel'
      OnClick = ppmiExportToExcelClick
    end
  end
end
