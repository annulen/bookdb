SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

prompt-tmp := .prompt-tmp

all: test

clean:

test:
	prove -lr t

test_trace:
	DBIC_TRACE=1 prove -lrv t

critic:
	checkmake Makefile
	perlcritic .

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

create_ddl:
	scripts/create_ddl.pl sql

prompt:
	rm -rf $(prompt-tmp)
	mkdir -p $(prompt-tmp)
	git archive HEAD | tar -x -C $(prompt-tmp)
	{ printf '\n---\n\n'; (cd $(prompt-tmp) && files-to-prompt -m --include-hidden .); } | xclip
	rm -rf $(prompt-tmp)

.PHONY: all clean test test_trace critic cover create_ddl prompt
