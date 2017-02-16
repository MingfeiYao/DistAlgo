% Mingfei Yao (my1914)

-module(system6).
-export([start/0]).

start() -> 
  Reliability = 80,
  Processes = [spawn(process, start, [self(), Reliability]) || _ <- lists:seq(1,5)],
  waitForPL([],length(Processes)).

waitForPL(LPLS, 0) ->
  Printer = spawn(printer, print, []),
  [ LPL ! {bind, LPLS} || LPL <- LPLS ],
  APPS = [ spawn(app, start, [P_number, length(LPLS)]) ||  P_number <- lists:seq(1,length(LPLS))],
  BEB = [ spawn(beb, start, []) || _ <- lists:seq(1, length(LPLS)) ],
  ERB = [ spawn(erb, start, []) || _ <- lists:seq(1, length(LPLS)) ],
  Bonds = lists:zip(ERB, lists:zip(BEB, LPLS)),
  APP_ERB = lists:zip(APPS, ERB),
  % Binding messages
  [ begin Erb ! {bind, Beb}, Lpl ! {bind, Erb}, Beb ! {bind, Lpl, Erb} end || {Erb, {Beb, Lpl}} <- Bonds],
  [ begin App ! {bind, Erb, Printer}, Erb ! {bind, App} end || {App, Erb} <- APP_ERB ],
  Max_messages = -1000,
  Timeout = 1000,
  [ LPL ! {pl_deliver, Max_messages, Timeout} || LPL <- LPLS ],
  % Terminates process 3 after 5 milliseconds
  timer:send_after(5, lists:nth(3, APPS), {timeout});

waitForPL(LPLS, LeftOver) ->
  receive 
    {lpl, LPL} -> 
      waitForPL([LPL|LPLS], LeftOver -1)
    after 1000 ->
      io:format("Failed to receive all PLs.~n"),
      waitForPL(LPLS, 0)
  end.
 
