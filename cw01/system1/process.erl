% Mingfei Yao (my1914)

-module(process).
-export([start/1]).

% Binding processes and printer
start(P_number) ->
  receive 
    {bind, Processes, Printer} -> waitForMessages(P_number, Processes, Printer)
  end.

% Wait for task1 to start.
waitForMessages(P_number, Processes, Printer) ->
  Message_list = [ {N, 0} || N <- lists:seq(1, length(Processes))],
  Messages = maps:from_list(Message_list),
  receive 
    {task1, start, Max_messages, Timeout} ->
      timer:send_after(Timeout, {timeout}),
      broadcastAndReceive(P_number, Processes, 0, Max_messages, Messages, Printer)
  end.

broadcastAndReceive(P_number, Processes, Messages_sent, Max_messages, Messages, Printer) ->
  receive
    {message, Source_P_number} -> 
      New_messages = maps:update(Source_P_number, maps:get(Source_P_number, Messages)+1, Messages),
      broadcastAndReceive(P_number, Processes, Messages_sent, Max_messages, New_messages, Printer);
    % Timeout received
    {timeout} ->
      Printer ! {print, P_number, Messages_sent, Messages},
      exit(normal)
    % if message queue empty, send messages. Cannot predict state of message queue.
    after 0 ->
      if 
        Messages_sent /= Max_messages ->
          [Process ! {message, P_number} || Process <- Processes],
          broadcastAndReceive(P_number, Processes, Messages_sent + 1, Max_messages, Messages, Printer);
        true -> 
          broadcastAndReceive(P_number, Processes, Messages_sent, Max_messages, Messages, Printer)
      end
  end.
