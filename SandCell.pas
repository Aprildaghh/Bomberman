unit SandCell;

interface

uses Cell;

type
  TSandCell = class(TCell)
    public
      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TSandCell }

constructor TSandCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
end;

end.
