% Mingfei Yao (my1914)
-module(system2).
-export([start/0]).

start() -> 
  Processes = [spawn(process, start, [self()]) || _ <- lists:seq(1,5)],
  waitForPL([],length(Processes)).

waitForPL(PLS, 0) ->
  Printer = spawn(printer, print, []),
  [ PL ! {bind, PLS} || PL <- PLS ],
  APPS = [ spawn(app, start, [P_number]) ||  P_number <- lists:seq(1,length(PLS))],
  Bonds = lists:zip(APPS, PLS),
  [ begin App ! {bind, Pl, Printer}, Pl ! {bind, App} end || {App, Pl} <- Bonds],
  Max_messages = -1000,
  Timeout = 3000,
  [APP ! {pl_deliver, Max_messages, Timeout} || APP <- APPS ];

waitForPL(PLS, LeftOver) ->
  receive 
    {pl, PL} -> 
      waitForPL([PL|PLS], LeftOver -1)
    after 1000 ->
      io:format("Failed to receive all PLs.~n"),
      waitForPL(PLS, 0)
  end.
 
