# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    DB = connect()
    curs = DB.cursor()
    curs.execute("DELETE FROM players;")
    DB.commit()
    DB.close()


def deletePlayers():
    """Remove all the player records from the database."""
    DB = connect()
    curs = DB.cursor()
    curs.execute("DELETE FROM matches;")
    DB.commit()
    DB.close()


def countPlayers():
    """Returns the number of players currently registered."""
    DB = connect()
    curs = DB.cursor()
    curs.execute("SELECT count(*) from players;")
    num_players = curs.fetchone()
    DB.close()
    return num_players[0]


def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    DB = connect()
    curs = DB.cursor()
    curs.execute("INSERT INTO players VALUES (%s);",(name,))
    DB.commit()
    DB.close()

## INSERT INTO players VALUES 

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
    DB = connect()
    curs = DB.cursor()
    curs.execute("select * from PlayerStandings;")
    PlayerStandings = curs.fetchall()
    DB.close()
    return PlayerStandings



def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    DB = connect()
    curs = DB.cursor()
    curs.execute("INSERT INTO matches VALUES (%s, %s);",(winner, loser))
    DB.commit()
    DB.close()
 
 
    def swissPairings():
        PlayerStandings = playerStandings()
        return [(PlayerStandings[i-1][0], PlayerStandings[i-1][1], PlayerStandings[i][0], PlayerStandings[i][1])
        for i in range(1, len(PlayerStandings), 2)]

