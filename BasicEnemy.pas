unit BasicEnemy;

interface

  uses Enemy;

  type
    TBasicEnemy = class(TEnemy)

      public

        constructor Create(XCorr, YCorr: Integer);
    end;


implementation

{ TBasicEnemy }

constructor TBasicEnemy.Create(XCorr, YCorr: Integer);
begin
  inherited Create(XCorr, YCorr);
end;

end.
