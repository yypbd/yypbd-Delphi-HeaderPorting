object FormVirtDiskExampleMain: TFormVirtDiskExampleMain
  Left = 0
  Top = 0
  Caption = 'FormVirtDiskExampleMain'
  ClientHeight = 183
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 148
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Attach'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 236
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Detach'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 148
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Compact'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 236
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Expand'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 324
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Merge'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 148
    Top = 108
    Width = 75
    Height = 25
    Caption = 'GetInfo'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 236
    Top = 108
    Width = 75
    Height = 25
    Caption = 'SetInfo'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 324
    Top = 108
    Width = 75
    Height = 25
    Caption = 'GetPhysVHD'
    TabOrder = 8
    OnClick = Button9Click
  end
end
