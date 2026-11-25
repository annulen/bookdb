requires 'perl', '5.030';
requires 'DBIx::Class';
requires 'DBD::SQLite';
requires 'SQL::Translator', '1.60';

on 'develop' => sub {
    requires 'Devel::Cover';
};

on 'test' => sub {
    requires 'Test::Fatal';
    requires 'Test::More';
}
