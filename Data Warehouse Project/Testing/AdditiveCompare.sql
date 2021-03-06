/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [TransactionTypeID]
      ,[Transaction]
  FROM [MyTestDB].[dbo].[DW_AdditiveTrans]

  where TransactionTypeID not in
  (
	select xtrm_id from [MyTestDB].[dbo].[APL_TransBalance]
  )



SELECT xtrm_id
      ,XTRM_Detail
  FROM [MyTestDB].[dbo].[APL_TransBalance]

  where xtrm_id not in
  (
	select [TransactionTypeID] from [MyTestDB].[dbo].[DW_AdditiveTrans]
  )
  order by xtrm_id