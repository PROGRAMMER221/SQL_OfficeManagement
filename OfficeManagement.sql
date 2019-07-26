

create database OfficeManagement

use OfficeManagement
go

create schema Office authorization dbo
go

create table [Office].[Department]
(
	DepId int not null constraint pk_OfficeManagement_Department_DepId primary key (DepId),
	DepName varchar(30) not null
)ON [Primary];
go

create procedure [Office].[Department_Ins]
(
	@DepId int,
	@DepName varchar(30)
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[Department] (DepId,DepName)
		values (@DepId,@DepName)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end

go

create table [Office].[SalaryGrade]
(
	Grade int not null constraint pk_Office_SalaryGrade_Grade primary key (Grade),
	MinSalary int not null,
	MaxSalary int not null,
)ON [Primary];

go

alter procedure [Office].[SalaryGrade_Ins]
(
	@Grade int,
	@MinSalary int,
	@MaxSalary int
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[SalaryGrade] (Grade,MinSalary,MaxSalary)
		values (@Grade,@MinSalary,@MaxSalary)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end

go

create table [office].[WorkShift]
(
	ShiftName varchar(2) not null constraint pk_Office_WorkShift_ShiftName primary key (ShiftName),
	TimeStart time not null,
	TimeEnd time not null
)ON [Primary];
go

alter procedure [Office].[WorkShift_Ins]
(
	@ShiftName varchar(2),
	@TimeStart time,
	@TimeEnd time
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[WorkShift] (ShiftName,TimeStart,TimeEnd)
		values (@ShiftName,@TimeStart,@TimeEnd)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end

go

create table [Office].[Employees]
(
	EmpId int not null constraint pk_Office_Employee_EmpId primary key (EmpId),
	EmpName varchar(50) not null,
	EmpFatherName varchar(50) not null,
	Designation varchar(20) not null,
	ManagerId int null constraint fk_Office_Employees_ManagerId foreign key (ManagerId) references [Office].[Employees] (EmpId),
	JoiningDate date not null,
	DepId int not null constraint fk_Office_Employees_DepId foreign key (DepId) references [Office].[Department] (DepId),
	ShiftName varchar(2) not null constraint fk_Office_Employees_ShiftName foreign key (ShiftName) references [Office].[WorkShift] (ShiftName),
	Arival time not null,
	Departure time not null,
	Grade int not null constraint fk_Office_Employees_Grade foreign key (Grade) references [Office].[SalaryGrade] (Grade),
	Salary int not null,
	Comission int not null
)ON [Primary];
go

alter procedure [Office].[Employees_Ins]
(
	@EmpId int,
	@EmpName varchar(50),
	@EmpFatherName varchar(50),
	@Designation varchar(20),
	@ManagerId int,
	@JoiningDate date,
	@DepId int,
	@ShiftName Varchar(2),
	@Arival time,
	@Departure time,
	@Grade int,
	@Salary int,
	@Comission int
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[Employees] (EmpId,EmpName,EmpFatherName,Designation,ManagerId,JoiningDate,DepId,ShiftName,Arival,Departure,Grade,Salary,Comission)
		values (@EmpId,@EmpName,@EmpFatherName,@Designation,@ManagerId,@JoiningDate,@DepId,@ShiftName,@Arival,@Departure,@Grade,@Salary,@Comission)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end
go

create table [office].[Attendance] 
(
	EmpId int not null constraint fk_office_Attendance_EmpId foreign key (EmpId) references [Office].[Employees] (EmpId),
	WDate date not null,
	ArivalDateTime DateTime not null,
	DepartureDateTime DateTime not null,
	WorkingHRS decimal(5,2) not null,
	OTHRS decimal(5,2) not null,
	DayType varchar(1) not null constraint ck_Office_Attendance_DayType Check (daytype in ('W','H','A','O'))
	constraint pk_office_EmpId_WDate primary key (EmpId,WDate)
)ON [Primary];
go


go

alter procedure [office].[Attendance_Ins]
(
	@EmpId int,
	@WDate date,
	@ArivalDateTime DateTime,
	@DepartureDateTime DateTime,
	@WorkingHRS decimal(5,2),
	@OTHRS decimal(5,2)
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[Attendance] (EmpId,WDate,ArivalDateTime,DepartureDateTime,WorkingHRS,OTHRS)
		values (@EmpId,@WDate,@ArivalDateTime,@DepartureDateTime,@WorkingHRS,@OTHRS)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end
go

create table [Office].[Salary]
(
	EmpId int not null constraint fk_office_Salary_EmpId foreign key (EmpId) references [Office].[Employees] (EmpId),
	SalMonth varchar(10) not null,
	SalYear int not null,
	Salary int not null,
	WDay int not null,
	Holiday int not null,
	WeeklyOff int not null,
	GrossSalary int not null
	constraint pk_Office_Salary_EmpId_SalMonth_SalYear primary key (EmpId,SalMonth,SalYear)
)ON [Primary];
go

alter procedure [Office].[Salary_Ins]
(
	@EmpId int,
	@SalMonth varchar(10),
	@SalYear int ,
	@Salary int,
	@WDay int,
	@Holiday int,
	@WeeklyOff int,
	@GrossSalary int
)
as
begin
	set nocount on
	begin transaction
	begin try
	insert into [Office].[Salary] (EmpId,SalMonth,SalYear,Salary,WDay,Holiday,WeeklyOff,GrossSalary)
		values (@EmpId,@SalMonth,@SalYear,@Salary,@WDay,@Holiday,@WeeklyOff,@GrossSalary)
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;    
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();  
  
		if @@TRANCOUNT > 0
		begin
			--print 'error catch'
			ROLLBACK TRANSACTION
		end
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
		RETURN;
	end catch
	if @@TRANCOUNT > 0
	begin
		--print 'commit'
		COMMIT TRANSACTION
	end
	RETURN;
end
go

create trigger [office].[trr_SalaryCheck] on [Office].[Employees]
after insert
as
begin
	declare	@grade int,
		@salary int

	declare cur_Salary cursor local forward_only read_only for select Grade,Salary from inserted
	open cur_Salary
	fetch next from cur_Salary into @grade,@salary
	while @@Fetch_Status = 0
	begin
		if not exists ( select * from [Office].[SalaryGrade] where Grade = @grade and @salary between MinSalary and MaxSalary)
		begin
			raiserror('Invalid Salary ',16,1)
			rollback transaction
		end
		fetch next from cur_Salary into @grade,@salary
	end
end
close cur_Salary
deallocate cur_Salary
go

select * from [Office].[Attendance]
