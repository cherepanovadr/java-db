#1.	One-To-One Relationship
create table passports (
passport_id int primary key,
passport_number varchar(20) unique);
CREATE table people (
person_id int primary key auto_increment,
first_name varchar(20) not null,
salary decimal(10,2),
passport_id int unique,

constraint fk_people_paasports
FOREIGN key (passport_id)
REFERENCES passports (passport_id)
);

INSERT INTO passports 
values 
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

insert into people (first_name, salary, passport_id)
values
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

#2.	One-To-Many Relationship


create table manufacturers
(manufacturer_id int primary key auto_increment,
`name` varchar(20) not null,
established_on date
);


create table models
(model_id int primary key auto_increment,
`name` varchar(20) not null,
manufacturer_id int,
constraint fk_models_manufacturers
FOREIGN key (manufacturer_id)
references manufacturers (manufacturer_id)
);

insert into manufacturers  (`name`,established_on)
values
 ('BMW','1916-03-01'),                                        
 ('Tesla','2003-01-01'),                                        
 ('Lada','1966-05-01');
 
 
 insert into models
values
 (101, 'X1', 1),                                        
 (102, 'i6', 1),                                        
 (103, 'Model S', 2),
 (104, 'Model X', 2),
 (105, 'Model 3', 2),
 (106, 'Nova', 3);
 
 #3.	Many-To-Many Relationship
 create table students 
 (student_id int primary key auto_increment,
 `name` varchar(20) not null);
 
  create table exams 
 (exam_id int primary key,
 `name` varchar(20) not null);
 
  create table students_exams 
 (student_id int,
  exam_id int,
  constraint pk_students_exams
  primary key (student_id, exam_id)  ,
    constraint fk_students_exams_students
    foreign key (student_id)
    references students (student_id),
     constraint fk_students_exams_exams
    foreign key (exam_id)
    references exams (exam_id));
 
 insert into students (`name`)
 values 
 ('Mila'),
 ('Toni'),
 ('Ron');
 
 insert into exams
 values 
 (101, 'Spring MVC'),
 (102, 'Neo4j'),
 (103, 'Oracle 11g');
 
 insert into students_exams
 values
 (1,101),
 (1,102),
 (2,101),
 (3,103),
 (2,102),
 (2,103);
 
 #4.	Self-Referencing
create table teachers 
(teacher_id int primary key auto_increment,
 `name` varchar(20) not null,
manager_id int);

INSERT INTO teachers
values
(101, 'John',null),
(102, 'Maya',106),
(103, 'Silvia',106),
(104, 'Ted',105),
(105, 'Mark',101),
(106, 'Greta',101);
 
 ALTER table teachers
 add constraint fk_teachers_managers
 foreign key (manager_id)
 references teachers (teacher_id);
 
  #5.	Online Store Database
 
    create table cities 
 (city_id int primary key auto_increment,
 `name` varchar(50));
 
 
     create table customers 
 (customer_id int primary key auto_increment,
 `name` varchar(50) ,
 `birthday` date,
 city_id int,
 constraint fr_customers_cities
 foreign key (city_id)
 references cities (city_id) );
 
  
     create table orders 
 (order_id int primary key auto_increment,
 `customer_id` int ,
 constraint fr_orders_cities
 foreign key (customer_id)
 references customers (customer_id));
 
   
     create table item_types 
 (item_type_id int primary key auto_increment,
 `name` varchar(50));
 
  create table items 
 (item_id int primary key auto_increment,
 `name` varchar(50),
 item_type_id int,
  constraint fk_items_item_types
 foreign key (item_type_id)
 references item_types (item_type_id) 
 );
 
 create table order_items
 (item_id int,
 order_id int,
 constraint pk_order_items
    primary key (order_id, item_id),
constraint fk_order_items_orders
    foreign key (order_id)
    references orders (order_id),
     constraint  fk_order_items_items
    foreign key (item_id)
    references items (item_id));
 
 #6.	University Database
 
create table majors 
(major_id int primary key auto_increment,
`name` varchar(50));
 
 create table subjects 
(subject_id int primary key auto_increment,
`subject_name` varchar(50));

 create table payments
(payment_id int primary key auto_increment,
payment_date date,
payment_amount decimal(8,2),
student_id int); 

 create table students
(student_id int primary key auto_increment,
student_number varchar(12),
student_name varchar(50),
major_id int,
constraint fk_students_majors
    foreign key (major_id)
    references majors (major_id)); 
    
    Alter table payments
    add constraint fk_payments_students
    foreign key (student_id)
    references students (student_id); 
    
create table agenda
 (student_id int,
 subject_id int,
constraint pk_agenda
    primary key (student_id, subject_id),
constraint fk_agenda_students
    foreign key (student_id)
    references students (student_id),
     constraint  fk_agenda_subjects
    foreign key (subject_id)
    references subjects (subject_id));

# 7.	SoftUni Design
 
 select mountain_range, peak_name, elevation peak_elevation
 from mountains m join peaks p on m.id= p.mountain_id
 where mountain_range = 'Rila'
 order by peak_elevation desc;
 
 