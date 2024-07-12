unit Observer;

interface

uses Subject;

type

  TObserver = interface
      procedure Update(Sender: TSubject);
  end;

implementation

end.
