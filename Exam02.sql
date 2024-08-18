/*

Exam P02

*/


-- 1. Write a query that displays Full name of an employee who has more than
--3 letters in his/her First Name.{1 Point}

select CONCAT(Fname,' ',Lname) as [Full Name]
from Employee
where LEN(Fname) > 3

-- 2. Write a query to display the total number of Programming books 
--available in the library with alias name ‘NO OF PROGRAMMING
--BOOKS’ {1 Point}

select COUNT(b.Cat_id) as [NO OF PROGRAMMING BOOKS]
from Book b inner join Category c
on lower(c.Cat_name) = 'programming' and b.Cat_id = c.Id


--3. Write a query to display the number of books published by
--(HarperCollins) with the alias name 'NO_OF_BOOKS'

select COUNT(b.Publisher_id) as [NO_OF_BOOKS]
from Book b inner join Publisher p
on b.Publisher_id = p.Id and lower(p.Name) = 'harpercollins'


--4. Write 
--a query to display the User SSN and name, date of borrowing and due date 
--of the User whose due date is before July 2022. {1 Point}

select u.SSN,u.User_Name,b.Borrow_date,b.Due_date
from Borrowing b inner join Users u
on b.User_ssn = u.SSN
where YEAR(b.Due_date) <= 2022 and MONTH(b.Due_date) < 7

--5. Write a query to display book title, author name and display in the 
--following format,
--' [Book Title] is written by [Author Name]. {2 Points}

select CONCAT(b.Title,' is written by ',a.Name) as [Book & Author]
from Book b inner join Book_Author ba
on b.Id = ba.Book_id inner join Author a
on a.Id = ba.Author_id

--6. Write a query to display the name of users who have letter 'A' in their 
--names. {1 Point}

select User_Name
from Users
where User_Name like '%A%'

--7. Write a query that display user SSN who makes the most borrowing{2
--Points}

select  MAX(user_count)
from (select User_ssn,COUNT(User_ssn) as [user_count]
from Borrowing 
group by User_ssn) as newTable

--8. Write a query that displays the total amount of money that each user paid 
--for borrowing books. {2 Points}

select User_ssn,SUM(Amount) as [user_fees]
from Borrowing 
group by User_ssn

--9. write a query that displays the category which has the book that has the 
--minimum amount of money for borrowing.

select c.Cat_name, b.Title
from(
select top(1)Book_id,amount
from (
select Book_id,SUM(Amount) as [amount]
from Borrowing
group by Book_id 
) as table1
order by amount
) as table2 inner join Book b
on b.Id = Book_id inner join Category c
on c.Id = b.Cat_id

--10. write a query that displays the email of an employee if it's not found, 
--display address if it's not found, display date of birthday. {1 Point}

select coalesce(Email,Address,cast(DoB as varchar(50)),'unknown') as [Employee any data]
from Employee

-- 11. Write a query to list the category and number of books in each category 
--with the alias name 'Count Of Books'. {1 Point}

select c.Id,c.Cat_name,COUNT(b.Id) as [Count of Books]
from Category c inner join Book b
on c.Id = b.Cat_id
group by c.Id,c.Cat_name

--12. Write a query that display books id which is not found in floor num = 1 
--and shelf-code = A1.

select b.Id
from Shelf s inner join Book b
on b.Shelf_code = s.Code and s.Code != 'A1' and s.Floor_num != 1

--13. Write a query that displays the floor number , Number of Blocks and 
--number of employees working on that floor.{2 Points}

select f.Number,f.Num_blocks,COUNT(e.Id)
from Employee e inner join Floor f
on e.Floor_no = f.Number
group by f.Number,f.Num_blocks

--14.Display Book Title and User Name to designate Borrowing that occurred 
--within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}

select b.Title,u.User_Name
from Book b inner join Borrowing bo
on b.Id = bo.Book_id inner join Users u 
on u.SSN = bo.User_ssn
where YEAR(bo.Borrow_date) = 2022 and MONTH(bo.Borrow_date) between 3 and 10

