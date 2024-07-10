unit ScreenState;

interface

type
  TScreenState = interface
    function LevelStarted: TScreenState;
    function Died: TScreenState;
    function LevelCompleted: TScreenState;
    function ClassName: String;
  end;

implementation

end.
