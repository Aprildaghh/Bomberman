unit PassedState;

interface

uses ScreenState;

type

  TPassedState = class (TInterfacedObject, TScreenState)

    private
    tState: TScreenState;

    public
      function LevelStarted: TScreenState;
      function Died: TScreenState;
      function LevelCompleted: TScreenState;
      function ClassName: string;

      property State: TScreenState read tState write tState;

      constructor Create; overload;
      constructor Create(var tState: TScreenState); overload;
  end;

implementation

{ TPassedState }

uses FailedState, GameState, LevelStartState;

function TPassedState.ClassName: string;
begin
  Result := 'TPassedState';
end;

constructor TPassedState.Create;
begin

end;

constructor TPassedState.Create(var tState: TScreenState);
begin
  State := tState;
end;

function TPassedState.Died: TScreenState;
begin
//
end;

function TPassedState.LevelCompleted: TScreenState;
begin
//
end;

function TPassedState.LevelStarted: TScreenState;
begin
  State := TGameState.Create;
  Result := State;
end;

end.
