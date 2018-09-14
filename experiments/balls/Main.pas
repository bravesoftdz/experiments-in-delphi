{******************************************************************************}
{                                                                              }
{ Collision Manager                                                            }
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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Math, Contnrs, CollisionManager;

Const
  Radius = 10;

type
  TBall = class(TActor)
  private
    _Timer : TTimer;
    procedure DoTimer(Sender : TObject);
    procedure DoPaint(Sender : TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfrmMain = class(TForm)
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    CollisionManager : TCollisionManager;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TBall }

constructor TBall.Create(AOwner: TComponent);
begin
  inherited;

  _Timer := TTimer.Create(Self);
  _Timer.Interval := 10;
  _Timer.OnTimer := DoTimer;

  Self.OnPaint := DoPaint;
  Self.Width  := Radius;
  Self.Height := Radius;

  dx := Random(5) + 5;
  dy := Random(5) + 5;
end;

procedure TBall.DoPaint(Sender: TObject);
begin
  Self.Canvas.Brush.Style := bsSolid;
  Self.Canvas.Brush.Color := Self.Canvas.Pen.Color;
  Self.Canvas.Ellipse(0, 0 ,Radius-1 , Radius-1);
end;

procedure TBall.DoTimer(Sender: TObject);
begin
  Self.X := Self.X + Round(dx / 5);
  Self.Y := Self.Y + Round(dy / 5);

  if (Self.Y<=0) or (Self.Y>=Self.Parent.ClientHeight - Self.Height) then begin
    dy := dy * (-1);
    if Self.Y>=(Self.Parent.ClientHeight - Self.Height) then Self.Y := (Self.Parent.ClientHeight - Self.Height)
  end;
  if (Self.X<=0) or (Self.X>=Self.Parent.ClientWidth - Self.Width) then begin
    dx := dx * (-1);
    if Self.X>=(Self.Parent.ClientWidth - Self.Width) then Self.X := (Self.Parent.ClientWidth - Self.Width)
  end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Invalidate;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
var
  Ball : TBall;
begin
  Ball := TBall.Create(Self);
  Ball.X := 10;
  Ball.Y := 10;
  Ball.Parent := frmMain;

  CollisionManager.TrackActor(Ball);
end;

procedure TfrmMain.FormPaint(Sender: TObject);
const
  RESOULTION = 32;
var
  x, y : integer;
  i    : integer;
  BallOfFury : TObjectList;
begin
  BallOfFury := TObjectList.Create;
  BallOfFury.OwnsObjects := false;
  for x := 0 to ceil(Self.ClientWidth / RESOULTION)-1 do begin
    for y := 0 to ceil(Self.ClientHeight / RESOULTION)-1 do begin
      Canvas.Brush.Color:= clBtnFace;
      BallOfFury.Clear;
      for i := 0 to CollisionManager.Count-1 do begin
        if ((TBall(CollisionManager.Items[i]).X>=x*RESOULTION) and (TBall(CollisionManager.Items[i]).X<(x+1)*RESOULTION))
        and ((TBall(CollisionManager.Items[i]).Y>=y*RESOULTION) and (TBall(CollisionManager.Items[i]).Y<(y+1)*RESOULTION)) then begin
          BallOfFury.Add(TBall(CollisionManager.Items[i]));
        end;
      end;
      if BallOfFury.Count>1 then begin
        Canvas.Brush.Color:= clRed;
        CollisionManager.CheckCollision(BallOfFury);
      end;
//      Canvas.FillRect(Rect(x*RESOULTION, y*RESOULTION, (x+1)*RESOULTION, (y+1)*RESOULTION));
//      Canvas.TextOut(x*RESOULTION, y*RESOULTION, inttostr(BallOfFury.Count));
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  DoubleBuffered := true;
  CollisionManager := TCollisionManager.Create;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CollisionManager.Free;
end;

end.
