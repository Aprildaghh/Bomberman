unit BombCell;

interface

uses Cell;

type
  TBombCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TBombCell }

constructor TBombCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
