SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

test:
	prove -lr t

test_trace:
	DBIC_TRACE=1 prove -lrv t

critic:
	perlcritic .

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

create_ddl:
	scripts/create_ddl.pl sql

prompt-tmp := .prompt-tmp

prompt:
	rm -rf $(prompt-tmp)
	mkdir -p $(prompt-tmp)
	git archive HEAD | tar -x -C $(prompt-tmp)
	{ printf '\n---\n\n'; (cd $(prompt-tmp) && files-to-prompt -m .); } | xclip
	rm -rf $(prompt-tmp)

.PHONY: test test_trace critic cover create_ddl prompt
