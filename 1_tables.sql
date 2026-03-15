CREATE TABLE IF NOT EXISTS noms (
    id INTEGER PRIMARY KEY,
    breton TEXT,
    français TEXT,
    genre TEXT,
    pluriel TEXT
);

CREATE TABLE IF NOT EXISTS adjectifs (
    id TEXT PRIMARY KEY,
    breton TEXT,
    français TEXT
);

CREATE TABLE IF NOT EXISTS déclencheurs (
    id INTEGER PRIMARY KEY,
    mot TEXT,
    mutation TEXT,
    critère_genre TEXT,
    critère_pl TEXT
);

CREATE TABLE IF NOT EXISTS mutations (
    lettre_initiale TEXT PRIMARY KEY,
    durcissante TEXT,
    adoucissante TEXT,
    spirante TEXT
);