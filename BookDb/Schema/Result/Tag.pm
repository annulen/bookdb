package BookDb::Schema::Result::Tag;
use base 'DBIx::Class::Core';

__PACKAGE__->table('tags');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

__PACKAGE__->has_many(
    'book_tags',
    'BookDb::Schema::Result::BookTag',
    'tag_id'
);

__PACKAGE__->many_to_many('books' => 'book_tags', 'book');

1;

