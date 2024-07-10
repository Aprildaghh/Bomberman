unit GameState;

interface

uses ScreenState;

type

  TGameState = class (TInterfacedObject, TScreenState)

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

{ TGameState }

uses FailedState, LevelStartState, PassedState;

constructor TGameState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TGameState.Create;
begin

end;

function TGameState.Died: TScreenState;
begin
  State := TFailedState.Create(tState);
  Result := State;
end;

function TGameState.ClassName: string;
begin
  Result := 'TGameState';
end;

function TGameState.LevelCompleted: TScreenState;
begin
  State := TPassedState.Create(tState);
  Result := State;
end;

function TGameState.LevelStarted: TScreenState;
begin
  // Result := State;
end;

end.
