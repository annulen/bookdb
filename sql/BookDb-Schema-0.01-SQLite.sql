BEGIN TRANSACTION;

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

CREATE TABLE tags (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

CREATE UNIQUE INDEX tag_name ON tags (name);

CREATE TABLE book_tags (
  book_id integer NOT NULL,
  tag_id integer NOT NULL,
  PRIMARY KEY (book_id, tag_id),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX book_tags_idx_tag_id ON book_tags (tag_id);

COMMIT;
