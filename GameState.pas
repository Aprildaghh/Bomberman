unit GameState;

interface

uses ScreenState;

type

  TGameState = class (TInterfacedObject, TScreenState)

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

{ TGameState }

uses FailedState, LevelStartState;

constructor TGameState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TGameState.Create;
begin

end;

procedure TGameState.Died;
begin
  State := TFailedState.Create(tState);
end;

function TGameState.getStateName: string;
begin
  Result := 'TGameState';
end;

procedure TGameState.LevelCompleted;
begin
  State := TLevelStartState.Create(tState);
end;

procedure TGameState.LevelStarted;
begin
// do nothing
end;

end.
