select *
	--Branch.CMR_Name 
from iO_Product_MasterReference RMR WITH (NOLOCK)
	
--Link Connection
LEFT JOIN iO_Link_MasterReference LMR WITH (NOLOCK)
	ON RMR.RMR_ID = LMR.LMR_IDLink_Code_ID
	AND LMR.LMR_IDLink_Association = '{b55145aa-2697-43b5-9c6a-c4a0960823d8}'--branch
--Link Branch
left join iO_Client_MasterReference as Branch with(nolock) on Branch.CMR_ID=LMR.LMR_IDLink_CMR 
		
		--'{7e504c4d-821c-4623-a928-28ee65c3b8c8}'owning branch

where RMR_SeqNumber='1748642'

/*number of loans owned by the branch*/
select count(*)
	--Branch.CMR_Name 
from iO_Product_MasterReference RMR WITH (NOLOCK)
	
--Link Connection
LEFT JOIN iO_Link_MasterReference LMR WITH (NOLOCK)
	ON RMR.RMR_ID = LMR.LMR_IDLink_Code_ID
	AND LMR.LMR_IDLink_Association = '{7e504c4d-821c-4623-a928-28ee65c3b8c8}'--branch
--Link Branch
left join iO_Client_MasterReference as Branch with(nolock) on Branch.CMR_ID=LMR.LMR_IDLink_CMR 
where branch.CMR_Name='Bendigo Branch '


/*number of loans reffered by the branch*/
select count(*)
	--Branch.CMR_Name 
from iO_Product_MasterReference RMR WITH (NOLOCK)
	
--Link Connection
LEFT JOIN iO_Link_MasterReference LMR WITH (NOLOCK)
	ON RMR.RMR_ID = LMR.LMR_IDLink_Code_ID
	AND LMR.LMR_IDLink_Association = '{5b3468c2-78d3-450d-bfe3-52c15a6a1d0c}'--branch
--Link Branch
left join iO_Client_MasterReference as Branch with(nolock) on Branch.CMR_ID=LMR.LMR_IDLink_CMR 
where branch.CMR_Name='Bendigo Branch '