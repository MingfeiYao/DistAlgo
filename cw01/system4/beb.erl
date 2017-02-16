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
    {pl_deliver, Max_messages, Timeout} ->
      APP ! {pl_deliver, Max_messages, Timeout};
    {broadcast, P_number} -> 
      PL ! {beb_broadcast, P_number};
    {pl_message, P_number} ->
      APP ! {pl_message, P_number}
  end,
  waitForMessage(PL, APP).
