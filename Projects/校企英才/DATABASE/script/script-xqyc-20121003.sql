USE [master]
GO
/****** Object:  Database [xiaoqiyingcaidatabasemanage]    Script Date: 2012/10/3 星期三 18:42:30 ******/
CREATE DATABASE [xiaoqiyingcaidatabasemanage]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'xiaoqiyingcaidatabasemanage', FILENAME = N'E:\MyWorkSpace\myProject\HiLandCompany\Projects\校企英才\DATABASE\xiaoqiyingcaidatabasemanage.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'xiaoqiyingcaidatabasemanage_log', FILENAME = N'E:\MyWorkSpace\myProject\HiLandCompany\Projects\校企英才\DATABASE\xiaoqiyingcaidatabasemanage_log.ldf' , SIZE = 5184KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [xiaoqiyingcaidatabasemanage].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ARITHABORT OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET  DISABLE_BROKER 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET RECOVERY FULL 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET  MULTI_USER 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET DB_CHAINING OFF 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'xiaoqiyingcaidatabasemanage', N'ON'
GO
USE [xiaoqiyingcaidatabasemanage]
GO
/****** Object:  StoredProcedure [dbo].[usp_Core_Area_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Core_Area_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT AreaID FROM [CoreArea] '
SET @SQLCOUNT='SELECT COUNT(AreaID) FROM [CoreArea] '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY AreaID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	T.*
FROM 
    [CoreArea] T inner join #PageIndex I on T.AreaID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_Core_Attachment_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[usp_Core_Attachment_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT attachmentID FROM [CoreAttachment] '
SET @SQLCOUNT='SELECT COUNT(attachmentID) FROM [CoreAttachment] '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY attachmentID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	T.*
FROM 
    [CoreAttachment] T inner join #PageIndex I on T.attachmentID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_Core_User_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[usp_Core_User_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT UserID FROM [CoreUser] '
SET @SQLCOUNT='SELECT COUNT(UserID) FROM [CoreUser] '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY UserID DESC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	T.*
FROM 
    [CoreUser] T inner join #PageIndex I on T.UserID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_General_Enterprise_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_General_Enterprise_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT BIZ.EnterpriseID FROM GeneralEnterprise BIZ '
SET @SQLCOUNT='SELECT COUNT(BIZ.EnterpriseID) FROM GeneralEnterprise BIZ '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY EnterpriseID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	BIZ.*
FROM 
    GeneralEnterprise BIZ inner join #PageIndex I on BIZ.EnterpriseID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_General_LoanBasic_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_General_LoanBasic_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT GLB.LoanID FROM GeneralLoanBasic GLB LEFT JOIN GeneralEnterprise GE ON GLB.LoanUserID= GE.EnterpriseGuid LEFT JOIN CoreUser CU ON GE.EnterpriseGuid= CU.DepartmentGuid '
SET @SQLCOUNT='SELECT COUNT(GLB.LoanID) FROM GeneralLoanBasic GLB LEFT JOIN GeneralEnterprise GE ON GLB.LoanUserID= GE.EnterpriseGuid LEFT JOIN CoreUser CU ON GE.EnterpriseGuid= CU.DepartmentGuid '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY LoanID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	GLB.*,CU.UserGuid as LoanUserRealID,CU.UserNameFirst+ ' ' + CU.UserNameLast as LoanUserRealName
FROM 
    GeneralLoanBasic GLB inner join #PageIndex I on GLB.LoanID = I.ItemID 
    LEFT JOIN GeneralEnterprise GE ON GLB.LoanUserID= GE.EnterpriseGuid 
    LEFT JOIN CoreUser CU ON GE.EnterpriseGuid= CU.DepartmentGuid
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_General_News_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_General_News_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT [NewsID] FROM [GeneralNews] '
SET @SQLCOUNT='SELECT COUNT(NewsID) FROM [GeneralNews] '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY [NewsID] ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	T.*,C.NewsCategoryName
FROM 
    [GeneralNews] T inner join #PageIndex I on T.[NewsID] = I.ItemID 
    Left Join GeneralNewsCategory C on T.NewsCategoryCode= C.NewsCategoryCode
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_General_NewsCategory_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[usp_General_NewsCategory_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT NewsCategoryID FROM [GeneralNewsCategory] '
SET @SQLCOUNT='SELECT COUNT(NewsCategoryID) FROM [GeneralNewsCategory] '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY NewsCategoryID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	T.*
FROM 
    [GeneralNewsCategory] T inner join #PageIndex I on T.NewsCategoryID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_General_Remind_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_General_Remind_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT BIZ.RemindID FROM GeneralRemind BIZ '
SET @SQLCOUNT='SELECT COUNT(BIZ.RemindID) FROM GeneralRemind BIZ '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY RemindID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	BIZ.*
FROM 
    GeneralRemind BIZ inner join #PageIndex I on BIZ.RemindID = I.ItemID 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_Simple_Product_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Simple_Product_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT productID FROM SimpleProduct '
SET @SQLCOUNT='SELECT COUNT(productID) FROM SimpleProduct '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY productID DESC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	A.*,B.productCategoryName
FROM 
    SimpleProduct A inner join #PageIndex I on A.productID = I.ItemID 
    LEFT JOIN SimpleProductCategory B ON A.productCategoryCode= B.productCategoryCode 
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_XQYC_Employee_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_XQYC_Employee_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT EMP.EmployeeID FROM XQYCEmployee EMP LEFT JOIN CoreUser CU ON EMP.UserGuid= CU.UserGuid '
SET @SQLCOUNT='SELECT COUNT(EMP.EmployeeID) FROM XQYCEmployee EMP LEFT JOIN CoreUser CU ON EMP.UserGuid= CU.UserGuid '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY EmployeeID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	EMP.*,CU.*
FROM 
    XQYCEmployee EMP inner join #PageIndex I on EMP.EmployeeID = I.ItemID 
    LEFT JOIN CoreUser CU ON EMP.UserGuid= CU.UserGuid
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_XQYC_InformationBroker_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_XQYC_InformationBroker_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT BIZ.InformationBrokerID FROM XQYCInformationBroker BIZ LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid '
SET @SQLCOUNT='SELECT COUNT(BIZ.InformationBrokerID) FROM XQYCInformationBroker BIZ LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY InformationBrokerID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	BIZ.*,CU.*
FROM 
    XQYCInformationBroker BIZ inner join #PageIndex I on BIZ.InformationBrokerID = I.ItemID 
    LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[usp_XQYC_Labor_SelectPaging]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_XQYC_Labor_SelectPaging]
(@startIndex INT, 
 @endindex INT,
 @whereClause Nvarchar(512)= NULL,
 @orderClause Nvarchar(200)=NULL
 )
AS
BEGIN

-- 创建临时表保存搜索结果
CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ItemID int
)

-- 为加快查找速度，在临时表上创建索引
CREATE INDEX page_index ON #PageIndex(IndexID)

-- 组装查询集合和查询数量的语句
DECLARE @SQL nvarchar(1024)
DECLARE @SQLCOUNT nvarchar(1024)
SET @SQL='SELECT BIZ.LaborID FROM XQYCLabor BIZ LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid '
SET @SQLCOUNT='SELECT COUNT(BIZ.LaborID) FROM XQYCLabor BIZ LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid '

-- 如果有条件语句的话，需要附加条件语句
IF @whereClause IS NOT NULL AND LEN(@whereClause) > 0
BEGIN
   SET @SQL=@SQL+' WHERE '+ @whereClause
   SET @SQLCOUNT=@SQLCOUNT+' WHERE '+ @whereClause
END

-- 如果有排序要求的话，需要附加排序语句
IF @orderClause IS NOT NULL AND LEN(@orderClause) > 0
BEGIN
	SET @SQL=@SQL+ ' ORDER BY '+ @orderClause
END
ELSE
BEGIN
	SET @SQL=@SQL+ ' ORDER BY LaborID ASC'
END



-- 将查询结果放入临时表中
INSERT INTO #PageIndex (ItemID)
EXEC sp_executesql @SQL


-- 联合业务逻辑表和临时表获取数据(数据来源于业务逻辑表,获取的规则来源于临时表)
SELECT 
	BIZ.*,CU.*
FROM 
    XQYCLabor BIZ inner join #PageIndex I on BIZ.LaborID = I.ItemID 
    LEFT JOIN CoreUser CU ON BIZ.UserGuid= CU.UserGuid
WHERE 
	I.IndexID between @startIndex and @endIndex
ORDER BY
	I.IndexID	

DROP TABLE #PageIndex

EXEC sp_executesql @SQLCOUNT

END

GO
/****** Object:  Table [dbo].[CoreAttachment]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreAttachment](
	[attachmentID] [int] IDENTITY(1,1) NOT NULL,
	[attachmentGuid] [uniqueidentifier] NOT NULL,
	[masterGuid] [uniqueidentifier] NULL,
	[attachmentRealName] [nvarchar](200) NULL,
	[attachmentFriendlyName] [nvarchar](200) NULL,
	[attachmentDesc] [nvarchar](2000) NULL,
	[attachmentCategory] [int] NULL,
	[attachmentMime] [nvarchar](20) NULL,
	[attachmentFileSize] [decimal](18, 2) NULL,
	[attachmentImageWidth] [decimal](18, 2) NULL,
	[attachmentImageHeight] [decimal](18, 2) NULL,
	[downloadCount] [int] NULL,
	[createTime] [datetime] NULL,
	[createUserGuid] [uniqueidentifier] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_CoreAttachment] PRIMARY KEY CLUSTERED 
(
	[attachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreDepartment]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreDepartment](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentGuid] [uniqueidentifier] NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[DepartmentNameShort] [nvarchar](50) NULL,
	[DepartmentDescription] [nvarchar](max) NULL,
	[DepartmentFullPath] [nvarchar](200) NULL,
	[DepartmentCode] [nvarchar](50) NULL,
	[DepartmentParentGuid] [uniqueidentifier] NULL,
	[DepartmentType] [int] NULL,
	[DepartmentIsSpecial] [int] NULL,
	[CanUsable] [int] NULL,
	[PropertyNames] [nvarchar](max) NULL,
	[PropertyValues] [nvarchar](max) NULL,
 CONSTRAINT [PK_CoreDepartment] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CorePermission]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CorePermission](
	[PermissionKey] [uniqueidentifier] NOT NULL,
	[OwnerKey] [nvarchar](50) NULL,
	[OwnerType] [int] NULL,
	[PermissionItemGuid] [uniqueidentifier] NULL,
	[PermissionItemValue] [int] NULL,
	[PermissionMode] [int] NULL,
	[PermissionKind] [int] NULL,
	[CreateUserGuid] [uniqueidentifier] NULL,
	[CreateUserType] [int] NULL,
	[IsFreeAwayCreator] [int] NULL,
 CONSTRAINT [PK_CorePermission] PRIMARY KEY CLUSTERED 
(
	[PermissionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreRole]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreRole](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleGuid] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](50) NULL,
	[RoleDescrition] [nvarchar](2000) NULL,
	[CanUsable] [int] NULL,
	[IsInnerRole] [int] NOT NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_CoreRole] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreUser]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[UserCode] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[PasswordEncrytType] [int] NULL,
	[PasswordEncrytSalt] [nvarchar](50) NULL,
	[UserNameCN] [nvarchar](50) NULL,
	[UserNameEN] [nvarchar](50) NULL,
	[UserNameFirst] [nvarchar](20) NULL,
	[UserNameLast] [nvarchar](20) NULL,
	[UserNameMiddle] [nvarchar](20) NULL,
	[DepartmentID] [int] NULL,
	[DepartmentGuid] [uniqueidentifier] NULL,
	[DepartmentCode] [nvarchar](20) NULL,
	[DepartmentUserType] [int] NULL,
	[UserFullPath] [nvarchar](200) NULL,
	[AreaCode] [nvarchar](20) NULL,
	[UserEmail] [nvarchar](50) NULL,
	[UserType] [int] NULL,
	[UserStatus] [int] NULL,
	[UserRemark] [nvarchar](2000) NULL,
	[UserCardID] [nvarchar](20) NULL,
	[UserCardIDIssued] [nvarchar](200) NULL,
	[DriversLicenceNumber] [nvarchar](50) NULL,
	[DriversLicenceNumberIssued] [nvarchar](200) NULL,
	[PassportCode] [nvarchar](50) NULL,
	[PassportCodeIssued] [nvarchar](200) NULL,
	[UserSex] [int] NULL,
	[UserBirthDay] [datetime] NULL,
	[MaritalStatus] [int] NULL,
	[UserMobileNO] [nvarchar](20) NULL,
	[UserRegisterDate] [datetime] NULL,
	[UserAgreeDate] [datetime] NULL,
	[UserWorkStartDate] [datetime] NULL,
	[UserWorkEndDate] [datetime] NULL,
	[CompanyMail] [nvarchar](50) NULL,
	[UserTitle] [nvarchar](50) NULL,
	[UserPosition] [nvarchar](50) NULL,
	[WorkTelphone] [nvarchar](20) NULL,
	[HomeTelephone] [nvarchar](20) NULL,
	[UserPhoto] [nvarchar](50) NULL,
	[UserMacAddress] [nvarchar](20) NULL,
	[UserLastIP] [nvarchar](20) NULL,
	[UserLastDateTime] [datetime] NULL,
	[BrokerKey] [nvarchar](50) NULL,
	[EnterpriseKey] [nvarchar](50) NULL,
	[UserHeight] [decimal](18, 2) NULL,
	[UserWeight] [decimal](18, 2) NULL,
	[UserNation] [nvarchar](50) NULL,
	[UserCountry] [nvarchar](50) NULL,
	[UserEducationalBackground] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_CoreUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreUserInRole]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoreUserInRole](
	[RelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [uniqueidentifier] NOT NULL,
	[RoleGuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CoreUserRole] PRIMARY KEY CLUSTERED 
(
	[UserGuid] ASC,
	[RoleGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralBank]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralBank](
	[BankID] [int] IDENTITY(1,1) NOT NULL,
	[BankGuid] [uniqueidentifier] NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[BankNo] [int] NULL,
	[IsPrimary] [int] NULL,
	[CanUsable] [int] NULL,
	[BankName] [nvarchar](200) NULL,
	[Branch] [nvarchar](200) NULL,
	[BankCode] [nvarchar](50) NULL,
	[AccountName] [nvarchar](50) NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[AccountStatus] [int] NULL,
	[BankAddress] [nvarchar](200) NULL,
	[AreaCode] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_GeneralBank] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralBasicSetting]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralBasicSetting](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[SettingKey] [nvarchar](50) NULL,
	[SettingValue] [nvarchar](200) NULL,
	[SettingDesc] [nvarchar](2000) NULL,
	[SettingCategory] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](50) NULL,
	[OrderNumber] [int] NULL,
	[CanUsable] [int] NULL,
	[IsInnerSetting] [int] NULL,
 CONSTRAINT [PK_CoreBasicSetting] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralEnterprise]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralEnterprise](
	[EnterpriseID] [int] IDENTITY(1,1) NOT NULL,
	[EnterpriseGuid] [uniqueidentifier] NULL,
	[CompanyName] [nvarchar](200) NULL,
	[BusinessType] [int] NULL,
	[TradingName] [nvarchar](200) NULL,
	[Industry] [nvarchar](200) NULL,
	[EnterpriseCode] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[PrincipleAddress] [nvarchar](200) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[EstablishedYears] [int] NULL,
	[EstablishedTime] [datetime] NULL,
	[GrossIncome] [decimal](18, 2) NULL,
	[Profit] [decimal](18, 2) NULL,
	[AssociatedEnterpriseGuid] [uniqueidentifier] NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[AreaCode] [nvarchar](50) NULL,
	[CompanyNameShort] [nvarchar](50) NULL,
	[CanUsable] [int] NULL,
	[Longitude] [decimal](18, 14) NULL,
	[Lantitude] [decimal](18, 14) NULL,
	[BrokerKey] [nvarchar](50) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_EnterpriseInfo] PRIMARY KEY CLUSTERED 
(
	[EnterpriseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralImage]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralImage](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[ImageGuid] [uniqueidentifier] NULL,
	[ImageName] [nvarchar](200) NULL,
	[RelativeGuid] [uniqueidentifier] NULL,
	[ImageCategoryCode] [nvarchar](50) NULL,
	[ImageKind] [nvarchar](50) NULL,
	[OwnerGuid] [uniqueidentifier] NULL,
	[ImageRelativePath] [nvarchar](500) NULL,
	[ImageSize] [int] NULL,
	[ImageWidth] [int] NULL,
	[ImageHeight] [int] NULL,
	[ImageStatus] [int] NULL,
	[ImageOrder] [int] NULL,
	[ImageIsMain] [int] NULL,
	[CanUsable] [int] NULL,
	[ImageType] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[ImageDescription] [nvarchar](max) NULL,
	[ImageDownCount] [int] NULL,
	[ImageDisplayCount] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_SimpleProductImage] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralLoanBasic]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralLoanBasic](
	[LoanID] [int] IDENTITY(1,1) NOT NULL,
	[LoanGuid] [uniqueidentifier] NULL,
	[LoanType] [int] NULL,
	[LoanAmount] [decimal](18, 2) NULL,
	[LoanTermType] [int] NULL,
	[LoanInterest] [decimal](18, 6) NULL,
	[LoanTermCount] [int] NULL,
	[LoanPurpose] [nvarchar](2000) NULL,
	[LoanUserID] [uniqueidentifier] NULL,
	[LoanDate] [datetime] NULL,
	[LoanStatus] [int] NULL,
	[CheckUserID] [uniqueidentifier] NULL,
	[CheckDate] [datetime] NULL,
	[ReadDate] [datetime] NULL,
	[ReadUserID] [uniqueidentifier] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_LoanBasicInfo] PRIMARY KEY CLUSTERED 
(
	[LoanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralLoanSchedule]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralLoanSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleGuid] [uniqueidentifier] NULL,
	[ScheduleNo] [nvarchar](50) NULL,
	[ScheduleStatus] [int] NULL,
	[LoanGuid] [uniqueidentifier] NULL,
	[Principal] [decimal](18, 2) NULL,
	[Interest] [decimal](18, 2) NULL,
	[Penalty] [decimal](18, 2) NULL,
	[LateCharge] [decimal](18, 2) NULL,
	[OtherFee] [decimal](18, 2) NULL,
	[PrincipalPaid] [decimal](18, 2) NULL,
	[InterestPaid] [decimal](18, 2) NULL,
	[PenaltyPaid] [decimal](18, 2) NULL,
	[LateChargePaid] [decimal](18, 2) NULL,
	[OtherFeePaid] [decimal](18, 2) NULL,
	[PrincipalBalance] [decimal](18, 2) NULL,
	[TotalBalance] [decimal](18, 2) NULL,
	[PaymentDate] [datetime] NULL,
	[PaidDate] [datetime] NULL,
	[ScheduleTimes] [int] NULL,
	[ScheduleParentGuid] [uniqueidentifier] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_LoanSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralLog]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogGuid] [uniqueidentifier] NULL,
	[LogCategory] [nvarchar](50) NULL,
	[LogStatus] [int] NULL,
	[LogLevel] [nvarchar](50) NULL,
	[Logger] [nvarchar](255) NULL,
	[LogMessage] [nvarchar](4000) NULL,
	[LogThread] [nvarchar](255) NULL,
	[LogException] [nvarchar](2000) NULL,
	[LogDate] [datetime] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_GeneralLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralNews]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralNews](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[NewsGuid] [uniqueidentifier] NOT NULL,
	[NewsCategoryCode] [nvarchar](20) NULL,
	[NewsTitle] [nvarchar](200) NULL,
	[NewsBody] [nvarchar](max) NULL,
	[NewsSEOUrl] [nvarchar](200) NULL,
	[NewsDate] [datetime] NULL,
	[NewsAuthor] [nvarchar](50) NULL,
	[NewsReadCount] [int] NULL,
	[CanUsable] [int] NULL,
	[NewsIsTop] [int] NULL,
	[NewsIsRecommend] [int] NULL,
	[NewsPlusCount] [int] NULL,
	[NewsMinusCount] [int] NULL,
	[NewsRating] [decimal](18, 2) NULL,
	[NewsOriginalFrom] [nvarchar](50) NULL,
	[NewsOriginalUrl] [nvarchar](200) NULL,
	[NewsOriginalAuthor] [nvarchar](50) NULL,
	[NewsOriginalDate] [datetime] NULL,
 CONSTRAINT [PK_GeneralNews] PRIMARY KEY CLUSTERED 
(
	[NewsGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralNewsCategory]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralNewsCategory](
	[NewsCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[NewsCategoryCode] [nvarchar](20) NOT NULL,
	[NewsCategoryName] [nvarchar](50) NULL,
	[CanUsable] [int] NULL,
 CONSTRAINT [PK_GeneralNewsCategory] PRIMARY KEY CLUSTERED 
(
	[NewsCategoryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralRemind]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralRemind](
	[RemindID] [int] IDENTITY(1,1) NOT NULL,
	[RemindGuid] [uniqueidentifier] NULL,
	[SenderKey] [nvarchar](50) NULL,
	[SenderName] [nvarchar](50) NULL,
	[ReceiverKey] [nvarchar](50) NULL,
	[ReceiverName] [nvarchar](50) NULL,
	[Emergency] [int] NULL,
	[Importance] [int] NULL,
	[TopLevel] [int] NULL,
	[RemindTitle] [nvarchar](50) NULL,
	[RemindUrl] [nvarchar](500) NULL,
	[RemindDescription] [nvarchar](max) NULL,
	[RemindCategory] [int] NULL,
	[RemindType] [int] NULL,
	[CreateDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[ExpireDate] [datetime] NULL,
	[ReadDate] [datetime] NULL,
	[ResourceKey] [nvarchar](50) NULL,
	[ProcessKey] [nvarchar](50) NULL,
	[ActivityKey] [nvarchar](50) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_GeneralRemind] PRIMARY KEY CLUSTERED 
(
	[RemindID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralResidental]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralResidental](
	[ResidentialID] [int] IDENTITY(1,1) NOT NULL,
	[ResidentialGuid] [uniqueidentifier] NULL,
	[ResidentalUserGuid] [uniqueidentifier] NULL,
	[ResidentialStatus] [int] NULL,
	[ResidentalNo] [int] NULL,
	[IsPrimary] [int] NULL,
	[State] [nvarchar](200) NULL,
	[City] [nvarchar](200) NULL,
	[Suburb] [nvarchar](200) NULL,
	[Street] [nvarchar](500) NULL,
	[ApartmentNo] [nvarchar](200) NULL,
	[PostCode] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[ResidentalYears] [int] NULL,
	[ResidentalMonths] [int] NULL,
	[ResidentalBeginTime] [datetime] NULL,
	[ResidentaEndTime] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_GeneralResidental] PRIMARY KEY CLUSTERED 
(
	[ResidentialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GeneralShoppingCart]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneralShoppingCart](
	[ShoppingItemID] [int] IDENTITY(1,1) NOT NULL,
	[ShoppingItemGuid] [uniqueidentifier] NULL,
	[ProductKey] [nvarchar](50) NULL,
	[ProductName] [nvarchar](255) NULL,
	[ProductPrice] [decimal](18, 2) NULL,
	[ProductQuantity] [int] NULL,
	[OwnerKey] [nvarchar](50) NULL,
	[IsTempOwner] [int] NULL,
	[ShoppingItemMemo] [nvarchar](max) NULL,
	[CreateTime] [datetime] NULL,
	[IsFavoriteItem] [int] NULL,
	[CanUsable] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_GeneralShoppingCart_1] PRIMARY KEY CLUSTERED 
(
	[ShoppingItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoanIncomeAsset]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanIncomeAsset](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemGuid] [uniqueidentifier] NULL,
	[ItemKind] [int] NULL,
	[ItemType] [int] NULL,
	[ItemNo] [int] NULL,
	[ItemName] [nvarchar](50) NULL,
	[ItemValue] [decimal](18, 2) NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_LoanIncomeAsset] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoanLiability]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanLiability](
	[LiabilityID] [int] IDENTITY(1,1) NOT NULL,
	[LiabilityGuid] [uniqueidentifier] NULL,
	[ItemKind] [int] NULL,
	[ItemType] [int] NULL,
	[LiabilityLenderInfo] [nvarchar](200) NULL,
	[LiabilityAmountOwing] [decimal](18, 2) NULL,
	[LiabilityPaymentMonthly] [decimal](18, 2) NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[PropertyNames] [nchar](10) NULL,
	[PropertyValues] [nchar](10) NULL,
 CONSTRAINT [PK_LoanLiability] PRIMARY KEY CLUSTERED 
(
	[LiabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoanSecuredProperty]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanSecuredProperty](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemGuid] [uniqueidentifier] NULL,
	[ItemName] [nvarchar](200) NULL,
	[ItemNo] [int] NULL,
	[ItemKind] [int] NULL,
	[ItemType] [int] NULL,
	[ItemDetail] [nvarchar](200) NULL,
	[ItemValue] [decimal](18, 2) NULL,
	[ItemOwerName] [nvarchar](50) NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_LoanSecuredProperty] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoanWorks]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanWorks](
	[WorkID] [int] IDENTITY(1,1) NOT NULL,
	[WorkGuid] [uniqueidentifier] NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[EmployerName] [nvarchar](200) NULL,
	[EmployerAddress] [nvarchar](200) NULL,
	[EmployerTelephone] [nvarchar](50) NULL,
	[EmploymentStatus] [int] NULL,
	[JobTitle] [nvarchar](50) NULL,
	[TimeEmployedYears] [int] NULL,
	[TimeEmployedMonths] [int] NULL,
	[IncomeafterTaxes] [decimal](18, 2) NULL,
	[IncomeCircle] [int] NULL,
	[NextIncomeDay] [datetime] NULL,
	[MainPayment] [decimal](18, 2) NULL,
	[RegularOtherPayment] [decimal](18, 2) NULL,
	[MainPaymentCircle] [int] NULL,
	[RegularOtherPaymentCircle] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_LoanWorks_1] PRIMARY KEY CLUSTERED 
(
	[WorkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SimpleProduct]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SimpleProduct](
	[productID] [int] IDENTITY(1,1) NOT NULL,
	[productGuid] [uniqueidentifier] NULL,
	[productCode] [nvarchar](50) NULL,
	[productName] [nvarchar](200) NULL,
	[productBrand] [nvarchar](50) NULL,
	[productCategoryCode] [nvarchar](50) NULL,
	[productPriceNormal] [decimal](18, 2) NULL,
	[productPricePromotion] [decimal](18, 2) NULL,
	[productPriceReference] [decimal](18, 2) NULL,
	[productAddress] [nvarchar](200) NULL,
	[productPackegUnit] [nvarchar](50) NULL,
	[productMaterial] [nvarchar](50) NULL,
	[productCountRepository] [int] NULL,
	[productCountSaled] [int] NULL,
	[productHasInvoice] [int] NULL,
	[productIsHot] [int] NULL,
	[productIsTop] [int] NULL,
	[productStatus] [int] NULL,
	[CanUsable] [int] NULL,
	[productSpecification] [nvarchar](max) NULL,
	[productMemo] [nvarchar](max) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_SimpleProduct] PRIMARY KEY CLUSTERED 
(
	[productID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SimpleProductCategory]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SimpleProductCategory](
	[productCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[productCategoryGuid] [uniqueidentifier] NULL,
	[productCategoryCode] [nvarchar](50) NULL,
	[productCategoryName] [nvarchar](200) NULL,
	[productCategoryStatus] [int] NULL,
	[CanUsable] [int] NULL,
	[productCategoryMemo] [nvarchar](max) NULL,
	[productCategoryOrder] [int] NULL,
	[productCount] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_SimpleProductCategory] PRIMARY KEY CLUSTERED 
(
	[productCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCEmployee]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCEmployee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [uniqueidentifier] NOT NULL,
	[Foo] [nvarchar](200) NULL,
 CONSTRAINT [PK_XQYCEmployee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCEnterpriseContract]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCEnterpriseContract](
	[ContractID] [int] IDENTITY(1,1) NOT NULL,
	[ContractGuid] [uniqueidentifier] NULL,
	[EnterpriseGuid] [uniqueidentifier] NULL,
	[EnterpriseInfo] [nvarchar](50) NULL,
	[ContractTitle] [nvarchar](50) NULL,
	[ContractDetails] [nvarchar](max) NULL,
	[ContractStartDate] [datetime] NULL,
	[ContractStopDate] [datetime] NULL,
	[ContractCreateDate] [datetime] NULL,
	[ContractCreateUserKey] [nvarchar](50) NULL,
	[ContractLaborCount] [int] NULL,
	[ContractLaborAddon] [nvarchar](max) NULL,
	[ContractStatus] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCEnterpriseContract] PRIMARY KEY CLUSTERED 
(
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCEnterpriseService]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCEnterpriseService](
	[EnterpriseServiceID] [int] IDENTITY(1,1) NOT NULL,
	[EnterpriseServiceGuid] [uniqueidentifier] NULL,
	[EnterpriseGuid] [uniqueidentifier] NULL,
	[EnterpriseInfo] [nvarchar](50) NULL,
	[EnterpriseServiceType] [int] NULL,
	[EnterpriseServiceStatus] [int] NULL,
	[EnterpriseServiceCreateDate] [datetime] NULL,
	[EnterpriseServiceCreateUserKey] [nvarchar](50) NULL,
	[EnterpriseServiceStartDate] [datetime] NULL,
	[EnterpriseServiceStopDate] [datetime] NULL,
	[ProviderUserGuid] [uniqueidentifier] NULL,
	[ProviderUserName] [nvarchar](50) NULL,
	[RecommendUserGuid] [uniqueidentifier] NULL,
	[RecommendUserName] [nvarchar](50) NULL,
	[ServiceUserGuid] [uniqueidentifier] NULL,
	[ServiceUserName] [nvarchar](50) NULL,
	[FinanceUserGuid] [uniqueidentifier] NULL,
	[FinanceUserName] [nvarchar](50) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCEnterpriseType] PRIMARY KEY CLUSTERED 
(
	[EnterpriseServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCInformationBroker]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCInformationBroker](
	[InformationBrokerID] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[InformationBrokerStatus] [int] NULL,
	[ProviderUserGuid] [uniqueidentifier] NULL,
	[ProviderUserName] [nvarchar](50) NULL,
	[RecommendUserGuid] [uniqueidentifier] NULL,
	[RecommendUserName] [nvarchar](50) NULL,
	[ServiceUserGuid] [uniqueidentifier] NULL,
	[ServiceUserName] [nvarchar](50) NULL,
	[FinanceUserGuid] [uniqueidentifier] NULL,
	[FinanceUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_XQYCInformationBroker] PRIMARY KEY CLUSTERED 
(
	[InformationBrokerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCLabor]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCLabor](
	[LaborID] [int] IDENTITY(1,1) NOT NULL,
	[LaborCode] [nvarchar](50) NULL,
	[UserGuid] [uniqueidentifier] NULL,
	[NativePlace] [nvarchar](200) NULL,
	[CurrentPlace] [nvarchar](200) NULL,
	[IDCardPlace] [nvarchar](200) NULL,
	[HouseHoldType] [nvarchar](50) NULL,
	[WorkSkill] [nvarchar](200) NULL,
	[WorkSkillPaper] [nvarchar](50) NULL,
	[WorkSituation] [nvarchar](max) NULL,
	[PreWorkSituation] [nvarchar](max) NULL,
	[HopeWorkSituation] [nvarchar](max) NULL,
	[HopeWorkSalary] [nvarchar](50) NULL,
	[UrgentLinkMan] [nvarchar](50) NULL,
	[UrgentTelephone] [nvarchar](50) NULL,
	[UrgentRelationship] [nvarchar](50) NULL,
	[InformationComeFrom] [nvarchar](50) NULL,
	[ProviderUserGuid] [uniqueidentifier] NULL,
	[ProviderUserName] [nvarchar](50) NULL,
	[RecommendUserGuid] [uniqueidentifier] NULL,
	[RecommendUserName] [nvarchar](50) NULL,
	[ServiceUserGuid] [uniqueidentifier] NULL,
	[ServiceUserName] [nvarchar](50) NULL,
	[FinanceUserGuid] [uniqueidentifier] NULL,
	[FinanceUserName] [nvarchar](50) NULL,
	[InsureType] [int] NULL,
	[LaborWorkStatus] [int] NULL,
	[CurrentContractStartDate] [datetime] NULL,
	[CurrentContractStopDate] [datetime] NULL,
	[CurrentContractDesc] [nvarchar](max) NULL,
	[InformationBrokerUserGuid] [uniqueidentifier] NULL,
	[InformationBrokerUserName] [nvarchar](50) NULL,
	[Memo1] [nvarchar](max) NULL,
	[Memo2] [nvarchar](max) NULL,
	[Memo3] [nvarchar](max) NULL,
	[Memo4] [nvarchar](max) NULL,
	[Memo5] [nvarchar](max) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCLabor] PRIMARY KEY CLUSTERED 
(
	[LaborID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCLaborContract]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCLaborContract](
	[LaborContractID] [int] IDENTITY(1,1) NOT NULL,
	[LaborContractGuid] [uniqueidentifier] NULL,
	[LaborUserGuid] [uniqueidentifier] NULL,
	[EnterpriseGuid] [uniqueidentifier] NULL,
	[EnterpriseContractGuid] [uniqueidentifier] NULL,
	[LaborContractStatus] [int] NULL,
	[LaborContractStartDate] [datetime] NULL,
	[LaborContractStopDate] [datetime] NULL,
	[LaborContractDetails] [nvarchar](max) NULL,
	[LaborContractDiscontinueDate] [datetime] NULL,
	[LaborContractDiscontinueDesc] [nvarchar](max) NULL,
	[LaborContractIsCurrent] [int] NULL,
	[OperateUserGuid] [uniqueidentifier] NULL,
	[OperateDate] [datetime] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCLaborContract] PRIMARY KEY CLUSTERED 
(
	[LaborContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCSalaryDetails]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCSalaryDetails](
	[SalaryDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[SalaryDetailsGuid] [uniqueidentifier] NULL,
	[SalarySummaryKey] [nvarchar](50) NULL,
	[SalaryItemKey] [nvarchar](50) NULL,
	[SalaryItemValue] [decimal](18, 2) NULL,
	[SalaryItemKind] [int] NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCSalaryDetails] PRIMARY KEY CLUSTERED 
(
	[SalaryDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XQYCSalarySummary]    Script Date: 2012/10/3 星期三 18:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCSalarySummary](
	[SalarySummaryID] [int] IDENTITY(1,1) NOT NULL,
	[SalarySummaryGuid] [uniqueidentifier] NULL,
	[SalaryDate] [datetime] NULL,
	[LaborKey] [nvarchar](50) NULL,
	[EnterpriseKey] [nvarchar](50) NULL,
	[EnterpriseContractKey] [nvarchar](50) NULL,
	[CreateUserKey] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[SalaryGrossPay] [decimal](18, 2) NULL,
	[SalaryRebate] [decimal](18, 2) NULL,
	[ManageFee] [decimal](18, 2) NULL,
	[SalaryMemo] [nvarchar](max) NULL,
	[PropertyNames] [ntext] NULL,
	[PropertyValues] [ntext] NULL,
 CONSTRAINT [PK_XQYCSalarySummary] PRIMARY KEY CLUSTERED 
(
	[SalarySummaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[CoreDepartment] ON 

INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (1, N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', N'管理中心C', N'管理部', N'', N'管理中心CC', N'GL', N'00000000-0000-0000-0000-000000000000', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (2, N'05cbf0c8-520b-c637-a437-cf040ed95c9e', N'技术部门', N'技术部', N'', NULL, N'JS', N'00000000-0000-0000-0000-000000000000', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (3, N'05cbf0d6-efa1-fe00-ba2b-7da465c8a008', N'测试部门', N'测试部', N'', NULL, N'CS', N'00000000-0000-0000-0000-000000000000', 1, 0, 0, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (4, N'05cbf131-ae44-7139-65f2-610417381d3c', N'财务中心', N'财务部', N'', NULL, N'CW', N'00000000-0000-0000-0000-000000000000', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (8, N'05cde7df-b3a8-59f2-dd9e-a234cfabc60e', N'客服部门', N'客服部', N'', NULL, N'Z1', N'00000000-0000-0000-0000-000000000000', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (9, N'05d1ae60-9b29-85c2-89fc-1f54de4a41de', N'管理1ty', N'管理1部', N'', N'管理中心C//管理1ty', N'GLQU', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (10, N'05d1ba09-1562-55a7-9b00-dfd4113942b3', N'管理11部', N'管理11部', N'', N'管理中心C//管理1ty//管理11部', N'GLQUOF', N'05d1ae60-9b29-85c2-89fc-1f54de4a41de', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (11, N'05d1ba0f-44ad-563d-bcd1-f2f4ff6b597f', N'测试1部', N'测试1部', N'', N'测试部门//测试1部', N'CSYI', N'05cbf0d6-efa1-fe00-ba2b-7da465c8a008', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (12, N'05d1ba16-dcce-b990-9244-8ed4a7b9d8a1', N'财务1部A', N'财务1部', N'', N'财务中心//财务1部AA', N'CW1V', N'05cbf131-ae44-7139-65f2-610417381d3c', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (13, N'05d1bc35-b0ae-3a35-e955-95348e2be1c4', N'管理2部', N'管理2部', N'', NULL, N'GLR3', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (14, N'05d1bc3d-58c1-e2d6-8339-2874dfc93d31', N'管理21部', N'管理21部', N'', NULL, N'GLR334', N'05d1bc35-b0ae-3a35-e955-95348e2be1c4', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (15, N'05d50c61-b7a5-bb0e-ef04-05c4aa5b0554', N'技术一部', N'技术一部', N'', NULL, N'JSFM', N'05cbf0c8-520b-c637-a437-cf040ed95c9e', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (16, N'05da6a50-0d3f-5b96-8bbd-10942dd8317d', N'管理111部门9', N'管理111部', N'', N'管理中心C//管理1ty//管理11部//管理111部门9', N'GLQUOFIL', N'05d1ba09-1562-55a7-9b00-dfd4113942b3', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (19, N'05da6afa-447b-ee72-6248-af74e8caba87', N'22', N'22', N'', N'管理中心C//管理2部//22', N'GLR35D', N'05d1bc35-b0ae-3a35-e955-95348e2be1c4', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (20, N'05da6b19-6e3c-5171-007b-f2d4d408fba6', N'管理1111部门7', N'管理1111部', N'', N'管理中心C//管理1ty//管理11部//管理111部门9//管理1111部门', N'GLQUOFIL5N', N'05da6a50-0d3f-5b96-8bbd-10942dd8317d', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (21, N'05da6b22-e6bf-5049-364b-a674516ad1a8', N'管理11111部', N'管理11111部', N'', N'管理中心C//管理1ty//管理11部//管理111部门9//管理1111部门//管理11111部', N'GLQUOFIL5N7P', N'05da6b19-6e3c-5171-007b-f2d4d408fba6', 1, 0, 1, N'', N'')
INSERT [dbo].[CoreDepartment] ([DepartmentID], [DepartmentGuid], [DepartmentName], [DepartmentNameShort], [DepartmentDescription], [DepartmentFullPath], [DepartmentCode], [DepartmentParentGuid], [DepartmentType], [DepartmentIsSpecial], [CanUsable], [PropertyNames], [PropertyValues]) VALUES (22, N'05da6b31-67f5-ff1a-8621-c5c4918a1c6e', N'联邦调查局', N'FBI', N'', N'联邦调查局', N'W8', N'00000000-0000-0000-0000-000000000000', 1, 0, 1, N'', N'')
SET IDENTITY_INSERT [dbo].[CoreDepartment] OFF
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d166b4-59fe-f5bd-a9c6-1534a0296a9d', N'05d164bc-f310-f8bb-4760-71e47a89791b', 3, N'97004e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d12a63-7c92-07ba-4edf-18f4a8aa625b', N'c884df15-8f7d-480e-8129-2d9b2f112a2d', 3, N'97004e95-0219-46a6-8409-0264446ccce8', 4, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cfd1dc-ca83-f366-7955-1ac48e6a7bc8', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc86c5-a736-9013-1f29-273450ebb7b2', N'05cbf0c8-520b-c637-a437-cf040ed95c9e', 8, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 3, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05dbd0fd-db19-9d15-68d8-27c4b839dbf9', N'05d9df8c-82d1-f08b-5808-4834b6fafe8b', 4, N'49cb6557-cf3a-4fe8-a3ac-e69e1499d2fa', 100, 1, 1, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc86c5-a731-1888-f006-27d434d8b04f', N'05cbf0c8-520b-c637-a437-cf040ed95c9e', 8, N'87773e95-0219-46a6-8409-0264446ccce8', 6, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc87a3-08a6-af96-94ef-3184910b21e1', N'05cbf131-ae44-7139-65f2-610417381d3c', 8, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 1, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d166b4-59f2-06a3-b04a-37341a3acffc', N'05d164bc-f310-f8bb-4760-71e47a89791b', 3, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 1, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05ce331a-e1b3-e948-1de0-3944bf68d218', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 1, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cfd1dc-ca92-7aed-d624-3e84da9aaf35', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'87773e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cb6701-4f4f-24f0-4c32-4ad47bda899e', N'b378663f-c02a-4205-957d-e47ec331d535', 1, N'97004e95-0219-46a6-8409-0264446ccce8', 22, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc019b-4f6e-ad37-129b-4ae438d83c2d', N'b378663f-c02a-4205-957d-e47ec331d535', 1, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 1, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d166b4-59ff-58af-9475-4cc4406a6d46', N'05d164bc-f310-f8bb-4760-71e47a89791b', 3, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05db6299-0f30-9d8e-21dd-5464f0f861e0', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'693597ab-a280-4bd6-9b80-d38ef5dfd2e0', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cde1c7-b224-dd98-4511-64f483baa621', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05db6299-0f3a-f10c-f69c-6ab49299c112', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'1b4199c4-7aae-4fdf-8c2e-522174be33c6', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05db6299-0f3f-3adb-a5c1-6f24fa6a5d2d', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'6013e432-fade-462a-a825-de4ef9be6ea5', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cde1c7-b222-911e-4782-6f3460e81fb3', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc86c5-a731-310e-7426-85b4075ba0da', N'05cbf0c8-520b-c637-a437-cf040ed95c9e', 8, N'97004e95-0219-46a6-8409-0264446ccce8', 6, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc87a3-08a0-ecdb-ab46-93e42a4ae0c4', N'05cbf131-ae44-7139-65f2-610417381d3c', 8, N'87773e95-0219-46a6-8409-0264446ccce8', 14, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05ce3000-368d-a52a-c355-aae4db38bedb', N'70119517-6031-4896-92d3-762c6426e9a8', 1, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 3, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cb6701-4f1b-6cac-1eb9-ab0480fb6460', N'b378663f-c02a-4205-957d-e47ec331d535', 1, N'87773e95-0219-46a6-8409-0264446ccce8', 18, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05ce2ea7-14c0-120d-0e4f-ab44557a67e9', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'87773e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05ce3000-368e-72e7-65af-bdb4777bf8d2', N'70119517-6031-4896-92d3-762c6426e9a8', 1, N'97004e95-0219-46a6-8409-0264446ccce8', 4, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d166af-5c9b-a489-aa20-be84f1299306', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'97004e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05db6299-0f3d-47f5-4712-c8d49d3ba23a', N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', 1, N'afa547f8-2070-4700-8a9a-70ed0ac87e61', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc01ae-ed91-18b1-4a9e-cf6421182030', N'b378663f-c02a-4205-957d-e47ec331d535', 1, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 3, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cc86c5-a739-4a8b-67e6-d564d52acfa5', N'05cbf0c8-520b-c637-a437-cf040ed95c9e', 8, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 3, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05dbd0e7-7c3f-6a39-2388-dec4568893cb', N'05d9df8c-82d1-f08b-5808-4834b6fafe8b', 4, N'897eac61-4c7d-4cce-a461-1f8eb0005210', 20, 1, 1, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cfd1dc-ca9d-62c4-ce47-e204812a710a', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'97004e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05cf1dcb-a0ce-d0af-0866-e8e4293a269c', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'97004e95-0219-46a6-8409-0264446ccce8', 20, 2, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d12a63-7c85-b4c5-2612-ebe4178a8af7', N'c884df15-8f7d-480e-8129-2d9b2f112a2d', 3, N'd8dd50b0-85ee-4fff-b82f-8f14f8d476cf', 1, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d12a63-7c9a-888b-f27a-f554d2baa8a8', N'c884df15-8f7d-480e-8129-2d9b2f112a2d', 3, N'87773e95-0219-46a6-8409-0264446ccce8', 2, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d12a63-7c95-f7db-2a87-fbe4a3c97dda', N'c884df15-8f7d-480e-8129-2d9b2f112a2d', 3, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 0, 1, NULL, N'0fac1828-5859-465d-b373-75d2e9a7a17c', 64, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05ce32a6-28fb-065f-d4f1-fce4a59a96f2', N'c02fc968-cf78-437b-becb-d40b7beb07e1', 1, N'53fce9e1-7c6d-4f7c-93c2-6f6672960187', 2, 2, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
INSERT [dbo].[CorePermission] ([PermissionKey], [OwnerKey], [OwnerType], [PermissionItemGuid], [PermissionItemValue], [PermissionMode], [PermissionKind], [CreateUserGuid], [CreateUserType], [IsFreeAwayCreator]) VALUES (N'05d166b4-59ff-cde0-8a36-fdf49a0b01d7', N'05d164bc-f310-f8bb-4760-71e47a89791b', 3, N'87773e95-0219-46a6-8409-0264446ccce8', 0, 1, NULL, N'b378663f-c02a-4205-957d-e47ec331d535', 1, 0)
SET IDENTITY_INSERT [dbo].[CoreRole] ON 

INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (1, N'c884df15-8f7d-480e-8129-2d9b2f112a2d', N'EmployeeBirthdayRemindReceiver', N'提醒信息收取人', 1, 1, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (2, N'05d164ac-6e59-0b73-c4da-8ba477c83ceb', N'testRole1', N'测试角色1', 1, 0, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (3, N'05d164b0-23d1-04e2-1621-70148fd998c3', N'testRole2', N'测试角色2', 0, 0, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (4, N'05d164ba-3c62-eaeb-15dd-5a245b5b9120', N'testRole3', N'测试角色3', 1, 0, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (5, N'05d164bc-f310-f8bb-4760-71e47a89791b', N'testRole4', N'测试角色4', 1, 0, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (6, N'05d164cd-bfaf-de6c-63e5-cc74679af30a', N'testRole5', N'测试角色5', 1, 0, N'', N'')
INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (7, N'05da4370-c481-d336-c007-ad444e5b4d86', N'', N'', 1, 0, N'', N'')
SET IDENTITY_INSERT [dbo].[CoreRole] OFF
SET IDENTITY_INSERT [dbo].[CoreUser] ON 

INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (1, N'0fac1828-5859-465d-b373-75d2e9a7a17c', N'admin', N'', N'123', 0, N'', N'', N'', N'yy', N'yy', N'yy', 0, N'6e1cbf82-80d4-48bc-b6b9-6fc640d51ff7', N'outer', NULL, NULL, N'', N'yy', 64, 1, N'', N'', NULL, NULL, NULL, NULL, NULL, 1, CAST(0x00009F5D00000000 AS DateTime), 10, N'y', CAST(0x00009F58010CFAA4 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'rrsss', N'yy', N'yy', N'yy', N'', N'', N'0.0.0.0', CAST(0x0000A0DF011FB7B0 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15008, N'b378663f-c02a-4205-957d-e47ec331d535', N'xieran', N'', N'123', 0, N'', N'', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', NULL, NULL, N'', N'notinmood@gmail.com', 1, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0C0006ACAFC AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15009, N'eb4a6fb5-f6cd-47a7-a025-e39182b0147e', N'xieran2', N'', N'123', 0, N'', N'', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', NULL, NULL, N'', N'123@ss.com', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0170105965E AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A01A009DD383 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15010, N'70119517-6031-4896-92d3-762c6426e9a8', N'beijing2', N'', N'123', 0, N'', N'北京2', N'', N'', N'', N'', 0, N'05cbf0c8-520b-c637-a437-cf040ed95c9e', N'', 1, N'技术部门//北京2', N'', N'bh@ss.com', 1, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0x0000A0E500000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15011, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'beijing', N'', N'123', 0, N'', N'北京', N'', N'', N'', N'', 0, N'05cbf131-ae44-7139-65f2-610417381d3c', N'', 8, N'财务中心//北京', N'', N'beijing2@gg.com', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0D9011755B7 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15012, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'zhonghong', N'', N'123', 0, N'', N'钟虹', N'', N'', N'', N'', 0, N'05d1ba16-dcce-b990-9244-8ed4a7b9d8a1', N'', 8, N'财务中心//财务1部A//钟虹', N'', N'zhonghong@txtqd.net', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0x0000A0DC00000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0BF00A19769 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15013, N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb', N'', N'123', 0, N'', N'tvb', N'', N'', N'', N'', 0, N'05d1ba09-1562-55a7-9b00-dfd4113942b3', N'', 8, N'管理中心C//管理1ty//管理11部//tvb', N'', N'tvb@ssswsc.om', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0x0000A0DB00000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0CD00986362 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15014, N'05d5eabe-0871-2ce5-1a5e-8a44b7cbfde3', N'txt01', N'', N'123', 0, N'', N'txt01员工1', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'txt01@txtqd.net', 2, 2, N'', N'', N'', N'', N'', N'', N'', 2, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'679e', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'5dc4ec48-5406-4746-aa12-93483bab104a', NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15015, N'05d5eae3-5327-903c-e99e-60c4f6096074', N'txt02', N'', N'123', 0, N'', N'txt02', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'txt02@ggg67', 2, 1, N'', N'', N'', N'', N'', N'', N'', 2, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'5dc4ec48-5406-4746-aa12-93483bab104a', NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15016, N'05d5eaed-2f95-2229-d446-86c49b0adf02', N'txt03', N'', N'123', 0, N'', N'txt03', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'txt03@sss.com', 2, 1, N'', N'', N'', N'', N'', N'', N'', 1, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'5dc4ec48-5406-4746-aa12-93483bab104a', NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15017, N'05d5ebab-576e-0cc2-c414-07f42f1a77e7', N'hl01', N'', N'123', 0, N'', N'hl01y', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 2, 1, N'', N'', N'', N'', N'', N'', N'', 1, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'4545656', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0CD00C0442E AS DateTime), N'', N'2143c821-3df5-4d68-8919-573541992d21', NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15018, N'05d5ebae-e21a-a347-ed4a-6a740f1a9a7b', N'hl02', N'', N'123', 0, N'', N'hl02', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 2, 3, N'', N'', N'', N'', N'', N'', N'', 2, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'sdfasd', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'2143c821-3df5-4d68-8919-573541992d21', NULL, NULL, NULL, NULL, NULL, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15019, N'05d63598-4e9b-dbde-6fed-7ac42e3849ce', N'infor0115', N'', N'123', 0, N'', N'infor0115', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'infor011@ssd', 4, 1, N'', N'', N'', N'', N'', N'', N'', 1, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0CE008E435D AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15020, N'05d7ec9a-cf5e-e7d8-de54-57a4a65bad90', N'info2', N'', N'123', 0, N'', N'info2', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'sss@ss.comc', 4, 1, N'', N'', N'', N'', N'', N'', N'', 1, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D3010AE5DB AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15021, N'05d7ed61-93b8-b02e-c4ed-5294b53851ac', N'info2555', N'', N'123', 0, N'', N'info2555', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'info2555', 4, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D3010E9FF8 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15022, N'05d7ee24-e3a7-6776-b54d-8e44b0391517', N'', N'', N'1234', 0, N'', N'ss', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D301124977 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15023, N'05d7ee8f-871c-2774-5239-27646c6be1ba', N'', N'', N'123', 0, N'', N'gg', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D301144955 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (15024, N'05d82c03-d2bb-74c6-e9c0-1974efeaffe8', N'', N'', N'123', 0, N'', N'ggg', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'laowurenyuan', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D400AFAF15 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'0.0.0.0', CAST(0x0000A0D400BCEB59 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16021, N'05d91c6d-1d38-b3df-55e7-ad84dbc82d9f', N'asfasdf', N'', N'123', 0, N'', N'sdafasdf', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'asdfsadfasdf', 4, 1, N'', N'', N'', N'', N'', N'', N'', 1, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D7008F35BC AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16022, N'05d92022-7636-9670-81ae-e90429a958cd', N'', N'', N'123', 0, N'', N'sdaaaaaa', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'dfads', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D700A1029B AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16023, N'05d92045-9d55-2c12-a10b-f0d40f788a9c', N'', N'', N'123', 0, N'', N'ewqrewr', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'tqetewtqet4233', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D700A1AB56 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16024, N'05d9206f-6a2e-d11b-2e1c-01c40798064a', N'', N'', N'123', 0, N'', N'asdfawer2eq', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'afSDFSDFASDF', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D700A273FE AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16025, N'05d920fd-f907-22db-019b-5024c0baf825', N'', N'', N'123', 0, N'', N'qwerwerqw2werwer', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D700A52031 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (16026, N'05d92458-540f-70ba-97c0-96f47a1ac40e', N'', N'', N'123', 0, N'', N'qsfdxzcZ', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 1, 1, N'', N'sadfsdg', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D700B5385D AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (17021, N'05d9dde8-058a-4359-a395-f2b490eb8a76', N'mnju', N'', N'123', 0, N'', N'mnju', N'', N'', N'', N'', 0, N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', N'', 8, N'管理中心C//mnju', N'', N'mnju@g', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0x0000A0DD00000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (17022, N'05d9df8c-82d1-f08b-5808-4834b6fafe8b', N'wuming', N'', N'123', 0, N'', N'wuming', N'', N'', N'', N'', 0, N'05cbed92-76fe-d2f8-0ce1-e794920ba4d1', N'', 1, N'管理中心C//wuming', N'', N'wuming@', 8, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0x0000A0DD00000000 AS DateTime), 5, N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [UserFullPath], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (17023, N'05d9e1e2-738f-9a53-84fa-fd943c8a2217', N'', N'', N'123', 0, N'', N'', N'', N'', N'', N'', 0, N'00000000-0000-0000-0000-000000000000', N'', 8, NULL, N'', N'', 4, 1, N'', N'', N'', N'', N'', N'', N'', 0, CAST(0xFFFF2E4600000000 AS DateTime), 5, N'', CAST(0x0000A0D9012BFE8E AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', 0, N'', N'')
SET IDENTITY_INSERT [dbo].[CoreUser] OFF
SET IDENTITY_INSERT [dbo].[CoreUserInRole] ON 

INSERT [dbo].[CoreUserInRole] ([RelationshipID], [UserGuid], [RoleGuid]) VALUES (3, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'c884df15-8f7d-480e-8129-2d9b2f112a2d')
INSERT [dbo].[CoreUserInRole] ([RelationshipID], [UserGuid], [RoleGuid]) VALUES (4, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'05d164bc-f310-f8bb-4760-71e47a89791b')
INSERT [dbo].[CoreUserInRole] ([RelationshipID], [UserGuid], [RoleGuid]) VALUES (5, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'05d164cd-bfaf-de6c-63e5-cc74679af30a')
INSERT [dbo].[CoreUserInRole] ([RelationshipID], [UserGuid], [RoleGuid]) VALUES (6, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'c884df15-8f7d-480e-8129-2d9b2f112a2d')
SET IDENTITY_INSERT [dbo].[CoreUserInRole] OFF
SET IDENTITY_INSERT [dbo].[GeneralBank] ON 

INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (1, N'8e70d417-ac0f-4fa2-b602-c0543bee942d', N'437d7a67-608e-4d1a-9494-34da9de6c0a4', 0, 0, 0, N'', N'', N'', N'', N'', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (2, N'aaae5a69-6d6e-4d49-93b6-f950f41317f7', N'176389f7-75d4-41d9-b3c8-750f94eb4592', 0, 0, 0, N'Westpac Bank', N'Norwest', N'732388', N'Westpac Choice eAccount ', N'569992', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (3, N'1139555d-edd0-4368-9fc7-0d3c9a5dd376', N'7e4393d6-a091-478e-9bd8-f5acd803b0b5', 0, 0, 0, N'CBA', N'Chatswood ', N'062140', N'Thomas J Velevski', N'10761296', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (4, N'5f29a84f-cb8b-45cf-a8b5-1dacb8a6cc69', N'521a262b-ee36-4ffc-8e31-25585e7e2d5e', 0, 0, 0, N'Commonwealth Bank', N'Parramatta ', N'062223', N'Cambell Ring', N'11006024', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (5, N'353ec82a-ce2d-4a7d-b5a6-e9c63ac77689', N'1c494e48-a789-4e81-87dc-25e0981a4f8b', 0, 0, 0, N'Commonwealth Bank', N'Parramatta ', N'062223', N'Cambell Ring', N'11006024', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (6, N'cbfa52a3-1d5b-4a14-9aeb-c04bbf01b53f', N'aa5e7127-1b39-4ed4-bb47-07a2b9b6d9fa', 0, 0, 0, N'', N'', N'', N'', N'', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (7, N'3652af68-a727-4a35-a971-3f80feed6d08', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', 0, 0, 0, N'sadf', N'dd', N'sdfsdf', N'asdfsd', N'fsdd', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (8, N'b67b7eb4-41a7-4852-9156-9898c6ea22af', N'ff0e5981-8d9f-45e7-bea5-08d775e51ae5', 0, 0, 0, N'df', N'ss', N'ss', N'sdfs', N'sss', 0, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralBank] ([BankID], [BankGuid], [UserGuid], [BankNo], [IsPrimary], [CanUsable], [BankName], [Branch], [BankCode], [AccountName], [AccountNumber], [AccountStatus], [BankAddress], [AreaCode], [Telephone], [Fax], [Email], [PropertyNames], [PropertyValues]) VALUES (9, N'10294bba-112d-4920-b501-301a59e017b8', N'0d2a8dc9-c6ae-43a2-b87f-f105e602539e', 0, 0, 0, N'Commonwealth Bank', N'Parramatta ', N'062223', N'Cambell Ring', N'11006024', 0, N'', N'', N'', N'', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralBank] OFF
SET IDENTITY_INSERT [dbo].[GeneralBasicSetting] ON 

INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (11, N'LaborDispatch', N'1', N'劳务派遣', N'EnterpriseServiceType', N'劳务派遣', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (12, N'HireBroke', N'2', N'代理招聘', N'EnterpriseServiceType', N'代理招聘', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (13, N'JobFair', N'3', N'人才会场', N'EnterpriseServiceType', N'人才会场', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (14, N'OnlineService', N'4', N'百伯网用户', N'EnterpriseServiceType', N'百伯网用户', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (15, N'CountPerPage', N'15', N'每页显示的信息条目数', N'BasicSetting', N'每页显示的信息条目数', 0, 1, 0)
SET IDENTITY_INSERT [dbo].[GeneralBasicSetting] OFF
SET IDENTITY_INSERT [dbo].[GeneralEnterprise] ON 

INSERT [dbo].[GeneralEnterprise] ([EnterpriseID], [EnterpriseGuid], [CompanyName], [BusinessType], [TradingName], [Industry], [EnterpriseCode], [TaxCode], [PrincipleAddress], [PostCode], [Telephone], [Fax], [Email], [EstablishedYears], [EstablishedTime], [GrossIncome], [Profit], [AssociatedEnterpriseGuid], [ContactPerson], [AreaCode], [CompanyNameShort], [CanUsable], [Longitude], [Lantitude], [BrokerKey], [PropertyNames], [PropertyValues]) VALUES (15008, N'5dc4ec48-5406-4746-aa12-93483bab104a', N'青岛天信通软件技术有限公司', 0, N'', N'', N'', N'', N'青岛市山东路曼哈顿广场', N'', N'', N'', N'', 0, CAST(0x0000A0CA0103C5BD AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'00000000-0000-0000-0000-000000000000', N'姜付鹏', N'', N'天信通', 1, CAST(0.00000000000000 AS Decimal(18, 14)), CAST(0.00000000000000 AS Decimal(18, 14)), N'', N'', N'')
INSERT [dbo].[GeneralEnterprise] ([EnterpriseID], [EnterpriseGuid], [CompanyName], [BusinessType], [TradingName], [Industry], [EnterpriseCode], [TaxCode], [PrincipleAddress], [PostCode], [Telephone], [Fax], [Email], [EstablishedYears], [EstablishedTime], [GrossIncome], [Profit], [AssociatedEnterpriseGuid], [ContactPerson], [AreaCode], [CompanyNameShort], [CanUsable], [Longitude], [Lantitude], [BrokerKey], [PropertyNames], [PropertyValues]) VALUES (15009, N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', 0, N'', N'', N'', N'', N'青岛市人民路90号', N'', N'', N'', N'', 0, CAST(0x0000A0CA01045217 AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'00000000-0000-0000-0000-000000000000', N'解然', N'', N'青岛海澜', 1, CAST(0.00000000000000 AS Decimal(18, 14)), CAST(0.00000000000000 AS Decimal(18, 14)), N'', N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralEnterprise] OFF
SET IDENTITY_INSERT [dbo].[GeneralImage] ON 

INSERT [dbo].[GeneralImage] ([ImageID], [ImageGuid], [ImageName], [RelativeGuid], [ImageCategoryCode], [ImageKind], [OwnerGuid], [ImageRelativePath], [ImageSize], [ImageWidth], [ImageHeight], [ImageStatus], [ImageOrder], [ImageIsMain], [CanUsable], [ImageType], [CreateTime], [ImageDescription], [ImageDownCount], [ImageDisplayCount], [PropertyNames], [PropertyValues]) VALUES (9, N'059b55ef-ed21-03b5-edaa-47442c584496', N'撒旦法', N'05992998-f4f5-cc91-2ed3-d7444a296318', N'', N'', N'00000000-0000-0000-0000-000000000000', N'/Product/2012/0317/059b55ef-ea9c-9718-2341-7b64616bea3d.jpg', 0, 0, 0, 1, 0, 0, 1, N'jpg', CAST(0x0000A01700AB29A4 AS DateTime), N'阿萨德 ', 0, 0, N'', N'')
INSERT [dbo].[GeneralImage] ([ImageID], [ImageGuid], [ImageName], [RelativeGuid], [ImageCategoryCode], [ImageKind], [OwnerGuid], [ImageRelativePath], [ImageSize], [ImageWidth], [ImageHeight], [ImageStatus], [ImageOrder], [ImageIsMain], [CanUsable], [ImageType], [CreateTime], [ImageDescription], [ImageDownCount], [ImageDisplayCount], [PropertyNames], [PropertyValues]) VALUES (10, N'059b567b-7156-c2c5-923e-81d4d0abb811', N'NoImage', N'05992998-f4f5-cc91-2ed3-d7444a296318', N'', N'', N'00000000-0000-0000-0000-000000000000', N'/Product/2012/0317/059b567b-7089-9f0f-f181-b4b45ee91ac2.jpg', 0, 0, 0, 1, 0, 1, 1, N'jpg', CAST(0x0000A01700ADC753 AS DateTime), N'asd ', 0, 0, N'', N'')
INSERT [dbo].[GeneralImage] ([ImageID], [ImageGuid], [ImageName], [RelativeGuid], [ImageCategoryCode], [ImageKind], [OwnerGuid], [ImageRelativePath], [ImageSize], [ImageWidth], [ImageHeight], [ImageStatus], [ImageOrder], [ImageIsMain], [CanUsable], [ImageType], [CreateTime], [ImageDescription], [ImageDownCount], [ImageDisplayCount], [PropertyNames], [PropertyValues]) VALUES (11, N'059b56df-6127-c537-89c2-7cd474086c02', N'v dff d', N'05992998-f4f5-cc91-2ed3-d7444a296318', N'', N'', N'00000000-0000-0000-0000-000000000000', N'/Product/2012/0317/059b56df-6028-81a7-687c-ec14a84be1a5.jpg', 0, 0, 0, 0, 0, 0, 0, N'jpg', CAST(0x0000A01700AFA703 AS DateTime), N'sda S DDSAF D', 0, 0, N'', N'')
INSERT [dbo].[GeneralImage] ([ImageID], [ImageGuid], [ImageName], [RelativeGuid], [ImageCategoryCode], [ImageKind], [OwnerGuid], [ImageRelativePath], [ImageSize], [ImageWidth], [ImageHeight], [ImageStatus], [ImageOrder], [ImageIsMain], [CanUsable], [ImageType], [CreateTime], [ImageDescription], [ImageDownCount], [ImageDisplayCount], [PropertyNames], [PropertyValues]) VALUES (12, N'059b576e-4916-382c-c4fc-0ed466d8e4f9', N'tyuytuy', N'c4b5b444-0972-4c49-9b8c-3e5861d20b0b', N'', N'', N'00000000-0000-0000-0000-000000000000', N'/Product/2012/0317/059b576e-4782-29ea-daa7-be1485b80aaa.jpg', 0, 0, 0, 1, 0, 1, 1, N'jpg', CAST(0x0000A01700B254F8 AS DateTime), N'fdgh dgh', 0, 0, N'', N'')
INSERT [dbo].[GeneralImage] ([ImageID], [ImageGuid], [ImageName], [RelativeGuid], [ImageCategoryCode], [ImageKind], [OwnerGuid], [ImageRelativePath], [ImageSize], [ImageWidth], [ImageHeight], [ImageStatus], [ImageOrder], [ImageIsMain], [CanUsable], [ImageType], [CreateTime], [ImageDescription], [ImageDownCount], [ImageDisplayCount], [PropertyNames], [PropertyValues]) VALUES (13, N'05a4660d-75a6-0ca3-e8be-c304a498687d', N'图片1', N'05a465ff-7d44-1253-2ba7-efa4da389dcc', N'', N'', N'00000000-0000-0000-0000-000000000000', N'/Product/2012/0414/05a4660d-74e3-1fd6-c6ee-dd4414c9e4ec.jpg', 0, 0, 0, 1, 0, 0, 1, N'jpg', CAST(0x0000A03300E97F67 AS DateTime), N'是的发送到', 0, 0, N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralImage] OFF
SET IDENTITY_INSERT [dbo].[GeneralLoanBasic] ON 

INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (2, N'42d21e17-3140-482f-b0e6-56a4577e053a', 0, CAST(1000.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'Pay Bills', N'176389f7-75d4-41d9-b3c8-750f94eb4592', CAST(0x00009FBE01784826 AS DateTime), 40, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FBF0107F66C AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15001, N'dec374ab-a347-4a09-b54f-a2b8d1ad9a04', 0, CAST(1260.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'', N'7e4393d6-a091-478e-9bd8-f5acd803b0b5', CAST(0x00009FBF01085FCD AS DateTime), 40, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FBF010C6E81 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15004, N'34ea9dfa-ee15-43fd-99a2-dba679c79c8f', 0, CAST(1000.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'bills', N'aa5e7127-1b39-4ed4-bb47-07a2b9b6d9fa', CAST(0x00009FC000DDD69B AS DateTime), 40, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD10102BEA4 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15006, N'22022679-538a-4df6-87be-cc8efe20bd1b', 0, CAST(1000.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'tyui', N'ba64467d-0636-4014-8936-ff8679a91cb8', CAST(0x00009FC700BF1405 AS DateTime), 0, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD10102C2D0 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15007, N'48b5764d-95ad-4602-b5e3-b23bc1d2b2ad', 0, CAST(1000.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'', N'd9ca04d0-1fa4-48f6-ab03-53a070a08dca', CAST(0x00009FCD00B35AF4 AS DateTime), 0, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD10102CB04 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15008, N'524227bc-e4eb-42ed-a604-72f3279071a8', 0, CAST(1760.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'', N'29782b6d-831f-418f-a05a-6e0351503b65', CAST(0x00009FD00107C4A9 AS DateTime), 0, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD10102CF8F AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15009, N'16ca0c2b-bc89-4841-9ed3-0d65aef21f02', 0, CAST(8762.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'sdsds', N'ff0e5981-8d9f-45e7-bea5-08d775e51ae5', CAST(0x00009FD001134B87 AS DateTime), 0, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD10102D574 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15010, N'd966f95b-3223-4321-8952-ac205edff432', 0, CAST(1400.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'', N'e8486182-1f16-445f-966a-c8621e3a4607', CAST(0x00009FD200C123F3 AS DateTime), 0, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD500F669C1 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanBasic] ([LoanID], [LoanGuid], [LoanType], [LoanAmount], [LoanTermType], [LoanInterest], [LoanTermCount], [LoanPurpose], [LoanUserID], [LoanDate], [LoanStatus], [CheckUserID], [CheckDate], [ReadDate], [ReadUserID], [PropertyNames], [PropertyValues]) VALUES (15011, N'022c2f91-90d7-46b7-be1e-1a1e7d940fce', 0, CAST(1000.00 AS Decimal(18, 2)), 40, CAST(0.300000 AS Decimal(18, 6)), 3, N'', N'0d2a8dc9-c6ae-43a2-b87f-f105e602539e', CAST(0x00009FD500F47FE1 AS DateTime), 10, N'00000000-0000-0000-0000-000000000000', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0x00009FD500F66285 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralLoanBasic] OFF
SET IDENTITY_INSERT [dbo].[GeneralLoanSchedule] ON 

INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (1, N'8c0cc7ff-2a61-4edc-b590-38c252fa0649', N'000', 0, N'dec374ab-a347-4a09-b54f-a2b8d1ad9a04', CAST(409.67 AS Decimal(18, 2)), CAST(31.50 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(441.17 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(850.33 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FC800000000 AS DateTime), CAST(0x00009FC800000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (2, N'a3dead95-48c2-46d3-a181-edfcdf8329b7', N'001', 0, N'dec374ab-a347-4a09-b54f-a2b8d1ad9a04', CAST(419.91 AS Decimal(18, 2)), CAST(21.26 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(430.41 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FE700000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (3, N'65b4b47c-78ac-4be4-b172-9f8d56cafc88', N'002', 0, N'dec374ab-a347-4a09-b54f-a2b8d1ad9a04', CAST(430.41 AS Decimal(18, 2)), CAST(10.76 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A00600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (4, N'd00b52f2-35a6-48e6-b713-000edf66aa4c', N'000', 0, N'b30c337f-4cfc-400c-989f-392ed320c896', CAST(572.24 AS Decimal(18, 2)), CAST(44.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1187.76 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FDA00000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (5, N'cfbeac6c-45be-4573-9fe7-25f8b43efb8d', N'001', 0, N'b30c337f-4cfc-400c-989f-392ed320c896', CAST(586.55 AS Decimal(18, 2)), CAST(29.69 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(601.21 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FF900000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (6, N'ee46348a-3b46-485e-a03a-67462dbcece6', N'002', 0, N'b30c337f-4cfc-400c-989f-392ed320c896', CAST(601.21 AS Decimal(18, 2)), CAST(15.03 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A01600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (7, N'3a466ba6-059d-401f-8e7f-e6a86ea76e68', N'000', 0, N'42d21e17-3140-482f-b0e6-56a4577e053a', CAST(325.14 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(674.86 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FD900000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (8, N'e990d999-c399-4a6d-9d9b-ef5d8b4e05a6', N'001', 0, N'42d21e17-3140-482f-b0e6-56a4577e053a', CAST(333.27 AS Decimal(18, 2)), CAST(16.87 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(341.60 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x00009FF800000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
INSERT [dbo].[GeneralLoanSchedule] ([ScheduleID], [ScheduleGuid], [ScheduleNo], [ScheduleStatus], [LoanGuid], [Principal], [Interest], [Penalty], [LateCharge], [OtherFee], [PrincipalPaid], [InterestPaid], [PenaltyPaid], [LateChargePaid], [OtherFeePaid], [PrincipalBalance], [TotalBalance], [PaymentDate], [PaidDate], [ScheduleTimes], [ScheduleParentGuid], [PropertyNames], [PropertyValues]) VALUES (9, N'afb7c1e4-2678-45b0-8601-e1229802c403', N'002', 0, N'42d21e17-3140-482f-b0e6-56a4577e053a', CAST(341.60 AS Decimal(18, 2)), CAST(8.54 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0x0000A01500000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), 1, N'00000000-0000-0000-0000-000000000000', N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralLoanSchedule] OFF
SET IDENTITY_INSERT [dbo].[GeneralLog] ON 

INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (47, N'05d9d6d1-03e4-9c23-a1ed-3bb42a6aeceb', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0D900F6DE13 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (48, N'05d9d6d1-0500-586c-07c1-53b4a9096e90', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0D900F6DE18 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (49, N'05da0ad2-3aae-925a-8c49-57b4aa5aa885', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DA0064FB5F AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (50, N'05da0ad2-45b7-6d8f-e2af-e124774a138c', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DA0064FBB5 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (51, N'05da4e5c-1ef2-5e37-e30b-d1449239b8d2', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DB001DA8BE AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (52, N'05da4e5c-1f43-e035-4bb4-d46487f818b5', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DB001DA8C8 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (53, N'05dab346-6c4f-2db7-913a-e2a4ca7ba342', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DC00768BA0 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (54, N'05dab346-8d92-ad9d-0f16-9bc43ec80014', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DC00768C41 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (55, N'05db12f5-4a31-e6c8-1dcf-bbe4af4b2b7d', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DD00B650FC AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (56, N'05db12f5-72d5-bdbc-3f81-cd24607a49a2', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DD00B651C1 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (2054, N'05db5f83-44e0-e677-da8e-6a143db98dfe', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DE009A4549 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (2055, N'05db5f83-6a2e-0722-4218-c62432da247b', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DE009A45FE AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (2056, N'05dbabc5-817b-82c2-2141-2394cb69af0a', N'Remind', 1, N'Notice', N'EnterpriseContractRemindTask', N'', N'', N'', CAST(0x0000A0DF007CCE05 AS DateTime), N'', N'')
INSERT [dbo].[GeneralLog] ([LogID], [LogGuid], [LogCategory], [LogStatus], [LogLevel], [Logger], [LogMessage], [LogThread], [LogException], [LogDate], [PropertyNames], [PropertyValues]) VALUES (2057, N'05dbabc5-96f7-9e16-1a4b-690414f81bb4', N'Remind', 1, N'Notice', N'BirthdayRemindTaskOfEmployee', N'', N'', N'', CAST(0x0000A0DF007CCE6E AS DateTime), N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralLog] OFF
SET IDENTITY_INSERT [dbo].[GeneralRemind] ON 

INSERT [dbo].[GeneralRemind] ([RemindID], [RemindGuid], [SenderKey], [SenderName], [ReceiverKey], [ReceiverName], [Emergency], [Importance], [TopLevel], [RemindTitle], [RemindUrl], [RemindDescription], [RemindCategory], [RemindType], [CreateDate], [StartDate], [ExpireDate], [ReadDate], [ResourceKey], [ProcessKey], [ActivityKey], [PropertyNames], [PropertyValues]) VALUES (11, N'05d9d6d1-02a0-2440-f903-de44ca2a8cb3', N'99999999-9999-9999-9999-999999999999', N'系统', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', 4, 4, 0, N'人员【钟虹】将在2012/9/30过生日', N'', N'', 1, 0, CAST(0x0000A0D900F6DE0C AS DateTime), CAST(0x0000A0D900F6DE0C AS DateTime), CAST(0x0000A0DE00000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralRemind] ([RemindID], [RemindGuid], [SenderKey], [SenderName], [ReceiverKey], [ReceiverName], [Emergency], [Importance], [TopLevel], [RemindTitle], [RemindUrl], [RemindDescription], [RemindCategory], [RemindType], [CreateDate], [StartDate], [ExpireDate], [ReadDate], [ResourceKey], [ProcessKey], [ActivityKey], [PropertyNames], [PropertyValues]) VALUES (12, N'05d9d6d1-02a0-2440-f903-de44ca2a8cb3', N'99999999-9999-9999-9999-999999999999', N'系统', N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', 4, 4, 0, N'人员【钟虹】将在2012/9/30过生日', N'', N'', 1, 0, CAST(0x0000A0D900F6DE0C AS DateTime), CAST(0x0000A0D900F6DE0C AS DateTime), CAST(0x0000A0DE00000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralRemind] ([RemindID], [RemindGuid], [SenderKey], [SenderName], [ReceiverKey], [ReceiverName], [Emergency], [Importance], [TopLevel], [RemindTitle], [RemindUrl], [RemindDescription], [RemindCategory], [RemindType], [CreateDate], [StartDate], [ExpireDate], [ReadDate], [ResourceKey], [ProcessKey], [ActivityKey], [PropertyNames], [PropertyValues]) VALUES (13, N'05da0ad2-2ccc-0d9e-fa3f-4e44e3c8fbb8', N'99999999-9999-9999-9999-999999999999', N'系统', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', 4, 4, 0, N'人员【wuming】将在2012/10/1过生日', N'', N'', 1, 0, CAST(0x0000A0DA0064FB2F AS DateTime), CAST(0x0000A0DA0064FB30 AS DateTime), CAST(0x0000A0DF00000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'')
INSERT [dbo].[GeneralRemind] ([RemindID], [RemindGuid], [SenderKey], [SenderName], [ReceiverKey], [ReceiverName], [Emergency], [Importance], [TopLevel], [RemindTitle], [RemindUrl], [RemindDescription], [RemindCategory], [RemindType], [CreateDate], [StartDate], [ExpireDate], [ReadDate], [ResourceKey], [ProcessKey], [ActivityKey], [PropertyNames], [PropertyValues]) VALUES (14, N'05da0ad2-2ccc-0d9e-fa3f-4e44e3c8fbb8', N'99999999-9999-9999-9999-999999999999', N'系统', N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', 4, 4, 0, N'人员【wuming】将在2012/10/1过生日', N'', N'', 1, 0, CAST(0x0000A0DA0064FB2F AS DateTime), CAST(0x0000A0DA0064FB30 AS DateTime), CAST(0x0000A0DF00000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralRemind] OFF
SET IDENTITY_INSERT [dbo].[GeneralResidental] ON 

INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (1, N'00000000-0000-0000-0000-000000000000', N'64f8bb8a-3ecd-40ab-9c59-dd6312626dbe', 10, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (2, N'00000000-0000-0000-0000-000000000000', N'64f8bb8a-3ecd-40ab-9c59-dd6312626dbe', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (3, N'00000000-0000-0000-0000-000000000000', N'56e655bd-b660-428d-ad1a-4269e70f178c', 30, 0, 0, N'NSW', N'', N'Kellyville', N'2 Phillipa Court', N'', N'2166', N'', N'', N'', N'', 8, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (4, N'00000000-0000-0000-0000-000000000000', N'56e655bd-b660-428d-ad1a-4269e70f178c', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (5, N'8bd86130-4e48-45c8-9362-4b1c28239ee0', N'f14bf39d-9916-476a-aebd-461f09942508', 10, 0, 0, N'NSW', N'', N'Willoughby ', N'6 Kalgoorlie St ', N'', N'2068 ', N'', N'', N'', N'', 12, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (6, N'9befe776-e7c2-40da-8297-2c3c930b6475', N'f14bf39d-9916-476a-aebd-461f09942508', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (7, N'368bb8fb-e255-4bfe-a1d4-29ea7c624800', N'b4be7bfc-8ed4-4d2d-bcff-6967aa0c0dbf', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street ', N'', N'2046 ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (8, N'9de9eee9-68f5-4705-a891-1f90e5d8e6fc', N'b4be7bfc-8ed4-4d2d-bcff-6967aa0c0dbf', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (9, N'9faf234c-05a8-43dc-b867-3b41396b0bfd', N'b50f8d04-3d53-4734-8158-ef69b40abdb0', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (10, N'043f1a8b-88c5-4cc2-ba3d-26012b67dae8', N'b50f8d04-3d53-4734-8158-ef69b40abdb0', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (11, N'a00229df-74c5-4524-a50d-a442a6749e8d', N'1cd5775b-1e26-4789-917b-a3ddb5cfd248', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (12, N'623661db-eea3-4fb8-a029-453ae441262f', N'1cd5775b-1e26-4789-917b-a3ddb5cfd248', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (13, N'b5c10b0b-8273-4c5d-b8b0-fe81314ed65a', N'75148221-0de2-45c5-912f-585a0b75a7b8', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (14, N'60053390-2553-4feb-bed9-278104286252', N'75148221-0de2-45c5-912f-585a0b75a7b8', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (15, N'1757d1f1-a53c-4421-95f9-dfa1ad2355b0', N'c4171e81-eda3-4f03-a49f-b84893a60105', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'NSW ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (16, N'ea42d213-04da-4f38-86c9-6084b5f25cf3', N'c4171e81-eda3-4f03-a49f-b84893a60105', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (17, N'724933be-db2c-45c4-8481-d126023e1678', N'9c273d50-b02e-48e8-9f65-0d0df3e7e28e', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'NSW ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (18, N'3970a605-3910-4d28-9fea-2a2c2b60d928', N'9c273d50-b02e-48e8-9f65-0d0df3e7e28e', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (19, N'358f5dd1-de7a-49ec-bad3-2b2410795576', N'ba23e61d-d8bf-4c7b-9ace-92f29df7e327', 10, 0, 0, N'NSW', N'', N'Balgowlah', N'204/7 Sylvan Avenue ', N'', N'2093 ', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (20, N'f900bb61-ce7f-4214-a914-cee5c32494da', N'ba23e61d-d8bf-4c7b-9ace-92f29df7e327', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (21, N'5a55c5c9-923d-46df-822c-0be562f469ae', N'ea0fb8ec-3b84-43b9-a051-13c9c7dab6d7', 10, 0, 0, N'ACT', N'', N'sdf', N'sdfsdfd', N'sdf', N'sdfsdfsdf', N'', N'', N'', N'', 4, 5, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (22, N'80d97d67-a9af-468a-931f-40aeab078751', N'ea0fb8ec-3b84-43b9-a051-13c9c7dab6d7', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (23, N'48e5ce03-3cc3-45b1-9927-f8f69b8c051a', N'300c65a2-7252-4cbf-bca4-cd6a7676825c', 10, 0, 0, N'ACT', N'', N'dsfd', N'asdf', N'sdfd', N'fsd', N'', N'', N'', N'', 5, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (24, N'bb47c865-8848-4f5f-ad3a-7d9dc86194fc', N'300c65a2-7252-4cbf-bca4-cd6a7676825c', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (25, N'7e1556c7-e5e3-4037-a04c-9fb52e790102', N'78979a35-5b14-4e59-ae85-968b7c31203b', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (26, N'9e97a3af-284e-4789-b459-efc5b380e6ef', N'78979a35-5b14-4e59-ae85-968b7c31203b', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (27, N'539ed40d-ae1b-4d6f-be81-9455c93c6c70', N'7b0a926e-de18-499f-8de9-3abcc40a1c44', 10, 0, 0, N'NSW', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (28, N'2c7597de-5bd5-4c4a-89a7-9f924b6d311f', N'7b0a926e-de18-499f-8de9-3abcc40a1c44', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (29, N'2ce88f86-9722-44a8-b33d-1bb6ffd3bd50', N'41bbf419-c9c6-4f70-aca3-d242ae21e4c2', 10, 0, 0, N'ACT', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 1, 7, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (30, N'93134de7-e9e8-4930-9e8f-a5decc173503', N'e86d6185-8fc0-4207-9402-adc68a608976', 10, 0, 0, N'ACT', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 0, 4, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (31, N'0025f0cf-dcde-4e4f-b422-033917b9101c', N'e86d6185-8fc0-4207-9402-adc68a608976', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (32, N'5a740d64-2fc2-447e-a4b0-4717c76251d4', N'41bbf419-c9c6-4f70-aca3-d242ae21e4c2', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (33, N'1c9d7633-0b06-4d74-90fe-492ff3a3e20d', N'd72922b0-7cb1-4a7f-a7b7-af4195188007', 10, 0, 0, N'ACT', N'', N'Five Dock ', N'53 Garfield Street', N'', N'2046 ', N'', N'', N'', N'', 0, 4, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
INSERT [dbo].[GeneralResidental] ([ResidentialID], [ResidentialGuid], [ResidentalUserGuid], [ResidentialStatus], [ResidentalNo], [IsPrimary], [State], [City], [Suburb], [Street], [ApartmentNo], [PostCode], [ContactPerson], [Telephone], [Fax], [Mobile], [ResidentalYears], [ResidentalMonths], [ResidentalBeginTime], [ResidentaEndTime], [CreateDate], [PropertyNames], [PropertyValues]) VALUES (34, N'4d2fbcc9-6bb5-4b44-835c-d2979cb861d0', N'd72922b0-7cb1-4a7f-a7b7-af4195188007', 0, 0, 0, N'ACT', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'')
SET IDENTITY_INSERT [dbo].[GeneralResidental] OFF
SET IDENTITY_INSERT [dbo].[LoanIncomeAsset] ON 

INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (1, N'ff280ce0-e656-4053-bf86-c12b68d11f0d', 0, 0, 0, N'house', CAST(759000.00 AS Decimal(18, 2)), N'176389f7-75d4-41d9-b3c8-750f94eb4592', N'', N'')
INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (2, N'a442cbec-da98-4b55-9a1c-d1e2f5c461c1', 0, 0, 0, N'car', CAST(20000.00 AS Decimal(18, 2)), N'176389f7-75d4-41d9-b3c8-750f94eb4592', N'', N'')
INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (3, N'd7becef3-6893-4b40-adf0-da9b2c7dfce3', 0, 0, 0, N'ss', CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (4, N'a0b5a6cc-31bd-4a96-9fa2-3780bacaa9c0', 0, 0, 0, N'f', CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (5, N'fb69a630-aad3-4be3-b485-e1f6e40df43a', 0, 0, 0, N's', CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanIncomeAsset] ([ItemID], [ItemGuid], [ItemKind], [ItemType], [ItemNo], [ItemName], [ItemValue], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (6, N'b7e2db45-aa70-49e7-9ca3-03d14389ea86', 0, 0, 0, N'z', CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
SET IDENTITY_INSERT [dbo].[LoanIncomeAsset] OFF
SET IDENTITY_INSERT [dbo].[LoanLiability] ON 

INSERT [dbo].[LoanLiability] ([LiabilityID], [LiabilityGuid], [ItemKind], [ItemType], [LiabilityLenderInfo], [LiabilityAmountOwing], [LiabilityPaymentMonthly], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (1, N'fd828804-1fe4-4d25-bbd1-8ad30924c1e4', 0, 0, N'NAB', CAST(1000.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'176389f7-75d4-41d9-b3c8-750f94eb4592', N'          ', N'          ')
INSERT [dbo].[LoanLiability] ([LiabilityID], [LiabilityGuid], [ItemKind], [ItemType], [LiabilityLenderInfo], [LiabilityAmountOwing], [LiabilityPaymentMonthly], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (2, N'8ba57d0f-102b-490a-8b4d-5a8dc36d9661', 0, 0, N'sd', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'          ', N'          ')
INSERT [dbo].[LoanLiability] ([LiabilityID], [LiabilityGuid], [ItemKind], [ItemType], [LiabilityLenderInfo], [LiabilityAmountOwing], [LiabilityPaymentMonthly], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (3, N'0d4e07e2-9a7e-4d5f-8936-76ab4be124fc', 0, 0, N'fsdfsd', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'          ', N'          ')
INSERT [dbo].[LoanLiability] ([LiabilityID], [LiabilityGuid], [ItemKind], [ItemType], [LiabilityLenderInfo], [LiabilityAmountOwing], [LiabilityPaymentMonthly], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (4, N'd8476710-61ee-436d-99af-21989ad47a31', 0, 0, N'fsdfddddd', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'          ', N'          ')
INSERT [dbo].[LoanLiability] ([LiabilityID], [LiabilityGuid], [ItemKind], [ItemType], [LiabilityLenderInfo], [LiabilityAmountOwing], [LiabilityPaymentMonthly], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (5, N'c4410d7e-f2ea-47ec-bd77-6c867f87d462', 0, 0, N'sss', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'          ', N'          ')
SET IDENTITY_INSERT [dbo].[LoanLiability] OFF
SET IDENTITY_INSERT [dbo].[LoanSecuredProperty] ON 

INSERT [dbo].[LoanSecuredProperty] ([ItemID], [ItemGuid], [ItemName], [ItemNo], [ItemKind], [ItemType], [ItemDetail], [ItemValue], [ItemOwerName], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (1, N'694e2c42-0189-40b7-889b-07de6e14be30', N'', 0, 0, 0, N'f', CAST(0.00 AS Decimal(18, 2)), N'4', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanSecuredProperty] ([ItemID], [ItemGuid], [ItemName], [ItemNo], [ItemKind], [ItemType], [ItemDetail], [ItemValue], [ItemOwerName], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (2, N'c37ef10d-3e45-4ff8-8731-bee783f55164', N'', 0, 0, 0, N'a', CAST(0.00 AS Decimal(18, 2)), N'3', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanSecuredProperty] ([ItemID], [ItemGuid], [ItemName], [ItemNo], [ItemKind], [ItemType], [ItemDetail], [ItemValue], [ItemOwerName], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (3, N'0d4d870b-8d1d-46fe-b807-8049cf725a8c', N'', 0, 0, 0, N'3', CAST(0.00 AS Decimal(18, 2)), N'3', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
INSERT [dbo].[LoanSecuredProperty] ([ItemID], [ItemGuid], [ItemName], [ItemNo], [ItemKind], [ItemType], [ItemDetail], [ItemValue], [ItemOwerName], [UserGuid], [PropertyNames], [PropertyValues]) VALUES (4, N'f5f4304f-d72e-479b-9430-11a1f45685b7', N'', 0, 0, 0, N'a', CAST(0.00 AS Decimal(18, 2)), N'f', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'', N'')
SET IDENTITY_INSERT [dbo].[LoanSecuredProperty] OFF
SET IDENTITY_INSERT [dbo].[LoanWorks] ON 

INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (1, N'9316c03c-1755-4ebe-82c2-815cc8cbd71a', N'437d7a67-608e-4d1a-9494-34da9de6c0a4', N'', N'', N'', 10, N'', 0, 0, CAST(0.00 AS Decimal(18, 2)), 20, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 20, 20, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (2, N'c99ca74f-710b-4f82-940b-8a9433280465', N'176389f7-75d4-41d9-b3c8-750f94eb4592', N'Coca Cola Amatil', N'North Sydney', N'93592069', 10, N'IT', 4, 0, CAST(6180.00 AS Decimal(18, 2)), 40, CAST(0xFFFF2E4600000000 AS DateTime), CAST(3200.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), 40, 40, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (3, N'75570298-e200-42de-a527-a922a59b74fa', N'7e4393d6-a091-478e-9bd8-f5acd803b0b5', N'Bluecoat Systems Pty Ltd', N'Level 40, 100 Miller St, North Sydney', N'0296571000', 10, N'Business Development ', 2, 0, CAST(7500.00 AS Decimal(18, 2)), 40, CAST(0xFFFF2E4600000000 AS DateTime), CAST(500.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 40, 40, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (4, N'46a74c6e-bc5e-4f4a-95e6-b6665fd58bb4', N'521a262b-ee36-4ffc-8e31-25585e7e2d5e', N'Challenge Recruitment', N'Level 11 100 George Street, Parramatta 2154', N'0296330501', 10, N'Branch Manager ', 0, 4, CAST(7068.00 AS Decimal(18, 2)), 40, CAST(0xFFFF2E4600000000 AS DateTime), CAST(1000.00 AS Decimal(18, 2)), CAST(1700.00 AS Decimal(18, 2)), 40, 40, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (5, N'0a19270a-bcef-4aee-907e-1cc807072a19', N'1c494e48-a789-4e81-87dc-25e0981a4f8b', N'Challenge Recruitment', N'Level 11 100 George Street, Parramatta 2154', N'0296330501', 10, N'Branch Manager ', 0, 4, CAST(7068.00 AS Decimal(18, 2)), 40, CAST(0xFFFF2E4600000000 AS DateTime), CAST(1000.00 AS Decimal(18, 2)), CAST(1700.00 AS Decimal(18, 2)), 40, 40, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (6, N'c874c8ad-8c21-4089-9ad1-e349f8582d4b', N'aa5e7127-1b39-4ed4-bb47-07a2b9b6d9fa', N'', N'', N'', 10, N'', 0, 0, CAST(0.00 AS Decimal(18, 2)), 20, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 20, 20, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (7, N'bd3c9bb3-2dec-443a-a248-6b019e8a6cbe', N'7bfbda3d-8332-40a6-aaa8-a20a84bf7f05', N'sdf', N'sdfsd', N'fsdfsdfd', 10, N'sdfsafsd', 6, 0, CAST(5555555.00 AS Decimal(18, 2)), 20, CAST(0x00009FB700000000 AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 20, 20, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (8, N'955773b8-4cdb-4992-8fcf-30fe9ff7255f', N'ff0e5981-8d9f-45e7-bea5-08d775e51ae5', N'fgfgfgfgf', N'dfgfd', N'gfgfgf', 10, N'fgfg', 7, 0, CAST(4465465.00 AS Decimal(18, 2)), 20, CAST(0x0000A08100000000 AS DateTime), CAST(64756.00 AS Decimal(18, 2)), CAST(6456565.00 AS Decimal(18, 2)), 20, 20, N'', N'')
INSERT [dbo].[LoanWorks] ([WorkID], [WorkGuid], [UserGuid], [EmployerName], [EmployerAddress], [EmployerTelephone], [EmploymentStatus], [JobTitle], [TimeEmployedYears], [TimeEmployedMonths], [IncomeafterTaxes], [IncomeCircle], [NextIncomeDay], [MainPayment], [RegularOtherPayment], [MainPaymentCircle], [RegularOtherPaymentCircle], [PropertyNames], [PropertyValues]) VALUES (9, N'7d3ee241-736a-4137-888a-a9753691425b', N'0d2a8dc9-c6ae-43a2-b87f-f105e602539e', N'Challenge Recruitment', N'Level 11 100 George Street, Parramatta 2154', N'0296330501', 10, N'Branch Manager ', 0, 4, CAST(7068.00 AS Decimal(18, 2)), 40, CAST(0x00009FDA00000000 AS DateTime), CAST(1000.00 AS Decimal(18, 2)), CAST(1700.00 AS Decimal(18, 2)), 40, 40, N'', N'')
SET IDENTITY_INSERT [dbo].[LoanWorks] OFF
SET IDENTITY_INSERT [dbo].[SimpleProduct] ON 

INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (1, N'c4b5b444-0972-4c49-9b8c-3e5861d20b0b', N'', N'香水异步加载功能对于 treeNode节点数据没有特别要求', N'', N'', CAST(78.00 AS Decimal(18, 2)), CAST(75.00 AS Decimal(18, 2)), CAST(128.00 AS Decimal(18, 2)), N'日本', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'    异步加载功能对于 treeNode 节点数据没有特别要求，如果采用简单 JSON 数据，请设置 setting.data.simple 中的属性
    如果异步加载每次都只返回单层的节点数据，那么可以不设置简单 JSON 数据模式
', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (2, N'0599241f-5c2c-a5b4-b0bd-b5744d3a164c', N'', N'手表', NULL, N'', CAST(800.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'瑞士', N'', N'', 0, 0, 0, 0, 0, 0, 0, N'', N'entity.ProductGuid', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (3, N'059924e9-5da6-6459-d64b-ec0481e84634', N'', N'asdf', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'sadf', N'', N'', 0, 0, 0, 0, 0, 0, 0, N'', N'asdfasdfsdfd', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (4, N'059924f4-701c-ac86-5cb2-c464ca1919f6', N'', N'asdf', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'fasdfd', N'', N'', 0, 0, 0, 0, 0, 0, 0, N'', N'asdfasdfsdfd', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (5, N'05992507-cb3c-37ef-6734-88c4dd482ef6', N'', N'asf', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'dfasdf', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'sadfasdfsdafdasf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (7, N'059925ad-ad5f-1586-a1ff-c754c39b7c42', N'dsfasd', N'wossss', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'sadfsdfsdf', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'asdfsadfsdfsdaf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (8, N'059927e1-ae4f-264c-ed35-d68464f972b6', N'sadf', N'sdfasd', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'asdf', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'asdfsdf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (9, N'059927f6-4e51-5120-094d-3eb40dfa170a', N'asdfas', N'sdfsd', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'dfasdf', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'sdfdsf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (10, N'059927fa-c16d-b627-45e8-df246c0aad1f', N'cZXcxzc', N'sdxcXZ', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'sadfasd', N'', N'', 0, 0, 0, 0, 0, 1, 0, N'', N'asdfd', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (11, N'05992803-ed56-8db9-7cc3-d8f4e23a3103', N'sdafsdfsad', N'sadfasd', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'asdf', N'', N'', 0, 0, 0, 0, 0, 1, 0, N'', N'sdfasdfdf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (12, N'059928a0-9625-8fdb-5d0f-5894a9298b45', N'rwer', N'e', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'werwe', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N're', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (13, N'059928a8-0302-2374-7ce8-c004f929ca7f', N'ter', N'er', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'e', N'', N'', 0, 0, 0, 0, 0, 1, 0, N'', N'erwter', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (14, N'059928e7-5261-551a-68ec-34445db94db6', N'555', N'55', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'5555', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (15, N'05992998-f4f5-cc91-2ed3-d7444a296318', N'fsdf', N'dfd', NULL, N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'', N'', N'', 0, 0, 0, 0, 1, 1, 0, N'', N'adfasdfdf', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (16, N'05a3b28c-384c-405f-cfe4-99c46dd85de2', N'jjj', N'jjj', N'', N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'jj', N'', N'', 0, 0, 0, 0, 0, 1, 1, N'', N'jjj', N'', N'')
INSERT [dbo].[SimpleProduct] ([productID], [productGuid], [productCode], [productName], [productBrand], [productCategoryCode], [productPriceNormal], [productPricePromotion], [productPriceReference], [productAddress], [productPackegUnit], [productMaterial], [productCountRepository], [productCountSaled], [productHasInvoice], [productIsHot], [productIsTop], [productStatus], [CanUsable], [productSpecification], [productMemo], [PropertyNames], [PropertyValues]) VALUES (17, N'05a465ff-7d44-1253-2ba7-efa4da389dcc', N'8u77y', N'佳能相机990', N'', N'', CAST(567.00 AS Decimal(18, 2)), CAST(560.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), N'日本', N'', N'', 0, 0, 0, 0, 1, 1, 1, N'', N'的萨法士大夫', N'', N'')
SET IDENTITY_INSERT [dbo].[SimpleProduct] OFF
SET IDENTITY_INSERT [dbo].[XQYCEmployee] ON 

INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (1, N'70119517-6031-4896-92d3-762c6426e9a8', N'bf3')
INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (2, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'dddddddd')
INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (3, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'')
INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (4, N'006e9833-50ab-44be-8a46-1a47acc093f7', N'')
INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (5, N'05d9dde8-058a-4359-a395-f2b490eb8a76', N'ggg')
INSERT [dbo].[XQYCEmployee] ([EmployeeID], [UserGuid], [Foo]) VALUES (6, N'05d9df8c-82d1-f08b-5808-4834b6fafe8b', N'ssss')
SET IDENTITY_INSERT [dbo].[XQYCEmployee] OFF
SET IDENTITY_INSERT [dbo].[XQYCEnterpriseContract] ON 

INSERT [dbo].[XQYCEnterpriseContract] ([ContractID], [ContractGuid], [EnterpriseGuid], [EnterpriseInfo], [ContractTitle], [ContractDetails], [ContractStartDate], [ContractStopDate], [ContractCreateDate], [ContractCreateUserKey], [ContractLaborCount], [ContractLaborAddon], [ContractStatus], [PropertyNames], [PropertyValues]) VALUES (1, N'05d7d83e-d242-ff48-9a81-3dd4d58ab2fe', N'00000000-0000-0000-0000-000000000000', N'', N'', N'', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', 0, N'', 1, N'', N'')
INSERT [dbo].[XQYCEnterpriseContract] ([ContractID], [ContractGuid], [EnterpriseGuid], [EnterpriseInfo], [ContractTitle], [ContractDetails], [ContractStartDate], [ContractStopDate], [ContractCreateDate], [ContractCreateUserKey], [ContractLaborCount], [ContractLaborAddon], [ContractStatus], [PropertyNames], [PropertyValues]) VALUES (2, N'05d7d8f7-4bf7-9eb4-b276-59746c6b513f', N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', N'ssss', N'', CAST(0x0000A0D700000000 AS DateTime), CAST(0x0000A0DC00000000 AS DateTime), CAST(0x0000A0D300ACA1BD AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', 6, N'gsdgasdgsd', 1, N'', N'')
INSERT [dbo].[XQYCEnterpriseContract] ([ContractID], [ContractGuid], [EnterpriseGuid], [EnterpriseInfo], [ContractTitle], [ContractDetails], [ContractStartDate], [ContractStopDate], [ContractCreateDate], [ContractCreateUserKey], [ContractLaborCount], [ContractLaborAddon], [ContractStatus], [PropertyNames], [PropertyValues]) VALUES (3, N'05d7d940-98fd-78a4-87d9-8984e74a57f4', N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', N's', N'', CAST(0x0000A0CC00000000 AS DateTime), CAST(0x0000A0DA00000000 AS DateTime), CAST(0x0000A0D300AE0196 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', 3, N'ssssssssssssssss', 1, N'', N'')
SET IDENTITY_INSERT [dbo].[XQYCEnterpriseContract] OFF
SET IDENTITY_INSERT [dbo].[XQYCEnterpriseService] ON 

INSERT [dbo].[XQYCEnterpriseService] ([EnterpriseServiceID], [EnterpriseServiceGuid], [EnterpriseGuid], [EnterpriseInfo], [EnterpriseServiceType], [EnterpriseServiceStatus], [EnterpriseServiceCreateDate], [EnterpriseServiceCreateUserKey], [EnterpriseServiceStartDate], [EnterpriseServiceStopDate], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [PropertyNames], [PropertyValues]) VALUES (3, N'05d645c9-fb23-fb79-71a6-edc4c2cb50af', N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', 1, 1, CAST(0x0000A0CE00D6EBE8 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', NULL, NULL, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb', N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'', N'')
INSERT [dbo].[XQYCEnterpriseService] ([EnterpriseServiceID], [EnterpriseServiceGuid], [EnterpriseGuid], [EnterpriseInfo], [EnterpriseServiceType], [EnterpriseServiceStatus], [EnterpriseServiceCreateDate], [EnterpriseServiceCreateUserKey], [EnterpriseServiceStartDate], [EnterpriseServiceStopDate], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [PropertyNames], [PropertyValues]) VALUES (4, N'05d645f7-cf8a-d835-f288-a31462e8eef4', N'5dc4ec48-5406-4746-aa12-93483bab104a', N'青岛天信通软件技术有限公司', 1, 1, CAST(0x0000A0CE00D7C7E4 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', NULL, NULL, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'')
INSERT [dbo].[XQYCEnterpriseService] ([EnterpriseServiceID], [EnterpriseServiceGuid], [EnterpriseGuid], [EnterpriseInfo], [EnterpriseServiceType], [EnterpriseServiceStatus], [EnterpriseServiceCreateDate], [EnterpriseServiceCreateUserKey], [EnterpriseServiceStartDate], [EnterpriseServiceStopDate], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [PropertyNames], [PropertyValues]) VALUES (5, N'05d64673-a6c0-fd71-1c40-d0e459491a78', N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', 2, 1, CAST(0x0000A0CE00DA1A4E AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'')
INSERT [dbo].[XQYCEnterpriseService] ([EnterpriseServiceID], [EnterpriseServiceGuid], [EnterpriseGuid], [EnterpriseInfo], [EnterpriseServiceType], [EnterpriseServiceStatus], [EnterpriseServiceCreateDate], [EnterpriseServiceCreateUserKey], [EnterpriseServiceStartDate], [EnterpriseServiceStopDate], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [PropertyNames], [PropertyValues]) VALUES (6, N'05d64733-b00e-1e22-0326-7384dd0808c5', N'5dc4ec48-5406-4746-aa12-93483bab104a', N'青岛天信通软件技术有限公司', 2, 1, CAST(0x0000A0CE00DDB416 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', NULL, NULL, N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'')
INSERT [dbo].[XQYCEnterpriseService] ([EnterpriseServiceID], [EnterpriseServiceGuid], [EnterpriseGuid], [EnterpriseInfo], [EnterpriseServiceType], [EnterpriseServiceStatus], [EnterpriseServiceCreateDate], [EnterpriseServiceCreateUserKey], [EnterpriseServiceStartDate], [EnterpriseServiceStopDate], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [PropertyNames], [PropertyValues]) VALUES (7, N'05d7851d-103e-d4b9-dace-19c4acfbe1d5', N'2143c821-3df5-4d68-8919-573541992d21', N'青岛紫光海澜网络技术有限公司', 4, 1, CAST(0x0000A0D200A5A5E7 AS DateTime), N'0fac1828-5859-465d-b373-75d2e9a7a17c', CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[XQYCEnterpriseService] OFF
SET IDENTITY_INSERT [dbo].[XQYCInformationBroker] ON 

INSERT [dbo].[XQYCInformationBroker] ([InformationBrokerID], [UserGuid], [InformationBrokerStatus], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName]) VALUES (3, N'05d63598-4e9b-dbde-6fed-7ac42e3849ce', 1, N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb')
INSERT [dbo].[XQYCInformationBroker] ([InformationBrokerID], [UserGuid], [InformationBrokerStatus], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName]) VALUES (4, N'05d7ed61-93b8-b02e-c4ed-5294b53851ac', 1, N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'00000000-0000-0000-0000-000000000000', N'')
INSERT [dbo].[XQYCInformationBroker] ([InformationBrokerID], [UserGuid], [InformationBrokerStatus], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName]) VALUES (1004, N'05d91c6d-1d38-b3df-55e7-ad84dbc82d9f', 1, N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'')
INSERT [dbo].[XQYCInformationBroker] ([InformationBrokerID], [UserGuid], [InformationBrokerStatus], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName]) VALUES (1005, N'05d9e1e2-738f-9a53-84fa-fd943c8a2217', 1, N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'')
SET IDENTITY_INSERT [dbo].[XQYCInformationBroker] OFF
SET IDENTITY_INSERT [dbo].[XQYCLabor] ON 

INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (1, NULL, N'05d7ee24-e3a7-6776-b54d-8e44b0391517', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb', N'00000000-0000-0000-0000-000000000000', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', NULL, NULL, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (2, NULL, N'05d7ee8f-871c-2774-5239-27646c6be1ba', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', 0, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (3, NULL, N'05d82c03-d2bb-74c6-e9c0-1974efeaffe8', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'81f81ed6-9dde-462f-8cb8-afb79d20d474', N'钟虹', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'c02fc968-cf78-437b-becb-d40b7beb07e1', N'北京', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', NULL, NULL, N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (4, NULL, N'05d92022-7636-9670-81ae-e90429a958cd', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (5, NULL, N'05d92045-9d55-2c12-a10b-f0d40f788a9c', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'05d7ed61-93b8-b02e-c4ed-5294b53851ac', N'', N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (6, NULL, N'05d9206f-6a2e-d11b-2e1c-01c40798064a', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'05d63598-4e9b-dbde-6fed-7ac42e3849ce', N'', N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (7, NULL, N'05d920fd-f907-22db-019b-5024c0baf825', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'', N'', N'', N'', N'', N'')
INSERT [dbo].[XQYCLabor] ([LaborID], [LaborCode], [UserGuid], [NativePlace], [CurrentPlace], [IDCardPlace], [HouseHoldType], [WorkSkill], [WorkSkillPaper], [WorkSituation], [PreWorkSituation], [HopeWorkSituation], [HopeWorkSalary], [UrgentLinkMan], [UrgentTelephone], [UrgentRelationship], [InformationComeFrom], [ProviderUserGuid], [ProviderUserName], [RecommendUserGuid], [RecommendUserName], [ServiceUserGuid], [ServiceUserName], [FinanceUserGuid], [FinanceUserName], [InsureType], [LaborWorkStatus], [CurrentContractStartDate], [CurrentContractStopDate], [CurrentContractDesc], [InformationBrokerUserGuid], [InformationBrokerUserName], [Memo1], [Memo2], [Memo3], [Memo4], [Memo5], [PropertyNames], [PropertyValues]) VALUES (8, NULL, N'05d92458-540f-70ba-97c0-96f47a1ac40e', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'70119517-6031-4896-92d3-762c6426e9a8', N'北京2', N'00000000-0000-0000-0000-000000000000', N'', N'00000000-0000-0000-0000-000000000000', N'', N'006e9833-50ab-44be-8a46-1a47acc093f7', N'tvb', 0, 0, CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'00000000-0000-0000-0000-000000000000', N'', N'', N'', N'', N'', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[XQYCLabor] OFF
SET IDENTITY_INSERT [dbo].[XQYCLaborContract] ON 

INSERT [dbo].[XQYCLaborContract] ([LaborContractID], [LaborContractGuid], [LaborUserGuid], [EnterpriseGuid], [EnterpriseContractGuid], [LaborContractStatus], [LaborContractStartDate], [LaborContractStopDate], [LaborContractDetails], [LaborContractDiscontinueDate], [LaborContractDiscontinueDesc], [LaborContractIsCurrent], [OperateUserGuid], [OperateDate], [PropertyNames], [PropertyValues]) VALUES (8, N'05d8e50a-5a98-eed4-c239-d0b4639bd3cc', N'05d82c03-d2bb-74c6-e9c0-1974efeaffe8', N'5dc4ec48-5406-4746-aa12-93483bab104a', N'00000000-0000-0000-0000-000000000000', 1, CAST(0x0000A0C900000000 AS DateTime), CAST(0x0000A0D200000000 AS DateTime), N'qqqqqqqqq', CAST(0xFFFF2E4600000000 AS DateTime), N'', 0, N'0fac1828-5859-465d-b373-75d2e9a7a17c', CAST(0x0000A0D60110DDA4 AS DateTime), N'', N'')
INSERT [dbo].[XQYCLaborContract] ([LaborContractID], [LaborContractGuid], [LaborUserGuid], [EnterpriseGuid], [EnterpriseContractGuid], [LaborContractStatus], [LaborContractStartDate], [LaborContractStopDate], [LaborContractDetails], [LaborContractDiscontinueDate], [LaborContractDiscontinueDesc], [LaborContractIsCurrent], [OperateUserGuid], [OperateDate], [PropertyNames], [PropertyValues]) VALUES (9, N'05d8e587-a763-9198-49aa-f6c49bfb2fea', N'05d82c03-d2bb-74c6-e9c0-1974efeaffe8', N'2143c821-3df5-4d68-8919-573541992d21', N'00000000-0000-0000-0000-000000000000', 0, CAST(0x0000A0C900000000 AS DateTime), CAST(0x0000A0D300000000 AS DateTime), N'hhhhh', CAST(0xFFFF2E4600000000 AS DateTime), N'', 0, N'0fac1828-5859-465d-b373-75d2e9a7a17c', CAST(0x0000A0D601133723 AS DateTime), N'', N'')
INSERT [dbo].[XQYCLaborContract] ([LaborContractID], [LaborContractGuid], [LaborUserGuid], [EnterpriseGuid], [EnterpriseContractGuid], [LaborContractStatus], [LaborContractStartDate], [LaborContractStopDate], [LaborContractDetails], [LaborContractDiscontinueDate], [LaborContractDiscontinueDesc], [LaborContractIsCurrent], [OperateUserGuid], [OperateDate], [PropertyNames], [PropertyValues]) VALUES (1002, N'05d91d42-e35d-2d2d-0e86-6e642beb873e', N'05d7ee24-e3a7-6776-b54d-8e44b0391517', N'5dc4ec48-5406-4746-aa12-93483bab104a', N'00000000-0000-0000-0000-000000000000', 1, CAST(0x0000A0CA00000000 AS DateTime), CAST(0x0000A0CC00000000 AS DateTime), N'fasdf', CAST(0xFFFF2E4600000000 AS DateTime), N'', 0, N'0fac1828-5859-465d-b373-75d2e9a7a17c', CAST(0x0000A0D7009337DA AS DateTime), N'', N'')
SET IDENTITY_INSERT [dbo].[XQYCLaborContract] OFF
/****** Object:  Index [IX_CoreUserInRole_RoleGuid]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_CoreUserInRole_RoleGuid] ON [dbo].[CoreUserInRole]
(
	[RoleGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreUserInRole_UserGuid]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_CoreUserInRole_UserGuid] ON [dbo].[CoreUserInRole]
(
	[UserGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeneralNews_NewsCategoryCode]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralNews_NewsCategoryCode] ON [dbo].[GeneralNews]
(
	[NewsCategoryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralNews_NewsID]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_GeneralNews_NewsID] ON [dbo].[GeneralNews]
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralRemind_CreateDate]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralRemind_CreateDate] ON [dbo].[GeneralRemind]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeneralRemind_ReceiverKey]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralRemind_ReceiverKey] ON [dbo].[GeneralRemind]
(
	[ReceiverKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralRemind_RemindCategory]    Script Date: 2012/10/3 星期三 18:42:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralRemind_RemindCategory] ON [dbo].[GeneralRemind]
(
	[RemindCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeneralBasicSetting] ADD  CONSTRAINT [DF_GeneralBasicSetting_OrderNumber]  DEFAULT ((0)) FOR [OrderNumber]
GO
ALTER TABLE [dbo].[GeneralLoanSchedule] ADD  CONSTRAINT [DF_GeneralLoanSchedule_ScheduleTime]  DEFAULT ((1)) FOR [ScheduleTimes]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'关联模块的Guid，比如新闻，比如产品的Guid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GeneralImage', @level2type=N'COLUMN',@level2name=N'RelativeGuid'
GO
USE [master]
GO
ALTER DATABASE [xiaoqiyingcaidatabasemanage] SET  READ_WRITE 
GO
