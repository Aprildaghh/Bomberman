unit LevelStartState;

interface

uses ScreenState, VCL.Dialogs;

type

  TLevelStartState = class (TInterfacedObject, TScreenState)

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

{ TLevelStartState }

uses FailedState, GameState, PassedState;

constructor TLevelStartState.Create(var tState: TScreenState);
begin
  State := tState;
end;

constructor TLevelStartState.Create;
begin

end;

function TLevelStartState.Died: TScreenState;
begin
  State := TFailedState.Create(tState);
  Result := State;
end;

function TLevelStartState.ClassName: string;
begin
  Result := 'TLevelStartState';
end;

function TLevelStartState.LevelCompleted: TScreenState;
begin
  State := TPassedState.Create(tState);
  Result := State;
end;

function TLevelStartState.LevelStarted: TScreenState;
begin
  State := TGameState.Create(tState);
  Result := State;
end;

end.
