
--Library Management System Project 2

-- Create a Branch  table

create table branch 
( 
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar(20),
contact_no varchar(10)
);

alter table branch 
alter column contact_no type  varchar(20);

create table employee
(
emp_id varchar(10) primary key,
emp_name varchar(20),	
position varchar(15),
salary int,
branch_id varchar(10) --FK
);
alter table employee
alter column salary type  float;

create table books
(
isbn varchar(20) primary key,
book_title varchar(75),
category varchar(15),
rental_price float,
status varchar(5),
author varchar(25),
publisher varchar(30)
);
alter table books
alter column category type  varchar(25);

create table members
(
member_id varchar(10) primary key,	
member_name varchar(20),
member_address varchar(20),
reg_date date
);

create table issued_status
(
issued_id varchar(10) primary key,
issued_member_id varchar(10), --FK
issued_book_name varchar(50),
issued_date date,
issued_book_isbn varchar(25), --FK
issued_emp_id varchar(10) --FK
);

alter table issued_status 
alter column issued_book_name type  varchar(75);



alter table  issued_status 
alter column issued_book_name type  varchar(30);

create table return_status
(
return_id varchar(10) primary key,
issued_id varchar(10),
return_book_name varchar(70),
return_date date,
return_book_isbn varchar(20)
);

-- Adding a foreign key ---
alter table issued_status
add constraint fk_members 
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books 
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employee 
foreign key (issued_emp_id)
references employee (emp_id);

alter table employee
add constraint fk_branch 
foreign key (branch_id)
references branch (branch_id);

alter table return_status
add constraint fk_issued_status 
foreign key (issued_id)
references issued_status (issued_id);

-----
select * from branch;
select * from employee;
select * from issued_status ;
select * from members ;
select * from return_status ;
select * from books ;
SELECT * FROM members WHERE member_id = 'C101';

--PROBLRM SOLVING--

--Q1. Create a New Book -- '978-1-60129-456-2' , 'to kill a mokingbird','Classic',6.00,'yes','Harper Lee','J.B','Lippincott & Co.'
insert into books (isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2' , 'To kill a Mokingbird','Classic',6.00,'yes','Harper Lee','J.B Lippincott & Co.');
select * from books ;

--Q2. Update an existing member's Address
Update members 
set member_address = '213 local St'
where  member_address = '123 Main St';

--Q3. Delete the record from the issued status Table 
--Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status ;
delete from issued_status
where issued_id = 'IS121';

select issued_id from issued_status where issued_id = 'IS121'; -- to recheck the value

--Q4. Retrieve All Books Issued by a Specific Employee 
--Select all books issued by the employee with emp_id = 'E101'.
select * from books;
select * from employee ;
select * from issued_status
where issued_emp_id = 'E101';

--Q5. List Members Who Have Issued More Than One Book 
--Use GROUP BY to find members who have issued more than one book.
select
    issued_emp_id,
    count(*)
from issued_status
group by 1
having count(*) > 1


--CTAS (Create Table As Select)
--Q6. Create Summary Tables:
--Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_issued_cnt as
select b.isbn, b.book_title, count(ist.issued_id) as issue_count
from issued_status as ist
join books as b
on ist.issued_book_isbn = b.isbn
group by b.isbn, b.book_title;

--Data Analysis & Findings
--Q7. The following SQL queries were used to address specific questions:
-- Retrieve All Books in a Specific Category:
select * from books where category = 'Fiction';

--Q8. Find Total Rental Income by Category:
select
    b.category,
    sum(b.rental_price),
    count(*)
from 
issued_status as ist
join
books as b
on b.isbn = ist.issued_book_isbn
group by 1;

--Q9. List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >= current_date - INTERVAL '180 days';

--Q10. List Employees with Their Branch Manager's Name and their branch details:
select 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
from employees as e1
join 
branch as b
on e1.branch_id = b.branch_id    
join
employees as e2
on e2.emp_id = b.manager_id;

--Q11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
select * from books
where rental_price > 7.00;

--Q12. Retrieve the List of Books Not Yet Returned
select * from issued_status as ist
left join
return_status as rs
on rs.issued_id = ist.issued_id
where rs.return_id is null;