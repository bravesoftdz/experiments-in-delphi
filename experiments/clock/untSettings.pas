unit untSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TfrmSettings = class(TForm)
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label8: TLabel;
    TrackBar1: TTrackBar;
    CheckBox3: TCheckBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses untMain;

{$R *.dfm}

procedure TfrmSettings.TrackBar1Change(Sender: TObject);
var
    value : byte;
begin
    value := TrackBar1.Position;
    If value<15 then begin
        TrackBar1.Position := 15;
        exit;
    end;
    if value<>100 then begin
        frmMain.AlphaBlendValue := value * 255 div 100;
        frmMain.AlphaBlend := TRUE;
    end else begin
        frmMain.AlphaBlendValue := value * 255 div 100;
        frmMain.AlphaBlend := FALSE;
    end;

    Label3.Caption := IntToStr(value)+'%';
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
    ComboBox1.ItemIndex := 1;
    CheckBox1.Checked := (frmMain.FormStyle = fsStayOnTop);
    TrackBar1.Position := frmMain.AlphaBlendValue * 100 div 255;
    Label3.Caption := IntToStr(frmMain.AlphaBlendValue)+'%';
end;

procedure TfrmSettings.Button1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmSettings.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

begin
  ShowWindow(Application.Handle, SW_HIDE);
end.

