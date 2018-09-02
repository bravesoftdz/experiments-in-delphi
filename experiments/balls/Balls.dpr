program Balls;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  CollisionManager in 'CollisionManager.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
