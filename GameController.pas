unit GameController;

interface

uses System.Generics.Collections, Levels, ScreenState, Vcl.Dialogs, System.UITypes,
    System.SysUtils, BombCell, Cell, BombController;

type

  TDirection = (UP, RIGHT, DOWN, LEFT);

  TGameController = class (TObject)
    private
      tScreenState            : TScreenState;
      tLevel                  : TLevels;
      tMoveLimit              : Integer;
      tHeroXCorr, tHeroYCorr  : Integer;
      tCellLayout             : CellArray;
      tCharLayout             : CharArray;
      cBombController         : TBombController;

      const MOVE_LIMIT        : Integer = 200;

      procedure UpdateGame(tPressedKey: Char);
      procedure DrawScreen;
      procedure MoveHero(tDirection: TDirection);
      procedure SetHeroCorr;
      procedure ChangeCell(x, y: integer; aName: string);
      function IsWinCondition                                       : boolean;
      function IsDeathCondition                                     : boolean;
      function IsMovable(tDirection: TDirection)                    : boolean;

    public
      procedure ProcessInput(tPressedKey: Char);

      constructor Create;
  end;

implementation

{ TGameArea }

uses GameView,  Vcl.Grids, LevelStartState, FailedState, PassedState,
    GameState,  HeroCell, EmptyCell, WallCell, PowerupCell, SandCell, ExitCell,
    EnemyCell, FireCell, LevelSettings;

procedure TGameController.ChangeCell(x, y: integer; aName: string);
var tIcon: Char;
begin
  tCellLayout[x, y].Free;
  tIcon := TLevelSettings.GetInstance.GetCharFromCellType(aName);
  tCharLayout[x, y] := tIcon;

  if aName = TBombCell.ClassName then tCellLayout[x, y] := TBombCell.Create(tIcon, x, y)
  else if aName = TEmptyCell.ClassName then tCellLayout[x, y] := TEmptyCell.Create(tIcon, x, y)
  else if aName = TEnemyCell.ClassName then tCellLayout[x, y] := TEnemyCell.Create(tIcon, x, y)
  else if aName = TExitCell.ClassName then tCellLayout[x, y] := TExitCell.Create(tIcon, x, y)
  else if aName = TFireCell.ClassName then tCellLayout[x, y] := TFireCell.Create(tIcon, x, y)
  else if aName = THeroCell.ClassName then tCellLayout[x, y] := THeroCell.Create(tIcon, x, y)
  else if aName = TPowerupCell.ClassName then tCellLayout[x, y] := TPowerupCell.Create(tIcon, x, y)
  else if aName = TSandCell.ClassName then tCellLayout[x, y] := TSandCell.Create(tIcon, x, y)
  else if aName = TWallCell.ClassName then tCellLayout[x, y] := TWallCell.Create(tIcon, x, y);
end;

constructor TGameController.Create;
begin
  inherited Create;
  tLevel := TLevels.Create;
  tMoveLimit := MOVE_LIMIT;
  tScreenState := TLevelStartState.Create(tScreenState);
  cBombController := TBombController.Create;
end;

procedure TGameController.DrawScreen;
begin
  tCellLayout := cBombController.GetCellLayout;
  tCharLayout :=cBombController.GetCharLayout;

  if (tScreenState is TLevelStartState) or
    (tScreenState is TGameState) then
  begin
    GameView.UpdateMoveLabel(tMoveLimit);
    var tBombInfo: string;
    tBombInfo := cBombController.GetBombsInformation;
    GameView.UpdateBombLabel(strtoint(Copy(tBombInfo, 1, 1)), strtoint(Copy(tBombInfo, 2, 1)));
    GameView.DrawGameScreen(tCharLayout);
  end
  else if tScreenState is TFailedState then
    GameView.DrawDeathScreen
  else if tScreenState is TPassedState then
    GameView.DrawLevelCompleteScreen;



end;

function TGameController.IsDeathCondition: boolean;
begin
  // later add to check if user is in alien if so return true
  if (tMoveLimit <= 0) or (tCellLayout[tHeroXCorr, tHeroYCorr].ClassName = TFireCell.ClassName) then
    Result := True
  else
    Result := False;

