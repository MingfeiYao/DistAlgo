# Distributed coursework
# Mingfei Yao (my1914)

MODULES = system1 system2 system3 process1 process2 printer pl app

# Build

ERLC 	= erlc -o ebin

ebin/%.beam: %.erl
	$(ERLC) $<

all:	ebin ${MODULES:%=ebin/%.beam}

ebin: 
	mkdir ebin

.PHONY: clean
clean: 
	rm -f ebin/* erl_crash.dump

# Run

SYSTEM	= system1
L_ERL	= erl -noshell -pa ebin -setcookie pass

run1:	all
	$(L_ERL) -s $(SYSTEM) start

SYSTEM2	= system2

run2:	all
	$(L_ERL) -s $(SYSTEM2) start

SYSTEM3	= system3

run3:	all
	$(L_ERL) -s $(SYSTEM3) start
