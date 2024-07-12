object mainForm: TmainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Bomberman'
  ClientHeight = 450
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object pnlGamePanel: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 450
    Caption = 'pnlGamePanel'
    Locked = True
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
      Width = 58
      Height = 15
      Caption = 'Moves Left'
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
      Left = 432
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
      Left = 432
      Top = 408
      Width = 29
      Height = 15
      Caption = 'None'
    end
    object gameMemo: TMemo
      Left = 112
      Top = 48
      Width = 313
      Height = 289
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      Lines.Strings = (
        'gameMemo')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pnlWelcomePanel: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 450
    TabOrder = 1
    OnClick = processPanelClick
    object WELCOME: TLabel
      Left = 176
      Top = 120
      Width = 185
      Height = 54
      Caption = 'WELCOME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
    object Label5: TLabel
      Left = 173
      Top = 224
      Width = 204
      Height = 21
      Caption = 'Press any button to continue..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
  end
  object pnlDeathPanel: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 450
    TabOrder = 2
    OnClick = processPanelClick
    object Label6: TLabel
      Left = 173
      Top = 145
      Width = 186
      Height = 54
      Caption = 'YOU DIED!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
    object Label7: TLabel
      Left = 173
      Top = 268
      Width = 204
      Height = 21
      Caption = 'Press any button to continue..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
  end
  object pnlLevelCompletePanel: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 450
    TabOrder = 3
    OnClick = processPanelClick
    object Label8: TLabel
      Left = 51
      Top = 127
      Width = 437
      Height = 45
      Caption = 'YOU COMPLETED THIS LEVEL!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
    object Label9: TLabel
      Left = 157
      Top = 210
      Width = 204
      Height = 21
      Caption = 'Press any button to continue..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = processPanelClick
    end
  end
end
