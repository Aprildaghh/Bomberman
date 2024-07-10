unit GameController;

interface

uses Vcl.Grids, System.Generics.Collections, Levels, ScreenState, LevelStartState, FailedState,
    GameState, Vcl.Forms, Vcl.Dialogs, System.UITypes, System.SysUtils, BombCell, Cell, HeroCell,
    EmptyCell, WallCell, PowerupCell, SandCell, ExitCell, EnemyCell, FireCell, LevelSettings;

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
      tBombs                  : TList<TBombCell>;

      const MOVE_LIMIT        : Integer = 200;
      const BOMB_LIMIT        : Integer = 2;

      procedure UpdateGame(tPressedKey: Char);
      procedure DrawScreen;
      procedure PlaceBomb;
      procedure MoveHero(tDirection: TDirection);
      procedure SetHeroCorr;
      procedure UpdateBombs;
      procedure BombGoBoom(var aBomb: TBombCell);
      procedure ClearLayoutsFromFire;
      procedure ChangeCell(x, y: integer; aName: string);
      function IsWinCondition                                       : boolean;
      function GetBombAtLocation( tXCorr, tYCorr: integer)          : TBombCell;
      function WasThereABomb( tXCorr, tYCorr: integer)              : boolean;
      function IsDeathCondition                                     : boolean;
      function IsMovable(tDirection: TDirection)                    : boolean;
    public
      procedure ProcessInput(tPressedKey: Char);

      constructor Create;
  end;

implementation

{ TGameArea }

uses GameView;

procedure TGameController.BombGoBoom(var aBomb: TBombCell);
var
  tXCorr, tYCorr, i: integer;
begin
  tXCorr := aBomb.XCoordinate;
  tYCorr := aBomb.YCoordinate;

  ChangeCell(tXCorr, tYCorr, TFireCell.ClassName);

  for i := 1 to 2 do
    if tXCorr+i <= 15 then
    begin
      if (tCellLayout[tXCorr+i, TYCorr].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr+i, TYCorr].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr+i, TYCorr].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr+i, TYCorr].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr+i, tYCorr, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr+i, tYCorr, TFireCell.ClassName);
    end;

  for i := 1 to 2 do
    if tXCorr-i > 0 then
    begin
      if (tCellLayout[tXCorr-i, TYCorr].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr-i, TYCorr].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr-i, TYCorr].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr-i, TYCorr].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr-i, tYCorr, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr-i, tYCorr, TFireCell.ClassName);

    end;

  for i := 1 to 2 do
    if tYCorr+i <= 30 then
    begin
      if (tCellLayout[tXCorr, TYCorr+i].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr+i].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr+i].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr, TYCorr+i].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr, tYCorr+i, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr, tYCorr+i, TFireCell.ClassName);

    end;

  for i := 1 to 2 do
    if tYCorr+i > 0 then
    begin
      if (tCellLayout[tXCorr, TYCorr-i].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr-i].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr-i].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr, TYCorr-i].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr, tYCorr-i, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr, tYCorr-i, TFireCell.ClassName);
    end;

  tBombs.Remove(aBomb);
  // aBomb.Free;
end;

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

procedure TGameController.ClearLayoutsFromFire;
var
  i: Integer;
  j: Integer;
begin
  // Clear layouts from fire's
  for i := 1 to 15 do
    for j := 1 to 30 do
      if tCellLayout[i, j].ClassName = TFireCell.ClassName then
      begin
        if WasThereABomb(i, j) then
        begin
          tCellLayout[i, j].Free;
          tCellLayout[i, j] := GetBombAtLocation(i, j);
          tCharLayout[i, j] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
        end
        else
          ChangeCell(i, j, TEmptyCell.ClassName);

      end;
end;

constructor TGameController.Create;
begin
  inherited Create;
  tLevel := TLevels.Create;
  tBombs := TList<TBombCell>.Create;
  tMoveLimit := MOVE_LIMIT;
  tScreenState := TLevelStartState.Create(tScreenState);
end;

