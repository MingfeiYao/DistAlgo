% Mingfei Yao (my1914)

-module(printer).
-export([print/0]).

% Shared resource for printing out map contents
print() ->

  receive
    {print, P_number, Messages_sent, Messages} ->
      io:format("~p ", [P_number]),
      Keys = maps:keys(Messages),
      [ io:format("{~p,~p} ", [ Messages_sent, maps:get(Key, Messages)]) || Key <- Keys],
      io:format("~n"),
      print()
  end.

