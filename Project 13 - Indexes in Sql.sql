/*
Indexes - Indexes facilitate quick retrieval of data on a huge table from a database. It allows you to find specific data
          without scanning through the entire table.
Types   - Non-Clustered Index, Clustered Index, Unique Index, Non-Unique Index
*/

--The following guidelines indicate when the use of an index should be reconsidered.
--1.Indexes should not be used on small tables.
--2.Tables that have frequent, large batch updates or insert operations.
--3.Indexes should not be used on columns that contain a high number of null values.
--4.Columns that are frequently manipulated should not be indexed.

drop table FullTimeEmployees;
create table FullTimeEmployees
            (ID int primary key, Name varchar(10), Gender varchar(50), Designation varchar(50), Salary int);

insert into FullTimeEmployees
values     (1, 'Yasir', 'Male', 'Manager', 25000),
           (2, 'Rabia', 'Female', 'Assistant', 20000),
		   (3, 'Zain', 'Male', 'Accountant', 35000),
		   (4, 'Muniba', 'Female', 'Operator', 15000),
		   (5, 'Sufyan', 'Male', 'Director', 45000);

select * from FullTimeEmployees;

--Indexex are only created on huge tables where we're dealing with millions of rows
--Indexes should not be used on small tables it's just for better clarification

--Creating an index on Salary column with ascending order then sql will have a pointer to every value stored in this column 
--The query will be much faster since the database will know where to find the desired records by referring to the index
--of this id column.

--Non-Clustered Index

create index IX_FTE_Salary
on FullTimeEmployees (Salary asc);

--when you applied non-clustered index on a table the sorting will happen in a separate table 
--on a column where the index was created

--now if i'm executing the query the sql will only fetching records mentioned in where clause 
--it will never scan through the entire records until it finds the desired records in ascending order

select * from FullTimeEmployees
where Salary > 10000 and Salary < 22000;

--Dropping an index
drop index FullTimeEmployees.IX_FTE_Salary;
		   
--Clustered Index
--A clustered index causes records to be physically stored in a sorted or sequential order.
--Whenever you're applying primary key on a column the clustered index automatically applied as well
--You can create only one clustered index ni a table.

drop table FullTimeEmployees;
create table FullTimeEmployees
            (ID int primary key, Name varchar(10), 
			Gender varchar(50), Designation varchar(50),
			Salary int);

select * from FullTimeEmployees;

--now if i'm inserting 5 row in the table
insert into FullTimeEmployees
values     (5, 'Sufyan', 'Male', 'Director', 45000);

--because i've applied primary key on id column then the clustered index automatically gets applied 
--and it'll keep the column in ascending order now if i'm inserting 2 row in a table
 
 insert into FullTimeEmployees
 values     (2, 'Rabia', 'Female', 'Assistant', 20000);

 --now if you're executing the query to see records in your table then you'll notice the sorting has applied automatically
 --the 2 row appears first and then the 5 row
select * from FullTimeEmployees;

--now similarly if i'm inserting 4 row in a table
insert into FullTimeEmployees
values     (4, 'Muniba', 'Female', 'Operator', 15000);

--Sql is maintaining records in ascending order because primary key identified clustered index 
insert into FullTimeEmployees
values     (1, 'Yasir', 'Male', 'Manager', 25000),
           (3, 'Zain', 'Male', 'Accountant', 35000);

select * from FullTimeEmployees;

--now if i want to apply clustered index without using primary key in table the syntax will be as
--sorting will only applied if you're applying clustered index in a column
drop table FullTimeEmployees;

create table FullTimeEmployees
            (ID int, Name varchar(10), 
			Gender varchar(50), Designation varchar(50),
			Salary int);

insert into FullTimeEmployees
values      (5, 'Sufyan', 'Male', 'Director', 45000),
            (2, 'Rabia', 'Female', 'Assistant', 20000),
			(1, 'Yasir', 'Male', 'Manager', 25000),
			(4, 'Muniba', 'Female', 'Operator', 15000),
			(3, 'Zain', 'Male', 'Accountant', 35000);

create clustered index IX_FTE_Id_Clustered
on FullTimeEmployees (Id Asc) ;

select * from FullTimeEmployees;
----------------------------------------------------------------------------------------------------------
--Unique Clustered Index , Non-Unique Clustered Index
drop table Books;
create table Books
            (BookId int NOT NULL, BookName varchar(50) NULL, Category varchar(50) NULL,
			Price int NULL, Publisher varchar(50));

insert into Books 
values     (1, 'Computer Architecture', 'Computers', 125, 'Oxford'),
           (2, 'Advanced Composite Materials', 'Science', 172, 'Pearson'),
		   (3, 'Asp.Net 4 Blue Book', 'Programming', 56, 'Bloomsbury'),
		   (4, 'Strategies Unplugged', 'Science', 99, 'Sunon & Schuster'),
		   (5, 'Teaching Science', 'Science', 164, 'Pearson'),
		   (6, 'Challenging Times', 'Business', 150, 'Oxford'),
		   (7, 'Circuit Bending', 'Science', 112, 'Sunon & Schuster'),
		   (8, 'Popular Science', 'Science', 210, 'Pearson'),
		   (9, 'Adobe Premiere', 'Computers', 62, 'Bloomsbury');

--Non-Unique Clustered Index
--if i'm applying clustered index on BookId column without using unique then non-unique index will be applied by deafault
--it means i can insert duplicate values 
select * from Books;
create clustered index CIX_Books_BookId
on Books (BookId Asc);

Insert into Books 
values     (9, 'Introduction to Computer', 'Computer', 500, 'HEC');

--Unique Clustered Index
--A unique index can be created on a column that does not have any duplicate values.

create unique clustered index CIX_Books_BookId
on Books (BookId Asc);

Insert into Books 
values     (9, 'Introduction to Computer', 'Computer', 500, 'HEC');

--Non-Clustered Non-Unique Index
create nonclustered index CIX_Books_BookName
on Books (BookName Asc);

Insert into Books
values     (10, 'Adobe Premier', 'Computer', 500, 'HEC');

--Unique Non-Clustered Index
--Unique non-clustered index will only apply if there are no duplicate values in the column
--i cannot insert duplicate values in it 
create unique nonclustered index CIX_Books_BookName
on Books (BookName Asc);

Insert into Books
values     (10, 'Adobe Premier', 'Computer', 500, 'HEC');

--Unique Constraint
--when you add a unique constraint, a unique index gets created behind the scenes.
--a unique index gets automatically generated after applying unique constraint
drop table Books;
create table Books
            (BookId int unique NOT NULL, BookName varchar(50) NULL, Category varchar(50) NULL,
			Price int NULL, Publisher varchar(50));

insert into Books 
values     (1, 'Computer Architecture', 'Computers', 125, 'Oxford'),
           (2, 'Advanced Composite Materials', 'Science', 172, 'Pearson'),
		   (3, 'Asp.Net 4 Blue Book', 'Programming', 56, 'Bloomsbury'),
		   (4, 'Strategies Unplugged', 'Science', 99, 'Sunon & Schuster'),
		   (5, 'Teaching Science', 'Science', 164, 'Pearson'),
		   (6, 'Challenging Times', 'Business', 150, 'Oxford'),
		   (7, 'Circuit Bending', 'Science', 112, 'Sunon & Schuster'),
		   (8, 'Popular Science', 'Science', 210, 'Pearson'),
		   (9, 'Adobe Premiere', 'Computers', 62, 'Bloomsbury');

-----------------------------------------------------------------------------------------------------------