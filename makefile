#!/usr/bin/make -f

.PHONY: install revert setup test

install:
	./install.sh

revert:
	./revert.sh

setup:
	git config core.hooksPath .github/hooks

test:
	shellcheck -s bash install.sh revert.sh scripts/startup-time.sh
	shellcheck -s bash lib/.aliases lib/.bash_profile lib/.bash_prompt lib/.exports lib/.extra lib/.functions lib/.path
	./scripts/startup-time.sh