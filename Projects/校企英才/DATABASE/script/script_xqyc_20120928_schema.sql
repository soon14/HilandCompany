USE [xiaoqiyingcaidatabasemanage]
GO
/****** Object:  StoredProcedure [dbo].[usp_Core_Area_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Core_Attachment_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Core_User_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_General_Enterprise_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_General_LoanBasic_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_General_News_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_General_NewsCategory_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_General_Remind_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_Simple_Product_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_XQYC_Employee_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_XQYC_InformationBroker_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_XQYC_Labor_SelectPaging]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[CoreAttachment]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[CoreDepartment]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[CorePermission]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
	[CreateUserGuid] [uniqueidentifier] NULL,
	[CreateUserType] [int] NULL,
	[IsFreeAwayCreator] [int] NULL,
 CONSTRAINT [PK_CorePermission] PRIMARY KEY CLUSTERED 
(
	[PermissionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CoreRole]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[CoreUser]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[CoreUserInRole]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralBank]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralBasicSetting]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralEnterprise]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralImage]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralLoanBasic]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralLoanSchedule]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralLog]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralNews]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralNewsCategory]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralRemind]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralResidental]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[GeneralShoppingCart]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[LoanIncomeAsset]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[LoanLiability]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[LoanSecuredProperty]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[LoanWorks]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[SimpleProduct]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[SimpleProductCategory]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[XQYCEmployee]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[XQYCEnterpriseContract]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[XQYCEnterpriseService]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[XQYCInformationBroker]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Table [dbo].[XQYCLabor]    Script Date: 2012/9/28 星期五 16:00:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XQYCLabor](
	[LaborID] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [dbo].[XQYCLaborContract]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
/****** Object:  Index [IX_CoreUserInRole_RoleGuid]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE NONCLUSTERED INDEX [IX_CoreUserInRole_RoleGuid] ON [dbo].[CoreUserInRole]
(
	[RoleGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CoreUserInRole_UserGuid]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE NONCLUSTERED INDEX [IX_CoreUserInRole_UserGuid] ON [dbo].[CoreUserInRole]
(
	[UserGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeneralNews_NewsCategoryCode]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralNews_NewsCategoryCode] ON [dbo].[GeneralNews]
(
	[NewsCategoryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralNews_NewsID]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_GeneralNews_NewsID] ON [dbo].[GeneralNews]
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralRemind_CreateDate]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralRemind_CreateDate] ON [dbo].[GeneralRemind]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeneralRemind_ReceiverKey]    Script Date: 2012/9/28 星期五 16:00:31 ******/
CREATE NONCLUSTERED INDEX [IX_GeneralRemind_ReceiverKey] ON [dbo].[GeneralRemind]
(
	[ReceiverKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GeneralRemind_RemindCategory]    Script Date: 2012/9/28 星期五 16:00:31 ******/
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
