unit GameController;

interface

uses System.Generics.Collections, Levels, ScreenState, Vcl.Dialogs, System.UITypes,
    System.SysUtils, BombController, EnemyController;

type

  TGameController = class (TObject)
    private
      tScreenState            : TScreenState;
      tLevel                  : TLevels;
      cBombController         : TBombController;
      cEnemyController        : TEnemyController;

      procedure UpdateGame(tPressedKey: Char);
      procedure DrawScreen;
      procedure MoveHero(tDirection: TDirection);

    public
      procedure ProcessInput(tPressedKey: Char);

      constructor Create;
  end;

implementation

{ TGameArea }

uses GameView,  Vcl.Grids, LevelStartState, FailedState, PassedState,
    GameState,  BombCell;

constructor TGameController.Create;
begin
  inherited Create;
  tLevel := TLevels.GetInstance;
  tScreenState := TLevelStartState.Create(tScreenState);
  cBombController := TBombController.Create;
  cEnemyController := TEnemyController.Create;
end;

procedure TGameController.DrawScreen;
var tBombInfo: string;
begin
  if (tScreenState is TLevelStartState) or
    (tScreenState is TGameState) then
  begin
    GameView.UpdateMoveLabel(tLevel.MoveLimit);
    tBombInfo := cBombController.GetBombsInformation;
    GameView.UpdateBombLabel(strtoint(Copy(tBombInfo, 1, 1)), strtoint(Copy(tBombInfo, 2, 1)));
    GameView.DrawGameScreen(tLevel.GetLevelCharLayout);
  end
  else if tScreenState is TFailedState then
    GameView.DrawDeathScreen
  else if tScreenState is TPassedState then
    GameView.DrawLevelCompleteScreen;

end;

procedure TGameController.ProcessInput(tPressedKey: Char);
begin

  if (tScreenState is TLevelStartState ) or
    (tScreenState is TFailedState) then
  begin
    cEnemyController.ClearEnemies;
    tScreenState := tScreenState.LevelStarted;
    cBombController.ClearBombs;
    tLevel.StartLevel;
    cEnemyController.GenerateEnemies;
  end
  else if tScreenState is TPassedState then
  begin
    cEnemyController.ClearEnemies;
    tScreenState := tScreenState.LevelStarted;
    cBombController.ClearBombs;
    tLevel.StartNextLevel;
    cEnemyController.GenerateEnemies;
  end
  else
    UpdateGame(tPressedKey);

  DrawScreen;
end;

procedure TGameController.UpdateGame(tPressedKey: Char);
begin

  if tLevel.IsWinCondition then
  begin
    tScreenState := tScreenState.LevelCompleted;
    Exit;
  end;

  if tLevel.IsDeathCondition then
  begin
    tScreenState := tScreenState.Died;
    Exit;
  end;

  case Integer(tPressedKey) of
    Integer('a'): MoveHero(LEFT);
    Integer('d'): MoveHero(RIGHT);
    Integer('w'): MoveHero(UP);
    Integer('s'): MoveHero(DOWN);
    vkSpace: cBombController.PlaceBomb;
  end;

end;

procedure TGameController.MoveHero(tDirection: TDirection);
var
  tCurrPlaceBomb, tNextPlaceBomb: TBombCell;
begin

  tCurrPlaceBomb := cBombController.GetBombAtLocation(tLevel.HeroX, tLevel.HeroY);
  
  case tDirection of
    UP    : tNextPlaceBomb := cBombController.GetBombAtLocation(tLevel.HeroX-1, tLevel.HeroY);
    DOWN  : tNextPlaceBomb := cBombController.GetBombAtLocation(tLevel.HeroX+1, tLevel.HeroY);
    RIGHT : tNextPlaceBomb := cBombController.GetBombAtLocation(tLevel.HeroX, tLevel.HeroY+1);
    LEFT  : tNextPlaceBomb := cBombController.GetBombAtLocation(tLevel.HeroX, tLevel.HeroY-1);
  end;

  tLevel.MoveHero(tDirection, tCurrPlaceBomb, tNextPlaceBomb);

  cEnemyController.Update;
  cBombController.Update;

  if tLevel.IsWinCondition then tScreenState.LevelCompleted;

end;

end.

{
hero -> enemy -> bomb

}
