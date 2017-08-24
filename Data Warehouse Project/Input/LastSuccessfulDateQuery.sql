If OBJECT_ID('tempdb..#tempLastDate') is not null
 drop table #tempLastDate

 ---- get all payments history, exclude ones with reversals-----
Select * into #tempLastDate
From
(
SELECT 
	iO_Product_MasterReference.RMR_SeqNumber, 
	--iO_Product_Transaction.RTM_Value, 
	iO_Product_Transaction.RTM_DateC,
	iO_Product_Transaction.RTM_IDLink_XTRM As 'TransTypeID'
FROM 
	dbo.iO_Control_TransactionMaster iO_Control_TransactionMaster, 
	dbo.iO_Product_MasterReference iO_Product_MasterReference, 
	dbo.iO_Product_Transaction iO_Product_Transaction
WHERE 
	iO_Product_Transaction.RTM_IDLink_RMR = iO_Product_MasterReference.RMR_ID 
	AND iO_Product_Transaction.RTM_IDLink_XTRM = iO_Control_TransactionMaster.XTRM_ID 
	and (iO_Product_Transaction.RTM_IDLink_Reversal ='' or iO_Product_Transaction.RTM_IDLink_Reversal is null)
	And iO_Control_TransactionMaster.XTRM_IDText Like 'Payment%' 
	And iO_Control_TransactionMaster.XTRM_IDText Not Like '%reversal%'
) As tem

---- remove last 2 business days direct debit payments (they are un-cleared payments)-------
Declare @DateDifference int
 
 set @DateDifference= 
	case 
		when DATENAME(weekday,GETDATE())='Monday' or DATENAME(weekday,GETDATE())='Tuesday' or DATENAME(weekday,GETDATE())='Wednesday'  or DATENAME(weekday,GETDATE())='Thursday' then 6
		else 4
	end

delete #tempLastDate 
where TransTypeID in
	(
		'{b426962b-3748-4bbf-9232-92ba164dc785}',
		'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
		'{468824e4-f92e-428c-8000-de9d68619d23}',
		'{3352de12-99f6-419e-8298-56650b8dbf96}',
		'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
		'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
		'{48b20755-ab94-464f-88b7-6194ccdc9b42}',
		'{77d7215b-a0ad-495a-86f5-e791f035f335}',
		'{9bb53719-af86-4935-8382-c7a103d375cf}',
		'{da9c356c-51b7-46e7-b637-22f2c2897a44}',
		'{df705e39-0448-487e-9668-237615051925}',
		'{e56e1c9e-241f-4338-ab3a-cde7af4ca8c0}'
	) 
	and (DATEADD (day, @DateDifference,convert(date,RTM_DateC))>=GETDATE())

---- insert last successful payment date to final table------------
insert into M3_Main_Rep.dbo.ZZ_Loan_LastPayment (loanno, lastdate)  (select RMR_SeqNumber, cast(max(RTM_DateC) as date) as latedate from #tempLastDate 
group by RMR_SeqNumber )
