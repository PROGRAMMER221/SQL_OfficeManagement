IF OBJECT_ID (N'dbo.Holiday', N'U') IS NOT NULL  
    DROP TABLE Holiday;  
GO  

create table [dbo].[Holiday]
(
	HDate date not null primary key,
	hname varchar(20) not null 
);

GO

IF OBJECT_ID (N'dbo.hrparameter', N'U') IS NOT NULL  
    DROP TABLE hrparameter;  
GO  

create table [dbo].[hrparameter]
-- Used for create a predefined Scaler Parameters  
(
	WeeklyOff varchar(10),
	GenWorkingHrs tinyint,
	HalfWorkingHrs tinyint,
	LunchHrs tinyint
) ON [PRIMARY];

GO

INSERT INTO [dbo].[hrparameter] VALUES ('Sunday',9,4,1);

GO

IF OBJECT_ID (N'dbo.ufWeeklyOff', N'FN') IS NOT NULL  
    DROP FUNCTION ufWeeklyOff;  
GO  

CREATE FUNCTION dbo.ufWeeklyOff()
RETURNS varchar(10)   
AS   
-- Returns the Weekly off if Not Defined returns Sunday.  
BEGIN  
    DECLARE @ret varchar(10);  
    SELECT @ret = WeeklyOff   
    FROM [dbo].[hrparameter];  
     IF (@ret IS NULL)   
        SET @ret = 'Sunday';  
    RETURN @ret;  
END; 

GO

IF OBJECT_ID (N'dbo.ufGenWhrs', N'FN') IS NOT NULL  
    DROP FUNCTION ufGenWhrs;  
GO  

CREATE FUNCTION dbo.ufGenWhrs()
RETURNS tinyint
AS   
-- Returns the generaral working Hours and If not defined returns 9
BEGIN  
    DECLARE @ret tinyint;  
    SELECT @ret = GenWorkingHrs   
    FROM [dbo].[hrparameter];  
     IF (@ret IS NULL)   
        SET @ret = 9;  
    RETURN @ret;  
END; 

GO

IF OBJECT_ID (N'dbo.ufHalfWhrs', N'FN') IS NOT NULL  
    DROP FUNCTION ufHalfWhrs;  
GO  

CREATE FUNCTION dbo.ufHalfWhrs()
RETURNS tinyint
AS   
-- Returns the generaral working Hours and If not defined returns 9
BEGIN  
    DECLARE @ret tinyint;  
    SELECT @ret = HalfWorkingHrs   
    FROM [dbo].[hrparameter];  
     IF (@ret IS NULL)   
        SET @ret = 4;  
    RETURN @ret;  
END; 

GO

IF OBJECT_ID (N'dbo.ufLunchHrs', N'FN') IS NOT NULL  
    DROP FUNCTION ufLunchHrs;  
GO  

CREATE FUNCTION dbo.ufLunchHrs()
RETURNS tinyint
AS   
-- Returns the generaral working Hours and If not defined returns 9
BEGIN  
    DECLARE @ret tinyint;  
    SELECT @ret = LunchHrs   
    FROM [dbo].[hrparameter];  
     IF (@ret IS NULL)   
        SET @ret = 1;  
    RETURN @ret;  
END; 

GO

Declare	@WDate date,
	@ArivalDateTime DateTime,
	@DepartureDateTime DateTime

set @WDate = '2019-07-29'
set @ArivalDateTime = '2019-07-29 9:00:00'
set @DepartureDateTime = '2019-07-29 18:00:00'

declare @DTY varchar(1),
	@TotalWorkingHRS decimal(5,2) = DATEDIFF(mi,@ArivalDateTime,@DepartureDateTime)/60.00,
	@nwhrs tinyint = [dbo].[ufGenWhrs](),
	@LunchHrs tinyint = [dbo].[ufLunchHrs](),
	@HalfWhrs tinyint = [dbo].[ufHalfWhrs](),
	@WeeklyOff varchar(10) = [dbo].[ufWeeklyoff](),
	@DayName varchar(10) = DATENAME(weekday,@Wdate),
	@HDate bit = 0,
	@WorkingHRS decimal(5,2) = 0,
	@OTHRS decimal(5,2) = 0

	select @HDate = 1 FROM [dbo].[Holiday] WHERE HDate = @WDate

	SELECT @DTY = CASE WHEN @DayName = @WeeklyOff AND @HDate = 1  Then 'H'
		WHEN @DayName = @WeeklyOff THEN 'W'
		ELSE 'P' END;
	
	IF @DTY = 'P'
	BEGIN
		SELECT @WorkingHRS = CASE WHEN @TotalWorkingHRS >= @nwhrs Then @nwhrs - @LunchHrs
			WHEN @TotalWorkingHRS >= @HalfWhrs AND @TotalWorkingHRS <= @nwhrs Then @HalfWhrs
			WHEN @TotalWorkingHRS < @HalfWhrs Then 0 END;
		
		IF @TotalWorkingHRS > @nwhrs
			set @OTHRS = @TotalWorkingHRS - @nwhrs;
		
		IF @WorkingHRS = 0
			set @DTY = 'A';
	END;	
	IF (@DTY = 'H' or @DTY = 'W')
		SELECT @OTHRS = CASE WHEN @TotalWorkingHRS >= @nwhrs THEN @TotalWorkingHRS - @LunchHrs
			WHEN @TotalWorkingHRS > @HalfWhrs AND @TotalWorkingHRS <= @nwhrs THEN @TotalWorkingHRS - 0.5
			WHEN @TotalWorkingHRS <= @HalfWhrs THEN @TotalWorkingHRS END;

	print @DTY
	print @WorkingHRS
	print @OTHRS


	
--	insert into [Office].[Attendance] (EmpId,WDate,ArivalDateTime,DepartureDateTime,WorkingHRS,OTHRS,Daytype)
--		values (@EmpId,@WDate,@ArivalDateTime,@DepartureDateTime,@WorkingHRS,@OTHRS,@DTY)

GO

