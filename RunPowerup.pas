unit RunPowerup;

interface

uses PowerupStrategy, Observer;

type
  TRunPowerup = class(TPowerupStrategy)
      public constructor Create(observer: TObserver);
  end;

implementation

{ TRunPowerup }

constructor TRunPowerup.Create(observer: TObserver);
begin
  inherited Create(observer);
end;

end.
