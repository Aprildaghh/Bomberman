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
  EnemyCell in 'EnemyCell.pas',
  PassedState in 'PassedState.pas',
  BombController in 'BombController.pas',
  BasicEnemy in 'BasicEnemy.pas',
  EnemyController in 'EnemyController.pas',
  EnemyFactory in 'EnemyFactory.pas',
  Enemy in 'Enemy.pas',
  Powerup in 'Powerup.pas',
  PowerupStrategy in 'PowerupStrategy.pas',
  RunPowerup in 'RunPowerup.pas',
  ShieldPowerup in 'ShieldPowerup.pas',
  TooMuchBombPowerup in 'TooMuchBombPowerup.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
