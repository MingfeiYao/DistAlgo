% Mingfei Yao (my1914)

-module(beb).
-export([start/0]).

start() ->
  receive
    {bind, PL, APP} ->
      waitForMessage(PL, APP)
  end.

waitForMessage(PL, APP) ->
  receive
    {broadcast, P_number} -> 
      PL ! {broadcast, P_number};
    {message, P_number} ->
      APP ! {message, P_number}
  end,
  waitForMessage(PL, APP).
