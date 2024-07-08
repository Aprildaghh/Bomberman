unit LevelSettings;

interface

uses Cell, System.SysUtils, System.Generics.Collections, BombCell, EmptyCell,
  EnemyCell, ExitCell, FireCell, HeroCell, PowerupCell, SandCell, WallCell, Vcl.Dialogs;

type

  TLevelSettings = class (TObject)
    private
      var tCharacters           : TDictionary<String, Char>;

      const CHARACTERS_FILE : string = 'characters.properties';
      const LEVEL_1_FILE    : string = 'level_1.lvl';
      const LEVEL_2_FILE    : string = 'level_2.lvl';

      class var theInstance     : TLevelSettings;

      function CharToCell(tCharacter: Char; tXCoordinate, tYCoordinate: integer): TCell;
      procedure ReadCharacters;
      constructor Create;
    public
      class function GetInstance                                  : TLevelSettings;
      function GetLevelLayoutFromFile(tLevelIndex: integer)       : CellArray;
  end;

implementation

{ TLevelSettings }

function TLevelSettings.CharToCell(tCharacter: Char; tXCoordinate, tYCoordinate: integer): TCell;
var
  i               : Integer;
  tCharacterName  : string;
begin

  for i := 0 to tCharacters.Values.Count -1 do
  begin
    if tCharacters.Values.ToArray[i] = tCharacter then
    begin
      tCharacterName := tCharacters.Keys.ToArray[i];
      break;
    end;
  end;

  if tCharacterName = 'bomb' then Result := TBombCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'empty' then Result := TEmptyCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'enemy' then Result := TEnemyCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'exit' then Result := TExitCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'fire' then Result := TFireCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'hero' then Result := THeroCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'powerup' then Result := TPowerupCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else if tCharacterName = 'sand' then Result := TSandCell.Create(tCharacter, tXCoordinate, tYCoordinate)
  else Result := TWallCell.Create(tCharacter, tXCoordinate, tYCoordinate);

end;

procedure TLevelSettings.ReadCharacters;
var
  myFile  : TextFile;
  line    : String;
begin
  if FileExists(TLevelSettings.CHARACTERS_FILE) then
  begin
    AssignFile(myFile, TLevelSettings.CHARACTERS_FILE);
    Reset(myFile);

    while not EOF(myFile) do
    begin
      ReadLn(myFile, line);

      TLevelSettings.theInstance.tCharacters.Add(
        Copy(line, 1, line.IndexOf('=')-1),
        line[Length(line)]
      );
    end;
  end;
end;

constructor TLevelSettings.Create;
begin
  tCharacters := TDictionary<String, Char>.Create;
  
end;

class function TLevelSettings.GetInstance : TLevelSettings;
begin
  if theInstance = nil then
  begin
    theInstance := TLevelSettings.Create;
    theInstance.ReadCharacters;
  end;
  Result := theInstance;
end;

function TLevelSettings.GetLevelLayoutFromFile(tLevelIndex: integer): CellArray;
var
  myFile          : TextFile;
  tFilePath, line : string;
  i, tRowCount    : Integer;
  tResultArray    : CellArray;
  aCell           : TCell;
begin
  if tLevelIndex = 1 then tFilePath := LEVEL_1_FILE
  else tFilePath := LEVEL_2_FILE;

  if FileExists(tFilePath) then
  begin
    AssignFile(myFile, tFilePath);
    Reset(myFile);

    tRowCount := 1;

    while not EOF(myFile) do
    begin
      ReadLn(myFile, line);

      for i := 1 to 30 do
      begin
        aCell := GetInstance.CharToCell(line[i], tRowCount, i);
        tResultArray[i, tRowCount] := aCell;
      end;

      inc(tRowCount);

    end;
  end;

  Result := tResultArray;
end;

end.
