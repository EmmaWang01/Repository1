if object_id('tempdb..#CashInTrans') is not null
drop table #CashInTrans

select rtm_idlink_rmr, rtm_idlink_xtrm, rtm_valueDB, rtm_valueCR, rtm_dateC
into #CashInTrans
from io_product_transaction
where rtm_idlink_xtrm in
(
	'{968fefb0-adc6-4512-8f83-9d8fda90b039}',
	'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}',
	'{88d368ae-d2e3-4db4-9880-3de434f3b542}',
	'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}',
	'{dc2c3e2a-1594-4058-b10f-73627855f28a}',
	'{9251d213-46b3-4ffe-a59e-675bc7ed8258}',
	'{68c8f71b-ea09-4110-82ed-eb9915b5ccb1}',
	'{2b59edef-b7fa-4033-a477-033ae9da122d}',
	'{19bfaee2-b601-4077-9d6e-75589010c1f4}',
	'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}',
	'{be317f39-30b3-4469-a80f-b7443d107391}',
	'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
	'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
	'{b426962b-3748-4bbf-9232-92ba164dc785}',
	'{77d7215b-a0ad-495a-86f5-e791f035f335}',
	'{a8136ec2-6d41-4df2-97e2-a92baa39f139}',
	'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}',
	'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}',
	'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}',
	'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}',
	'{7b99c226-70ee-477d-a247-5491f344862b}', --Money3\Loan\Payment\Payment Refinanced
	'{d96fdc0b-ea82-46c3-9982-0bc4f155935c}',
	'{ef859b47-2820-4459-b033-4bd4d321251a}',
	'{b264fbcd-976f-4328-b758-2f0f7520f0d6}',
	'{d90943f6-a537-4e04-adc0-7a880260a940}',
	'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}',
	'{0e71d163-0bf4-4185-8b48-9e7db7b471fe}',
	'{64a336b6-6562-4abe-809d-ddb951f4c24a}',
	'{244d60d7-2cef-4e24-8a7d-02c9cab998d1}',
	'{cde651a4-8f90-4baf-adc5-83e8499eaa3c}',
	'{e832ac26-3c19-41aa-871c-a08f9b698d69}',
	'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}',
	'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}',
	'{468824e4-f92e-428c-8000-de9d68619d23}',
	'{d685de8f-4009-4968-9fe6-bd63de507376}',
	'{8ae7a940-e7de-47ba-a98e-6227241c4698}',
	'{1d80d541-cd59-4e75-90d5-6c48e9c326ca}',
	'{274ab776-dbd9-4187-9621-2a5f08c68ab4}',
	'{1711bd64-942a-456a-b723-e65d3c877a89}',
	'{f6260e2e-aa78-400a-8c8d-17af33ae0aaf}',
	'{914d2104-748b-47fe-b580-3e9939c39d2a}',
	'{ace232e8-0025-4daf-8535-4e31e55ce71f}',
	'{09cd3218-dd59-44ae-8fd3-c8f45bc501d5}',
	'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
	'{df705e39-0448-487e-9668-237615051925}'

	-- DW CSV TransactionGroup as 'Cash in' 
) and RTM_TypeGhost=0
;
with c as
(

select 
	loan.LoanNo as LoanNO
	,sum(trans.RTM_ValueCR-trans.RTM_ValueDB) as 'CashIn'
from (select distinct LoanNo from Reporting_Loan.dbo.lc_balance19062017) Loan
left join io_product_masterreference rmr on rmr.rmr_seqnumber=Loan.loanNo
left join #CashInTrans trans on trans.RTM_IDLink_RMR=rmr.RMR_ID
Group by  LoanNo
)

--select * from c where loanno=2278702

select 
	C.*
	,Loan.Prod_Status
	--,Loan.Prod_Type
	,Loan.[Net Received]
	,isnull(c.CashIn,0)-isnull(Loan.[Net Received],0) as 'Diff'
from c
left join Reporting_Loan.dbo.lc_balance19062017 Loan on c.LoanNo=Loan.LoanNo
where Prod_Status in
(
	'Active'
	--,'Approved'
	,'Arrears'
	--,'Awaiting Customer Contact'
	--,'Awaiting Emp/Rental'
	--,'Awaiting Further Documents'
	--,'Cancelled'
	,'Collections - Bankrupt'
	,'Collections - DDR Attempt'
	,'Collections - Dead File'
	,'Collections - Do Not Action'
	,'Collections - Dormant'
	,'Collections - External'
	,'Collections - Judgement'
	,'Collections - Legal'
	,'Collections - Part IX'
	,'Collections - Part X'
	,'Collections - Payment Plan'
	,'Collections - Settled'
	,'Collections - Still to Action'
	,'Collections - Valid Phone'
	,'Collections - Veda Listing'
	,'Current'
	,'Default'
	,'Do Not Action'
	--,'Esign'
	--,'Expired Application'
	--,'Extra Documents Needed - ID'
	,'Hardship'
	,'Hold'
	--,'Incomplete Application'
	,'Negotiated payout'
	,'Paid in Full'
	,'Paid in full early discount'
	,'Payment Plan'
	--,'Pre Approved'
	--,'Received'
	--,'Redirect'
	,'Special Arrangement'
	--,'Unsuccessful'
	--,'Waiting on Docs/Credit Req'
	--,'Waiting on References'
	--,'Waiting on Welcome Call'
	--,'Written Off'
)
and loan.[Cash Out] is not null and loan.DishonCnt>0 and abs(isnull(c.CashIn,0)-isnull(Loan.[Net Received],0))>10


--select * from iO_Control_TransactionMaster where xtrm_detail like 'Money3\Loan\Payment\Payment Refinanced'
