inherited fmDeploymentSelect: TfmDeploymentSelect
  Left = 445
  Top = 295
  Caption = 'Select Deployment'
  ClientWidth = 801
  ExplicitWidth = 817
  PixelsPerInch = 96
  TextHeight = 18
  inherited gbSearchString: TRzGroupBox
    Width = 801
    ExplicitWidth = 801
  end
  inherited pnButtons: TRzPanel
    Width = 801
    ExplicitWidth = 801
    inherited pnOKCancel: TRzPanel
      Left = 642
      ExplicitLeft = 642
    end
    inherited pnNewEditDelete: TRzPanel
      Width = 642
      ExplicitWidth = 642
    end
  end
  inherited gbGrid: TRzGroupBox
    Width = 801
    Caption = 'Deployments'
    ExplicitWidth = 801
    inherited gLookUp: TcxGrid
      Width = 793
      ExplicitWidth = 793
      inherited tvData: TcxGridTableView
        object colID: TcxGridColumn
          Visible = False
        end
        object colLicenceID: TcxGridColumn
          Caption = 'Master Licence ID'
          Width = 161
        end
        object colName: TcxGridColumn
          Caption = 'Name'
          Width = 338
        end
        object colGuid: TcxGridColumn
          Caption = 'GUID'
          Width = 182
        end
        object colAuthorised: TcxGridColumn
          Caption = 'Authorised'
          Width = 84
        end
      end
    end
  end
end
