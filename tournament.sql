-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

/* drops tables and views if they exist for testing */
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;
DROP VIEW IF EXISTS TotalWins;
DROP VIEW IF EXISTS TotalLosses;
DROP VIEW IF EXISTS PlayerStandings;




CREATE TABLE players(
	name TEXT,
	p_id SERIAL PRIMARY KEY);

CREATE TABLE matches(
	winner_id INTEGER references players (p_id),
	loser_id INTEGER references players (p_id),
	match_id SERIAL PRIMARY KEY);

/* PID & num losses */
create view TotalLosses as
	Select players.p_id as p_id, COALESCE(count(loser_id),0) as NumLosses
	from players LEFT JOIN matches
	ON matches.loser_id  = players.p_id
	group by players.p_id
	order by NumLosses DESC;

/* PID & num wins */
create view TotalWins as
	select players.p_id as p_id, COALESCE(count(winner_id), 0) as NumWins 
	from players left join matches 
	on matches.winner_id = players.p_id 
	group by p_id 
	order by NumWins;

/* joins above -- and calculates total matches - oders by num wins, descending */
create view PlayerStandings as
select TotalWins.p_id as p_id, name, TotalWins.NumWins as NumWins,  (TotalWins.NumWins + TotalLosses.NumLosses) as NumMatches
from players, TotalLosses, TotalWins
where players.p_id = TotalWins.p_id and TotalLosses.p_id = TotalWins.p_id
order by NumWins DESC;


