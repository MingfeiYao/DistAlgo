# Distributed coursework
# Mingfei Yao (my1914)

MODULES = system5 process printer app lossypl beb

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

SYSTEM	= system5
L_ERL	= erl -noshell -pa ebin -setcookie pass

run:	all
	$(L_ERL) -s $(SYSTEM) start

