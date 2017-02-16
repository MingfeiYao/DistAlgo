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
  % Outcome for whether or not to drop message
  Outcome = rand:uniform(100),
  receive
    {pl_deliver, Max_messages, Timeout} ->
      Beb ! {pl_deliver, Max_messages, Timeout};
    {pl_broadcast, P_number} ->
      Beb ! {pl_message, P_number};
    {beb_broadcast, P_number} ->
      if 
        Outcome =< Rel ->
          [ LPL ! {pl_broadcast, P_number} || LPL <- LPLS ];
        true -> true
      end
  end,
  waitForMessage(LPLS, Rel, Beb).
