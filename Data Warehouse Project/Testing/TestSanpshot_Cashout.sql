
-- diff missing in DW

select 
	APL.*
	,DW.*
	,isnull(APL.APLCashOut,0)-isnull(DW.Cash_Out,0) as 'Diff'
from
(
	select 
		RTM_IDLink_RMR
		,RMR_SeqNumber as 'LoanNo'
		,xrm.XRP_Detail as 'ProductType'
		--,xsu.XSU_Detail as 'Status'
		,sum(isnull(RTM_ValueDB,0)-isnull(RTM_ValueCR,0)) as 'APLCashOut'
	from M3_Main.dbo.iO_Product_Transaction RTM
	left join M3_Main.dbo.iO_Product_MasterReference RMR on RTM.RTM_IDLink_RMR=RMR.RMR_ID
	left join M3_MAIN.dbo.iO_Control_ProductMaster xrm on XRP_ID=rmr.RMR_IDLink_XRP
	where RTM_IDLink_XTRM in
		(
			'{c71def8a-f18a-46d1-8650-94b2db4731b9}',
			'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}',
			'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}',
			'{71b22e14-385f-45a8-a389-36559632ff65}',
			'{755f7320-b81c-4268-aa94-38802e51505f}',
			'{0f57a357-5888-4946-a857-f568ab18042e}',
			'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}',
			'{4b1b5721-c264-4daf-866a-9dc4d04517b8}'

		) and RTM_TypeGhost=0
	Group by RTM_IDLink_RMR,RMR_SeqNumber,xrm.XRP_Detail
)APL
Full outer join
(
	select
		LoanPK
		,Cash_Out 
	from [TEST_Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot]
)DW on DW.LoanPK=APL.RTM_IDLink_RMR
--where isnull(APL.APLCashOut,0)-isnull(DW.Cash_Out,0)=0
where isnull(APL.APLCashOut,0)-isnull(DW.Cash_Out,0)!=0 and APL.LoanNo is not null -- diff missing in DW




--extra in dw
select result.*, xsux.XSU_Detail from 
(
select 
	APL.*
	,DW.*
	,isnull(APL.APLCashOut,0)-isnull(DW.Cash_Out,0) as 'Diff'
from
(
	select 
		RTM_IDLink_RMR
		,RMR_SeqNumber as 'LoanNo'
		--,xrm.XRP_Detail as 'ProductType'
		--,xsu.XSU_Detail as 'Status'
		,sum(isnull(RTM_ValueDB,0)-isnull(RTM_ValueCR,0)) as 'APLCashOut'
	from M3_Main.dbo.iO_Product_Transaction RTM
	left join M3_Main.dbo.iO_Product_MasterReference RMR on RTM.RTM_IDLink_RMR=RMR.RMR_ID
	--left join M3_MAIN.dbo.iO_Control_ProductMaster xrm on XRP_ID=rmr.RMR_IDLink_XRP
	where RTM_IDLink_XTRM in
		(
			'{c71def8a-f18a-46d1-8650-94b2db4731b9}',
			'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}',
			'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}',
			'{71b22e14-385f-45a8-a389-36559632ff65}',
			'{755f7320-b81c-4268-aa94-38802e51505f}',
			'{0f57a357-5888-4946-a857-f568ab18042e}',
			'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}',
			'{4b1b5721-c264-4daf-866a-9dc4d04517b8}'

		)
	Group by RTM_IDLink_RMR,RMR_SeqNumber
)APL
Full outer join
(
	select
		snap.LoanPK
		,Cash_Out 
		,loan.LoanID
	from [TEST_Money3_DW_Warehouse].[fact].[fact_Loan_Snapshot] snap
	left join [TEST_Money3_DW_Warehouse].dim.dim_Loan loan on snap.Loan_sKey=loan.Loan_sKey
)DW on DW.LoanPK=APL.RTM_IDLink_RMR

where isnull(APL.APLCashOut,0)-isnull(DW.Cash_Out,0)!=0 and APL.LoanNo is not null
) result
left join M3_Main.dbo.iO_Product_MasterReference RMRx on RMRx.RMR_ID=result.LoanPK
left join M3_Main.dbo.iO_Control_StatusMaster xsux on xsux.XSU_ID=RMRx.RMR_IDLink_XSU
