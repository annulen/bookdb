#!/usr/bin/env perl

use BookDb;
use Test::Fatal;
use Test::More tests => 6;

use strict;
use warnings;

sub fixture {
    my $schema = BookDb->connect(':memory:');
    $schema->deploy;

    my $books = $schema->resultset('Book');
    my $tags = $schema->resultset('Tag');

    return $schema, $books, $tags;
}

sub fixture_dune {
    my ($books, $tags) = @_;
    my $book = $books->create({ title => 'Dune',
                                author => 'Herbert',
                                year => 1965,
                                filename => 'dune.epub' });
    my $tag = $tags->find_or_create({ name => 'sci-fi' }, { key => 'tag_name' });
    return $book, $tag;
}

subtest 'foreign keys' => sub {
    plan tests => 2;
    my ($schema) = fixture();

    my $on = $schema->storage->dbh->selectrow_arrayref('PRAGMA foreign_keys');
    is_deeply $on, [1], 'прагма включена';
    like exception {
        $schema->resultset('BookTag')->create({ book_id => 42, tag_id => 42 })
    }, qr/FOREIGN KEY constraint/, 'сирота не создаётся';
};

subtest 'create / find' => sub {
    plan tests => 3;
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
    plan tests => 5;
    my ($schema, $books, $tags) = fixture();
    my ($book, $scifi) = fixture_dune($books, $tags);

    $book->add_to_tags($scifi);                 # только строка в book_tags
    is $book->tags->count, 1;
    is $scifi->books->count, 1;                 # обратная сторона

    $book->remove_from_tags($scifi);            # связь удалена, тег жив
    is $book->tags->count, 0;
    ok $tags->find({ name => 'sci-fi' }), 'тег не удалён';

    $book->set_tags([$scifi]);                  # заменяет только связи
    is $tags->count, 1, 'set_tags не трогает сами теги';
};

subtest 'unique' => sub {
    plan tests => 2;
    my ($schema, $books, $tags) = fixture();
    fixture_dune($books, $tags);

    like exception { $tags->create({ name => 'sci-fi' }) }, qr/UNIQUE constraint/, 'дубль тега запрещён';

    ok $books->find({ filename => 'dune.epub' }, { key => 'book_filename' });
};

subtest 'cascade: Row->delete' => sub {
    plan tests => 3;
    my ($schema, $books, $tags) = fixture();
    my ($book, $tag) = fixture_dune($books, $tags);

    $book->add_to_tags($tag);

    my $links = $schema->resultset('BookTag');
    is $links->count, 1, 'связь есть до удаления';   # вот эта строка делает тест осмысленным

    $book->delete;
    is $links->count, 0, 'ORM-каскад снёс связь';
    is $tags->count, 1, 'сам тег жив';
};

subtest 'cascade: ResultSet->delete' => sub {
    plan tests => 4;
    my ($schema, $books, $tags) = fixture();
    my ($book, $tag) = fixture_dune($books, $tags);

    $book->add_to_tags($tag);

    my $links = $schema->resultset('BookTag');
    is $links->count, 1;

    $books->search_rs({ filename => 'dune.epub' })->delete;  # один SQL, без ORM-каскадов
    is $links->count, 0, 'сработал ON DELETE CASCADE уже в БД';
    is $books->count, 0;
    is $tags->count, 1;
};
