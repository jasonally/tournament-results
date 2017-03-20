-- Table definitions for the tournament project.

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

-- PostgreSQL doesn't connect to the database by default
\c tournament

DROP VIEW IF EXISTS wins;
DROP VIEW IF EXISTS losses;
DROP VIEW IF EXISTS standings;

DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;

CREATE TABLE players
(
  id serial PRIMARY KEY,
  name text
);

-- Winner and loser are foreign keys that reference id in players table
CREATE TABLE matches
(
  id serial PRIMARY KEY,
  winner integer REFERENCES players(id),
  loser integer REFERENCES players(id)
);

-- COALESCE sets value to 0 if COUNT(m.winner) is null
CREATE VIEW wins AS
SELECT
  p.id AS id,
  COALESCE(COUNT(m.winner), 0) AS matches_won
FROM players AS p
LEFT JOIN matches AS m
ON p.id = m.winner
GROUP BY p.id
ORDER BY matches_won DESC;

CREATE VIEW losses AS
SELECT
  p.id AS id,
  COALESCE(COUNT(m.loser), 0) AS matches_lost
FROM players AS p
LEFT JOIN matches AS m
ON p.id = m.loser
GROUP BY p.id
ORDER BY matches_lost DESC;

-- Joins could be done using WHERE and AND clauses
-- I find LEFT JOIN, RIGHT JOIN, etc. to be more readable
CREATE VIEW standings AS
SELECT
  p.id AS id,
  p.name AS name,
  w.matches_won as wins,
  (l.matches_lost + w.matches_won) AS matches
FROM players AS p
LEFT JOIN wins AS w
ON p.id = w.id
LEFT JOIN losses AS l
ON p.id = l.id
ORDER BY wins DESC;