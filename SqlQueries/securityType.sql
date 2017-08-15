	SELECT 
		RSC_TypeOfSecurity	
	FROM iO_Product_SecurityVEH
	where RSC_IDLink_RMR = (select rmr_id from io_product_masterreference where rmr_seqnumber=1787170)
