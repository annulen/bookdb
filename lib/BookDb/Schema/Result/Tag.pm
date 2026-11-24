package BookDb::Schema::Result::Tag;
use parent 'DBIx::Class::Core';

__PACKAGE__->table('tags');
__PACKAGE__->add_columns(
    id => { data_type => 'integer', is_auto_increment => 1 },
    name => { data_type => 'text' },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

__PACKAGE__->has_many(
    'book_tags',
    'BookDb::Schema::Result::BookTag',
    'tag_id'
);

__PACKAGE__->many_to_many('books' => 'book_tags', 'book');

1;

