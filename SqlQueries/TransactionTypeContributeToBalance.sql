--- list of transaction types contribute to balance

	select XTRM_ID, XTRM_Detail, XTRM_IDText,XTRM_IDUser, XRBl_Detail from iO_Control_TransactionMaster xtrm
	left join iO_Control_TransactionBalance xtrbl on xtrm.XTRM_ID=xtrbl.XTRMb_IDLink_XTRM 
	left join iO_Control_ProductBalance xrbl on xrbl.XRBl_ID=xtrbl.XTRMb_IDLink_XRBl
	WHERE xrbl.XRBl_ID = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' --//Loan\Standard\Principal
	--and XTRM_Detail like '%Deferred Revenue%'



	select distinct XRBl_Detail from iO_Control_TransactionMaster xtrm
	left join iO_Control_TransactionBalance xtrbl on xtrm.XTRM_ID=xtrbl.XTRMb_IDLink_XTRM 
	left join iO_Control_ProductBalance xrbl on xrbl.XRBl_ID=xtrbl.XTRMb_IDLink_XRBl



