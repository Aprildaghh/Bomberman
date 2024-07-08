unit PowerupCell;

interface

uses Cell;

type
  TPowerupCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TPowerupCell }

constructor TPowerupCell.Create(tIcon: Char; tXCoordinate,
  tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
