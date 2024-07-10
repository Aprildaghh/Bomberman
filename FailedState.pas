unit FailedState;

interface

uses ScreenState;

type

  TFailedState = class (TInterfacedObject, TScreenState)

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

{ TFailedState }
uses LevelStartState, GameState, PassedState;

constructor TFailedState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TFailedState.Create;
begin

end;

function TFailedState.Died: TScreenState;
begin
  // Result := State;
end;

function TFailedState.ClassName: string;
begin
  Result := 'TFailedState';
end;

function TFailedState.LevelCompleted: TScreenState;
begin
  // Result := State;
end;

function TFailedState.LevelStarted: TScreenState;
begin
  State := TGameState.Create(tState);
  Result := State;
end;

end.
