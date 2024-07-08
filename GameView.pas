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
    procedure mGameAreaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
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
  procedure DrawGameStartScreen;
  procedure DrawDeathScreen;
implementation

{$R *.dfm}

procedure TmainForm.FormCreate(Sender: TObject);
begin
  gameController := TGameController.Create;
  gameController.ProcessInput('k');
end;

procedure TmainForm.mGameAreaKeyPress(Sender: TObject; var Key: Char);
begin
  gameController.ProcessInput(Key);
end;

procedure DrawGameScreen(tGameArea: CharArray);
var
  i: Integer;
  j: Integer;
  line: string;
begin
  mainForm.gameMemo.Clear;
  for i := 1 to 15 do
  begin
    line := '';
    for j := 1 to 30 do
    begin
      line := line + tGameArea[j, i];
    end;
    mainForm.gameMemo.Lines.Add(line);
  end;
  mainForm.gameMemo.Refresh;

  mainForm.pnlGamePanel.Show;
  // hide other panels
end;

procedure DrawDeathScreen;
begin
  //
end;

procedure DrawGameStartScreen;
begin
  //
end;

procedure DrawLevelCompleteScreen;
begin
  //
end;

end.

{
* change TStringGrid to TMemo *

There will be 3 panels
1. Greeting Panel
  - show 'welcome to the game! press any key to continue'
2. Game Panel
  - show game already ready
3. Next Level Panel
  - show 'Congrulations! press any key to next level'


powerup
  - strategy pattern
  - state pattern
enemy
  - factory pattern

}
