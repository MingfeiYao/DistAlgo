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
    {pl_deliver, Max_messages, Timeout} ->
      Beb ! {pl_deliver, Max_messages, Timeout};
    {pl_message, P_number} ->
      Beb ! {pl_message, P_number},
      [ LPL ! {pl_message, P_number} || LPL <- LPLS ];
    {beb_broadcast, P_number} ->
      if 
        Outcome =< Rel ->
          [ LPL ! {pl_message, P_number} || LPL <- LPLS ];
        true -> true
      end
  end,
  waitForMessage(LPLS, Rel, Beb).
