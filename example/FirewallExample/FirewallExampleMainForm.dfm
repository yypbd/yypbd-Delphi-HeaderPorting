object FormFirewallExampleMain: TFormFirewallExampleMain
  Left = 0
  Top = 0
  Caption = 'FormFirewallExampleMain'
  ClientHeight = 387
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 12
    Width = 177
    Height = 25
    Caption = 'Adding a LAN Rule'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MemoLog: TMemo
    Left = 399
    Top = 14
    Width = 446
    Height = 241
    ImeName = 'Microsoft Office IME 2007'
    Lines.Strings = (
      'MemoLog')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button2: TButton
    Left = 16
    Top = 43
    Width = 177
    Height = 25
    Caption = 'Adding a per Interface Rule'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 74
    Width = 177
    Height = 25
    Caption = 'Adding a Protocol Rule'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 105
    Width = 177
    Height = 25
    Caption = 'Adding a Rule with Edge Traversal'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 16
    Top = 136
    Width = 177
    Height = 25
    Caption = 'Adding a Service Rule'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 16
    Top = 167
    Width = 177
    Height = 25
    Caption = 'Adding an ICMP Rule'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 16
    Top = 199
    Width = 177
    Height = 25
    Caption = 'Adding an Application Rule'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 16
    Top = 230
    Width = 177
    Height = 25
    Caption = 'Adding an Outbound Rule'
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 204
    Top = 12
    Width = 177
    Height = 25
    Caption = 'Checking if a Rule is Enabled'
    TabOrder = 9
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 212
    Top = 43
    Width = 177
    Height = 25
    Caption = 'Disabling the Firewall per Interface'
    TabOrder = 10
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 204
    Top = 74
    Width = 177
    Height = 25
    Caption = 'Enabling Rule Groups'
    TabOrder = 11
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 204
    Top = 105
    Width = 177
    Height = 25
    Caption = 'Enumerating Firewall Rules'
    TabOrder = 12
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 204
    Top = 136
    Width = 177
    Height = 25
    Caption = 'Restricting Service'
    TabOrder = 13
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 204
    Top = 167
    Width = 177
    Height = 25
    Caption = 'Retrieving Firewall Settings'
    TabOrder = 14
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 204
    Top = 198
    Width = 177
    Height = 25
    Caption = 'Turning the Firewall Off'
    TabOrder = 15
    OnClick = Button15Click
  end
end
