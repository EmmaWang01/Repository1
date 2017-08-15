SELECT DISTINCT iO_Client_MasterReference.CMR_ID, iO_Link_MasterReference.LMR_IDLink_Association, iO_Client_MasterReference.CMR_Name
FROM            iO_Link_MasterReference with(nolock) INNER JOIN
                         iO_Client_MasterReference with(nolock) ON iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND 
                         iO_Link_MasterReference.LMR_IDLink_Association = '{b55145aa-2697-43b5-9c6a-c4a0960823d8}' AND iO_Client_MasterReference.CMR_Name IS NOT NULL
--where CMR_Name like '%PFC%'
ORDER BY iO_Client_MasterReference.CMR_Name 

select * from ZZ_Branch_Dialer where Branch_Name like '%PFC%' and LoanType like '%LifeStyle%'

select * from ZZ_Branch_Dialer where LoanType like '%life%'

select top 5 * from io_product_masterreference rmr
left join io_link_masterreference lmr on rmr.rmr_id=lmr.lmr_idlink_code_id and lmr.lmr_idlink_association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}'
	and lmr.lmr_idlink_cmr in ('{abe9ef0b-4f3b-4f71-8c14-e6be45653a85}',
'{a55c2794-5365-42f1-9dff-b4147bb0fddf}',
'{62f3a6d2-9da3-4d9b-8648-cce4215bb517}')
and rmr.rmr_idlink_xrp='{969e0757-1354-4346-aad5-bddf4c46cb89}'



select * from iO_Control_LinkMaster where xlk_id='{b55145aa-2697-43b5-9c6a-c4a0960823d8}'


select
	cmr_id
	,CMR_Name
	,LMR_IDLink_Association
	,xlk.XLK_ID
	,xlk.XLK_Detail
from iO_Client_MasterReference cmr
left join iO_Link_MasterReference lmr on cmr.CMR_ID=lmr.LMR_IDLink_CMR
left join iO_Control_LinkMaster xlk on xlk.XLK_ID=lmr.LMR_IDLink_Association
 where cmr_name like '%Personal Loan%'

 union
 select
	cmr_id
	,CMR_Name
	,LMR_IDLink_Association
	,xlk.XLK_ID
	,xlk.XLK_Detail
from iO_Client_MasterReference cmr
left join iO_Link_MasterReference lmr on cmr.CMR_ID=lmr.LMR_IDLink_CMR
left join iO_Control_LinkMaster xlk on xlk.XLK_ID=lmr.LMR_IDLink_Association
 where cmr_name like '%Direct Secured%'
  order by cmr_name, XLK_Detail