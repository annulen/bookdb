#!/usr/bin/env perl

use BookDb;
use Test::More;

use strict;
use warnings;

my $schema = BookDb->connect(':memory:');
$schema->deploy;

done_testing();
