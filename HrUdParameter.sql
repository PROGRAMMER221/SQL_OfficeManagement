IF OBJECT_ID (N'dbo.hrparameter', N'U') IS NOT NULL  
    DROP TABLE hrparameter;  
GO  

create table [dbo].[hrparameter]
-- Used for create a predefined Scaler Parameters  
(
	WeeklyOff varchar(10),
	GenWorkingHrs tinyint
) ON [PRIMARY];

GO

INSERT INTO [dbo].[hrparameter] VALUES ('Sunday',8)

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
