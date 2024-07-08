unit FailedState;

interface

uses ScreenState;

type

  TFailedState = class (TInterfacedObject, TScreenState)

    private
    tState: TScreenState;

    public
      procedure LevelStarted;
      procedure Died;
      procedure LevelCompleted;
      function getStateName: string;

      property State: TScreenState read tState write tState;

      constructor Create; overload;
      constructor Create(var tState: TScreenState); overload;
  end;

implementation

{ TFailedState }
uses LevelStartState, GameState;

constructor TFailedState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TFailedState.Create;
begin

end;

procedure TFailedState.Died;
begin
// do nothing
end;

function TFailedState.getStateName: string;
begin
  Result := 'TFailedState';
end;

procedure TFailedState.LevelCompleted;
begin
// do nothing
end;

procedure TFailedState.LevelStarted;
begin
  State := TLevelStartState.Create(tState);
end;

end.
