{******************************************************************************}
{                                                                              }
{ Clock                                                                        }
{                                                                              }
{ The contents of this file are subject to the MIT License (the "License");    }
{ you may not use this file except in compliance with the License.             }
{ You may obtain a copy of the License at https://opensource.org/licenses/MIT  }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ Unit owner:    Mišel Krstović                                                }
{                                                                              }
{******************************************************************************}

unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Math;

const
    CS_DROPSHADOW = $00020000;

type
//  TAntialiasing = [anOff, anQuick, anAccurate]

  TSettings = record
    Transparency  : Byte; 		// Default: 0 Opaque
//    Antialiasing  : TAntialiasing;	// Default: anOff
    MovableWindow : Boolean;		// Default: TRUE
    ZoomLevel     : Byte;
    DropShadow    : Boolean;		// Default: TRUE
    AlwaysOnTop   : Boolean;		// Default: TRUE
    LocationTop   : Integer;
    LocationLeft  : Integer;
  end;

  TfrmMain = class(TForm)
    PopupMenu1: TPopupMenu;
    About1: TMenuItem;
    Close1: TMenuItem;
    Image1: TImage;
    Timer1: TTimer;
    PaintBox1: TPaintBox;
    N2: TMenuItem;
    procedure HideTitlebar;
    procedure ShowTitlebar;
    procedure Close1Click(Sender: TObject);
    procedure ShapeWindow;
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmMain: TfrmMain;

implementation

uses untSettings;

{$R *.dfm}

var
    Timer1 : TTimer;

procedure TfrmMain.HideTitlebar;
var
    Style: Longint;
begin
    if BorderStyle = bsNone then Exit;
    Style := GetWindowLong(Handle, GWL_STYLE);
    if (Style and WS_CAPTION) = WS_CAPTION then begin
        case BorderStyle of
            bsSingle,
            bsSizeable: SetWindowLong(Handle, GWL_STYLE, Style and
                (not (WS_CAPTION)) or WS_BORDER);
            bsDialog: SetWindowLong(Handle, GWL_STYLE, Style and
                (not (WS_CAPTION)) or DS_MODALFRAME or WS_DLGFRAME);
        end;
        Height := Height - GetSystemMetrics(SM_CYCAPTION);
        Refresh;
    end;
end;

procedure TfrmMain.ShowTitlebar;
var
    Style: Longint;
begin
    if BorderStyle = bsNone then Exit;
    Style := GetWindowLong(Handle, GWL_STYLE);
    if (Style and WS_CAPTION) <> WS_CAPTION then begin
        case BorderStyle of
            bsSingle,
            bsSizeable: SetWindowLong(Handle, GWL_STYLE, Style or WS_CAPTION or WS_BORDER);
            bsDialog: SetWindowLong(Handle, GWL_STYLE, Style or WS_CAPTION or DS_MODALFRAME or WS_DLGFRAME);
        end;
        Height := Height + GetSystemMetrics(SM_CYCAPTION);
        Refresh;
    end;
end;

procedure TfrmMain.Close1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
    inherited;
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
// TODO:    Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST or WS_EX_NOACTIVATE;
end;

procedure TfrmMain.ShapeWindow;
var
    rgn : HRGN;
    r   : TRect;
begin
    GetWindowRect(handle,r);
    r.Right := r.Right-r.Left;
    r.Bottom := r.Bottom-r.Top;
    r.Left := 0;
    r.Top := 0;

    rgn := CreateEllipticRgn(-2, -2, r.Right + 4, r.Bottom + 4);
    SetWindowRgn(handle, rgn, true);
end;

procedure TfrmMain.PaintBox1Paint(Sender: TObject);
var
    Date : TDateTime;
    Hours, Minutes, Seconds, MilliSeconds : Word;
    x,
    y,i : Integer;
    degree : integer;
    width,
    radius  : integer;
    color,
    acolor : tcolor;
begin
    SetBkMode(frmMain.Canvas.Handle, TRANSPARENT);
    Date := Now();
    DecodeTime(Date, Hours, Minutes, Seconds, MilliSeconds);

    For I:= 0 to 2 do begin
        case i of
            2 : begin
                    // Seconds
                    Width := 2;
                    Color := $0083D6DB;
                    aColor := $00A4FFED;
                    degree := Seconds * 6;
                    radius := 48;
                end;
            1 : begin
                    // minutes
                    Width := 3;
                    Color := $0078524E;
                    aColor := $00EDCBCC;
                    degree := minutes * 6;
                    radius := 50;
                end;
            0 : begin
                    // hours
                    Width := 5;
                    Color := $0078524E;
                    aColor := $00EDCBCC;
                    degree := hours * 30 + (minutes * 6) div 12;
                    radius := 30;

                end;
        end;
        degree := degree - 90;
        x := trunc(radius * (cos(DegToRad(degree)))  + (clientWidth div 2));
        y := trunc(radius * (sin(DegToRad(degree)))  + (clientheight div 2));
        PaintBox1.Canvas.Pen.Width := Width+1;
        PaintBox1.Canvas.Pen.Color := aColor;
        PaintBox1.Canvas.MoveTo(clientWidth div 2, clientHeight div 2);
        PaintBox1.Canvas.LineTo(x,y);

        PaintBox1.Canvas.Pen.Width := Width;
        PaintBox1.Canvas.Pen.Color := Color;
        PaintBox1.Canvas.MoveTo(clientWidth div 2, clientHeight div 2);
        PaintBox1.Canvas.LineTo(x,y);
    end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled := False;
    try
        // Update the clock arms to reflect current system time
        PaintBox1.Invalidate;

        // Refresh Always on top
        // To solve problems with other always on top apps
        // TODO
        If frmSettings=nil then BringWindowToTop(Handle)
    finally
        Timer1.Enabled := True;
    end;
end;

procedure TfrmMain.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    ReleaseCapture;
    SendMessage(frmMain.Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
    frmSettings := TfrmSettings.Create(self);
    try
        Application.NormalizeAllTopMosts;
        frmSettings.ShowModal;
    finally
        Application.RestoreTopMosts;
        frmSettings.Free;
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    HideTitlebar;
    ShapeWindow;

    ClientHeight := Image1.Height;
    ClientWidth := Image1.Width;
    DoubleBuffered := true;

    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TfrmMain.FormDeactivate(Sender: TObject);
begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

begin
    ShowWindow(Application.Handle, SW_HIDE);
end.
