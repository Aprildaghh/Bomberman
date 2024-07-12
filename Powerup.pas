unit Powerup;

interface

uses PowerupStrategy, System.Generics.Collections, Subject, Observer,
  RunPowerUp, ShieldPowerUp, TooMuchBombPowerup;

type
  TPowerup = class (TInterfacedObject, TObserver)
    private
      PowerupStrategy       : TPowerupStrategy;
      currentPowers         : TList<TPowerupStrategy>;

      RunActive,
      TooMuchBombActive,
      ShieldActive        : Boolean;

    public
      property IsRunActive          : Boolean read RunActive;
      property IsTooMuchBombActive  : Boolean read TooMuchBombActive;
      property IsShieldActive       : Boolean read ShieldActive;

      procedure Update(Sender: TSubject);
      procedure PowerUp;
      procedure UpdatePowerups;

      function ToString  : String;

      constructor Create;
  end;

implementation

{ TPowerup }

constructor TPowerup.Create;
begin
  PowerupStrategy := TPowerupStrategy.Create(self);
  currentPowers := TList<TPowerupStrategy>.Create;
  RunActive := False;
  TooMuchBombActive := False;
  ShieldActive := False;
end;

function TPowerup.ToString: String;
var str: string;
  i: Integer;
begin
  str := '';

  if currentPowers.Count = 0 then
    str := 'None';

  for i := 0 to currentPowers.Count - 1 do
  begin
    str := str + Copy(currentPowers.ToArray[i].ToString, 2, Length(currentPowers.ToArray[i].ToString));
    if i <> currentPowers.Count - 1 then str := str + ', ';
  end;

  Result := str;

end;

procedure TPowerup.PowerUp;
var
  randomPowerIndex: Integer;
begin
  randomize;
  randomPowerIndex := random(2);

  if randomPowerIndex = 0 then
  begin
    RunActive := True;
    currentPowers.Add(TRunPowerup.Create(self));
  end
  else if randomPowerIndex = 1 then
  begin
    ShieldActive := True;
    currentPowers.Add(TShieldPowerup.Create(self));
  end
  else if randomPowerIndex = 2 then
  begin
    TooMuchBombActive := True;
    currentPowers.Add(TTooMuchBombPowerup.Create(self));
  end

end;

procedure TPowerup.Update(Sender: TSubject);
begin

  if Sender is TRunPowerup then
  begin
    RunActive := False;
    currentPowers.Remove(TPowerupStrategy(Sender));
  end
  else if Sender is TTooMuchBombPowerup then
  begin
    TooMuchBombActive := False;
    currentPowers.Remove(TPowerupStrategy(Sender));
  end
  else if Sender is TShieldPowerup then
  begin
    ShieldActive := False;
    currentPowers.Remove(TPowerupStrategy(Sender));
  end;

end;

procedure TPowerup.UpdatePowerups;
var
  i: Integer;
begin
  for i := 0 to currentPowers.Count - 1 do
    currentPowers.ToArray[i].Update;
end;

end.
