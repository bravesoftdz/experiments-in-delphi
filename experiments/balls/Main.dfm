object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Balls - Collision Manager [PRESS SPACE]'
  ClientHeight = 345
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Tag = 1
    Interval = 1
    OnTimer = Timer1Timer
    Left = 368
    Top = 8
  end
end
