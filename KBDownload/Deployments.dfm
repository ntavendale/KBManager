object fmDeployments: TfmDeployments
  Left = 631
  Top = 342
  BorderIcons = []
  Caption = 'Deployments'
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
  OnClose = FormClose
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
  object gDeployments: TcxGrid
    Left = 0
    Top = 57
    Width = 1000
    Height = 561
    Align = alClient
    PopupMenu = ppmDeployments
    TabOrder = 1
    object tvDeployments: TcxGridTableView
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
      object colDeploymentID: TcxGridColumn
        Visible = False
      end
      object colLicenceID: TcxGridColumn
        Caption = 'Licence ID'
        Width = 86
      end
      object colFinferprint: TcxGridColumn
        Caption = 'Deployment ID'
        Width = 221
      end
      object colModified: TcxGridColumn
        Caption = 'Modified'
        Width = 158
      end
      object colModifiedBy: TcxGridColumn
        Caption = 'Modified By'
        Width = 151
      end
      object colRequireSnapshot: TcxGridColumn
        Caption = 'Require Snapshot'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Width = 118
      end
      object colEnforceFingerprint: TcxGridColumn
        Caption = 'Enforce Deployemnt ID'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Width = 152
      end
      object colAuthorized: TcxGridColumn
        Caption = 'Authorized'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Width = 88
      end
    end
    object lvDeployments: TcxGridLevel
      GridView = tvDeployments
    end
  end
  object ppmDeployments: TPopupMenu
    OnPopup = ppmDeploymentsPopup
    Left = 288
    Top = 208
    object ppmiResetDeploymentID: TMenuItem
      Caption = 'Reset Deployment ID'
      OnClick = ppmiResetDeploymentIDClick
    end
    object ppmiEnableDownloads: TMenuItem
      Caption = 'Enable Downloads'
      OnClick = ppmiEnableDownloadsClick
    end
    object ppmiNew: TMenuItem
      Caption = 'New'
      OnClick = ppmiNewClick
    end
    object ppmiEdit: TMenuItem
      Caption = 'Edit'
      OnClick = ppmiEditClick
    end
    object ppmiDisallow: TMenuItem
      Caption = 'Disallow Downloads'
      OnClick = ppmiDisallowClick
    end
    object ppmiFilter: TMenuItem
      Caption = 'Filter From LicenceID List'
      OnClick = ppmiFilterClick
    end
    object ppmiSnapshots: TMenuItem
      Caption = 'Snapshots'
      OnClick = ppmiSnapshotsClick
    end
    object ppmiExport: TMenuItem
      Caption = 'Export'
      OnClick = ppmiExportClick
    end
  end
  object odList: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*'
    Left = 152
    Top = 176
  end
end
