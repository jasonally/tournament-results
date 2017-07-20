# Project: Tournament Results

### About
This project uses concepts from Udacity's [Intro to Relational Databases](https://www.udacity.com/course/intro-to-relational-databases--ud197) course to build a tournament database app. The database is for use in a [Swiss-style tournament](https://en.wikipedia.org/wiki/Swiss-system_tournament) where competitors are matched based on similar win-loss records. The database schema uses [PostgreSQL](https://www.postgresql.org/) while the functions that interact with the schema are in a corresponding Python file.

### Directory Contents
1. `tournament.sql` - Contains the PostgreSQL database schema
2. `tournament.py` - Contains Python functions used to update or retrieve data from the schema
3. `tournament_test.py` - Contains unit tests to verify tournament.py's functions work properly

### How to Run
1. Clone this repo to your computer
2. Import the database schema by navigating to this repo in Terminal and typing the following commands:    
  `psql -> \i tournament.sql -> \q`
3. Run `tournament_test.py` by typing:    
  `python tournament_test.py`
  
### Areas for Improvement
Udacity suggested the database schema could be improved to contain the ability to create multiple tournaments, each with different tables containing players, matches, wins, losses, standings, and Swiss-style match pairings.
