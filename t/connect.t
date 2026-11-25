#!/usr/bin/env perl

use BookDb;
use Test::Fatal;
use Test::More;

use strict;
use warnings;

ok exception { BookDb->connect; }, 'connect without filename is not allowed';

done_testing();
