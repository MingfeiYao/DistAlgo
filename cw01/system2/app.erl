% Mingfei Yao (my1914)

-module(app).
-export([start/2]).

start(P_number, Num_p) ->
  receive
    {bind, PL, Printer} -> 
      waitForTask(P_number, PL, Num_p, Printer)
  end.

waitForTask(P_number, PL, Num_p, Printer) ->
  receive
    {pl_deliver, Max_messages, Timeout} -> 
      timer:send_after(Timeout, {timeout}),
      Initial_message = [ {P, 0} || P <- lists:seq(1, Num_p)],
      startTask(P_number, PL, 0, Max_messages, maps:from_list(Initial_message), Printer)
  end.

startTask(P_number, PL, Messages_sent, Max_messages, Messages, Printer) ->
  receive
    {pl_deliver, Source_P_number} -> 
      case maps:is_key(Source_P_number, Messages) of
        true ->
          New_Messages = maps:update(Source_P_number, maps:get(Source_P_number, Messages)+1, Messages),
          startTask(P_number, PL, Messages_sent, Max_messages, New_Messages, Printer);
        false -> 
          New_Messages = maps:put(Source_P_number, 1, Messages),
          startTask(P_number, PL, Messages_sent, Max_messages, New_Messages, Printer)
      end;
    {timeout} ->
      Printer ! {print, P_number, Messages_sent, Messages},
      exit(normal)
    after 0 ->
      if
        Messages_sent /= Max_messages ->
          PL ! {pl_send, P_number},
          startTask(P_number, PL, Messages_sent+1, Max_messages, Messages, Printer);
        true ->
          startTask(P_number, PL, Messages_sent, Max_messages, Messages, Printer)
      end
  end.

