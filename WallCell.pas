unit WallCell;

interface

uses Cell;

type
  TWallCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TWallCell }

constructor TWallCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
