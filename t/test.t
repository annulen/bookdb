#!/usr/bin/env perl

use BookDb;
use Test::More;

use strict;
use warnings;

my $schema = BookDb->connect(':memory:');
$schema->deploy;

my $books = $schema->resultset('Book');
my $tags = $schema->resultset('Tag');

subtest 'create / find' => sub {
    my $book = $books->create({
        title => 'SICP', author => 'Abelson, Sussman',
        year => 1985, filename => 'sicp.fb2',
    });
    ok $book->id, 'is_auto_increment works';
    ok $book->in_storage;
    is $books->find({ filename => 'sicp.fb2' }, { key => 'book_filename' })->id, $book->id;
};

done_testing();
