requires 'DBIx::Class';
requires 'DBD::SQLite';
requires 'SQL::Translator';

on 'test' => sub {
    requires 'Test::More';
}
