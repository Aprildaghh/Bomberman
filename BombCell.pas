unit BombCell;

interface

uses Cell;

type

  TBombCell = class(TCell)
    private
      tBoomTimer: integer;

      const BOOM_TIME: integer = 4;
    public
      property BoomTimer: integer read tBoomTimer write tBoomTimer;

      constructor Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
  end;

implementation

{ TBombCell }

constructor TBombCell.Create(tIcon: Char; tXCoordinate, tYCoordinate: integer);
begin
  inherited Create(tIcon, tXCoordinate, tYCoordinate);
  tBoomTimer := BOOM_TIME;
end;


end.
