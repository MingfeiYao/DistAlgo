% Mingfei Yao (my1914)

-module(beb).
-export([start/0]).

start() ->
  receive
    {bind, PL, Erb} ->
      waitForMessage(PL, Erb)
  end.

waitForMessage(PL, Erb) ->
  receive
    {pl_deliver, Max_messages, Timeout} ->
      Erb ! {pl_deliver, Max_messages, Timeout};
    {erb_broadcast, P_number} -> 
      PL ! {beb_broadcast, P_number};
    {message, P_number} ->
      Erb ! {pl_message, P_number}
  end,
  waitForMessage(PL, Erb).
