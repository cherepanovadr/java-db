CREATE DATABASE fsd; # not for Judge
# check for default values!
#0
CREATE TABLE countries (
id int Primary key auto_increment,
`name` VARCHAR(45) not NULL); 

CREATE TABLE towns (
id int Primary key auto_increment,
`name` VARCHAR(45) not NULL, 
country_id int not NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (country_id)
REFERENCES countries (id));

CREATE TABLE stadiums (
id int Primary key auto_increment,
`name` VARCHAR(45) not NULL, 
capacity int not NULL,
town_id int not NULL,
CONSTRAINT fk_stadiums_towns
FOREIGN KEY (town_id)
REFERENCES towns (id));

CREATE TABLE teams (
id int Primary key auto_increment,
`name` VARCHAR(45) not NULL, 
established date not NULL,
fan_base bigint DEFAULT 0 not NULL,
stadium_id int not NULL,
CONSTRAINT fk_teams_stadiums
FOREIGN KEY (stadium_id)
REFERENCES stadiums (id));

CREATE TABLE skills_data (
id int Primary key auto_increment,
dribbling int DEFAULT 0, 
pace int DEFAULT 0, 
passing int DEFAULT 0, 
shooting int DEFAULT 0, 
speed int DEFAULT 0, 
strength int DEFAULT 0);

CREATE TABLE players (
id int Primary key auto_increment,
`first_name` VARCHAR(10) not NULL, 
`last_name` VARCHAR(20) not NULL,
age int not null,
position char(1) not null,
salary decimal(10,2) not null,
hire_date DATETIME,
skills_data_id int NOT NULL,
team_id int,
CONSTRAINT fk_players_skills_data
FOREIGN KEY (skills_data_id)
REFERENCES skills_data (id),
CONSTRAINT fk_players_teams
FOREIGN KEY (team_id)
REFERENCES teams (id));

CREATE TABLE coaches (
id int Primary key auto_increment,
`first_name` VARCHAR(10) not NULL, 
`last_name` VARCHAR(20) not NULL,
salary decimal(10,2) not NULL DEFAULT 0,
coach_level int not NULL DEFAULT 0);

CREATE TABLE players_coaches (
player_id int,
coach_id int,
CONSTRAINT pk_players_coaches
PRIMARY KEY (player_id, coach_id),

CONSTRAINT fk_players_coaches_players
FOREIGN KEY (player_id)
REFERENCES players (id),
CONSTRAINT fk_players_coaches_coaches
FOREIGN KEY (coach_id)
REFERENCES coaches (id));


#2
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary*2,char_length(first_name)
from players
WHERE age >= 45;

#3
UPDATE coaches 
SET coach_level = coach_level+1
where left(first_name, 1) = 'A' 
AND id in (select coach_id
from players_coaches
group by 1
having count(player_id) >=1);

#4

DELETE from players
where age>=45; 

#5
SELECT first_name, age, salary
from players
ORDER BY 3 desc;

#6
SELECT p.id, concat_ws(' ',first_name, last_name) as full_name, age, position, hire_date
from players p join skills_data sd
on sd.id = p.skills_data_id
WHERE hire_date is NULL and sd.strength>50
and age< 23 and position = 'A'
order by salary, age;

#7
SELECT t.`name` team_name, t.established, t.fan_base, count(p.id) count_of_players
from teams t left join players p
on t.id = p.team_id
GROUP BY t .id
order by 4 desc,3 desc;  # including teams with 0 players

#8
SELECT max(sd.speed) max_speed, t.`name` town_name from 
towns t left join stadiums s
on t.id = s.town_id
left join teams tms on s.id = tms.stadium_id
LEFT join players p on tms.id =p.team_id
left join skills_data sd on p.skills_data_id = sd.id
where tms.`name` !='Devify'
group by t.id
order by 1 desc, 2;

#9
select c.`name`, count(p.`first_name`) total_count_of_players, sum(p.salary) total_sum_of_salaries
from countries c left join towns t
on c.id = t.country_id
left join stadiums st on st.town_id = t.id
left join teams te on te.stadium_id = st.id
left join players p on p.team_id = te.id
group by c.`name`
order by 2 desc, 1;

#10
delimiter //
create function udf_stadium_players_count (stadium_name VARCHAR(30))
returns int deterministic
 begin
  return 
   (select count(p.id) count
 from stadiums s 
 left join teams t 
 on s.id = t.stadium_id
 left join players p on p.team_id = t.id
 where s.`name` = stadium_name);
 end //
delimiter ;
select udf_stadium_players_count('Jaxworks');
 
#11

delimiter //
create procedure udp_find_playmaker(min_dribble_points int,  team_name VARCHAR(45))
begin
select concat(p.first_name,' ', p.last_name) full_name, p.age, p.salary, sk.dribbling, sk.speed, t.`name` 'team_name'
from skills_data sk join players p
on p.skills_data_id = sk.id
join teams t on t.id = p.team_id 
and t.`name` = team_name
where dribbling >min_dribble_points
order by sk.speed desc limit 1;

end //
delimiter ;

call udp_find_playmaker(20, 'Skyble');


