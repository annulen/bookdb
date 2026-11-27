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
    plan tests => 3;
    my ($schema, $books, $tags) = fixture();
    my ($book, $scifi) = fixture_dune($books, $tags);

    my $on = $schema->storage->dbh->selectrow_arrayref('PRAGMA foreign_keys');
    is_deeply $on, [1], 'foreign_keys pragma is enabled';
    like exception {
        $schema->resultset('BookTag')->create({ book_id => $book->id, tag_id => 42 })
    }, qr/FOREIGN KEY constraint/, 'cannot insert book_tag link with orphan tag_id';
    like exception {
        $schema->resultset('BookTag')->create({ book_id => 42, tag_id => $scifi->id })
    }, qr/FOREIGN KEY constraint/, 'cannot insert book_tag link with orphan book_id';
};

subtest 'create / find' => sub {
    plan tests => 3;
    my ($schema, $books, $tags) = fixture();

    my $book = $books->create({
        title => 'SICP', author => 'Abelson, Sussman',
        year => 1985, filename => 'sicp.fb2',
    });
    ok $book->id, 'is_auto_increment on books.id works';
    ok $book->in_storage, 'created book object corresponds to the row in storage';
    is $books->find({ filename => 'sicp.fb2' }, { key => 'book_filename' })->id, $book->id, 'find by books.filename works';
};

subtest 'many_to_many' => sub {
    plan tests => 5;
    my ($schema, $books, $tags) = fixture();
    my ($book, $scifi) = fixture_dune($books, $tags);

    $book->add_to_tags($scifi);                 # только строка в book_tags
    is $book->tags->count, 1, 'verify number of tags for given book';
    is $scifi->books->count, 1, 'verify number of books for given tag';

    $book->remove_from_tags($scifi);            # связь удалена, тег жив
    is $book->tags->count, 0, 'ensure book is correctly removed from tag';
    ok $tags->find({ name => 'sci-fi' }), 'ensure tag is preserved after deletion of the last book';

    $book->set_tags([$scifi]);                  # заменяет только связи
    is $tags->count, 1, "set_tags doesn't affect tags table";
};

subtest 'unique' => sub {
    plan tests => 2;
    my ($schema, $books, $tags) = fixture();
    fixture_dune($books, $tags);

    like exception { $tags->create({ name => 'sci-fi' }) }, qr/UNIQUE constraint/, 'duplicate tags are forbidden';

    ok $books->find({ filename => 'dune.epub' }, { key => 'book_filename' }), 'find by unique index works';
};

subtest 'cascade: Row->delete' => sub {
    plan tests => 3;
    my ($schema, $books, $tags) = fixture();
    my ($book, $tag) = fixture_dune($books, $tags);

    $book->add_to_tags($tag);

    my $links = $schema->resultset('BookTag');
    is $links->count, 1, 'link exists before deletion';

    $book->delete;
    is $links->count, 0, 'ORM cascade removes dangling link';
    is $tags->count, 1, 'tag is preserved';
};

subtest 'cascade: ResultSet->delete' => sub {
    plan tests => 4;
    my ($schema, $books, $tags) = fixture();
    my ($book, $tag) = fixture_dune($books, $tags);

    $book->add_to_tags($tag);

    my $links = $schema->resultset('BookTag');
    is $links->count, 1, 'link exists before deletion';

    $books->search_rs({ filename => 'dune.epub' })->delete;  # SQL DELETE without ORM cascade
    is $links->count, 0, 'dangling link removed by ON DELETE CASCADE inside DB';
    is $books->count, 0, 'book is deleted';
    is $tags->count, 1, 'tag is preserved';
};
