package BookDb::Schema::Result::Book;
use base 'DBIx::Class::Core';

__PACKAGE__->table('books');
__PACKAGE__->add_columns(qw/id title author/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    'book_tags',
    'BookDb::Schema::Result::BookTag',
    'book_id'
);

__PACKAGE__->many_to_many('tags' => 'book_tags', 'tag');

1;

