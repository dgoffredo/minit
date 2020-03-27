# minit: the make-based init system

# This makefile requires GNU make.

SERVICES := $(patsubst services/%,%,$(wildcard services/*))

# Start all of the services.
.PHONY: start
start: $(patsubst %,started/%,$(SERVICES))

# Stop all of the services.
.PHONY: stop
stop: $(patsubst %,started/%,$(SERVICES))

# "clean" is a phony (doesn't produce a file) target used to delete all
# placeholder files produced by this makefile.
.PHONY: clean
clean:
	rm -f started/* stopped/* \
	      makefiles/* \
		  dependencies.edges dependents/*

# TODO: document
makefiles/%: services/%/deps dependents/%
	bin/service-makefile $(patsubst makefiles/%,%,$@) $^ >$@

dependencies.edges: services/*/deps
	bin/combine-dependencies $^ >$@

dependents/%: dependencies.edges
	sed -n 's/^\(\S\+\) $(patsubst dependents/%,%,$@)$$/\1/p' $< | \
		sort | \
		uniq >$@

# Include the generated makefiles, one for each service.  These makefiles
# contain the rules for starting and stopping each service.
include $(patsubst %,makefiles/%,$(SERVICES))
