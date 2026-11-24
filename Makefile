test:
	DBIC_TRACE=1 prove -lrv t

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

prompt:
	echo -e '\n---\n' | cat - <(files-to-prompt -m .) | xclip
