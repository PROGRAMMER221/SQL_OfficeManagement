
use OfficeManagement

execute [Office].[Department_Ins] 001,'Marketing'
execute [Office].[Department_Ins] 002,'Sales'
execute [Office].[Department_Ins] 003,'HR'
go

execute [Office].[SalaryGrade_Ins] 101,10000,20000
execute [Office].[SalaryGrade_Ins] 102,20000,30000
execute [Office].[SalaryGrade_Ins] 103,30000,40000
go

execute [Office].[WorkShift_Ins] 'DY','10:00','18:00'
execute [Office].[WorkShift_Ins] 'NY','21:00','6:00'
go

execute [Office].[Employees_Ins] 5501,'Amartya Mishra','Ajay Kumar Mishra','Clerk',null,'12/03/2000',001,'DY','10:00','18:00',101,15000,5000
execute [Office].[Employees_Ins] 5502,'Meeraj Singh','Rahul Singh','Project Manager',null,'06/22/2001',002,'NY','21:00','6:00',102,25000,4000
execute [Office].[Employees_Ins] 5503,'Shivam Tripathi','Ganesh Tripathi','Accountant',null,'10/09/1900',003,'DY','10:00','18:00',103,35000,7000
execute [Office].[Employees_Ins] 5504,'Harsh Sharma','Gaurav Sharma','Assiatant',null,'04/09/1999',002,'NY','21:00','6:00',102,27000,9000
execute [Office].[Employees_Ins] 5505,'Mayank Raj','Aman Raj','DBA',null,'11/11/1999',001,'NY','21:00','6:00',101,17000,1000
execute [Office].[Employees_Ins] 5506,'Varun Varma','Gopal Varma','Fincance Adviser',null,'01/30/1989',002,'DY','10:00','18:00',103,29999,2000
go

insert into [Office].[WeeklyOff] values ('Sunday')

go

insert into [Office].[Holiday] values ('08/15/2019','Independance Day'),
('10/02/2019','Gandhi Jayanti'),
('12/25/2019','X-mas'),
('07/28/2019','Speccial Day')
go

execute [Office].[Attendance_Ins] 5501,'07/29/2019','07/29/2019 21:00','07/30/2019 6:00'
execute [Office].[Attendance_Ins] 5501,'07/30/2019','07/30/2019 21:00','07/31/2019 7:00'
execute [Office].[Attendance_Ins] 5501,'07/28/2019','07/28/2019 21:00','07/29/2019 6:00'
go
