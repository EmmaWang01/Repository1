

--103	Loan\Standard\Application {f6e26460-bf66-40fd-9bb2-112ebc2f2b07}  -- application amount
--104	Loan\Standard\Approved	{57af2f0d-9ec7-46c7-9468-cf633f9b4930}	--Approved amount (including fees such as application fee, commission paid and insurance)
--130015	Loan\Standard\New Application Amount {fa9b4019-3380-435c-bcdd-40b78d39471e}	-- Approved amount (fees not included, can be used as cash out?), but example loan 1278044,it's a appliction but have value. 
--117 Loan\Standard\Principal {cf421ec7-af23-474c-9f8f-46e6b899075f} -- Current Balance
--130012 total fees on APL loan summary screen



select XRBl_ID, XRBl_IDUser,XRBl_Detail from iO_Control_ProductBalance where XRBl_ID in 
(
	'{fa9b4019-3380-435c-bcdd-40b78d39471e}'
	,'{f6e26460-bf66-40fd-9bb2-112ebc2f2b07}'
	,'{57af2f0d-9ec7-46c7-9468-cf633f9b4930}'
)


-- below shows none of these 3 can be used as approved amount or cashout
select
	Loan.LoanNo
	,Loan.Prod_Status
	,Loan.Prod_Type
	,Loan.[Cash Out]
	,a.RCB_CurrentValue as 'ApprovedWithoutFee?'
	,b.RCB_CurrentValue as 'Applied'
	,a.RCB_CurrentValue-b.RCB_CurrentValue as 'Diff'
	,c.RCB_CurrentValue as 'ApprovedWithFee?'
from Reporting_Loan.dbo.lc_balance18062017 Loan
left join iO_Product_MasterReference rmr on Loan.LoanNo=rmr.RMR_SeqNumber
left join iO_Product_ControlBalance a on a.RCB_IDLink_RMR=rmr.RMR_ID and a.RCB_IDLink_XRBl='{fa9b4019-3380-435c-bcdd-40b78d39471e}' --130015	Loan\Standard\New Application Amount
left join iO_Product_ControlBalance b on b.RCB_IDLink_RMR=rmr.RMR_ID and b.RCB_IDLink_XRBl='{f6e26460-bf66-40fd-9bb2-112ebc2f2b07}' --103	Loan\Standard\Application
left join iO_Product_ControlBalance c on c.RCB_IDLink_RMR=rmr.RMR_ID and c.RCB_IDLink_XRBl='{57af2f0d-9ec7-46c7-9468-cf633f9b4930}' --104	Loan\Standard\Approved

where Loan.Prod_Status='Cancelled'



/*
'{c71def8a-f18a-46d1-8650-94b2db4731b9}',
'{175097b2-f5b8-453f-933e-22b136b5badb}',
'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}',
'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}',
'{71b22e14-385f-45a8-a389-36559632ff65}',
'{755f7320-b81c-4268-aa94-38802e51505f}',
'{0f57a357-5888-4946-a857-f568ab18042e}',
'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}',
'{4b1b5721-c264-4daf-866a-9dc4d04517b8}',
'{7c9ab385-4985-45ad-87e2-19af9f3d6478}',
'{9f3fded2-344d-4f5c-8e26-efe4ed0b247f}',
'{360f0924-92dd-4e5d-bff5-0026526f5645}',
'{b3452828-3b39-485b-80ef-7a680a02a7ff}',
'{58104117-e95f-415a-8905-36fc122c4983}',
'{797c1245-adc5-4d1e-ba29-8b006431c89a}',
'{6089ea50-f311-4e49-a0e2-ee3a3929b957}',
'{2cfef587-908c-48e9-8e5c-4d7788ab720c}',
'{d537a6a6-6d8a-4801-8f22-b6dd26a56cbe}',

--disbursment transaction types
*/

if object_id('tempdb..#DisbursmentTrans') is not null
drop table #DisbursmentTrans

select rtm_idlink_rmr, rtm_idlink_xtrm, rtm_valueDB, rtm_valueCR, rtm_dateC
into #DisbursmentTrans
from io_product_transaction
where rtm_idlink_xtrm in
(
	'{c71def8a-f18a-46d1-8650-94b2db4731b9}',
	'{175097b2-f5b8-453f-933e-22b136b5badb}',
	'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}',
	'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}',
	'{71b22e14-385f-45a8-a389-36559632ff65}',
	'{755f7320-b81c-4268-aa94-38802e51505f}',
	'{0f57a357-5888-4946-a857-f568ab18042e}',
	'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}',
	'{4b1b5721-c264-4daf-866a-9dc4d04517b8}',
	'{7c9ab385-4985-45ad-87e2-19af9f3d6478}',
	'{9f3fded2-344d-4f5c-8e26-efe4ed0b247f}',
	'{360f0924-92dd-4e5d-bff5-0026526f5645}',
	'{b3452828-3b39-485b-80ef-7a680a02a7ff}',
	'{58104117-e95f-415a-8905-36fc122c4983}',
	'{797c1245-adc5-4d1e-ba29-8b006431c89a}', --refund
	'{6089ea50-f311-4e49-a0e2-ee3a3929b957}', --refund
	'{2cfef587-908c-48e9-8e5c-4d7788ab720c}',
	'{d537a6a6-6d8a-4801-8f22-b6dd26a56cbe}'
	-- DW CSV TransactionGroup as 'Cash Out' 
) and RTM_TypeGhost=0
;
with c as
(

select 
	loan.LoanNo as LoanNO
	,sum(trans.RTM_ValueDB-trans.RTM_ValueCR) as 'Disbursment'
from (select distinct LoanNo from Reporting_Loan.dbo.lc_balance18062017) Loan
left join io_product_masterreference rmr on rmr.rmr_seqnumber=Loan.loanNo
left join #DisbursmentTrans trans on trans.RTM_IDLink_RMR=rmr.RMR_ID
Group by  LoanNo
)

--select * from c where loanno=2278702

select 
	C.*
	,Loan.Prod_Status
	--,Loan.Prod_Type
	,Loan.[Cash Out]
	,isnull(c.Disbursment,0)-isnull(Loan.[Cash Out],0) as 'Diff'
from c
left join Reporting_Loan.dbo.lc_balance18062017 Loan on c.LoanNo=Loan.LoanNo
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
and loan.[Cash Out] is not null and abs(isnull(c.Disbursment,0)-isnull(Loan.[Cash Out],0))>10


----// should refund be part of cashout or cashin
 
select a.*, rmr.RMR_SeqNumber from #DisbursmentTrans a
left join iO_Product_MasterReference rmr on a.RTM_IDLink_RMR=rmr.RMR_ID
where RTM_IDLink_XTRM in
(
	'{797c1245-adc5-4d1e-ba29-8b006431c89a}', --refund
	'{6089ea50-f311-4e49-a0e2-ee3a3929b957}' --refund
)



