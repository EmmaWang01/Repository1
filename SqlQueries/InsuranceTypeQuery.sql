select
	rcfe_id,
	XTRM_IDText,
	rcfe_value,
	cmr_name
from
	io_product_controlfee
		left join io_control_transactionmaster
			on rcfe_idlink_xtrm = xtrm_id
			left join io_client_masterreference
			on rcfe_idlink_payable = cmr_id
		left join io_control_productfeepayable
			on rcfe_idlink_payable = xrfp_id
			
where
	rcfe_idlink_rmr = '@AccountID'
	and rcfe_type = 130000


	select XTRM_IDText 
	from io_product_controlfee 
	left join io_control_transactionmaster
			on rcfe_idlink_xtrm = xtrm_id
	where RCFe_Type=130000 
		and RCFe_IDLink_RMR=(select rmr_id from iO_Product_MasterReference where rmr_seqnumber=1776815)



	select RCFe_IDLink_RMR from io_product_controlfee 
	left join io_control_transactionmaster
			on rcfe_idlink_xtrm = xtrm_id
	where RCFe_Type=130000 
	group by RCFe_IDLink_RMR having count(1)>1