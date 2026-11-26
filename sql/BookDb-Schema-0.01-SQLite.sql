--
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu Nov 26 12:27:18 2026
--

BEGIN TRANSACTION;

--
-- Table: books
--
DROP TABLE books;

CREATE TABLE books (
  id INTEGER PRIMARY KEY NOT NULL,
  title text NOT NULL,
  author text NOT NULL,
  translator text,
  year integer,
  filename text NOT NULL,
  summary text,
  comment text
);

CREATE UNIQUE INDEX book_filename ON books (filename);

--
-- Table: tags
--
DROP TABLE tags;

CREATE TABLE tags (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

CREATE UNIQUE INDEX tag_name ON tags (name);

--
-- Table: book_tags
--
DROP TABLE book_tags;

CREATE TABLE book_tags (
  book_id integer NOT NULL,
  tag_id integer NOT NULL,
  PRIMARY KEY (book_id, tag_id),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX book_tags_idx_book_id ON book_tags (book_id);

CREATE INDEX book_tags_idx_tag_id ON book_tags (tag_id);

COMMIT;
