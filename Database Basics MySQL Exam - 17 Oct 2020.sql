CREATE DATABASE softuni_stores_system;

CREATE TABLE pictures(
id int PRIMARY KEY AUTO_INCREMENT,
url varchar(100) not null,
added_on DATETIME not null);

CREATE TABLE categories (
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(40) not null UNIQUE);

CREATE TABLE products (
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(40) not null UNIQUE,
best_before date,
price decimal (10,2) not null,
`description` TEXT,
category_id int not null,
picture_id int not null,
CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories (id),
CONSTRAINT fk_products_pictures
FOREIGN KEY (picture_id)
REFERENCES pictures (id));

CREATE TABLE towns (
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(20) not null UNIQUE);

CREATE TABLE addresses (
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(50) not null UNIQUE,
town_id int not null,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (town_id)
REFERENCES towns (id));

CREATE TABLE stores (
id int PRIMARY KEY AUTO_INCREMENT,
`name` varchar(20) not null UNIQUE,
rating float not null,
has_parking TINYINT(1) DEFAULT 0,
address_id int not null,
CONSTRAINT fk_stores_addresses
FOREIGN KEY (address_id)
REFERENCES addresses (id));


CREATE TABLE products_stores (
product_id int not NULL,
store_id int not NULL,
CONSTRAINT pk_products_stores
PRIMARY KEY (product_id, store_id),
CONSTRAINT fk_products_stores_stores
FOREIGN KEY (store_id)
REFERENCES stores (id),
CONSTRAINT fk_products_stores_products
FOREIGN KEY (product_id)
REFERENCES products (id));

CREATE TABLE employees (
id int PRIMARY KEY AUTO_INCREMENT,
`first_name` varchar(15) not null,
`middle_name` char(1),
`last_name` varchar(20) not null,
salary decimal (19,2) not null default 0,
hire_date date not null,
manager_id int,
store_id int not null,
CONSTRAINT fk_employees_stores
FOREIGN KEY (store_id)
REFERENCES stores (id),
CONSTRAINT fk_employees_employees
FOREIGN KEY (manager_id)
REFERENCES employees (id));



