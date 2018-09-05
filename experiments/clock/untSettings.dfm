object frmSettings: TfrmSettings
  Left = 188
  Top = 82
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 418
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 107
    Width = 58
    Height = 13
    Caption = 'Antialiasing:'
    Transparent = True
  end
  object Label8: TLabel
    Left = 8
    Top = 134
    Width = 70
    Height = 13
    Caption = 'Transparency:'
    Transparent = True
  end
  object Label2: TLabel
    Left = 8
    Top = 200
    Width = 58
    Height = 13
    Caption = 'Zoom Level:'
  end
  object Label3: TLabel
    Left = 84
    Top = 134
    Width = 20
    Height = 13
    Caption = '0%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 230
    Width = 345
    Height = 2
  end
  object CheckBox2: TCheckBox
    Left = 84
    Top = 271
    Width = 169
    Height = 17
    Caption = 'Unmovable window'
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 84
    Top = 248
    Width = 169
    Height = 17
    Caption = 'Always on top'
    TabOrder = 3
  end
  object TrackBar1: TTrackBar
    Left = 76
    Top = 153
    Width = 153
    Height = 25
    Max = 100
    Frequency = 15
    TabOrder = 1
    ThumbLength = 16
    OnChange = TrackBar1Change
  end
  object ComboBox1: TComboBox
    Left = 84
    Top = 104
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      'Disabled (fast)'
      'Quick '#39'n Dirty (default)'
      'Accurate (Slower)')
  end
  object CheckBox3: TCheckBox
    Left = 84
    Top = 294
    Width = 169
    Height = 17
    Caption = 'Drop Shadow'
    TabOrder = 5
  end
  object ComboBox2: TComboBox
    Left = 84
    Top = 197
    Width = 53
    Height = 21
    TabOrder = 2
    Text = '100%'
  end
  object Button1: TButton
    Left = 198
    Top = 385
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 279
    Top = 385
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = Button2Click
  end
end
