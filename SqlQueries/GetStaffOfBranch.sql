select * from io_control_linkmaster where XLK_Detail like '%Structure\Branch to Staff%' --//{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}

select * from iO_Client_MasterReference where cmr_name like '%direct secured%' --//{3e1b219b-3156-4ee0-b146-ff0e4a5b5e40}


select
	CMRBranch.CMR_ID as 'Branch GUID'
	,CMRBranch.CMR_Name as 'Branch Name'
	,LMR.LMR_IDLink_Association 
	,CMRStaff.CMR_ID as 'Staff GUID'
	,CMRStaff.CMR_Name as 'Staff Name'
	,CMRStaff.CMR_SeqNumber as 'Staff No'
from iO_Client_MasterReference CMRBranch
left join iO_Link_MasterReference LMR on LMR.LMR_IDLink_Code_ID=CMRBranch.CMR_ID and LMR.LMR_IDLink_Association='{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'
left join iO_Client_MasterReference CMRStaff on CMRStaff.CMR_ID=LMR.LMR_IDLink_CMR
where CMRBranch.CMR_ID='{3e1b219b-3156-4ee0-b146-ff0e4a5b5e40}'


