unit Cell;

interface


type

  TCell = class abstract (TObject)
    private
      tIcon: Char;
      tXCoordinate, tYCoordinate: integer;

    public
      property Icon: Char read tIcon;
      property XCoordinate: integer read tXCoordinate write tXCoordinate;
      property YCoordinate: integer read tYCoordinate write tYCoordinate;

      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

  CellArray = array[1..30, 1..15] of TCell;

implementation

{ TCell }

constructor TCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  self.tIcon := tIcon;
  XCoordinate := tXCoordinate;
  YCoordinate := tYCoordinate;
end;

end.
