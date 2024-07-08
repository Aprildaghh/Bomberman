object mainForm: TmainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Bomberman'
  ClientHeight = 459
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlGamePanel: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 457
    Caption = 'pnlGamePanel'
    TabOrder = 0
    object lblMoveCountLabel: TLabel
      Left = 72
      Top = 408
      Width = 6
      Height = 15
      Caption = '0'
    end
    object Label1: TLabel
      Left = 40
      Top = 376
      Width = 71
      Height = 15
      Caption = 'Move Counts'
    end
    object Label2: TLabel
      Left = 184
      Top = 376
      Width = 68
      Height = 15
      Caption = 'Bomb Count'
    end
    object Label3: TLabel
      Left = 312
      Top = 376
      Width = 68
      Height = 15
      Caption = 'Aliens Count'
    end
    object Label4: TLabel
      Left = 448
      Top = 376
      Width = 53
      Height = 15
      Caption = 'PowerUps'
    end
    object lblAliensCountLabel: TLabel
      Left = 344
      Top = 408
      Width = 6
      Height = 15
      Caption = '0'
    end
    object lblBombCountLabel: TLabel
      Left = 208
      Top = 408
      Width = 15
      Height = 15
      Caption = '*/*'
    end
    object lblPowerUpsLabel: TLabel
      Left = 459
      Top = 408
      Width = 29
      Height = 15
      Caption = 'None'
    end
    object gameMemo: TMemo
      Left = 40
      Top = 24
      Width = 461
      Height = 329
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'gameMemo')
      ParentFont = False
      TabOrder = 0
    end
  end
end
