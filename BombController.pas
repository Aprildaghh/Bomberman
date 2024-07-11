unit BombController;

interface

uses Cell, Levels, BombCell, System.Generics.Collections;

type

  TBombController = class (TObject)
    private
      tBombs                  : TList<TBombCell>;
      tHeroXCorr, tHeroYCorr  : Integer;
      tCellLayout             : CellArray;
      tCharLayout             : CharArray;

      const BOMB_LIMIT        : Integer = 2;

      procedure ChangeCell(x, y: integer; aName: string);
      procedure UpdateBombs;
      procedure BombGoBoom(var aBomb: TBombCell);
      procedure ClearLayoutsFromFire;

      function GetBombAtLocation( tXCorr, tYCorr: integer)          : TBombCell;
    public
      procedure PlaceBomb;
      procedure Update(tHeroXCorr, tHeroYCorr : integer; var tCellLayout: CellArray;
        var tCharLayout: CharArray);
      procedure PlantBombFromList;
      procedure ClearBombs;
      procedure UpdateLayouts(tHeroXCorr, tHeroYCorr : integer; var tCellLayout: CellArray;
        var tCharLayout: CharArray);

      function GetCellLayout: CellArray;
      function GetCharLayout: CharArray;
      function GetBombsInformation: string;
      function WasThereABomb( tXCorr, tYCorr: integer)              : boolean;

      constructor Create;
  end;

implementation

{ TBombController }

{
  todo's
change BombGoBoom bc it's disgusting
}

uses LevelSettings, EmptyCell, EnemyCell, ExitCell, HeroCell, FireCell,
  PowerupCell, SandCell, WallCell, System.SysUtils, Vcl.Dialogs;

procedure TBombController.BombGoBoom(var aBomb: TBombCell);
var
  tXCorr, tYCorr, i: integer;
begin
  tXCorr := aBomb.XCoordinate;
  tYCorr := aBomb.YCoordinate;

  ChangeCell(tXCorr, tYCorr, TFireCell.ClassName);

  for i := 1 to 2 do
    if tXCorr+i <= 15 then
    begin
      if (tCellLayout[tXCorr+i, TYCorr].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr+i, TYCorr].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr+i, TYCorr].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr+i, TYCorr].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr+i, tYCorr, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr+i, tYCorr, TFireCell.ClassName);
    end;

  for i := 1 to 2 do
    if tXCorr-i > 0 then
    begin
      if (tCellLayout[tXCorr-i, TYCorr].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr-i, TYCorr].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr-i, TYCorr].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr-i, TYCorr].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr-i, tYCorr, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr-i, tYCorr, TFireCell.ClassName);

    end;

  for i := 1 to 2 do
    if tYCorr+i <= 30 then
    begin
      if (tCellLayout[tXCorr, TYCorr+i].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr+i].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr+i].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr, TYCorr+i].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr, tYCorr+i, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr, tYCorr+i, TFireCell.ClassName);

    end;

  for i := 1 to 2 do
    if tYCorr+i > 0 then
    begin
      if (tCellLayout[tXCorr, TYCorr-i].ClassName = TWallCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr-i].ClassName = TExitCell.ClassName) or
        (tCellLayout[tXCorr, TYCorr-i].ClassName = TBombCell.ClassName) then break;
      if (tCellLayout[tXCorr, TYCorr-i].ClassName = TSandCell.ClassName) then
      begin
        ChangeCell(tXCorr, tYCorr-i, TFireCell.ClassName);
        break;
      end;
      ChangeCell(tXCorr, tYCorr-i, TFireCell.ClassName);
    end;

  tBombs.Remove(aBomb);
  // aBomb.Free;
end;

procedure TBombController.ChangeCell(x, y: integer; aName: string);
var tIcon: Char;
begin
  tCellLayout[x, y].Free;
  tIcon := TLevelSettings.GetInstance.GetCharFromCellType(aName);
  tCharLayout[x, y] := tIcon;

  if aName = TBombCell.ClassName then tCellLayout[x, y] := TBombCell.Create(tIcon, x, y)
  else if aName = TEmptyCell.ClassName then tCellLayout[x, y] := TEmptyCell.Create(tIcon, x, y)
  else if aName = TEnemyCell.ClassName then tCellLayout[x, y] := TEnemyCell.Create(tIcon, x, y)
  else if aName = TExitCell.ClassName then tCellLayout[x, y] := TExitCell.Create(tIcon, x, y)
  else if aName = TFireCell.ClassName then tCellLayout[x, y] := TFireCell.Create(tIcon, x, y)
  else if aName = THeroCell.ClassName then tCellLayout[x, y] := THeroCell.Create(tIcon, x, y)
  else if aName = TPowerupCell.ClassName then tCellLayout[x, y] := TPowerupCell.Create(tIcon, x, y)
  else if aName = TSandCell.ClassName then tCellLayout[x, y] := TSandCell.Create(tIcon, x, y)
  else if aName = TWallCell.ClassName then tCellLayout[x, y] := TWallCell.Create(tIcon, x, y);

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
      if tCellLayout[i, j].ClassName = TFireCell.ClassName then
      begin
        if WasThereABomb(i, j) then
        begin
          tCellLayout[i, j].Free;
          tCellLayout[i, j] := GetBombAtLocation(i, j);
          tCharLayout[i, j] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
        end
        else
          ChangeCell(i, j, TEmptyCell.ClassName);

      end;
end;

constructor TBombController.Create;
begin
  if self = nil then showmessage('bomb is nil amman tanrim');
  tBombs := TList<TBombCell>.Create;
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
  Result := inttostr(tBombs.Count) + inttostr(BOMB_LIMIT);
end;

function TBombController.GetCellLayout: CellArray;
begin
  Result := tCellLayout;
end;

function TBombController.GetCharLayout: CharArray;
begin
  Result := tCharLayout;
end;

procedure TBombController.PlaceBomb;
var aBomb: TBombCell;
begin
  if tBombs.Count >= BOMB_LIMIT then Exit;


  aBomb := TBombCell.Create(
      TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName), tHeroXCorr, tHeroYCorr);

  tBombs.Add(aBomb);

  tCellLayout[tHeroXCorr, tHeroYCorr].Free;
  tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
  tCellLayout[tHeroXCorr, tHeroYCorr] := aBomb;

end;

procedure TBombController.PlantBombFromList;
begin
  tCellLayout[tHeroXCorr, tHeroYCorr] := GetBombAtLocation(tHeroXCorr, tHeroYCorr);
  tCharLayout[tHeroXCorr, tHeroYCorr] := TLevelSettings.GetInstance.GetCharFromCellType(TBombCell.ClassName);
end;

procedure TBombController.Update(tHeroXCorr, tHeroYCorr : integer; var tCellLayout: CellArray;
        var tCharLayout: CharArray);
begin
  UpdateLayouts(tHeroXCorr, tHeroYCorr, tCellLayout, tCharLayout);

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

procedure TBombController.UpdateLayouts(tHeroXCorr, tHeroYCorr: integer;
  var tCellLayout: CellArray; var tCharLayout: CharArray);
var
  i: Integer;
  j: Integer;
begin
  self.tHeroXCorr := tHeroXCorr;
  self.tHeroYCorr := tHeroYCorr;
  self.tCellLayout := tCellLayout;
  self.tCharLayout := tCharLayout;

  //
  //for i := 1 to 15 do
      //showmessage(tCharLayout[i]);


end;

function TBombController.WasThereABomb( tXCorr, tYCorr: integer): boolean;
begin
  if GetBombAtLocation(tXCorr, tYCorr) = nil then Result := False
  else Result := True;
end;

end.
