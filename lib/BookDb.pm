package BookDb;

use BookDb::Schema;
use Carp qw(croak);
use strict;
use warnings;

sub connect {
    my ($class, $file) = @_;
    croak 'Usage: BookDb->connect($file)' unless defined $file && length $file;

    return BookDb::Schema->connect(
        "dbi:SQLite:dbname=$file", '', '',
        { sqlite_unicode  => 1 },
        { on_connect_call => 'use_foreign_keys' },
    );
}

1;
