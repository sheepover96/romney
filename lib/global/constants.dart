const VERSION = 1;

const TABLE_WORDS_INIT_QUERY = """
CREATE TABLE IF NOT EXISTS words (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  word TEXT NOT NULL,
  reading TEXT,
  meaning TEXT,
  is_favorite INTEGER,
  is_in_dictionary INTEGER,
  created_at TEXT NOT NULL,
  CONSTRAINT is_favorite_bool CHECK (is_favorite IN (0, 1) OR is_favorite IS NULL),
  CONSTRAINT is_in_dictionary_bool CHECK (is_in_dictionary IN (0, 1) OR is_in_dictionary IS NULL)
);
""";

const TABLE_TAGS_INIT_QUERY = """
CREATE TABLE IF NOT EXISTS tags (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  tag TEXT NOT NULL,
  created_at TEXT NOT NULL
);
""";

const TABLE_WORD_TAG_INIT_QUERY = """
CREATE TABLE IF NOT EXISTS word_tags (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  word_id INTEGER,
  tag_id INTEGER,
  FOREIGN KEY (word_id) REFERENCES words (id),
  FOREIGN KEY (tag_id) REFERENCES tags (id)
);
""";
