#!/usr/bin/env perl

use DBICx::TestDatabase;
use Test::More;

use strict;
use warnings;

my $schema = DBICx::TestDatabase->new('BookDb::Schema');

done_testing();