end;

function TGameController.IsMovable(tDirection: TDirection): boolean;
var aCell: TCell;
begin
  // COLLISION DETECT
  case tDirection of
    UP: aCell := tCellLayout[tHeroXCorr-1, tHeroYCorr];
    RIGHT: aCell := tCellLayout[tHeroXCorr, tHeroYCorr+1];
    DOWN: aCell := tCellLayout[tHeroXCorr+1, tHeroYCorr];
    LEFT: aCell := tCellLayout[tHeroXCorr, tHeroYCorr-1];
  end;

  if (aCell.ClassName = TWallCell.ClassName) or (aCell.ClassName = TSandCell.ClassName) then Result := False
  else Result := True;

end;

function TGameController.IsWinCondition: boolean;
var aCell: TCell;
begin
  // checks if user is in exit
  aCell := tCellLayout[tHeroXCorr, tHeroYCorr];
  if aCell.ClassName = TExitCell.ClassName then Result := True
  else Result := False;

end;

procedure TGameController.ProcessInput(tPressedKey: Char);
begin

  if (tScreenState is TLevelStartState ) or
    (tScreenState is TFailedState) then
  begin
    tScreenState := tScreenState.LevelStarted;
    tCellLayout := tLevel.GetLevelCellLayout;
    tCharLayout := tLevel.GetLevelCharLayout;
    tMoveLimit := MOVE_LIMIT;
    SetHeroCorr;
    cBombController.UpdateLayouts(tHeroXCorr, tHeroYCorr, tCellLayout, tCharLayout);
    cBombController.ClearBombs;
  end
  else if tScreenState is TPassedState then
  begin
    tScreenState := tScreenState.LevelStarted;
    tCellLayout := tLevel.GetNextLevelCellLayout;
    tCharLayout := tLevel.GetLevelCharLayout;
    cBombController.ClearBombs;
    tMoveLimit := MOVE_LIMIT;
    SetHeroCorr;
    cBombController.UpdateLayouts(tHeroXCorr, tHeroYCorr, tCellLayout, tCharLayout);
    cBombController.ClearBombs;
  end
  else
    UpdateGame(tPressedKey);

  DrawScreen;
end;

procedure TGameController.SetHeroCorr;
var tHeroCorr: HeroCorr;
begin
    tHeroCorr := tLevel.GetHerosCorr;
    tHeroXCorr := tHeroCorr[0];
    tHeroYCorr := tHeroCorr[1];
end;

procedure TGameController.UpdateGame(tPressedKey: Char);
begin

  if IsWinCondition then
  begin
    tScreenState := tScreenState.LevelCompleted;
    Exit;
  end;

  if IsDeathCondition then
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
begin
  if not IsMovable(tDirection) then Exit;

  dec(tMoveLimit);

  if cBombController.WasThereABomb(tHeroXCorr, tHeroYCorr) then cBombController.PlantBombFromList
  else ChangeCell(tHeroXCorr, tHeroYCorr, TEmptyCell.ClassName);

  case tDirection of
    UP    : dec(tHeroXCorr);
    DOWN  : inc(tHeroXCorr);
    RIGHT : inc(tHeroYCorr);
    LEFT  : dec(tHeroYCorr);
  end;

  if IsWinCondition then
  begin
    tScreenState.LevelCompleted;
    cBombController.ClearBombs;
    Exit;
  end;

  if not cBombController.WasThereABomb(tHeroXCorr, tHeroYCorr) then
  begin
    tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(THeroCell.ClassName);
    tCellLayout[tHeroXCorr, tHeroYCorr].Free;
    tCellLayout[tHeroXCorr, tHeroYCorr] := THeroCell.Create(
    TLevelSettings.GetInstance.GetCharFromCellType(THeroCell.ClassName), tHeroXCorr, tHeroYCorr);
  end;

  cBombController.Update(tHeroXCorr, tHeroYCorr, tCellLayout, tCharLayout);

end;

end.
