% Mingfei Yao (my1914)
-module(system3).
-export([start/0]).

start() -> 
  Processes = [spawn(process, start, [self()]) || _ <- lists:seq(1,5)],
  waitForPL([],length(Processes)).

waitForPL(PLS, 0) ->
  Printer = spawn(printer, print, []),
  [ PL ! {bind, PLS} || PL <- PLS ],
  APPS = [ spawn(app, start, [P_number]) ||  P_number <- lists:seq(1,length(PLS))],
  BEB = [ spawn(beb, start, []) || _ <- lists:seq(1, length(PLS)) ],
  Bonds = lists:zip(APPS, lists:zip(BEB, PLS)),
  % Binding app, pl, beb
  [ begin App ! {bind, Beb, Printer}, Pl ! {bind, App}, Beb ! {bind, Pl, App} end || {App, {Beb,Pl}} <- Bonds],
  % System parameters :
  Max_messages = 100,
  Timeout = 1000,
  [ PL ! {pl_deliver, Max_messages, Timeout} || PL <- PLS ];

waitForPL(PLS, LeftOver) ->
  receive 
    {pl, PL} -> 
      waitForPL([PL|PLS], LeftOver -1)
    after 1000 ->
      io:format("Failed to receive all PLs.~n"),
      waitForPL(PLS, 0)
  end.
 
