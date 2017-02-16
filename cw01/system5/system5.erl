% Mingfei Yao (my1914)

-module(system5).
-export([start/0]).

start() -> 
  Reliability = 100,
  Processes = [spawn(process, start, [self(), Reliability]) || _ <- lists:seq(1,5)],
  waitForPL([],length(Processes)).

waitForPL(LPLS, 0) ->
  Printer = spawn(printer, print, []),
  [ LPL ! {bind, LPLS} || LPL <- LPLS ],
  APPS = [ spawn(app, start, [P_number, length(LPLS)]) ||  P_number <- lists:seq(1,length(LPLS))],
  BEB = [ spawn(beb, start, []) || _ <- lists:seq(1, length(LPLS)) ],
  Bonds = lists:zip(APPS, lists:zip(BEB, LPLS)),
  % Binding components
  [ begin App ! {bind, Beb, Printer}, Lpl ! {bind, App}, Beb ! {bind, Lpl, App} end || {App, {Beb, Lpl}} <- Bonds],
  Max_messages = -100,
  Timeout = 1000,
  [ LPL ! {pl_deliver, Max_messages, Timeout} || LPL <- LPLS ],
  % Terminate process 3 after 5 milliseconds
  timer:send_after(5, lists:nth(3, APPS), {timeout});

waitForPL(LPLS, LeftOver) ->
  receive 
    {lpl, LPL} -> 
      waitForPL([LPL|LPLS], LeftOver -1)
    after 1000 ->
      io:format("Failed to receive all PLs.~n"),
      waitForPL(LPLS, 0)
  end.
 
