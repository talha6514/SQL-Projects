-- Creating the database
create database fifa19;

-- selecting the database
use fifa19;

-- creating table
create table players (ID int, Name varchar(255), age int(3), nationality varchar(255), overallrating int,
potentialrating int, club varchar(255), value int, wage int, preferredfoot ENUM("Left", "right"), jerseynumber int,
joined datetime, height varchar(10), weight int(3), penalties int(3));
 
-- checking the table structure
desc players;
 
-- importing data into players table
load data local infile "D:/Learning/Machine Learning/fifa19-Dataset.csv" into table players columns terminated by "," 
optionally enclosed by "'" ignore 1 lines;

-- selecting first 10 rows of the table
select * from players limit 10;

-- total number of players in the dataset
select count(*) from players;

-- total number of nationalities in the dataset
select count(distinct nationality) as no_of_nationalities from players;

-- total, avg and std deviation of wages of all the players
select sum(wage) as total_wage, avg(wage), stddev(wage) as std_dev from players;

-- total no of players by their nationalities ordered in descending
select count(*) as freq, nationality from players group by nationality order by 1 desc;

-- top 3 countries in player count wise
select count(*) as freq, nationality from players group by nationality order by 1 desc limit 3;

-- max wage and name of the player
select max(wage), Name from players where wage = (select max(wage) from players);

-- min wage and name of the player
select min(wage) from players;
select Name from players where wage = (select min(wage) from players);

-- total no of players who are getting minimum wage
select count(Name) from players where wage = (select min(wage) from players);

-- name of the player with the best overall rating
select name from players where overallrating = (select max(overallrating) from players);

-- football clubs based on overall rating of its players
select sum(overallrating) as total_rating, club from players group by club order by total_rating desc;

-- top 3 football clubs based on overall rating of its players
select sum(overallrating) as total_rating, club from players group by club order by total_rating desc limit 3;

-- top 3 football clubs based on average overall rating of its players
select avg(overallrating) as avg_rating, club from players group by club order by avg_rating desc limit 3;

-- top 5 clubs based on overall rating of their players and their corresponding averages
select avg(overallrating) as avg_rating, club from players group by club order by avg_rating desc limit 5;

-- distribution of players whoose preferred foot is left vs right
select count(*) as freq, preferredfoot from players group by 2 order by 1 desc;

-- which jersey number is the luckiest (depends how you define lucky because lucky is a subjective word)
-- we are defining lucky as the jersey which has the highest total wage
select sum(wage) as total_wage, jerseynumber from players group by jerseynumber order by total_wage desc limit 1;

-- frequency distribution of nationalities among players whoose club name starts with 'M'
select count(*) as freq, nationality from players where club like "M%" group by nationality order by freq desc;

-- how many players have joined their respective clubs in the date range 20 May 2018 to 10 April 2019 both inclusive
select count(*) from players where joined >= "2018-05-20" and joined <="2019-04-10";

-- how many players have joined their clubs date/month/year wise
select count(*) as freq, date(joined) from players group by 2 order by 2 desc;
select count(*) as freq, year(joined) from players group by 2 order by 2 desc;