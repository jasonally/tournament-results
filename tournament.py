#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
import bleach

def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    db = connect()
    c = db.cursor()
    query = "DELETE FROM matches;"
    c.execute(query)
    db.commit()
    db.close()

def deletePlayers():
    """Remove all the player records from the database."""
    db = connect()
    c = db.cursor()
    query = "DELETE FROM players;"
    c.execute(query)
    db.commit()
    db.close()

def countPlayers():
    """Returns the number of players currently registered."""
    db = connect()
    c = db.cursor()
    query = "SELECT COUNT(*) AS num FROM players;"
    c.execute(query)
    # Only need count field; use c.fetchone()[0] instead of c.fetchall()
    rows = c.fetchone()[0]
    db.close()
    return rows

def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    db = connect()
    c = db.cursor()
    # Prevent malicious names, just in case
    clean_name = bleach.clean(name)
    query = "INSERT INTO players (name) VALUES (%s);"
    # Use a tuple instead of string interpolation
    c.execute(query, (clean_name,))
    db.commit()
    db.close();

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    db = connect()
    c = db.cursor()
    query = "SELECT * FROM standings;"
    c.execute(query)
    standings = c.fetchall()
    db.close()
    return standings

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    db = connect()
    c = db.cursor()
    query = "INSERT INTO matches (winner, loser) VALUES (%s, %s);"
    c.execute(query, (winner, loser,))
    db.commit()
    db.close();

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    # Retrieve standings using playerStandings()
    standings = playerStandings()
    # Start with i=1 entry -- the second entry in standings
    # Return info for entry above i=1 (the i-1 entry), then provide the
    # i=1 entry and continue iterating
    return [(standings[i-1][0], standings[i-1][1],
        standings[i][0], standings[i][1]) for i in range(1, len(standings), 2)]

