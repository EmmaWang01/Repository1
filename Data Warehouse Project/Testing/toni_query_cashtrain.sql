with c as 
	(
	select b.rmr_id, b.RMR_SeqNumber, a.RTM_DateC,a.RTM_ValueDB, c.XTRM_Detail 
	,ROW_NUMBER() over(partition by b.RMR_SeqNumber,a.RTM_ValueDB order by a.RTM_ValueDB ) as 'RowNumber'
	from iO_Product_Transaction a
	left join iO_Product_MasterReference b on a.RTM_IDLink_RMR=b.RMR_ID
	left join iO_Control_TransactionMaster c on c.XTRM_ID=a.RTM_IDLink_XTRM
	where RTM_IDLink_XTRM in
	(
		'{7b4ea91e-c309-43f2-b890-5c252be34ae4}','{e2d6802b-a89c-484e-8c9d-cda0c9a268f3}'
	) and RTM_DateC>'20160701'
	)

	select c.*,cmr.CMR_Name from c
	left join iO_Link_MasterReference a on c.RMR_ID=a.LMR_IDLink_Code_ID
	and a.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}'
	left join iO_Client_MasterReference cmr on cmr.CMR_ID=a.LMR_IDLink_CMR
	 where CMR_Name='Cashtrain Branch' and RowNumber>1
	order by RMR_SeqNumber 


	select * from iO_Control_LinkMaster where XLK_Detail like '%loan%branch%'



	select * from iO_DataStorage_SalesReport where DSS_LoanNumber=2168846 order by DSS_SeqNumber desc


	select top 100 RMR_SeqNumber, a.RTM_ValueCR,a.RTM_ValueDB, a.RTM_DateC, XTRM_Detail from iO_Product_Transaction a
	 left join iO_Product_MasterReference b on a.RTM_IDLink_RMR=b.RMR_ID
	 left join iO_Control_TransactionMaster c on a.RTM_IDLink_XTRM=c.XTRM_ID
	 left join iO_Product_Transaction d on a.RTM_IDLink_Reversal=d.RTM_ID
	--where RTM_IDLink_XTRM='{3e8fbdc3-2992-4805-9738-27acf8d914f0}' and RTM_TypeGhost=0
	where c.XTRM_Detail like '%reversal%' and a.RTM_TypeGhost=0 and d.RTM_TypeGhost=1


	select * from iO_Control_TransactionMaster where XTRM_IDUser=130039