#1.	Employees with Salary Above 35000
DELIMITER //
create procedure usp_get_employees_salary_above_35000()
BEGIN
SELECT first_name, last_name 
from employees
where salary > 35000
order by 1,2, employee_id;
END//
DELIMITER ;
CALL usp_get_employees_salary_above_35000();

#2.	Employees with Salary Above Number
DELIMITER //
create procedure usp_get_employees_salary_above(
in min_salary DECIMAL (19,4) )
BEGIN

SELECT first_name, last_name 
from employees
where salary >= min_salary
order by 1,2, employee_id;
END//
DELIMITER ;
CALL usp_get_employees_salary_above(35000);

#3.	Town Names Starting With
DELIMITER //
create procedure usp_get_towns_starting_with (in words VARCHAR(50))
BEGIN
select `name`
from towns
where `name` like concat(words, '%')
order by 1;
END//
DELIMITER ;
CALL usp_get_towns_starting_with('b');

#4.	Employees from Town
DELIMITER //
create procedure usp_get_employees_from_town (town_name VARCHAR (50))
BEGIN
SELECT e.first_name, e.last_name 
from employees e join addresses a using(address_id)
join towns t using(town_id)
where t.`name`=town_name
order by 1,2, employee_id;
END//
DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

#5.	Salary Level Function
DELIMITER //
CREATE FUNCTION ufn_get_salary_level (salary decimal)
RETURNS VARCHAR(20) deterministic
BEGIN
return (case
when salary < 30000 then 'Low'
when salary between 30000 and 50000 then 'Average'
when salary > 50000 then 'High'
END);
END//
DELIMITER ;
SELECT ufn_get_salary_level (13500);

#6.	Employees by Salary Level

DELIMITER //
CREATE procedure usp_get_employees_by_salary_level (s_level VARCHAR(20))
BEGIN
SELECT first_name, last_name
from employees
where  ufn_get_salary_level(salary) = s_level
Order by 1 desc, 2 desc;
END //
DELIMITER ;

CALL usp_get_employees_by_salary_level ('Low');

#7.	Define Function
DELIMITER //
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT deterministic
BEGIN
RETURN word REGEXP CONCAT('^[', set_of_letters, ']+$');
END //
DELIMITER ;

select  ufn_is_word_comprised ('Sofia', 'Sofia');

#8.	Find Full Name

#10.	Future Value Function
delimiter //
CREATE function ufn_calculate_future_value (sum DECIMAL(19,4), interest double, years INT)
RETURNS DECIMAL(19,4) deterministic
begin
RETURN sum * POW(1+interest, years);
end  //
DELIMITER ;
select ufn_calculate_future_value(1000, 0.5,5);

#11.	Calculating Interest
delimiter //
create procedure usp_calculate_future_value_for_account (id int, interest decimal(19,4))
begin
select a.id, h.first_name, h.last_name, a.balance current_balance, ufn_calculate_future_value(balance, interest, 5) balance_in_5_years
from account_holders h join accounts a on a.account_holder_id = h.id
where a.id = id ;
end //

delimiter ;
CALL usp_calculate_future_value_for_account(1, 0.1);

#12.	Deposit Money
delimiter //
create procedure usp_deposit_money(account_id int, money_amount decimal(19,4)) 
begin
	START TRANSACTION;
	IF(
    (select count(*) from accounts where id = account_id) = 0 )
    or (money_amount<=0)
	THEN ROLLBACK;
	ELSE
	UPDATE accounts
	SET balance = balance + money_amount where id = account_id;
	END IF;
end //
delimiter ;
CALL usp_deposit_money(1, 10);
select * from accounts;

#13.	Withdraw Money
delimiter //
create procedure usp_withdraw_money(account_id int, money_amount decimal(19,4)) 
begin
	START TRANSACTION;
	IF(
    (select count(*) from accounts where id = account_id) = 0 )
    or (money_amount<=0)
    or ((SELECT balance from accounts where id = account_id) - money_amount<0)
	THEN ROLLBACK;
	ELSE
	UPDATE accounts
	SET balance = balance - money_amount where id = account_id;
	END IF;
end //
delimiter ;
CALL usp_withdraw_money(1, 200);
select * from accounts;

#14.	Money Transfer
delimiter //
create procedure usp_transfer_money(from_account_id int, to_account_id int, amount decimal(19,4)) 
begin
	START TRANSACTION;
	IF (
    (select count(*) from accounts where id in (from_account_id, to_account_id)) != 2)
    OR (amount<=0)
    OR ((SELECT balance from accounts where id = from_account_id) - amount<0)
 	THEN ROLLBACK;
	ELSE
    UPDATE accounts
	SET balance = balance - amount
	WHERE id = from_account_id;

	UPDATE accounts
	SET balance = balance + amount
	WHERE id = to_account_id;     
END IF;
end //
delimiter ;
CALL usp_transfer_money(1, 2, 15.00);
select * from accounts;

	UPDATE accounts
	SET balance = balance + 100
	WHERE id = 2;     

#15.	Log Accounts Trigger
create table `logs` (
log_id int primary key auto_increment,
account_id int,
old_sum decimal (19,2),
new_sum decimal (19,2));

delimiter //
CREATE TRIGGER tr_update_accounts
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (account_id,old_sum,new_sum)
    VALUES (OLD.id, old.balance, new.balance);
END //
delimiter ;


