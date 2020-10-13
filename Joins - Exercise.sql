#1.	Employee Address
select e.employee_id,	e.job_title,a.address_id,a.address_text
from employees e join addresses a
on e.address_id=a.address_id
order by address_id limit 5;

#2.	Addresses with Towns
select e.first_name, e.last_name, t.`name` town, a.address_text
from employees e join addresses a on e.address_id=a.address_id
join towns t on a.town_id=t.town_id
order by first_name limit 5;
 
 #3.	Sales Employee
select e.employee_id,e.first_name,e.last_name,d.`name` department_name
 from employees e join departments d on d.department_id = e.department_id
 where d.`name`='Sales'
 order by employee_id desc;
 
 #4.	Employee Departments
 select e.employee_id,e. first_name, e.salary,d.`name` department_name
 from employees e join departments d
 on e.department_id=d.department_id
 where salary>15000 order by e.department_id desc limit 5;
 
  #5.	Employees Without Project
  select e.employee_id, e.first_name
  from employees e
  where employee_id not in (select temp.employee_id from employees_projects temp)
order by employee_id desc limit 3;

  select e.employee_id,e.first_name
  from employees e left join employees_projects temp 
  on e.employee_id=temp.employee_id
  where temp.employee_id is null
  order by employee_id desc limit 3;

 #6.	Employees Hired After
select e.first_name, e.last_name, e.hire_date, d.`name` dept_name
from employees e join (select * from departments where `name` in('Sales','Finance')) d
on e.department_id = d.department_id 
where hire_date> '1999-01-01' 
order by hire_date;
 
 #7.	Employees with Project
select e.employee_id, e.first_name, p.`name` project_name
from employees e join employees_projects ep on e.employee_id=ep.employee_id
join (select *from projects
where start_date > '2002-08-13' and end_date is null) p
on ep.project_id = p.project_id
order by 2, 3
limit 5;

#8.	Employee 24
select e.employee_id,e.first_name, if(year(p.start_date) >= '2005', NULL, p.`name`) project_name
from employees e join employees_projects ep on e.employee_id=ep.employee_id
join projects p
on ep.project_id = p.project_id
where e.employee_id = '24'
order by 3;

#9.	Employee Manager
select e.employee_id, e.first_name, e.manager_id, m.first_name manager_name
from employees e join employees m
on e.manager_id=m.employee_id
where e.manager_id in (3,7)
Order by 2;

#10. Employee Summary
select e.employee_id, concat_ws(' ', e.first_name, e.last_name, e.middle_name) employee_name,	concat_ws(' ', man.first_name, man.last_name, man.middle_name) manager_name, d.`name` department_name
from employees e join departments d on e.department_id = d.department_id join employees man
on e.manager_id = man.employee_id
where e.manager_id is not null
order by 1
limit 5;

#11. Min Average Salary
select `avg(salary)` min_average_salary from (
select d.department_id, avg(salary) from employees e
join departments d on e.department_id=d.department_id
group by 1
order by 2 limit 1) a;

#12.	Highest Peaks in Bulgaria
select c.country_code, mountain_range, peak_name, elevation from 
countries c join mountains_countries mc on c.country_code=mc.country_code
join mountains m on mc.mountain_id=m.id
join peaks p
on p.mountain_id=m.id
where elevation > 2835 and country_name = 'Bulgaria'
order by elevation desc;


#13.	Count Mountain Ranges
select country_code, count(mountain_range) mountain_range from 
mountains_countries mc join mountains m
on mc.mountain_id=m.id
where country_code in (select country_code from 
countries
where country_name in ('United States', 'Russia','Bulgaria'))
group by country_code;

#14.	Countries with Rivers
select country_name, river_name from 
continents con join countries c on con.continent_code= c.continent_code
 left join countries_rivers cr
on cr.country_code = c.country_code
left join rivers r on cr.river_id=r.id
where continent_name = 'Africa'
order by 1
limit 5;

#15.	*Continents and Currencies
     
SELECT d1.continent_code, d1.currency_code, d1.currency_usage FROM 
	(SELECT `c`.`continent_code`, `c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d1
LEFT JOIN 
	(SELECT `c`.`continent_code`,`c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	 GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage
 
WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;





#16.  Countries Without Any Mountains
select count(*) country_count
from countries c left join mountains_countries mc 
on c.country_code=mc.country_code
where mc.mountain_id is null;


#17.  Highest Peak and Longest River by Country
SELECT 
    c.country_name,
       highest_peak_elevation,
    MAX(r.length) longest_river_length
FROM
    countries c
        JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        JOIN
    rivers r ON cr.river_id = r.id
        JOIN
    mountains_countries mc ON mc.country_code = c.country_code
        JOIN
    mountains m ON m.id = mc.mountain_id
        JOIN
    peaks p ON p.mountain_id = m.id
GROUP BY c.country_name
ORDER BY 2 DESC , 3 DESC , 1
LIMIT 5;

