package BookDb::Schema::ResultSet::Tag;
use parent 'DBIx::Class::ResultSet';

use strict;
use warnings;

sub ensure_by_name {
    my ($self, $tag_name) = @_;
    return $self->find_or_create({ name => $tag_name }, { key => 'tag_name' });
}

1;

