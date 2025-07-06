create database companyDB
use companyDB
create schema cm

create table cm.Department(
DNum int primary key default 1,
DName varchar(50) not null default 'HR',
location varchar(50) not null ,
)

create table cm.employee(
SSN int primary key check (SSN > 0),
FName varchar(255) not null,
LName varchar(255) not null,
gender varchar(10) not null default 'm',
Supervisor int,
DNum int,
foreign key (Supervisor) references cm.employee(ssn) on delete no action,
foreign key(DNum) references cm.department(DNum) on delete no action
)


create table cm.project(
PNum int primary key default 1,
PName varchar(50) not null unique,
location varchar(50) not null,
DNum int,
foreign key(DNum) references cm.department(DNum) on delete no action on update no action
)

create table cm.dependent(
Name varchar(50) not null,
gender varchar(10) not null default 'm',
BirthDate varchar(20),
SSN int,
primary key(ssn,name),
foreign key(ssn) references cm.employee(ssn) on delete no action on update no action
)


create table cm.Emp_project(
SSN int,
PNum int,
primary key(ssn,pnum),
foreign key (ssn) references cm.employee(ssn) on delete no action on update no action,
foreign key (pnum) references cm.project (pnum) on delete no action on update no action
)

-- department table
alter table cm.department add hiringDate date;
alter table cm.department add SSN int;
alter table cm.department add constraint FK_Employee_Department foreign key (ssn) references cm.employee(ssn);

-- employee table
alter table cm.employee add BirthDate date;

-- dependent table
alter table cm.dependent alter column BirthDate date;

-- Emp_project table
alter table cm.Emp_project add workingHours varchar(50);

-- drop constraint
alter table cm.employee drop constraint DF__employee__gender__59063A47;
SELECT name 
FROM sys.default_constraints 
WHERE parent_object_id = OBJECT_ID('cm.employee');





-- 1. Insert into Department
INSERT INTO cm.Department (DNum, DName, location, hiringDate, SSN)
VALUES 
(1, 'HR', 'Cairo', '2020-01-10', NULL),
(2, 'IT', 'Alexandria', '2021-03-15', NULL),
(3, 'Finance', 'Giza', '2022-06-01', NULL);

-- 2. Insert into Employee
INSERT INTO cm.Employee (SSN, FName, LName, gender, Supervisor, DNum, BirthDate)
VALUES
(1001, 'Ahmed', 'Hassan', 'm', NULL, 1, '1990-05-10'),
(1002, 'Sara', 'Ali', 'f', 1001, 2, '1992-07-22'),
(1003, 'Youssef', 'Mahmoud', 'm', 1001, 3, '1988-11-03');

-- ????? ?? SSN ?? Department ??? ????? ????????
UPDATE cm.Department SET SSN = 1001 WHERE DNum = 1;
UPDATE cm.Department SET SSN = 1002 WHERE DNum = 2;
UPDATE cm.Department SET SSN = 1003 WHERE DNum = 3;

-- 3. Insert into Project
INSERT INTO cm.Project (PNum, PName, location, DNum)
VALUES
(1, 'Payroll System', 'Cairo', 1),
(2, 'Website Redesign', 'Alexandria', 2),
(3, 'Budget Analysis', 'Giza', 3);

-- 4. Insert into Dependent
INSERT INTO cm.Dependent (Name, gender, BirthDate, SSN)
VALUES
('Mona', 'f', '2010-03-15', 1001),
('Kareem', 'm', '2015-08-19', 1002),
('Layla', 'f', '2012-12-05', 1003);

-- 5. Insert into Emp_project
INSERT INTO cm.Emp_project (SSN, PNum, workingHours)
VALUES
(1001, 1, '40'),
(1002, 2, '35'),
(1003, 3, '30'),
(1002, 1, '10');  




