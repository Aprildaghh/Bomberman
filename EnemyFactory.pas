unit EnemyFactory;

interface

  uses Enemy, BasicEnemy, Levels;

  type

    TEnemyFactory = class (TObject)
      private
        tLevel        : TLevels;

        function IsCreateable(XCorr, YCorr: Integer)        : boolean;
      public
        function ProvideEnemy(tEnemyType: string = 'basic') : TEnemy;

        constructor Create;
    end;

implementation

{ TEnemyFactory }

uses EmptyCell;

constructor TEnemyFactory.Create;
begin
  tLevel := TLevels.GetInstance;
end;

function TEnemyFactory.IsCreateable(XCorr, YCorr: Integer): boolean;
var isEmpty: boolean;
begin
  isEmpty := tLevel.CellNameAt(XCorr, YCorr) = TEmptyCell.ClassName;
  if not isEmpty then
  begin
    Result := False;
    Exit;
  end;

  if tLevel.IsMovable(XCorr, YCorr, Up) or tLevel.IsMovable(XCorr, YCorr, Right)
  or tLevel.IsMovable(XCorr, YCorr, Left) or tLevel.IsMovable(XCorr, YCorr, Down) then
    Result := True and isEmpty
  else Result := False;
end;


function TEnemyFactory.ProvideEnemy(tEnemyType: string = 'basic'): TEnemy;
var
  aEnemy: TEnemy;
  x, y  : Integer;
begin
  aEnemy := nil;

  repeat
  begin
    Randomize;
    x := random(15)+1;
    y := random(30)+1;
  end;
  until IsCreateable(x, y);


  if tEnemyType = 'basic' then aEnemy := TBasicEnemy.Create(x, y);

  Result := aEnemy;
end;

end.
