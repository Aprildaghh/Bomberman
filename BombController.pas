unit BombController;

interface

uses Cell, Levels, BombCell, System.Generics.Collections;

type

  TBombController = class (TObject)
    private
      tLevel                  : TLevels;
      tBombs                  : TList<TBombCell>;
      tBombLimit              : Integer;
      tStandardBombLimit      : Integer;

      procedure UpdateBombs;
      procedure BombGoBoom(var aBomb: TBombCell);
      procedure ClearLayoutsFromFire;

      function PlaceFire(x, y: Integer): boolean;
    public
      property BombLimit: Integer read tBombLimit write tBombLimit;
      property StandardBombLimit: Integer read tStandardBombLimit;

      procedure PlaceBomb;
      procedure Update;
      procedure PlantBombFromList;
      procedure ClearBombs;

      function GetBombAtLocation( tXCorr, tYCorr: integer)          : TBombCell;
      function GetBombsInformation: string;
      function WasThereABomb( tXCorr, tYCorr: integer)              : boolean;

      constructor Create;
  end;

implementation

{ TBombController }

uses LevelSettings, EmptyCell, EnemyCell, ExitCell, HeroCell, FireCell,
  PowerupCell, SandCell, WallCell, System.SysUtils, Vcl.Dialogs;

procedure TBombController.BombGoBoom(var aBomb: TBombCell);
var
  tXCorr, tYCorr, i: integer;
begin
  tXCorr := aBomb.XCoordinate;
  tYCorr := aBomb.YCoordinate;

  tLevel.ChangeCell(tXCorr, tYCorr, TFireCell.ClassName);

  for i := 1 to 2 do
    if tXCorr+i <= 15 then
      if not PlaceFire(tXCorr+i, tYCorr) then break;

  for i := 1 to 2 do
    if tXCorr-i > 0 then
      if not PlaceFire(tXCorr-i, tYCorr) then break;

  for i := 1 to 2 do
    if tYCorr+i <= 30 then
      if not PlaceFire(tXCorr, tYCorr+i) then break;

  for i := 1 to 2 do
    if tYCorr-i > 0 then
      if not PlaceFire(tXCorr, tYCorr-i) then break;

  tBombs.Remove(aBomb);
  // aBomb.Free;
end;

procedure TBombController.ClearBombs;
begin
  tBombs.Clear;
end;

procedure TBombController.ClearLayoutsFromFire;
var
  i: Integer;
  j: Integer;
begin
  // Clear layouts from fire's
  for i := 1 to 15 do
    for j := 1 to 30 do
      if tLevel.CellNameAt(i, j) = TFireCell.ClassName then
      begin
        if WasThereABomb(i, j) then tLevel.PlantBomb(i, j, GetBombAtLocation(i, j))
        else tLevel.ChangeCell(i, j, TEmptyCell.ClassName);
      end;
end;

constructor TBombController.Create;
begin
  tBombs := TList<TBombCell>.Create;
  tLevel := TLevels.GetInstance;
  tStandardBombLimit := 2;
  tBombLimit := tStandardBombLimit;
end;

function TBombController.GetBombAtLocation(tXCorr,
  tYCorr: integer): TBombCell;
var
  i     : Integer;
  aBomb : TBombCell;
begin
  // get the bombcell from the location and return
  for i := 0 to tBombs.Count - 1 do
  begin
    aBomb := tBombs.ToArray[i];
    if (aBomb.XCoordinate = tXCorr) and (aBomb.YCoordinate = tYCorr) then
    begin
      Result := aBomb;
      Exit;
    end;
  end;
  Result := nil;
end;

function TBombController.GetBombsInformation: string;
begin
  Result := inttostr(tBombs.Count) + inttostr(tBombLimit);
end;

procedure TBombController.PlaceBomb;
var aBomb: TBombCell;
begin
  if tBombs.Count >= tBombLimit then Exit;

  aBomb := TBombCell.Create(
      TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName), tLevel.HeroX, tLevel.HeroY);

  tBombs.Add(aBomb);

  tLevel.ChangeCell(tLevel.HeroX, tLevel.HeroY, TBombCell.ClassName);

end;

function TBombController.PlaceFire(x, y: Integer): boolean;
begin
  if (tLevel.CellNameAt(x, y) = TWallCell.ClassName) or
        (tLevel.CellNameAt(x, y) = TExitCell.ClassName) or
        (tLevel.CellNameAt(x, y) = TBombCell.ClassName) then
  begin
    Result := False;
    Exit;
  end;
  if (tLevel.CellNameAt(x, y) = TSandCell.ClassName) then
  begin
    randomize;
    if random(100)+1 < 5 then
      tLevel.PlacePowerup(x, y)
    else
      tLevel.ChangeCell(x, y, TFireCell.ClassName);
    Result := False;
    Exit;
  end;
  if tLevel.CellNameAt(x, y) = TEnemyCell.ClassName then
  begin
    tLevel.ChangeCellWithoutFree(x, y, TFireCell.ClassName);
  end;
  tLevel.ChangeCell(x, y, TFireCell.ClassName);
  Result := True;
end;

procedure TBombController.PlantBombFromList;
begin
  tLevel.PlantBomb(tLevel.HeroX, tLevel.HeroY, GetBombAtLocation(tLevel.HeroX, tLevel.HeroY));
end;

procedure TBombController.Update;
begin
  ClearLayoutsFromFire;
  UpdateBombs;
end;

procedure TBombController.UpdateBombs;
var
  i: Integer;
begin
  for i := 0 to tBombs.Count -1 do
  begin
    if i >= tBombs.Count then break;
    tBombs.ToArray[i].BoomTimer := tBombs.ToArray[i].BoomTimer - 1;
    if tBombs.ToArray[i].BoomTimer <= 0 then
      BombGoBoom(tBombs.ToArray[i]);
  end;

end;

function TBombController.WasThereABomb( tXCorr, tYCorr: integer): boolean;
begin
  if GetBombAtLocation(tXCorr, tYCorr) = nil then Result := False
  else Result := True;
end;

end.
