package BookDb;

use BookDb::Schema;
use strict;
use warnings;

sub connect {
    my ($class, $file) = @_;
    return BookDb::Schema->connect(
        "dbi:SQLite:dbname=$file", '', '',
        { sqlite_unicode  => 1 },
        { on_connect_call => 'use_foreign_keys' },
    );
}

1;
