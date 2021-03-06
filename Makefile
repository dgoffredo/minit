
PREFIX ?= /usr/local

.PHONY: install
install:
	mkdir -p $(PREFIX)/etc/minit && cp -r src/etc/minit $(PREFIX)/etc
	mkdir -p $(PREFIX)/etc/minit/services
	mkdir -p $(PREFIX)/etc/minit/started
	mkdir -p $(PREFIX)/etc/minit/stopped
	mkdir -p $(PREFIX)/etc/minit/makefiles
	mkdir -p $(PREFIX)/var/log/minit
	mkdir -p $(PREFIX)/bin && cp src/bin/minit $(PREFIX)/bin/minit

.PHONY: uninstall
uninstall:
	rm -r $(PREFIX)/etc/minit
	rm -r $(PREFIX)/var/log/minit
	rm $(PREFIX)/bin/minit
