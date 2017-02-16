% Mingfei Yao (my1914)

-module(process).
-export([start/1]).

start(System) ->
  PL = spawn(pl, start, []),
  System ! {pl, PL}.
