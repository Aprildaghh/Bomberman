unit EmptyCell;

interface

uses Cell;

type
  TEmptyCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TEmptyCell }

constructor TEmptyCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
