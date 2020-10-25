create table photos (
id int primary key auto_increment,
`description` text not null,
`date` datetime not null,
views int not null DEFAULT 0);

create table comments (
id int primary key auto_increment,
`comment` varchar (255) not null,
`date` datetime not null,
photo_id int not null, 
constraint fk_comments_photos
Foreign key (photo_id)
references photos (id));

create table users (
id int primary key auto_increment,
`username` varchar (30) not null UNIQUE,
`password` varchar (30) not null,
`email` varchar (50) not null,
gender char(1) not null, 
age int not null, 
`job_title` varchar (40) not null,
`ip` varchar (30) not null);

create table addresses (
id int primary key auto_increment,
address varchar (30) not null,
town varchar (30) not null,
country varchar (30) not null,
user_id int not null,
constraint fk_addresses_users
Foreign key (user_id)
References users (id));

create table likes (
id int primary key auto_increment,
photo_id int, 
user_id int, 
constraint fk_likes_users
Foreign key (user_id)
references users (id),
constraint fk_likes_photos
Foreign key (photo_id)
references photos (id));

create table users_photos (
user_id int not null,
photo_id int not null, 
 constraint pk_users_photos
 Primary key (user_id,photo_id),
constraint fk_users_photos_users
Foreign key (user_id)
references users (id),
constraint fk_users_photos_photos
Foreign key (photo_id)
references photos (id));

-- 02.	Insert
insert into addresses (address, town, country, user_id) 
select u.`username`, u.`password`, u.`ip`, u.age 
from users u
where gender = 'M';

-- 03.	Update
UPDATE addresses
SET country = (case
when left(country,1) = 'B' then 'Blocked'
when left(country,1) = 'T' then 'Test'
when left(country,1) = 'P' then 'In Progress'
end)
where left(country,1) in ( 'B','T','P');

-- 04.	Delete
delete from addresses
where id%3 = 0;

-- 05.	Users

select `username`, gender , age
from users
order by age desc, 1;

-- 06.	Extract 5 Most Commented Photos
select c.photo_id id, p.`date` date_and_time, p.`description`, count(c.id) commentsCount
from comments c join photos p on c.photo_id = p.id
group by c.photo_id
order by commentsCount desc, id
limit 5;

-- 07.	Lucky Users

 select concat(u.id,' ', u.`username`) id_username, u.email
 from users u join users_photos up on up.user_id = u.id
 where up.user_id = up.photo_id;
 
 -- 08.	Count Likes and Comments
 select p.id photo_id, count(DISTINCT l.id) likes_count,  count(DISTINCT c.id) comments_count
from photos p left join likes l on p.id = l.photo_id
left join comments c on  p.id = c.photo_id
group by 1
order by 2 desc , 3 desc , 1;

-- 09.	The Photo on the Tenth Day of the Month
select concat(substr(`description`, 1,30),'...') summary, `date` from photos
where DAY(`date`) = 10
order by 2 desc;

--  10.	Get User’s Photos Count
delimiter //
create function udf_users_photos_count(p_username VARCHAR(30)) 
returns int deterministic
begin
return 
 ( select count(*) photosCount from 
users u join users_photos up on u.id=up.user_id
where `username` = p_username);  
end //
delimiter ;
select udf_users_photos_count('ssantryd');

--  11.	Increase User Age
delimiter //
create procedure udp_modify_user(p_address VARCHAR(30), p_town VARCHAR(30)) 
begin
	update users u join addresses a on u.id = a.user_id
	set age = age + 10
	where a.address = p_address and a.town = p_town;
end //
delimiter ;
CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT u.username, u.email,u.gender,u.age,u.job_title FROM users AS u
WHERE u.username = 'eblagden21';
