unit PowerupStrategy;

interface

uses Observer, Subject;

type

  TPowerupStrategy = class abstract (TInterfacedObject, TSubject)
    private
      timeLeft: Integer;
      observer: TObserver;

      const POWERUP_TIME: Integer = 15;

      procedure NotifyObserver;
    public
      procedure Update;

      constructor Create(observer: TObserver);
  end;

implementation

{ TPowerupStrategy }

constructor TPowerupStrategy.Create(observer: TObserver);
begin
  self.observer := observer;
  timeLeft := POWERUP_TIME;
end;

procedure TPowerupStrategy.NotifyObserver;
begin
  observer.Update(self);
end;

procedure TPowerupStrategy.Update;
begin
  dec(timeLeft);
  if timeLeft <= 0 then
    NotifyObserver;
end;

end.
