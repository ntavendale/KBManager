program LicenceFileViewer;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  Licence in '..\Common\Units\Licence.pas',
  CommonFunctions in '..\Common\Units\CommonFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
