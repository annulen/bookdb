#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";
use BookDb;

use strict;
use warnings;

my ($dir, $ver_new, $ver_old) = @ARGV;

die "Usage: $0 output_dir [new_version old_version]"
    unless defined $dir && length $dir;

-d $dir or mkdir $dir;

my $s = BookDb->connect(":memory:");
$s->create_ddl_dir([ "SQLite" ], $ver_new, $dir, $ver_old, { add_drop_table => 0, no_comments => 1 });
