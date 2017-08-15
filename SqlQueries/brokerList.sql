


select 
	distinct CMRB.CMR_ID
	,CMRB.CMR_Name
	,CTC.CTC_CompanyName
	,CTC.CTC_CompanyACN 
	,CTC.CTC_CompanyABN 
from iO_Client_MasterReference CMRB
inner join iO_Link_MasterReference BrokerL on CMRB.cmr_id=BrokerL.LMR_IDLink_CMR and BrokerL.LMR_IDLink_Association ='{69783579-9e83-4e82-bb25-7b3d52b0f99d}'
inner join io_client_typeCompany CTC on CTC.CTC_IDLink_CMR=CMRB.CMR_ID
