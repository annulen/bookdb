Trying to organize my e-book collection and learn DBIx::Class at the same time

## Perl dependencies

See [cpanfile](cpanfile).

## Additional software used for development

* `checkmake` - linter/analyzer for Makefiles
```
go install github.com/checkmake/checkmake/cmd/checkmake@latest
```

Following software is required for `make prompt` target:

* `files-to-prompt-rust`
```
cargo install files-to-prompt
```
* `xclip`
