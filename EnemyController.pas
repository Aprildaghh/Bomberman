unit EnemyController;

interface

  uses Cell, EnemyCell, FireCell, Enemy, Levels, BasicEnemy, System.Generics.Collections, EnemyFactory;

  type

    TEnemyController = class (TObject)
      private
        tLevel        : TLevels;
        tEnemies      : TList<TEnemy>;
        fEnemyFactory : TEnemyFactory;

        const ENEMY_COUNT: Integer = 3;

        procedure KillThoseInFire;
        procedure KillEnemy(enemy: TEnemy);
      public
        procedure GenerateEnemies;
        procedure Update;
        procedure ClearEnemies;

        function GetEnemyCount                    : Integer;
        function GetEnemyAtLocation(x, y: integer): TEnemy;

        constructor Create;
    end;


implementation

{ TEnemyController }

uses LevelSettings, Vcl.Dialogs, SYstem.SysUtils;

procedure TEnemyController.ClearEnemies;
begin
  tEnemies.Clear;
end;

constructor TEnemyController.Create;
begin
  tLevel := TLevels.GetInstance;
  fEnemyFactory := TEnemyFactory.Create;
  tEnemies := TList<TEnemy>.Create;
end;

procedure TEnemyController.GenerateEnemies;
var
  i: Integer;
begin
  for i := 1 to ENEMY_COUNT do
    tEnemies.Add(fEnemyFactory.ProvideEnemy());

  for i := 0 to tEnemies.Count - 1 do
  begin
    tLevel.ChangeCell(tEnemies.ToArray[i].Cell.XCoordinate,
      tEnemies.ToArray[i].Cell.YCoordinate, TEnemyCell.ClassName);
  end;
end;

function TEnemyController.GetEnemyAtLocation(x, y: integer): TEnemy;
var
  i: Integer;
begin
  for i := 0 to tEnemies.Count - 1 do
    if (tEnemies.ToArray[i].Cell.XCoordinate = x) and
      (tEnemies.ToArray[i].Cell.YCoordinate = y) then
    begin
      Result := tEnemies.ToArray[i];
      Exit;
    end;
  Result := nil;
end;

function TEnemyController.GetEnemyCount: Integer;
begin
  Result := tEnemies.Count;
end;

procedure TEnemyController.KillEnemy(enemy: TEnemy);
begin
  tEnemies.Remove(enemy);
  enemy.Cell.Free;
  enemy.Free;
end;

procedure TEnemyController.KillThoseInFire;
var
  i, x, y : Integer;
begin
  for i := 0 to tEnemies.Count - 1 do
  begin
    try
      x := tEnemies.ToArray[i].Cell.XCoordinate;
      y := tEnemies.ToArray[i].Cell.YCoordinate;
      if tLevel.CellNameAt(x, y) = TFireCell.ClassName then KillEnemy(tEnemies.ToArray[i]);
    except
      on ERangeError do ; // ignore
    end;
  end;
end;

procedure TEnemyController.Update;
var
  i: Integer;
begin
  KillThoseInFire;
  
  for i := 0 to tEnemies.Count - 1 do
    tEnemies.ToArray[i].Move;


end;

end.
