unit ShieldPowerup;

interface

uses PowerupStrategy, Observer;

type
  TShieldPowerup = class (TPowerupStrategy)
    public constructor Create(observer: TObserver);
  end;

implementation

{ TShieldPowerup }

constructor TShieldPowerup.Create(observer: TObserver);
begin
  inherited Create(observer);
end;

end.