procedure TGameController.DrawScreen;
begin

  if ('TLevelStartState' = tScreenState.ClassName) or
    ('TGameState' = tScreenState.ClassName) then
  begin
    GameView.UpdateMoveLabel(tMoveLimit);
    GameView.UpdateBombLabel(tBombs.Count, BOMB_LIMIT);
    GameView.DrawGameScreen(tCharLayout);
  end
  else if 'TFailedState' = tScreenState.ClassName then
    GameView.DrawDeathScreen
  else if 'TPassedState' = tScreenState.ClassName then
    GameView.DrawLevelCompleteScreen
end;

function TGameController.GetBombAtLocation(tXCorr,
  tYCorr: integer): TBombCell;
var
  i     : Integer;
  aBomb : TBombCell;
begin
  // get the bombcell from the location and return
  for i := 0 to tBombs.Count - 1 do
  begin
    aBomb := tBombs.ToArray[i];
    if (aBomb.XCoordinate = tXCorr) and (aBomb.YCoordinate = tYCorr) then
    begin
      Result := aBomb;
      Exit;
    end;
  end;
  Result := nil;
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

function TGameController.WasThereABomb( tXCorr, tYCorr: integer): boolean;
begin
  // check if the hero's current location has a bomb
  if GetBombAtLocation(tXCorr, tYCorr) = nil then Result := False
  else Result := True;
end;

procedure TGameController.ProcessInput(tPressedKey: Char);
begin

  if (tScreenState is TLevelStartState ) or
    ('TFailedState' = tScreenState.ClassName) then
  begin
    tScreenState := tScreenState.LevelStarted;
    tCellLayout := tLevel.GetLevelCellLayout;
    tCharLayout := tLevel.GetLevelCharLayout;
    tMoveLimit := MOVE_LIMIT;
    tBombs.Clear;
    SetHeroCorr;
  end
  else if 'TPassedState' = tScreenState.ClassName then
  begin
    tScreenState := tScreenState.LevelStarted;
    tCellLayout := tLevel.GetNextLevelCellLayout;
    tCharLayout := tLevel.GetLevelCharLayout;
    tMoveLimit := MOVE_LIMIT;
    tBombs.Clear;
    SetHeroCorr;
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

procedure TGameController.UpdateBombs;
var
  i: Integer;
begin
  for i := 0 to tBombs.Count -1 do
  begin
    if i >= tBombs.Count then break;
    tBombs.ToArray[i].BoomTimer := tBombs.ToArray[i].BoomTimer - 1;
    if tBombs.ToArray[i].BoomTimer <= 0 then
      BombGoBoom(tBombs.ToArray[i]);
  end;

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

  ClearLayoutsFromFire;

  case Integer(tPressedKey) of
    Integer('a'): MoveHero(LEFT);
    Integer('d'): MoveHero(RIGHT);
    Integer('w'): MoveHero(UP);
    Integer('s'): MoveHero(DOWN);
    vkSpace: PlaceBomb;
  end;

end;

procedure TGameController.MoveHero(tDirection: TDirection);
begin
  if IsMovable(tDirection) then
  begin
    dec(tMoveLimit);

    if WasThereABomb(tHeroXCorr, tHeroYCorr) then
    begin
      tCellLayout[tHeroXCorr, tHeroYCorr] := GetBombAtLocation(tHeroXCorr, tHeroYCorr);
      tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
    end
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
      tBombs.Clear;
      Exit;
    end;

    if not WasThereABomb(tHeroXCorr, tHeroYCorr) then
    begin
      tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(THeroCell.ClassName);
      tCellLayout[tHeroXCorr, tHeroYCorr].Free;
      tCellLayout[tHeroXCorr, tHeroYCorr] := THeroCell.Create(
      TLevelSettings.GetInstance.GetCharFromCellType(THeroCell.ClassName), tHeroXCorr, tHeroYCorr);
    end;

    UpdateBombs;
  end;

end;

procedure TGameController.PlaceBomb;
var aBomb: TBombCell;
begin
  if tBombs.Count >= BOMB_LIMIT then Exit;


  aBomb := TBombCell.Create(
      TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName), tHeroXCorr, tHeroYCorr);

  tBombs.Add(aBomb);

  tCellLayout[tHeroXCorr, tHeroYCorr].Free;
  tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
  tCellLayout[tHeroXCorr, tHeroYCorr] := aBomb;

end;

end.
