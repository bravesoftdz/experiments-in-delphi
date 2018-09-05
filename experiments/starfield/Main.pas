unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math, Contnrs, AppEvnts,
  ExtCtrls;

const
  maxz = 1000;
  
type
  TArrayOfDouble = class
    value : array of Double;
    constructor create(size : Integer);
  end;

  TForm1 = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    frame: TPaintBox;
    gameRunner: TTimer;
    procedure frameResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure gameRunnerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure framePaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    (**starField*)
    sf : TObjectList;
    grays : array of TColor;
    speed : double;
    screenWidth : Integer;
    screenHeight : Integer;
  public
    { Public declarations }
    (** Size of the display area *)
    procedure drawStarField();
  end;

var
  Form1: TForm1;

implementation

uses Types;

{$R *.dfm}

function RGBToColor(Red, Green, Blue : Integer): TColor;
begin
  result := blue shl 16 + green shl 8 + red;
end;

function xrandom : double;
begin
  result := random(1000) / 1000;
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
//  if Msg.message=WM_PAINT then handled := true;
end;

procedure TForm1.drawStarField();
var
  i : integer;
  sz : integer;
  a : TArrayOfDouble;
  zd : double;
  z,x,y : double;
begin
 if (sf=nil) then begin
  sf := TObjectList.Create;
	SetLength(grays, 256);
	for i:=0 to 256-1 do grays[i] := RGBToColor(i,i,i);

	for i:=0 to 20-1 do begin
    a := TArrayOfDouble.Create(4);
    sf.add(a);
		a.value[0] := screenWidth * xrandom();
		a.value[1] := screenHeight * xrandom();
		a.value[2] := maxz * xrandom();
	end;
 end;

 zd := 500;
 for i := 0 to sf.Count - 1 do begin
	 a := TArrayOfDouble(sf.Items[i]);
	 z := a.value[2]; x := a.value[0]; y := a.value[1];
	 x := zd*x/(zd+z);
	 y := zd*y/(zd+z);
	 sz := trunc(max(1,(maxz-z)/100));
   frame.Canvas.Pen.Color := grays[trunc((maxz-z)*255/maxz)];
   frame.Canvas.Brush.Color := grays[trunc((maxz-z)*255/maxz)];
	 frame.Canvas.Ellipse(
    trunc(x + screenWidth/2),
    trunc(y+screenHeight/2),
    trunc(x + screenWidth/2)+sz,
    trunc(y+screenHeight/2)+sz//,
//    grays[trunc((maxz-z)*255/maxz)]    
   );
	 a.value[2] := a.value[2] - speed;
	 if(a.value[2]<=0) then begin
    	a.value[0] := 2*screenWidth*xrandom()-screenWidth;
			a.value[1] := 2*screenHeight*xrandom()-screenHeight;
			a.value[2] := maxz;
		end;
 	end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  a : TArrayOfDouble;
begin
  case key of
 	  'R': begin
 		  gameRunner.Enabled := false;
 		  gameRunner.Enabled := true;
    end;
	  '+': begin
      a := TArrayOfDouble.create(4);
      sf.add(a);
			a.value[0] := screenWidth * xrandom();
			a.value[1] := screenHeight * xrandom();
			a.value[2] := 0.1+10 * xrandom();
			a.value[3] := 255 * xrandom();
    end;
		'-': if(sf.count>2) then sf.delete(0);
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  frameResize(Sender);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  speed := 11;
  gameRunner.Enabled := true;
  randomize;
  frameResize(sender);
//  frame.Buffer.Clear;
end;

procedure TForm1.framePaint(Sender: TObject);
begin
  drawStarField();
end;

procedure TForm1.frameResize(Sender: TObject);
var
  d : TRect;
begin
  d := Self.BoundsRect;
  screenHeight := d.Bottom - d.Top;
  screenWidth := d.Right - d.Left;
	frame.invalidate;
end;

procedure TForm1.gameRunnerTimer(Sender: TObject);
begin
  frame.invalidate;
end;

{ TArrayOfDouble }

constructor TArrayOfDouble.create(size: Integer);
begin
  setlength(value, size);
end;

end.
