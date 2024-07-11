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

uses LevelSettings;

constructor TEnemy.Create(XCorr, YCorr: Integer);
begin
  tLevel := TLevels.GetInstance;
  cCell := TEnemyCell.Create(TLevelSettings.GetInstance.GetCharFromCellType(TEnemyCell.ClassName), XCorr, YCorr);
end;

function TEnemy.IsMovable(tDirection: TDirection): boolean;
begin
  Result := tLevel.IsMovable(self.cCell.XCoordinate,
    self.cCell.YCoordinate, tDirection);
end;

procedure TEnemy.Move;
var direction: TDirection;
begin

  repeat
    begin
      Randomize;
      direction := TDirection(random(3));
    end;
    until IsMovable(direction);

  case direction of
    UP: cCell.XCoordinate := cCell.XCoordinate - 1;
    RIGHT: cCell.YCoordinate := cCell.YCoordinate + 1;
    DOWN: cCell.XCoordinate := cCell.XCoordinate + 1;
    LEFT: cCell.YCoordinate := cCell.YCoordinate - 1;
  end;
end;

end.
