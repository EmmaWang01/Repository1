/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP 1000 [fact_Loan_Snapshot_sKey]
      ,[LoanPK]
      ,[ApplicationAmount]
      ,[Cash_Out]
      ,[Estimated_Monthly_AccountFees]
      ,[Estimated_Interest]
      ,[Income]
      ,[Expenses]
      ,[ApprovalDurationDays]
      ,[DeclineDurationDays]
      ,[BadDebtDurationDays]
      ,[SettlementDurationDays]
      ,[DischargeDurationDays]
      ,[Loan_sKey]
      ,[Product_sKey]
      ,[Assessor__sKey]
      ,[Broker_sKey]
      ,[BrokerContact_sKey]
      ,[ApprovalOfficer__sKey]
      ,[SettlementOfficer_sKey]
      ,[Current_Branch_sKey]
      ,[Referring_Branch_sKey]
      ,[Settlement_Date_sKey]
      ,[Lodgement_Date_sKey]
      ,[Approved_Date_sKey]
      ,[Discharge_Date_sKey]
      ,[Bad_Debt_Date_sKey]
      ,[Declined_Date_sKey]
      ,[Batch_Execution_Id]
      ,[Row_Is_Current]
      ,[Checksum]
      ,[Supersedes_sKey]
  FROM [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot]
  */

 
 
  select count(*) from [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] where Lodgement_Date_sKey is not null
  
  select count(*) from [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] where Settlement_Date_sKey is not null

  select count(*) from [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] where Approved_Date_sKey is not null



select count(distinct(LoanPK)) from [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] where Row_Is_Current=1 --2124919

select count(distinct rmr_id) from M3_MAIN.dbo.iO_Product_MasterReference --2124919





if OBJECT_ID('tempdb..#DWL') is not null
drop table #DWL

select 
	distinct L.LoanID
	,C.Full_Date
into #DWL 
from [Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] LS
inner join dim.dim_Calendar C on LS.Lodgement_Date_sKey=C.Calendar_sKey
inner join dim.dim_Loan L on L.LoanPK=LS.LoanPK
order by L.LoanID
  --623662 rows


if OBJECT_ID('tempdb..#M3L') is not null
drop table #M3L

select 
	distinct rmr.RMR_SeqNumber
	,rcd.RCD_CurrentStart
into #M3L
from M3_MAIN.dbo.iO_Product_MasterReference rmr
inner join M3_MAIN.dbo.iO_Product_ControlDate rcd on rmr.RMR_ID=rcd.RCD_IDLink_RMR and rcd.RCD_Type=106 -- lodgement date
where rcd.RCD_CurrentStart is not null
order by RMR_SeqNumber
--2074668 rows

select top 100 * from #M3L where RMR_SeqNumber not in
(select LoanID from #DWL)
