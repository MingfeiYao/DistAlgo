% Mingfei Yao (my1914)
-module(system1).
-export([start/0]).

start() -> 
  Processes = [spawn(process, start, [P_number]) || P_number <- lists:seq(1,5)],
  Printer = spawn(printer, print, []),
  Max_messages = -1000,
  Timeout = 3000,
  [Process ! {bind, Processes, Printer} || Process <- Processes],
  [Process ! {task1, start, Max_messages, Timeout} || Process <- Processes].
