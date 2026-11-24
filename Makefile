test:
	DBIC_TRACE=1 prove -lrv t

cover:
	cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover

prompt:
	{ printf '\n---\n\n'; files-to-prompt -m .; } | xclip -selection clipboard

.PHONY: test cover prompt
