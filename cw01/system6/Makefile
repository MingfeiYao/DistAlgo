# Distributed coursework
# Mingfei Yao (my1914)

MODULES = system6 process printer app lossypl beb erb

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

SYSTEM	= system6
L_ERL	= erl -noshell -pa ebin -setcookie pass

run:	all
	$(L_ERL) -s $(SYSTEM) start

