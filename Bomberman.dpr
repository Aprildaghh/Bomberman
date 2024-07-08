program Bomberman;



uses
  Vcl.Forms,
  Cell in 'Cell.pas',
  GameController in 'GameController.pas',
  Levels in 'Levels.pas',
  GameView in 'GameView.pas' {mainForm},
  FailedState in 'FailedState.pas',
  GameState in 'GameState.pas',
  LevelStartState in 'LevelStartState.pas',
  LevelSettings in 'LevelSettings.pas',
  ScreenState in 'ScreenState.pas',
  WallCell in 'WallCell.pas',
  EmptyCell in 'EmptyCell.pas',
  SandCell in 'SandCell.pas',
  BombCell in 'BombCell.pas',
  FireCell in 'FireCell.pas',
  ExitCell in 'ExitCell.pas',
  HeroCell in 'HeroCell.pas',
  PowerupCell in 'PowerupCell.pas',
  EnemyCell in 'EnemyCell.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
