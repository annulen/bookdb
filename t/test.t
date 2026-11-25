#!/usr/bin/env perl

use BookDb;
use Test::Fatal;
use Test::More;

use strict;
use warnings;

sub fixture {
    my $schema = BookDb->connect(':memory:');
    $schema->deploy;

    my $books = $schema->resultset('Book');
    my $tags = $schema->resultset('Tag');

    return $schema, $books, $tags;
}

subtest 'create / find' => sub {
    my ($schema, $books, $tags) = fixture();

    my $book = $books->create({
        title => 'SICP', author => 'Abelson, Sussman',
        year => 1985, filename => 'sicp.fb2',
    });
    ok $book->id, 'is_auto_increment works';
    ok $book->in_storage;
    is $books->find({ filename => 'sicp.fb2' }, { key => 'book_filename' })->id, $book->id;
};

subtest 'many_to_many' => sub {
    my ($schema, $books, $tags) = fixture();

    my $book = $books->create({ title => 'Dune',
                                author => 'Herbert',
                                year => 1965,
                                filename => 'dune.epub' });
    my $scifi = $tags->find_or_create({ name => 'sci-fi' }, { key => 'tag_name' });

    $book->add_to_tags($scifi);                 # только строка в book_tags
    is $book->tags->count, 1;
    is $scifi->books->count, 1;                 # обратная сторона

    $book->remove_from_tags($scifi);            # связь удалена, тег жив
    is $book->tags->count, 0;
    ok $tags->find({ name => 'sci-fi' }), 'тег не удалён';

    $book->set_tags([$scifi]);                  # заменяет только связи
    is $tags->count, 1, 'set_tags не трогает сами теги';
};

subtest 'unique + cascade' => sub {
    my ($schema, $books, $tags) = fixture();

    $books->create({ title => 'Dune',
                     author => 'Herbert',
                     year => 1965,
                     filename => 'dune.epub' });
    $tags->find_or_create({ name => 'sci-fi' }, { key => 'tag_name' });

    ok exception { $tags->create({ name => 'sci-fi' }) }, 'дубль тега запрещён';

    my $book = $books->find({ filename => 'dune.epub' }, { key => 'book_filename' });
    my $id = $book->id;
    $book->delete;                              # Row->delete каскадирует
    is $schema->resultset('BookTag')->search({ book_id => $id })->count, 0;
};

done_testing();
