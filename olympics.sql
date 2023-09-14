select * from noc_regions;
select * from athlete_events;
-- How many olympics games have been held?
select count(distinct games) as total_olympic_games from athlete_events;

-- 2. List down all Olympics games held so far.
select  distinct year,season,city from athlete_events order by 1;

-- 3. Mention the total no of nations who participated in each olympics game?
select count(distinct region) as yoyal_countries, games from athlete_events a join noc_regions nc on a.noc=nc.noc group by 2 order by 2; 

-- 4. Which year saw the highest and lowest no of countries participating in olympics
select max(games) as highest_countries,min(games) as lowest_countries from athlete_events;

-- 5. Which nation has participated in all of the olympic games
select region as country,count(distinct games) from athlete_events a join noc_regions nc on a.noc=nc.noc group by 1 having count(distinct games)=51;

-- 6. Identify the sport which was played in all summer olympics. 
select sport, count(distinct games),count(distinct season) from athlete_events group by 1 order by 2 desc;
with t1 as
          	(select count(distinct games) as total_games
          	from athlete_events where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from athlete_events where season = 'Summer'),
          t3 as
          	(select sport, count(1) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;
-- 7. Which Sports were just played only once in the olympics.
with t1 as
          	(select distinct games, sport
          	from athlete_events),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;
      
-- 8. Fetch the total no of sports played in each olympic games.
select count(distinct sport),games from athlete_events group by 2 order by 1 desc,2 asc ;

-- 9. Fetch oldest athletes to win a gold medal
select distinct * from athlete_events  where medal ='gold'
 and age =( select max(age) from athlete_events group by medal having medal='gold') order by id desc; 
 
 -- 10. Find the Ratio of male and female athletes participated in all olympic games.
 with t1 as (select sex ,count(1) as cnt from athlete_events group by sex),
 t2 as (select *,row_number() over(order by cnt)as rn from t1),
 max_cnt as (select cnt from t2 where rn=1),
 min_cnt as (select cnt from t2 where rn=2)
 select concat('1 : ', round(max_cnt.cnt/min_cnt.cnt, 2)) as ratio
    from min_cnt, max_cnt;

-- 11. Fetch the top 5 athletes who have won the most gold medals.
with t1 as (select name,team,medal from athlete_events),
t2 as (select distinct name as athlete_name,count(medal)as cnt from t1 where medal='gold' group by athlete_name )
select distinct t2.athlete_name,t1.team,cnt from t2 join t1 on t1.name=t2.athlete_name order by cnt desc limit 5;

-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)
with t1 as (select name,team,medal from athlete_events),
t2 as (select  name as athlete_name,count(medal)as cnt from t1 where medal in ('gold','silver','bronze') group by athlete_name )
select distinct t2.athlete_name,t1.team,cnt from t2 join t1 on t1.name=t2.athlete_name order by cnt desc limit 5;

-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
select region,count(medal), dense_rank() over(order by count(medal) desc) as rnk from athlete_events a join noc_regions nc on a.noc=nc.noc
where medal <> 'NA'  group by region limit 5;

-- 14. List down total gold, silver and bronze medals won by each country.
with t1 as (select region,medal from athlete_events a join noc_regions nc on a.noc=nc.noc),
t2 as (select region, count(medal) as gold from t1 where medal='gold' group by region),
t3 as (select region, count(medal) as silver from t1 where medal='silver' group by region),
t4 as (select region, count(medal) as bronze from t1 where medal='bronze' group by region)
select distinct t1.region,gold,silver,bronze from t2 join t1 on t1.region=t2.region 
join t3 on t2.region=t3.region join t4 on t4.region=t3.region order by gold desc ;

-- 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
with cte as(select t1.NOC,t1.games,t2.region,t1.medal from athlete_events as t1 join noc_regions as t2 on t1.NOC=t2.NOC)
select games,region as Country,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2 order by 1;

-- 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
with cte as(select t1.NOC,t1.games,t2.region,t1.medal from athlete_events as t1 join noc_regions as t2 on t1.NOC=t2.NOC),
cte2 as(select region,games,sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as medal,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2)
select distinct games,concat(first_value(region) over(partition by games order by gold desc)
, ' - '
, first_value(gold) over(partition by games order by gold desc)) as Max_Gold,
concat(first_value(region) over(partition by games order by silver desc)
, ' - '
, first_value(silver) over(partition by games order by silver desc)) as Max_Silver,
concat(first_value(region) over(partition by games order by bronze desc)
, ' - '
, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze
from cte2 order by 1;

-- 17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
with cte as(select t1.NOC,t1.games,t2.region,t1.medal from athlete_events as t1 join noc_regions as t2 on t1.NOC=t2.NOC),
cte2 as(select region,games,sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as medal,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2)
select distinct games,concat(first_value(region) over(partition by games order by gold desc)
, ' - '
, first_value(gold) over(partition by games order by gold desc)) as Max_Gold,
concat(first_value(region) over(partition by games order by silver desc)
, ' - '
, first_value(silver) over(partition by games order by silver desc)) as Max_Silver,
concat(first_value(region) over(partition by games order by bronze desc)
, ' - '
, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze,
concat(first_value(region) over(partition by games order by medal desc)
, ' - '
, first_value(medal) over(partition by games order by medal desc)) as Max_Medal from cte2 order by 1;

-- 18-Which countries have never won gold medal but have won silver/bronze medals?
with t1 as (select region,medal from athlete_events a join noc_regions nc on a.noc=nc.noc),
t2 as (select region as countary,
sum(case when medal='gold' then 1 else 0 end) as gold,
sum(case when medal='silver' then 1 else 0 end)as silver,
sum(case when medal='bronze' then 1 else 0 end)as bronze
from t1 group by region)
select * from t2 where gold=0 order by 4 asc, 3 desc;

-- 19. In which Sport/event, India has won highest medals.
select t2.region,t1.sport,count(*) as total_medals from athlete_events as t1 join noc_regions as t2 on t1.NOC=t2.NOC
where medal<>'NA' and region='India'
group by 1,2 order by 3 desc
limit 1;

-- 20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
select Games, Sport, COUNT( Medal) as Total_Medal
from athlete_events
where Sport = 'Hockey'and NOC = 'IND' and Medal != 'NA'
group by Games, Sport
order by 3 desc



 
 



