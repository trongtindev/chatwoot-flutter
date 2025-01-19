CREATE TABLE IF NOT EXISTS cached_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    url TEXT,
    data TEXT,
    createdAt INTEGER,
    UNIQUE (url) ON CONFLICT REPLACE
);

CREATE INDEX IF NOT EXISTS url_index ON cached_requests (url);
