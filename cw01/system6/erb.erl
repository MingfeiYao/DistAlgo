% Mingfei Yao (my1914)

-module(erb).
-export([start/0]).

start() -> 
  receive
    {bind, Beb} ->
      bindApp(Beb)
  end.

bindApp(Beb) ->
  receive
    {bind, App} -> waitForMessages(Beb, App, [])
  end.

waitForMessages(Beb, App, Seen) ->
  receive
    {pl_deliver, Max_messages, Timeout} ->
      App ! {pl_deliver, Max_messages, Timeout};
    {pl_message, Source_P_number} -> 
      case lists:member(Source_P_number, Seen) of
        true -> true;
        false -> 
          App ! {message, Source_P_number},
          waitForMessages(Beb, App, Seen ++ [Source_P_number])
      end;
    {broadcast, P_number} ->
      Beb ! {erb_broadcast, P_number}
  end,
  waitForMessages(Beb, App, Seen).
