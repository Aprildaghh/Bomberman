unit Enemy;

interface

uses EnemyCell, Levels;

type

  TEnemy = class abstract (TObject)
    private
      tLevel        : TLevels;
      cCell         : TEnemyCell;

      function IsMovable(tDirection: TDirection): boolean;
    public
      property Cell: TEnemyCell read cCell;

      procedure Move;

      constructor Create(XCorr, YCorr: Integer);
  end;

implementation

{ TEnemy }

uses LevelSettings, EmptyCell, Vcl.Dialogs, BombCell, ExitCell;

constructor TEnemy.Create(XCorr, YCorr: Integer);
begin
  tLevel := TLevels.GetInstance;
  cCell := TEnemyCell.Create(TLevelSettings.GetInstance.GetCharFromCellType(TEnemyCell.ClassName), XCorr, YCorr);
end;

function TEnemy.IsMovable(tDirection: TDirection): boolean;
var isThereExit: boolean;
begin
  isThereExit := False;

  case tDirection of
    UP: if tLevel.CellNameAt(self.cCell.XCoordinate-1, self.cCell.YCoordinate) = TExitCell.ClassName then isThereExit := True;
    RIGHT: if tLevel.CellNameAt(self.cCell.XCoordinate, self.cCell.YCoordinate+1) = TExitCell.ClassName then isThereExit := True;
    DOWN: if tLevel.CellNameAt(self.cCell.XCoordinate+1, self.cCell.YCoordinate) = TExitCell.ClassName then isThereExit := True;
    LEFT: if tLevel.CellNameAt(self.cCell.XCoordinate, self.cCell.YCoordinate-1) = TExitCell.ClassName then isThereExit := True;
  end;

  Result := tLevel.IsMovable(self.cCell.XCoordinate,
    self.cCell.YCoordinate, tDirection) and not isThereExit;
end;

procedure TEnemy.Move;
var 
  direction : TDirection;
  randNum   : integer;
begin

  if tLevel.CellNameAt(cCell.XCoordinate, cCell.YCoordinate) <> TBombCell.ClassName then
    tLevel.ChangeCell(cCell.XCoordinate, cCell.YCoordinate, TEmptyCell.ClassName);

  Randomize;
  randNum := random(3);
  direction := TDirection(randNum);

  while not IsMovable(direction) do
  begin
    randNum := (randNum+1) mod 4;
    direction := TDirection(randNum);
  end;

  case direction of
    UP: cCell.XCoordinate := cCell.XCoordinate - 1;
    RIGHT: cCell.YCoordinate := cCell.YCoordinate + 1;
    DOWN: cCell.XCoordinate := cCell.XCoordinate + 1;
    LEFT: cCell.YCoordinate := cCell.YCoordinate - 1;
  end;

  if tLevel.CellNameAt(cCell.XCoordinate, cCell.YCoordinate) <> TBombCell.ClassName then
    tLevel.ChangeCell(cCell.XCoordinate, cCell.YCoordinate, TEnemyCell.ClassName);

end;

end.
