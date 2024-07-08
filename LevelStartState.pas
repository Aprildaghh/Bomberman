unit LevelStartState;

interface

uses ScreenState;

type

  TLevelStartState = class (TInterfacedObject, TScreenState)

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

{ TLevelStartState }

uses FailedState, GameState;

constructor TLevelStartState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TLevelStartState.Create;
begin

end;

procedure TLevelStartState.Died;
begin
// do nothing
end;

function TLevelStartState.getStateName: string;
begin
  Result := 'TLevelStartState';
end;

procedure TLevelStartState.LevelCompleted;
begin
// do nothing
end;

procedure TLevelStartState.LevelStarted;
begin
  State := TGameState.Create(tState);
end;

end.
