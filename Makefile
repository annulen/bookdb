test:
	prove -lr t

test_trace:
	DBIC_TRACE=1 prove -lrv t

critic:
	perlcritic .

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

create_ddl:
	mkdir -p sql
	perl -Ilib -MBookDb -e 'BookDb->connect(":memory:")->create_ddl_dir([ "SQLite" ], undef, "sql")'

prompt:
	{ printf '\n---\n\n'; files-to-prompt -m `git ls-tree --full-tree --name-only -r HEAD`; } | xclip

.PHONY: test test_trace critic cover create_ddl prompt
