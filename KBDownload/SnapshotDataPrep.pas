unit SnapshotDataPrep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, KB.SnapShot, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfmSnapshotDataPrep = class(TForm)
    pbSnapshot: TProgressBar;
    lbProgress: TLabel;
    tmPrep: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure tmPrepTimer(Sender: TObject);
  private
    { Private declarations }
    procedure PrepSnapshots;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfmSnapshotDataPrep.FormActivate(Sender: TObject);
begin
  lbProgress.Caption := '';
  tmPrep.Enabled := TRUE;
end;

procedure TfmSnapshotDataPrep.PrepSnapshots;
var
  LList : TSnapshotList;
begin
  pbSnapshot.Max := 6;
  pbSnapshot.Min := 0;
  Screen.Cursor := crHourglass;
  try
    lbProgress.Caption := 'Retrieving Most Recent Snapshots';
    Application.ProcessMessages;
    LList := TSnapshotList.GetAllMostRecent;
    pbSnapshot.StepIt;
    try
      lbProgress.Caption := 'Prepping Agents By OS Version';
      Application.ProcessMessages;
      LList.SubmitAgentsByOSVersion;
      pbSnapshot.StepIt;

      lbProgress.Caption := 'Prepping FIM Agents By OS Version';
      Application.ProcessMessages;
      LList.SubmitFIMAgentsByOSVersion;
      pbSnapshot.StepIt;

      lbProgress.Caption := 'Prepping Real Time FIM Agents By OS Version';
      Application.ProcessMessages;
      LList.SubmitRTFIMAgentsByOSVersion;
      pbSnapshot.StepIt;

      lbProgress.Caption := 'Prepping Process Monitor Agents By OS Version';
      Application.ProcessMessages;
      LList.SubmitPMAgentsByOSVersion;
      pbSnapshot.StepIt;

      lbProgress.Caption := 'Prepping KB Modules Data';
      Application.ProcessMessages;
      LList.SubmitKBModules;
      pbSnapshot.StepIt;
    finally
      LList.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
  ShowMessage('Tables Synced');
end;

procedure TfmSnapshotDataPrep.tmPrepTimer(Sender: TObject);
begin
  tmPrep.Enabled := FALSE;
  PrepSnapshots;
  Close;
end;

end.
