package BookDb::Schema::Result::Book;
use parent 'DBIx::Class::Core';

use strict;
use warnings;

__PACKAGE__->table('books');
__PACKAGE__->add_columns(
    id => { data_type => 'integer', is_auto_increment => 1 },
    title => { data_type => 'text' },
    author => { data_type => 'text' },
    translator => { data_type => 'text', is_nullable => 1 },
    year => { data_type => 'integer' },
    filename => { data_type => 'text' },
    summary => { data_type => 'text', is_nullable => 1 },
    comment => { data_type => 'text', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    'book_tags',
    'BookDb::Schema::Result::BookTag',
    'book_id'
);

__PACKAGE__->many_to_many('tags' => 'book_tags', 'tag');

1;

