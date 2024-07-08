unit EnemyCell;

interface

uses Cell;

type
  TEnemyCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TPowerupCell }

constructor TEnemyCell.Create(tIcon: Char; tXCoordinate,
  tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
