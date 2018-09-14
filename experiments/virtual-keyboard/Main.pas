{******************************************************************************}
{                                                                              }
{ Virtual Keyboard                                                             }
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

unit Main;

// todo: If DEL button is held down then send a CTRL+DEL key press
// todo: A special button for SYMBOLS
// todo: Holding a letter shows other variations/accents
//       "-" -> "-", "�", "�"
//       "$" -> "=W=", "�", "$", "�", "�"
//       "&" -> "&", "�"
//       "e" -> " ", " ", " ", "�", "�", "e", "�", "�"
//       and others (check Character Map application) (a, c, e, i, d, n, o, u, y)
// todo: Portrait/landscape mode (90 degrees rotation)
// todo: When SHIFT button is down the following must happen:
//       1) The SHIFT button is shaded
//       2) The letters are CAPITALIZED/LOWERED upon SHIFT state
// todo: SHIFT button is initially down (active)
// todo: Implement a prediction mode (e.g. T9, others)
// todo: Prediction mode must be disableable
// todo: Buttons are square

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls;

type
  TMainForm = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    btnBackspace: TSpeedButton;
    btnSpace: TSpeedButton;
    SpeedButton29: TSpeedButton;
    btnReturn: TSpeedButton;
    pnlNumbers: TPanel;
    pnlLetters: TPanel;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton34: TSpeedButton;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    SpeedButton44: TSpeedButton;
    SpeedButton45: TSpeedButton;
    SpeedButton46: TSpeedButton;
    SpeedButton47: TSpeedButton;
    SpeedButton48: TSpeedButton;
    SpeedButton49: TSpeedButton;
    SpeedButton50: TSpeedButton;
    SpeedButton51: TSpeedButton;
    SpeedButton52: TSpeedButton;
    SpeedButton53: TSpeedButton;
    SpeedButton54: TSpeedButton;
    SpeedButton55: TSpeedButton;
    SpeedButton56: TSpeedButton;
    SpeedButton57: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton58: TSpeedButton;
    procedure btnBackspaceClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSpaceClick(Sender: TObject);
    procedure MouseClickHandler(Sender: TObject);
    procedure SpeedButton50Click(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton44Click(Sender: TObject);
  private
    { Private declarations }
    GlobalShiftState : Boolean;
    LettersVisible : Boolean;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;

    procedure ClickSound;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses MMSystem;

{$R *.dfm}

{ TForm1 }

procedure TMainForm.ClickSound;
var
  MediaFile : String;
begin
  MediaFile := 'click.wav';
  if FileExists(MediaFile) then
    PlaySound(PChar(MediaFile), 0, SND_ASYNC);
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
//  Params.Style := Params.Style AND WS_CAPTION;
  Params.ExStyle := Params.ExStyle OR WS_EX_NOACTIVATE OR WS_EX_TOPMOST;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  GlobalShiftState := false;
  LettersVisible := true;
  pnlLetters.BringToFront;
end;

procedure TMainForm.MouseClickHandler(Sender: TObject);
var
  _handle : HWND;
  TempChar : Char;
begin
  Application.HandleMessage;
  _handle := GetActiveWindow;
  if _handle = Self.Handle then
    _handle := GetNextWindow(Self.Handle, GW_HWNDNEXT);

//  SetActiveWindow(_handle);
  if length(TSpeedButton(Sender).Caption)>=1 then begin
    TempChar := TSpeedButton(Sender).Caption[1];

    try
      if LettersVisible then begin
        if (TSpeedButton(Sender).Tag=0) and (GlobalShiftState) then begin
          keybd_event(16, 0, KEYEVENTF_KEYUP, 0);
        end else begin
          keybd_event(16, 0, $00, 0);
        end;
      end else begin
        if TSpeedButton(Sender).Tag=0 then begin
          keybd_event(16, 0, KEYEVENTF_KEYUP, 0);
        end else begin
          keybd_event(16, 0, $00, 0);
        end;
      end;
      keybd_event(VkKeyScan(TempChar), 0, 0, 0);
      keybd_event(VkKeyScan(TempChar), 0, KEYEVENTF_KEYUP, 0);
    finally
      keybd_event(16, 0, KEYEVENTF_KEYUP, 0);
    end;
  end;

  ClickSound;
end;

procedure TMainForm.SpeedButton21Click(Sender: TObject);
begin
  GlobalShiftState := not GlobalShiftState;
end;

procedure TMainForm.SpeedButton29Click(Sender: TObject);
begin
  pnlLetters.BringToFront;
  LettersVisible := true;
end;

procedure TMainForm.SpeedButton44Click(Sender: TObject);
begin
  GlobalShiftState := not GlobalShiftState;
end;

procedure TMainForm.SpeedButton50Click(Sender: TObject);
begin
  pnlNumbers.BringToFront;
  LettersVisible := false;
end;

procedure TMainForm.btnBackspaceClick(Sender: TObject);
begin
  keybd_event(VK_BACK, 0, 0, 0);
  keybd_event(VK_BACK, 0, KEYEVENTF_KEYUP, 0);
  ClickSound;
end;

procedure TMainForm.btnSpaceClick(Sender: TObject);
begin
  keybd_event(VK_SPACE, 0, 0, 0);
  keybd_event(VK_SPACE, 0, KEYEVENTF_KEYUP, 0);
  ClickSound;
end;

procedure TMainForm.btnReturnClick(Sender: TObject);
begin
  keybd_event(VK_RETURN, 0, 0, 0);
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0);
  ClickSound;
end;

procedure TMainForm.WMActivate(var Message: TWMActivate);
begin
  Message.Result := WA_INACTIVE;
end;

procedure TMainForm.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

end.
