object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Starfield'
  ClientHeight = 400
  ClientWidth = 640
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object frame: TPaintBox
    Left = 0
    Top = 0
    Width = 640
    Height = 400
    Align = alClient
    OnPaint = framePaint
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 56
    Top = 16
  end
  object gameRunner: TTimer
    Interval = 10
    OnTimer = gameRunnerTimer
    Left = 56
    Top = 48
  end
end