--15.Display Employee Full Name and Name Of his/her Supervisor as
--Supervisor Name.{2 Points}

select CONCAT(e.Fname,' ',e.Lname) as [Full Name],CONCAT(super.Fname,' ',super.Lname) as [Supervisor Name]
from Employee e inner join Employee super
on super.Id = e.Super_id

--16.Select Employee name and his/her salary but if there is no salary display
--Employee bonus. {2 Points}

select CONCAT(Fname,' ',Lname) as [Employee Full Name],coalesce(Salary,Bouns,'unknown') as [Employee any income]
from Employee

--17.Display max and min salary for Employees {2 Points}

select MAX(Salary) as [Max. Salary],MIN(Salary) as [Min. Salary]
from Employee

--18.Write a function that take Number and display if it is even or odd {2 Points}

create function EvenOrOdd(@num int)
returns varchar(4)
begin
declare @case varchar(4)
if @num % 2 = 0
begin
set @case = 'Even'
end
else
begin
set @case = 'Odd'
end
return @case
end

select dbo.EvenOrOdd(15)

--19.write a function that take category name and display Title of books in that 
--category {2 Points}

create function GetBookTitle(@CatName varchar(50))
returns varchar(50)
begin
declare @BookName varchar(50)
select @BookName = b.Title 
from Book b inner join Category c
on b.Cat_id = c.Id
where c.Cat_name = @CatName

return @BookName
end


select dbo.GetBookTitle('Mathematics')


--20. write a function that takes the phone of the user and displays Book Title , 
--user-name, amount of money and due-date. {2 Points}

create function GetDataByPhone(@PhNum varchar(11))
returns table
as
return
(
select b.Title, u.User_Name,bo.Amount,bo.Due_date
from User_phones up inner join Users u
on up.User_ssn = u.SSN and up.Phone_num = @PhNum
inner join Borrowing bo on bo.User_ssn = u.SSN inner join 
Book b on b.Id = bo.Book_id
)

select * from GetDataByPhone('0102585555')

--21.Write a function that take user name and check if it's duplicated
--return Message in the following format ([User Name] is Repeated 
--[Count] times) if it's not duplicated display msg with this format [user 
--name] is not duplicated,if it's not Found Return [User Name] is Not
--Found {2 Points}


create or alter function SeeIfDuplicated(@name varchar(30))
returns varchar(100)
begin

declare @count int
declare @message varchar(100)
select @count = COUNT(User_Name) 
from Users
where User_Name = @name

if @count = 1
begin
select @message = CONCAT(@name,' is not duplicated! ')
end
else if @count = 0
begin
select @message = CONCAT(@name,' is not found! ')
end
else
begin 
select @message = CONCAT(@name,' is repeated ',@count,' times')
end

return @message

end

select dbo.SeeIfDuplicated('Alaa Omar')


--22.Create a scalar function that takes date and Format to return Date With
--That Format. {2 Points}

create function FormatDate(@date date,@format varchar(10))
returns varchar(50)
begin

return format(@date,@format)

end


select dbo.FormatDate(getdate(),'yyyy')

alter function FormatDate(@code int)
returns varchar(50)
begin 
declare @res varchar(50)
select @res  = CONVERT(varchar,GETDATE(),@code)

return @res
end

select dbo.FormatDate(111)
select dbo.FormatDate(112)


