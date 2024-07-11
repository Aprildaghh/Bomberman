unit EnemyFactory;

interface

  uses Enemy, BasicEnemy;

  type

    TEnemyFactory = class (TObject)
      public
        function ProvideEnemy(tEnemyType: string = 'basic') : TEnemy;
    end;

implementation

{ TEnemyFactory }

function TEnemyFactory.ProvideEnemy(tEnemyType: string = 'basic'): TEnemy;
var aEnemy: TEnemy;
begin
  if tEnemyType = 'basic' then aEnemy := TBasicEnemy.Create;

  Result := aEnemy;
end;

end.
