BEGIN TRAN


DECLARE @sSQL       NVARCHAR(100)
DECLARE @MaxID      INT
DECLARE @MinID      INT
DECLARE @CurrentID  INT
DECLARE @TempSQL    NVARCHAR(100)

/*
This is your original table which has the dashed data
*/
CREATE TABLE #OriginalTable
(
   ID INT IDENTITY
  ,Data NVARCHAR(100)
)

/*
This is your CollectingTempTables
*/
CREATE TABLE #TempTable
(
   ID INT IDENTITY
  ,Data NVARCHAR(100)
)
CREATE TABLE #FinalTable
(
   ID INT IDENTITY
  ,Data INT
)

/*
Some Dummy
*/
INSERT INTO #OriginalTable(Data) VALUES ('1-2-3-4')
INSERT INTO #OriginalTable(Data) VALUES ('5-6-7-8')
INSERT INTO #OriginalTable(Data) VALUES ('9-10-11-12')
----------------------------------- Action ---------------------------------------------

INSERT INTO #TempTable(Data)
SELECT   REPLACE  ('SELECT '''+ DATA, '-' , ' ''  UNION  SELECT '' ' )+''' '
FROM #OriginalTable


SELECT @MaxID=MAX(ID)
      ,@MinID=MIN(ID)
FROM #TempTable

SET @CurrentID = @MinID


WHILE(@CurrentID<=@MaxID)
BEGIN
     SELECT @TempSQL= #TempTable.Data
     FROM #TempTable
     WHERE ID = @CurrentID


    INSERT INTO #FinalTable(Data)
    EXEC(@TempSQL)

    SET @CurrentID = @CurrentID + 1
END


SELECT Data
FROM #FinalTable
ORDER BY Data   

 

DROP TABLE #FinalTable
DROP TABLE #TempTable
DROP TABLE #OriginalTable

ROLLBACK TRAN
