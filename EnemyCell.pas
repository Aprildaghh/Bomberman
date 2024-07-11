unit EnemyCell;

interface

uses Cell;

type
  TEnemyCell = class abstract (TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TEnemyCell }

constructor TEnemyCell.Create(tIcon: Char; tXCoordinate,
  tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
