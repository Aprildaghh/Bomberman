unit GameView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, GameController, Levels,
  Vcl.ExtCtrls;

type

  TmainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblMoveCountLabel: TLabel;
    lblBombCountLabel: TLabel;
    lblAliensCountLabel: TLabel;
    lblPowerUpsLabel: TLabel;
    pnlGamePanel: TPanel;
    gameMemo: TMemo;
    pnlWelcomePanel: TPanel;
    WELCOME: TLabel;
    Label5: TLabel;
    pnlDeathPanel: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    pnlLevelCompletePanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure processPanelClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    gameController: TGameController;


  public
    { Public declarations }

  end;

var
  mainForm: TmainForm;
  procedure DrawGameScreen(tGameArea: CharArray);
  procedure DrawLevelCompleteScreen;
  procedure DrawDeathScreen;
  procedure DrawGreetScreen;
  procedure HideAllPanels;
  procedure UpdateMoveLabel(tMovesLeft: integer);
  procedure UpdateBombLabel(tBombPlanted, tBombLimit: integer);
implementation

{$R *.dfm}

procedure TmainForm.FormCreate(Sender: TObject);
begin
  gameController := TGameController.Create;
  HideAllPanels;
  DrawGreetScreen;
end;

procedure TmainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  gameController.ProcessInput(Key);
end;

procedure TmainForm.processPanelClick(Sender: TObject);
begin
  gameController.ProcessInput(' ');
end;

procedure DrawGameScreen(tGameArea: CharArray);
var
  i: Integer;
  j: Integer;
  line: string;
begin
  HideAllPanels;
  mainForm.gameMemo.Clear;
  for i := 1 to 15 do
  begin
    line := '';
    for j := 1 to 30 do line := line + tGameArea[i, j];

    mainForm.gameMemo.Lines.Add(line);
  end;
  mainForm.gameMemo.Refresh;

  mainForm.pnlGamePanel.Show;
end;

procedure HideAllPanels;
begin
  mainForm.pnlGamePanel.Hide;
  mainForm.pnlWelcomePanel.Hide;
  mainForm.pnlDeathPanel.Hide;
  mainForm.pnlLevelCompletePanel.Hide;
end;

procedure DrawGreetScreen;
begin
  HideAllPanels;
  mainForm.pnlWelcomePanel.Show;
end;

procedure DrawDeathScreen;
begin
  HideAllPanels;
  mainForm.pnlDeathPanel.Show;
end;

procedure DrawLevelCompleteScreen;
begin
  HideAllPanels;
  mainForm.pnlLevelCompletePanel.Show;
end;

procedure UpdateMoveLabel(tMovesLeft: integer);
begin
  mainForm.lblMoveCountLabel.Caption := inttostr(tMovesLeft);
end;

procedure UpdateBombLabel(tBombPlanted, tBombLimit: integer);
begin
  mainForm.lblBombCountLabel.Caption := inttostr(tBombPlanted) + ' / ' + inttostr(tBombLimit);
end;

end.
{
powerup
  - strategy pattern
  - state pattern
enemy
  - factory pattern
}
