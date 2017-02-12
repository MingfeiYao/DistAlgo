% Mingfei Yao (my1914)

-module(lossypl).
-export([start/1]).

start(Rel) ->
  receive
    {bind, LPLS} ->
      bindBeb(LPLS, Rel)
  end.

bindBeb(LPLS, Rel) ->
  receive
    {bind, Beb} -> 
      waitForMessage(LPLS, Rel, Beb)
  end.

waitForMessage(LPLS, Rel, Beb) ->
  Outcome = rand:uniform(100),
  receive
    {message, P_number} ->
      Beb ! {message, P_number},
      waitForMessage(LPLS, Rel, Beb);
    {broadcast, P_number} ->
      if 
        Outcome =< Rel ->
          [ LPL ! {message, P_number} || LPL <- LPLS ];
        true -> true
      end,
      waitForMessage(LPLS, Rel, Beb)
  end.
