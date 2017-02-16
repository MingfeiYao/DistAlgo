% Mingfei Yao (my1914)

-module(pl).
-export([start/0]).

start() ->
  receive
    {bind, PLS} ->
      bindBeb(PLS)
  end.

bindBeb(PLS) ->
  receive
    {bind, Beb} -> 
      waitForMessage(PLS, Beb)
  end.

waitForMessage(PLS, Beb) ->
  receive
    {pl_deliver, Max_messages, Timeout} ->
      Beb ! {pl_deliver, Max_messages, Timeout};
    {pl_broadcast, P_number} ->
      Beb ! {pl_deliver, P_number};
    {beb_broadcast, P_number} ->
      [ PL ! {pl_broadcast, P_number} || PL <- PLS ]
  end,
  waitForMessage(PLS, Beb).
