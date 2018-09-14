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
{ The Original Code is CollisionManager.pas.                                   }
{                                                                              }
{ Unit owner:    Mišel Krstović                                                 }
{                                                                              }
{******************************************************************************}

unit CollisionManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Math, Contnrs;

type
  TActor = class(TPaintBox)
  private
    function _GetX: Integer;
    function _GetY: Integer;
    procedure _SetX(Value : Integer);
    procedure _SetY(Value : Integer);
  public
    dx, dy : integer;
    property X : Integer read _GetX write _SetX;
    property Y : Integer read _GetY write _SetY;
  end;

  TCollisionCluster = TObjectList;

  TCollisionClusters = array of TCollisionCluster;

  TCollisionManager = class
  private
    _List : TObjectList;
    function _GetListCount: Integer;
    function _GetActor(Index: Integer): TActor;
  public
    constructor Create;
    destructor Destroy; override;
    procedure TrackActor(Actor : TActor);
    property Count : Integer read _GetListCount;
    property Items[Index: Integer]: TActor read _GetActor;
    function CheckCollision(Actors : TObjectList) : TCollisionClusters;
  end;

implementation

{ TCollisionManager }

function Overlaps(u, r: TRect): boolean;
var
    rad_u_x,
    rad_r_x,
    rad_u_y,
    rad_r_y,
    distance_x,
    distance_y : integer;
    flag : byte;
begin
    flag := 0;

    // Calculate horizontal overlap
    rad_u_x := ceil((u.Right + u.Left) div 2); // Midpoint
    rad_r_x := ceil((r.Right + r.Left) div 2); // Midpoint
    distance_x := abs(rad_u_x-rad_r_x);
    if distance_x<=(abs(rad_u_x-u.Right)+abs(rad_r_x-r.Right)) then inc(flag);

    // Calculate vertical overlap
    rad_u_y := ceil((u.Top + u.Bottom) div 2);
    rad_r_y := ceil((r.Top + r.Bottom) div 2);
    distance_y := abs(rad_u_y-rad_r_y);
    if distance_y<=(abs(rad_u_y-u.Top)+abs(rad_r_y-r.Top)) then inc(flag);

    if flag=2 then result := true
    else result := false;
end;

function Overlaps2(u, r: TRect): boolean;
var
    u_x,
    r_x,
    u_y,
    r_y,
    distance : integer;
begin
    result := false;

    // Calculate horizontal overlap
    u_x := ceil((u.Right + u.Left) div 2); // Midpoint
    r_x := ceil((r.Right + r.Left) div 2); // Midpoint

    // Calculate vertical overlap
    u_y := ceil((u.Top + u.Bottom) div 2);
    r_y := ceil((r.Top + r.Bottom) div 2);

    distance := ceil(sqrt(sqr(u_x - r_x)+sqr(u_y - r_y)));
    result := distance<=min(u_x, u_y)
end;

procedure TCollisionManager.TrackActor(Actor: TActor);
begin
   _List.Add(Actor);
end;

function TCollisionManager._GetActor(Index: Integer): TActor;
begin
  if (index<_List.Count) and (index>=0) then begin
    result := TActor(_List.Items[index]);
  end else begin
    result := nil;
  end;
end;

function TCollisionManager._GetListCount: Integer;
begin
  result := _List.Count;
end;

function TCollisionManager.CheckCollision(
  Actors: TObjectList): TCollisionClusters;
var
  CopyList : TObjectList;
  i, j : integer;
  u, t : TRect;
  x, y, theta, radius : Extended;
begin
  CopyList := TObjectList.Create;
  CopyList.OwnsObjects := False;
  CopyList.Assign(Actors);
  for i := 0 to Actors.Count-1 do begin
    for j := 0 to Actors.Count-1 do begin
      if i<>j then begin
        u := Rect(
          TActor(Actors.Items[i]).Left,
          TActor(Actors.Items[i]).Top,
          TActor(Actors.Items[i]).Left + TActor(Actors.Items[j]).Width,
          TActor(Actors.Items[i]).Top + TActor(Actors.Items[j]).Height
        );
        t := Rect(
          TActor(Actors.Items[j]).Left,
          TActor(Actors.Items[j]).Top,
          TActor(Actors.Items[j]).Left + TActor(Actors.Items[j]).Width,
          TActor(Actors.Items[j]).Top + TActor(Actors.Items[j]).Height
        );
        if Overlaps(u, t) then begin
          y := TActor(CopyList.Items[i]).DY - TActor(CopyList.Items[j]).DY;
          x := TActor(CopyList.Items[i]).DX - TActor(CopyList.Items[j]).DX;
          theta := ArcTan2(y, x) + Pi/2;
          radius := 1; //Sqrt(Sqr(x)+Sqr(y));

          TActor(CopyList.Items[i]).DX := round(TActor(CopyList.Items[i]).DX + radius * cos(theta));
          TActor(CopyList.Items[i]).DY := round(TActor(CopyList.Items[i]).DY + radius * sin(theta));
        end;
      end;
    end;
  end;
  Actors.Assign(CopyList);
end;

constructor TCollisionManager.Create;
begin
  _List := TObjectList.Create;
  _List.OwnsObjects := False;
end;

destructor TCollisionManager.Destroy;
begin
  _List.Free;
end;

{ TActor }

function TActor._GetX: Integer;
begin
  result := left;
end;

function TActor._GetY: Integer;
begin
  result := top;
end;

procedure TActor._SetX(Value: Integer);
begin
  left := value;
end;

procedure TActor._SetY(Value: Integer);
begin
  top := value;
end;

end.
