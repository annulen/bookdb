#!/usr/bin/env perl

use BookDb;
use Test::Fatal;
use Test::More;

use strict;
use warnings;

like exception { BookDb->connect; }, qr/empty \$file/, 'connect without filename is not allowed';
like exception { BookDb->connect(''); }, qr/empty \$file/, 'connect without filename is not allowed';

done_testing();
