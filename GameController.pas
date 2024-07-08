unit GameController;

interface

uses Vcl.Grids, System.Generics.Collections, Levels, ScreenState, LevelStartState, FailedState,
    GameState, Vcl.Forms, Vcl.Dialogs;

type

  TGameController = class (TObject)
    private
      tScreenState    : TScreenState;
      tLevel          : TLevels;

      procedure UpdateGame(tPressedKey: Char);
      procedure DrawScreen;
    public
      procedure ProcessInput(tPressedKey: Char);

      constructor Create;
  end;

implementation

{ TGameArea }

uses GameView;

constructor TGameController.Create;
begin
  inherited Create;
  tLevel := TLevels.Create;
  tScreenState := TGameState.Create(tScreenState);

  // tScreenState := TLevelStartState.Create(tScreenState);          // prob this will break
end;

procedure TGameController.DrawScreen;
begin
  showmessage(tScreenState.getStateName);
  if TLevelStartState.ClassName = tScreenState.getStateName then
    GameView.DrawGameStartScreen
  else if TFailedState.ClassName = tScreenState.getStateName then
    GameView.DrawDeathScreen
  else
    GameView.DrawGameScreen(tLevel.GetLevelLayout);
end;

procedure TGameController.ProcessInput(tPressedKey: Char);
begin

  if TLevelStartState.ClassName = tScreenState.getStateName then tScreenState.LevelStarted
  else if TFailedState.ClassName = tScreenState.getStateName then tScreenState.LevelStarted
  else
    UpdateGame(tPressedKey);

  DrawScreen;
end;

procedure TGameController.UpdateGame(tPressedKey: Char);
begin
// update game
end;

end.
