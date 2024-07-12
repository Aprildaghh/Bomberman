unit Levels;

interface

uses Cell, Vcl.Dialogs, System.SysUtils, BombCell;

type

  CharArray = array[1..15, 1..30] of Char;
  TDirection = (UP, RIGHT, DOWN, LEFT);

  TLevels = class (TObject)
    private
      tLevelCount              : Integer;
      tStartCellLayout         : CellArray;
      tCurrentCellLayout       : CellArray;
      tHeroXCorr, tHeroYCorr   : Integer;
      tMoveLimit               : Integer;

      const MOVE_LIMIT         : Integer = 200;

      class var Instance       : TLevels;

      procedure SetNextLevelLayoutFromFile;
      procedure SetHeroCorr;

      constructor Create;
    public
      property MoveLimit: Integer read tMoveLimit;
      property HeroX: Integer read tHeroXCorr;
      property HeroY: Integer read tHeroYCorr;

      procedure StartLevel;
      procedure StartNextLevel;
      procedure ChangeCell(x, y: integer; aName: string);
      procedure MoveHero(tDirection: TDirection; tCurrPlaceBomb, tNextPlaceBomb: TBombCell);
      procedure PlantBomb(x, y: integer; aBombCell: TBombCell);
      procedure ChangeCellWithoutFree(x, y: integer; aName:string);

      function CellNameAt(x, y: integer)        : String;
      function GetLevelCharLayout               : CharArray;
      function IsMovable(aXFrom, aYFrom: Integer; tDirection: TDirection): boolean;
      function IsWinCondition                   : boolean;
      function IsDeathCondition                 : boolean;

      class function GetInstance: TLevels;
  end;

implementation

{ TLevels }

uses LevelSettings, HeroCell, EmptyCell, WallCell, PowerupCell, SandCell, ExitCell,
    EnemyCell, FireCell;

function TLevels.CellNameAt(x, y: integer): String;
begin
  Result := tCurrentCellLayout[x, y].ClassName;
end;

procedure TLevels.ChangeCell(x, y: integer; aName: string);
begin
  tCurrentCellLayout[x, y].Free;
  ChangeCellWithoutFree(x, y, aName);
end;

procedure TLevels.ChangeCellWithoutFree(x, y: integer; aName: string);
var tIcon: Char;
begin
  tIcon := TLevelSettings.GetInstance.GetCharFromCellType(aName);

  if      aName = TBombCell.ClassName     then tCurrentCellLayout[x, y] := TBombCell.Create(tIcon, x, y)
  else if aName = TEmptyCell.ClassName    then tCurrentCellLayout[x, y] := TEmptyCell.Create(tIcon, x, y)
  else if aName = TEnemyCell.ClassName    then tCurrentCellLayout[x, y] := TEnemyCell.Create(tIcon, x, y)
  else if aName = TExitCell.ClassName     then tCurrentCellLayout[x, y] := TExitCell.Create(tIcon, x, y)
  else if aName = TFireCell.ClassName     then tCurrentCellLayout[x, y] := TFireCell.Create(tIcon, x, y)
  else if aName = THeroCell.ClassName     then tCurrentCellLayout[x, y] := THeroCell.Create(tIcon, x, y)
  else if aName = TPowerupCell.ClassName  then tCurrentCellLayout[x, y] := TPowerupCell.Create(tIcon, x, y)
  else if aName = TSandCell.ClassName     then tCurrentCellLayout[x, y] := TSandCell.Create(tIcon, x, y)
  else if aName = TWallCell.ClassName     then tCurrentCellLayout[x, y] := TWallCell.Create(tIcon, x, y);
end;

constructor TLevels.Create;
begin
  tLevelCount := 0;
  SetNextLevelLayoutFromFile;
end;

procedure TLevels.SetHeroCorr;
var i, j        : Integer;
begin
  for i := 1 to 15 do
    for j := 1 to 30 do
    begin
      if tCurrentCellLayout[i, j].ClassName = THeroCell.ClassName then
      begin
        tHeroXCorr := i;
        tHeroYCorr := j;
        Exit;
      end;
    end
