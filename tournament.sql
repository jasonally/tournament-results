-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament

DROP VIEW IF EXISTS wins;
DROP VIEW IF EXISTS losses;
DROP VIEW IF EXISTS standings;

DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;

CREATE TABLE players(
    id serial PRIMARY KEY,
    name text
);

CREATE TABLE matches(
    id serial PRIMARY KEY,
    winner integer REFERENCES players(id),
    loser integer REFERENCES players(id)
);

CREATE VIEW wins AS
SELECT p.id AS id,
    COALESCE(COUNT(m.winner), 0) AS matches_won
FROM players p
LEFT JOIN matches m
ON p.id = m.winner
GROUP BY p.id
ORDER BY matches_won DESC;

CREATE VIEW losses AS
SELECT p.id AS id,
    COALESCE(COUNT(m.loser), 0) AS matches_lost
FROM players p
LEFT JOIN matches m
ON p.id = m.loser
GROUP BY p.id
ORDER BY matches_lost DESC;

CREATE VIEW standings AS
SELECT p.id AS id,
    p.name AS name,
    w.matches_won as wins,
    (l.matches_lost + w.matches_won) AS matches
FROM players p
LEFT JOIN wins w
ON p.id = w.id
LEFT JOIN losses l
ON p.id = l.id
ORDER BY wins DESC;