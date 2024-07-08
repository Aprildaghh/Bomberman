unit Levels;

interface

uses Cell, Vcl.Dialogs;

type

  CharArray = array[1..30, 1..15] of Char;

  TLevels = class (TObject)
    private
      tLevelCount: integer;
      tLevelLayout: CellArray;

      procedure SetLevelLayout;
    public
      procedure NextLevel;

      function GetLevelLayout: CharArray;

      constructor Create;
  end;

implementation

{ TLevels }

uses LevelSettings;

constructor TLevels.Create;
begin
  tLevelCount := 1;
  SetLevelLayout;
end;

function TLevels.GetLevelLayout: CharArray;
var
  tLayout   : CharArray;
  i, j      : Integer;
begin
  for i := 1 to 30 do
  begin
    for j := 1 to 15 do
    begin
      tLayout[i, j] := tLevelLayout[i, j].Icon;
    end;
  end;

  Result := tLayout;
end;

procedure TLevels.NextLevel;
begin
  // inc(tLevelCount);
  tLevelCount := (tLevelCount mod 2) + 1;
  SetLevelLayout;
end;

procedure TLevels.SetLevelLayout;
var
  tSettings: TLevelSettings;
begin
  tSettings := TLevelSettings.GetInstance;
  tLevelLayout := tSettings.GetLevelLayoutFromFile(tLevelCount);
end;

end.
