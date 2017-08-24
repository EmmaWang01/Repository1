select * from iO_Control_LinkMaster where XLK_ID='{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'


select cmr_id,cmr_name, count(*)
from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_cmr where  lmr.lmr_idlink_association = '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'
group by CMR_ID,CMR_Name having count(*)>1


select [dbo].[GetStaffAssociatedBranch]('STARK Gene')

select * from iO_Client_MasterReference where CMR_Name like '%Werribee Branch%'


select cmr_name from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_code_id where lmr.lmr_idlink_cmr  in (select cmr_id from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_cmr where cmr_name = 'STARK Gene'  and lmr.lmr_idlink_association = '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}') and lmr.lmr_idlink_association =  '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'

select cmr_name from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_code_id where lmr.lmr_idlink_cmr  in (select cmr_id from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_cmr where cmr_name = 'STAINES John'  and lmr.lmr_idlink_association = '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}') and lmr.lmr_idlink_association =  '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'



select cmr_name from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_code_id where lmr.lmr_idlink_cmr  in (select cmr_id from io_client_masterreference cmr inner join io_link_masterreference lmr on cmr.cmr_id = lmr.lmr_idlink_cmr where cmr_name = 'Werribee Branch'  and lmr.lmr_idlink_association = '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}') and lmr.lmr_idlink_association =  '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'