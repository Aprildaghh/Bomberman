unit TooMuchBombPowerup;

interface

uses PowerupStrategy, Observer;

type
  TTooMuchBombPowerup = class (TPowerupStrategy)
    public constructor Create(observer: TObserver);
  end;

implementation

{ TTooMuchBombPowerup }

constructor TTooMuchBombPowerup.Create(observer: TObserver);
begin
  inherited Create(observer);
end;

end.
