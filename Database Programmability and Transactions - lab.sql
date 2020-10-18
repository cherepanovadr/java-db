# SQL Functions
drop function if exists ufn_count_employees_by_town;

DELIMITER //
create function ufn_count_employees_by_town(town_name Varchar(50))
returns int deterministic   #difference to procedure
begin
declare emp_count int;
set emp_count := (select count(*) from employees e
join addresses a on e.address_id = a. address_id
join towns t using(town_id)
where t.`name` = town_name);
return emp_count;
end //
DELIMITER ;

SELECT UFN_COUNT_EMPLOYEES_BY_TOWN ('Sofia');

#SQL Stored procedures
DROP PROCEDURE IF EXISTS usp_select_employees_by_seniority;
#1
DELIMITER //
CREATE PROCEDURE usp_select_employees_by_seniority()
BEGIN 
	SELECT employee_id, first_name, last_name, hire_date FROM employees
	WHERE round((DATEDIFF(NOW(),hire_date) /365.25)) < 15;
END //
DELIMITER ;

CALL usp_select_employees_by_seniority_with_argument();

#2
DELIMITER //
CREATE PROCEDURE usp_select_employees_by_seniority_with_argument(IN years_employed INT)
BEGIN 
	SELECT employee_id, first_name, last_name, hire_date, round(DATEDIFF(NOW(),hire_date) /365.25)
    FROM employees
	WHERE round((DATEDIFF(NOW(),hire_date) /365.25)) < years_employed;
END //
DELIMITER ;

CALL usp_select_employees_by_seniority_with_argument(25);

#3
DELIMITER //
create procedure usp_add_numbers
(first_number INT,
second_number INT,
out result INT)

BEGIN
	SET result = first_number + second_number;
END //
DELIMITER ;
SET @answer = 0;
CALL usp_add_numbers(4,5,@answer);
SELECT @answer;


#2.	Employees Promotion
DELIMITER //
create procedure usp_raise_salaries(
in department_name VARCHAR(50),
in percentage DOUBLE)
begin
UPDATE employees JOIN departments d using(department_id)
SET salary = salary * (1 + percentage/100)
where d.`name` = department_name;
END// 
DELIMITER ;

CALL usp_raise_salaries('Sales',-10); #just updates

select * from employees e JOIN departments d using(department_id)
where d.`name` = 'Sales';


# Transaction
DELIMITER //
create procedure usp_raise_salary_by_id(id int)
BEGIN
	START TRANSACTION;
    IF ((Select count(employee_id) from employees where employee_id like id) <> 1) then
    ROLLBACK;
    ELSE
    UPDATE employees AS e SET salary = salary + salary * 0.05
    where e.employees_id = id;
    END if;
END //
DELIMITER ;

# Triggers

CREATE TABLE deleted_employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	middle_name VARCHAR(20),
	job_title VARCHAR(50),
	department_id INT,
	salary DOUBLE 
);

DELIMITER //
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN 
	INSERT INTO deleted_employees(first_name,last_name,middle_name,job_title,department_id,salary)
	VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,OLD.job_title,OLD.department_id,OLD.salary);
END //
DELIMITER ;

DELETE FROM employees 
where employee_id = 1;

select * from employees;


