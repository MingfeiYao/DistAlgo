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
    {message, P_number} ->
      Beb ! {message, P_number},
      waitForMessage(PLS, Beb);
    {broadcast, P_number} ->
      [ PL ! {message, P_number} || PL <- PLS ],
      waitForMessage(PLS, Beb)
  end.