end;

class function TLevels.GetInstance: TLevels;
begin
  if Instance = nil then Instance := TLevels.Create;
  Result := Instance;
end;

function TLevels.GetLevelCharLayout: CharArray;
var
  tLayout   : CharArray;
  i, j      : Integer;
begin
  for i := 1 to 15 do
    for j := 1 to 30 do
      tLayout[i, j] := tCurrentCellLayout[i, j].Icon;

  Result := tLayout;
end;

function TLevels.IsDeathCondition: boolean;
begin
  if (tMoveLimit <= 0) or (tCurrentCellLayout[tHeroXCorr, tHeroYCorr].ClassName = TFireCell.ClassName) or
    (tCurrentCellLayout[tHeroXCorr, tHeroYCorr].ClassName = TEnemyCell.ClassName) then
    Result := True
  else
    Result := False;
end;

function TLevels.IsMovable(aXFrom, aYFrom: Integer;
  tDirection: TDirection): boolean;
var aCell: TCell;
begin
  case tDirection of
    UP: aCell := tCurrentCellLayout[aXFrom-1, aYFrom];
    RIGHT: aCell := tCurrentCellLayout[aXFrom, aYFrom+1];
    DOWN: aCell := tCurrentCellLayout[aXFrom+1, aYFrom];
    LEFT: aCell := tCurrentCellLayout[aXFrom, aYFrom-1];
  end;

  if (aCell.ClassName = TWallCell.ClassName) or (aCell.ClassName = TSandCell.ClassName) then Result := False
  else Result := True;
end;

function TLevels.IsWinCondition: boolean;
var aCell: TCell;
begin
  aCell := tCurrentCellLayout[tHeroXCorr, tHeroYCorr];
  if aCell.ClassName = TExitCell.ClassName then Result := True
  else Result := False;
end;

procedure TLevels.MoveHero(tDirection: TDirection; tCurrPlaceBomb, tNextPlaceBomb: TBombCell);
var
  i: Integer;
begin
  if not IsMovable(tHeroXCorr, tHeroYCorr, tDirection) then Exit;

  dec(tMoveLimit);

  if tCurrPlaceBomb <> nil then tCurrentCellLayout[tHeroXCorr, tHeroYCorr] := tCurrPlaceBomb
  else ChangeCell(tHeroXCorr, tHeroYCorr, TEmptyCell.ClassName);

  case tDirection of
    UP    : dec(tHeroXCorr);
    DOWN  : inc(tHeroXCorr);
    RIGHT : inc(tHeroYCorr);
    LEFT  : dec(tHeroYCorr);
  end;

  if tCurrentCellLayout[tHeroXCorr, tHeroYCorr].ClassName = TExitCell.ClassName then Exit;

  if tNextPlaceBomb = nil then
  begin
    tCurrentCellLayout[tHeroXCorr, tHeroYCorr].Free;
    tCurrentCellLayout[tHeroXCorr, tHeroYCorr] := THeroCell.Create(
      TLevelSettings.GetInstance.GetCharFromCellType(THeroCell.ClassName), tHeroXCorr, tHeroYCorr);
  end;

end;

procedure TLevels.PlantBomb(x, y: integer; aBombCell: TBombCell);
begin
  tCurrentCellLayout[x, y].Free;
  tCurrentCellLayout[x, y] := aBombCell;
end;

procedure TLevels.SetNextLevelLayoutFromFile;
begin
  tLevelCount := (tLevelCount mod 2) + 1;
  tCurrentCellLayout := TLevelSettings.GetInstance.GetLevelLayoutFromFile(tLevelCount);
  SetHeroCorr;
end;

procedure TLevels.StartLevel;
begin
  tMoveLimit := MOVE_LIMIT;
  tCurrentCellLayout := TLevelSettings.GetInstance.GetLevelLayoutFromFile(tLevelCount);
  SetHeroCorr;

end;

procedure TLevels.StartNextLevel;
begin
  tMoveLimit := MOVE_LIMIT;
  SetNextLevelLayoutFromFile;
  SetHeroCorr;
end;

end.

