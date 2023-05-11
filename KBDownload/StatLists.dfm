object fmStatLists: TfmStatLists
  Left = 372
  Top = 206
  Caption = 'Stats'
  ClientHeight = 654
  ClientWidth = 946
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
  object gStatList: TcxGrid
    Left = 0
    Top = 0
    Width = 946
    Height = 654
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 17
    ExplicitWidth = 637
    ExplicitHeight = 561
    object tvStatList: TcxGridTableView
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
      object colStatListID: TcxGridColumn
        Visible = False
        Width = 86
        IsCaptionAssigned = True
      end
      object colCreated: TcxGridColumn
        Caption = 'Created'
        Width = 172
      end
      object colCreatedBy: TcxGridColumn
        Caption = 'Created By'
        Width = 162
      end
      object colModified: TcxGridColumn
        Caption = 'Modeified'
        Width = 199
      end
      object colCurrentDownloads: TcxGridColumn
        Caption = 'Current Downloads'
        Width = 143
      end
    end
    object lvStatList: TcxGridLevel
      GridView = tvStatList
    end
  end
end
