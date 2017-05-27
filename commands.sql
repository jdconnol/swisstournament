# of wins by winner ID
select winner_id, count(*) as wins from matches group by winner_id;

# of wins by winner ID
select winner_id, count(*) as wins from matches group by winner_id;

# of losses by ID
select loser_id, count(*) as losses from matches group by loser_id;

# losses and wins 
select *, COALESCE(count(loser_id),0) from (select winner_id, count(*) as wins from matches group by winner_id) as NumWins FULL OUTER JOIN (select loser_id, count(*) as losses from matches group by loser_id) as NumLosses on NumWins.winner_id = NumLosses.loser_id;





#merge players with losses
# of losses by ID
select loser_id, count(*) as losses from matches group by loser_id;

# merge players with wins/losses
select * from players left join ((select winner_id, count(*) as wins from matches group by winner_id) as NumWins FULL OUTER JOIN (select loser_id, count(*) as losses from matches group by loser_id) as NumLosses on NumWins.winner_id = NumLosses.loser_id) as WinLossTally on WinLossTally.loser_id = players.p_id;


#player losses 
Select players.p_id as p_id, COALESCE(count(loser_id),0) as NumLosses from players LEFT JOIN matches ON matches.loser_id  = players.p_id group by players.p_id order by NumLosses DESC;

select players.p_id as p_id, COALESCE(count(winner_id))

#player wins 
select players.p_id as p_id, COALESCE(count(winner_id), 0) as NumWins from players left join matches on matches.winner_id = players.p_id group by p_id order by NumWins;

#players standings
select *, (numwins + numlosses) as totalmatches from (Select players.p_id as p_id, COALESCE(count(loser_id),0) as NumLosses from players LEFT JOIN matches ON matches.loser_id  = players.p_id group by players.p_id order by NumLosses DESC) as plosses inner join (select players.p_id as p_id, COALESCE(count(winner_id), 0) as NumWins from players left join matches on matches.winner_id = players.p_id group by p_id order by NumWins) as pwins on plosses.P_id = pwins.p_id;