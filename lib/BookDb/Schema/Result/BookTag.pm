package BookDb::Schema::Result::BookTag;
use base 'DBIx::Class::Core';

__PACKAGE__->table('book_tags');
__PACKAGE__->add_columns(qw/book_id tag_id/);
__PACKAGE__->set_primary_key(qw/book_id tag_id/); # Composite primary key

__PACKAGE__->belongs_to('book' => 'BookDb::Schema::Result::Book', 'book_id');
__PACKAGE__->belongs_to('tag'  => 'BookDb::Schema::Result::Tag',  'tag_id');

1;

