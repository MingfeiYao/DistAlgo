% Mingfei Yao (my1914)

-module(pl).
-export([start/0]).

start() ->
  receive
    {bind, PLS} ->
      bindApp(PLS)
  end.

bindApp(PLS) ->
  receive
    {bind, App} -> 
      waitForMessage(PLS, App)
  end.

waitForMessage(PLS, App) ->
  receive
    {message, P_number} ->
      App ! {message, P_number},
      waitForMessage(PLS, App);
    {broadcast, P_number} ->
      [ PL ! {message, P_number} || PL <- PLS ],
      waitForMessage(PLS, App)
  end.
