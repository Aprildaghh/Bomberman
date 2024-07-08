unit HeroCell;

interface

uses Cell;

type
  THeroCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ THeroCell }

constructor THeroCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
