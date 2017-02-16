% Mingfei Yao (my1914)

-module(process).
-export([start/2]).

start(System, Rel) ->
  LPL = spawn(lossypl, start, [Rel]),
  System ! {lpl, LPL}.
