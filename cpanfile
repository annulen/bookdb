requires 'DBIx::Class';
requires 'DBD::SQLite';
requires 'SQL::Translator';

on 'develop' => sub {
    requires 'Devel::Cover';
};

on 'test' => sub {
    requires 'Test::More';
}
