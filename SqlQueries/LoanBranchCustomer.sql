select 
	RMR.RMR_ID
	,RMR.RMR_SeqNumber
	,Branch.CMR_Name
	,PrimaryClient.CMR_Name
	,XSU.XSU_Detail
from iO_Product_MasterReference RMR
left join iO_Link_MasterReference LmrBranch on LmrBranch.LMR_IDLink_Code_ID=RMR.RMR_ID
 and LmrBranch.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}' --//Loan/owning branch
left join iO_Client_MasterReference Branch on Branch.CMR_ID=LmrBranch.LMR_IDLink_CMR

left join iO_Link_MasterReference LmrClient on LmrClient.LMR_IDLink_Code_ID=RMR.RMR_ID
and LmrClient.LMR_IDLink_Association='{146afcaa-059b-469e-a000-0103e84144dc}' --//Loan/primary Client
left join iO_Client_MasterReference PrimaryClient on PrimaryClient.CMR_ID=LmrClient.LMR_IDLink_CMR

left join iO_Control_StatusMaster XSU on XSU.XSU_ID=RMR.RMR_IDLink_XSU
where RMR.RMR_SeqNumber>1999000

/*
select * from iO_Control_LinkMaster
where XLK_ID in ('{b55145aa-2697-43b5-9c6a-c4a0960823d8}','{146afcaa-059b-469e-a000-0103e84144dc}')
*/