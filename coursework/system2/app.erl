% Mingfei Yao (my1914)

-module(app).
-export([start/1]).

start(P_number) ->
  receive
    {bind, PL, Printer} -> 
      waitForTask(P_number, PL, Printer)
  end.

waitForTask(P_number, PL, Printer) ->
  receive
    {pl_deliver, Max_messages, Timeout} -> 
      timer:send_after(Timeout, {timeout}),
      PL ! {broadcast, P_number},
      startTask(P_number, PL, 1, Max_messages, #{}, Printer)
  end.

startTask(P_number, PL, Messages_sent, Max_messages, Messages, Printer) ->
  receive
    {message, Source_P_number} -> 
      case maps:is_key(Source_P_number, Messages) of
        true ->
          New_Messages = maps:update(Source_P_number, maps:get(Source_P_number, Messages)+1, Messages),
          if 
            Messages_sent /= Max_messages ->
              PL ! {broadcast, P_number},
              startTask(P_number, PL, Messages_sent+1, Max_messages, New_Messages, Printer);
            true ->
              startTask(P_number, PL, Messages_sent, Max_messages, New_Messages, Printer)
          end;
        false -> 
          New_Messages = maps:put(Source_P_number, 1, Messages),
          if
            Messages_sent /= Max_messages ->
              PL ! {broadcast, P_number},
              startTask(P_number, PL, Messages_sent+1, Max_messages, New_Messages, Printer);
            true ->
              startTask(P_number, PL, Messages_sent, Max_messages, New_Messages, Printer)
          end
      end;
    {timeout} ->
      Printer ! {print, P_number, Messages_sent, Messages} 
  end.

