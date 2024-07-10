unit Levels;

interface

uses Cell, Vcl.Dialogs, System.SysUtils, HeroCell;

type

  Cells = (Bomb);     // add more cells
  CharArray = array[1..15, 1..30] of Char;
  HeroCorr = array [0..1] of Integer;

  TLevels = class (TObject)
    private
      tLevelCount: integer;
      tLevelLayout: CellArray;

      procedure SetLevelLayoutFromFile;
    public
      function GetLevelCharLayout     : CharArray;
      function GetLevelCellLayout     : CellArray;
      function GetNextLevelCellLayout : CellArray;
      function GetHerosCorr           : HeroCorr;

      constructor Create;
  end;

implementation

{ TLevels }

uses LevelSettings;

constructor TLevels.Create;
begin
  tLevelCount := 1;
  SetLevelLayoutFromFile;
end;

function TLevels.GetHerosCorr: HeroCorr;
var
  i, j        : Integer;
  tHeroCorr   : HeroCorr;
begin
  for i := 1 to 15 do
    for j := 1 to 30 do
    begin
      if tLevelLayout[i, j].ClassName = THeroCell.ClassName then
      begin
        tHeroCorr[0] := i;
        tHeroCorr[1] := j;
        Result := tHeroCorr;
        Exit;
      end;
    end
end;

function TLevels.GetLevelCharLayout: CharArray;
var
  tLayout   : CharArray;
  i, j      : Integer;
begin
  for i := 1 to 15 do
    for j := 1 to 30 do
      tLayout[i, j] := tLevelLayout[i, j].Icon;

  Result := tLayout;
end;

function TLevels.GetNextLevelCellLayout: CellArray;
begin
  // inc(tLevelCount);
  tLevelCount := (tLevelCount mod 2) + 1;
  SetLevelLayoutFromFile;
  Result := tLevelLayout;
end;

function TLevels.GetLevelCellLayout: CellArray;
begin
  SetLevelLayoutFromFile;
  Result := tLevelLayout;
end;

procedure TLevels.SetLevelLayoutFromFile;
var
  tSettings: TLevelSettings;
begin
  tSettings := TLevelSettings.GetInstance;
  tLevelLayout := tSettings.GetLevelLayoutFromFile(tLevelCount);
end;

end.

