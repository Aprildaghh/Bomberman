unit Enemy;

interface

uses EnemyCell;

type

  Direction = (Up, Right, Down, Left);

  TEnemy = class abstract (TObject)
    private
      tXCorr, tYCorr: Integer;
      tCell         : TEnemyCell;

      procedure MoveEnemy(tDirection: Direction);

      function IsCreateable(XCorr, YCorr: Integer): boolean;
      function IsMovable(tDirection: Direction)    : boolean;
    public
      procedure Move;

      constructor Create;
  end;

implementation

{ TEnemy }

uses LevelSettings;

constructor TEnemy.Create;
var XCorr, YCorr: Integer;
begin
  while True do
  begin
    Randomize;
    XCorr := random(15)+1;
    YCorr := random(30)+1;
    if IsCreateable(XCorr, YCorr) then
    begin
      self.tXCorr := XCorr;
      self.tYCorr := YCorr;
    end;
  end;
  tCell := TEnemyCell.Create(TLevelSettings.GetInstance.GetCharFromCellType(TEnemyCell.ClassName), XCorr, YCorr);
end;

function TEnemy.IsCreateable(XCorr, YCorr: Integer): boolean;
begin

end;

function TEnemy.IsMovable(tDirection: Direction): boolean;
begin

end;

procedure TEnemy.Move;
begin
  Randomize;

  while True do
  begin
    case random(4) of
      0: if IsMovable(Up) then begin MoveEnemy(Up); Exit; end;
      1: if IsMovable(Right) then begin MoveEnemy(Right); Exit; end;
      2: if IsMovable(Down) then begin MoveEnemy(Down); Exit; end;
      3: if IsMovable(Left) then begin MoveEnemy(Left); Exit; end;
    end;
  end;
end;

procedure TEnemy.MoveEnemy(tDirection: Direction);
begin

end;

end.
