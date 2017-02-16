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
    {pl_deliver, Max_messages, Timeout} ->
      App ! {pl_deliver, Max_messages, Timeout};
    {pl_deliver, P_number} ->
      % Receiving messages from others,
      % Forward to App
      App ! {pl_deliver, P_number};
    {pl_send, P_number} ->
      % App broadcasts messages
      % Forward to other PLs
      [ PL ! {pl_deliver, P_number} || PL <- PLS ]
  end,
  waitForMessage(PLS, App).
