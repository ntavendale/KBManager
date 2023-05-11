object fmSnapshotDataPrep: TfmSnapshotDataPrep
  Left = 864
  Top = 478
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Snapshot Data Prep'
  ClientHeight = 101
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 18
  object lbProgress: TLabel
    Left = 8
    Top = 48
    Width = 65
    Height = 18
    Caption = 'lbProgress'
  end
  object pbSnapshot: TProgressBar
    Left = 8
    Top = 16
    Width = 641
    Height = 17
    Step = 1
    TabOrder = 0
  end
  object tmPrep: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmPrepTimer
    Left = 296
    Top = 48
  end
end
