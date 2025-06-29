-- Copyright © 2025 Mark Summerfield. All Rights Reserved.

PRAGMA USER_VERSION = 1;

CREATE TABLE Generations (
    gid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    created REAL DEFAULT (JULIANDAY('NOW')) NOT NULL,
    message TEXT,

    CHECK(gid > 0)
);

CREATE VIEW ViewGenerations AS
    SELECT gid, DATETIME(created) AS created, message FROM Generations
        ORDER BY gid DESC;

CREATE VIEW LastGeneration AS SELECT COALESCE(MAX(gid), 0) AS gid
    FROM Generations;

-- kind
--  U uncompressed raw bytes (the actual file); usize set; zsize NULL
--  Z zlib deflated raw bytes (the actual file); usize & zsize set
--  S same as record whose gid is pgid; usize & zsize as pgid record & data
--    NULL
CREATE TABLE Files (
    gid INTEGER NOT NULL, -- generation ID
    filename TEXT NOT NULL, -- contains full (relative) path
    kind TEXT NOT NULL,
    usize INTEGER NOT NULL, -- uncompressed size
    zsize INTEGER NOT NULL, -- zlib-deflated size; 0 means not compressed
    pgid INTEGER NOT NULL, -- set to gid if 'U' or 'Z' or to parent if 'S'
    data BLOB,

    CHECK(kind IN ('U', 'Z', 'S')),
    CHECK(usize > 0),
    CHECK(zsize >= 0),
    FOREIGN KEY(pgid) REFERENCES Generations(gid),
    FOREIGN KEY(gid) REFERENCES Generations(gid),
    PRIMARY KEY(gid, filename)
);

CREATE TABLE Ignores (pattern TEXT PRIMARY KEY NOT NULL) WITHOUT ROWID;