--23.Create a stored procedure to show the number of books per Category.{2
--Points

create or alter proc sp_BooksCategory
as 
select c.Id, COUNT(b.Id) as [Books Number]
from Book b inner join Category c
on b.Cat_id = c.Id
group by c.Id


sp_BooksCategory


--24.Create a stored procedure that will be used in case there is an old manager 
--who has left the floor and a new one becomes his replacement. The 
--procedure should take 3 parameters (old Emp.id, new Emp.id and the 
--floor number) and it will be used to update the floor table. {3 Points}

create proc sp_UpdateFloorManager @oldID int,@newID int,@FloorNumber int
as 
update Floor
set MG_ID = @newID
where MG_ID = @oldID and Number = @FloorNumber

sp_UpdateFloorManager 3,1,1


--25.Create a view AlexAndCairoEmp that displays Employee data for users 
--who live in Alex or Cairo. {2 Points

create view AlexAndCairoEmp
as
select *
from Employee
where lower(Address) in ('alex','cairo') 


select * from AlexAndCairoEmp



--26.create a view "V2" That displays number of books per shelf {2 Points}

create or alter view V2 
as 
select Shelf_code, COUNT(Id) as [Books_Number]
from Book
group by Shelf_code

select * from V2

--27.create a view "V3" That display the shelf code that have maximum 
--number of books using the previous view "V2" {2 Points}

create view V3
as
select Shelf_code
from V2
where Books_Number = (select MAX(Books_Number) from V2)

select * from V3

--28.Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN Book Id Due Date
--Return
--Date
--fees
--then create A trigger that instead of inserting the data of returned book 
--checks if the return date is the due date or not if not so the user must pay 
--a fee and it will be 20% of the amount that was paid before. {3 Points}

create table ReturnedBooks (
UserSSN int,
BookID int,
DueDate date,
ReturnDate date,
fees dec(18,0)
)

create or alter trigger InTimeOrNot
on ReturnedBooks
after insert
as
if (select DueDate from inserted) > (select ReturnDate from inserted)
begin
update ReturnedBooks
set fees = fees*1.2
where UserSSN = (select UserSSN from inserted)
end

insert into ReturnedBooks values (250,409,'1-10-2024 00:00:00',GETDATE(),2300)
insert into ReturnedBooks values (251,410,'10-1-2024 00:00:00',GETDATE(),2400)


--29.In the Floor table insert new Floor With Number of blocks 2 , employee 
--with SSN = 20 as a manager for this Floor,The start date for this manager 
--is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 
--moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
--Mohamed(his SSN =12) His position . {3 Points}

insert into Floor values (49,2,20,GETDATE())

update Floor 
set MG_ID = 12
where MG_ID = 5

update Floor 
set MG_ID = 5
where Number = 6

--////////////////////////////////////////////////////////////////
----Question 30
--///////////////////////////////////////////////////////////////
create view V_2006_Check
as
select *
from Floor
where YEAR(Hiring_Date) = 2022 and MONTH(Hiring_Date) between 3 and 5

select * from V_2006_Check

insert into Floor values (8,2,2,'7-8-2023'),(7,1,4,'4-8-2022') -- 6 does exist in floor number so i added a new floor number as 8

select * from V_2006_Check

--31. Create a trigger to prevent anyone from Modifying or Delete or Insert in 
--the Employee table ( Display a message for user to tell him that he can’t 
--take any action with this Table)

create trigger tri_EmployeeNo
on Employee
instead of insert,update,delete
as 
print 'You cant take any action to this table'

update Employee
set Fname = 'Nano'
where Id = 1


--32.Testing Referential Integrity , Mention What Will Happen When:
--A. Add a new User Phone Number with User_SSN = 50 in
--User_Phones Table {1 Point}
--B. Modify the employee id 20 in the employee table to 21 {1 Point}
--C. Delete the employee with id 1 {1 Point}
--D. Delete the employee with id 12 {1 Point}
--E. Create an index on column (Salary) that allows you to cluster the 
--data in table Employee. {1 Point}

-- (A)
insert into User_phones values(50,'01287577651')
-- error : to create a new row with a new user this user has to be in the main table "Users" first

-- (B)
update Employee set Id = 21 where Id = 20
-- Previously there was a trigger created to prevent any modification to this table 
-- so, the message 'You cant take any action to this table' appeares

-- (C)
delete from Employee where Id = 1
-- Previously there was a trigger created to prevent any modification to this table 
-- so, the message 'You cant take any action to this table' appeares


-- (D)
delete from Employee where Id = 12
-- Previously there was a trigger created to prevent any modification to this table 
-- so, the message 'You cant take any action to this table' appeares

-- (E)

create clustered index SalaryControl
on Employee (Salary)

-- Cannot create more than one clustered index as we know for each table there's a primary key which is considered a clustered index by default 

