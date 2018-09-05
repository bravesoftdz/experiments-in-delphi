program Clock;

uses
  Windows,
  Forms,
  untMain in 'untMain.pas' {frmMain},
  untSettings in 'untSettings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmMain, frmMain);
  ShowWindow(Application.Handle, SW_HIDE);
  ShowWindow(frmMain.Handle, SW_SHOWNORMAL); //Only add this if you want your form to show.
  Application.Run;
end.
