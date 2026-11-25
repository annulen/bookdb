test:
	DBIC_TRACE=1 prove -lrv t

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

create_ddl:
	perl -Ilib -M BookDb -e 'BookDb->connect(":memory:")->create_ddl_dir([SQLite])'

prompt:
	{ printf '\n---\n\n'; files-to-prompt -m `git ls-tree --full-tree --name-only -r HEAD`; } | xclip

.PHONY: test cover create_ddl prompt
