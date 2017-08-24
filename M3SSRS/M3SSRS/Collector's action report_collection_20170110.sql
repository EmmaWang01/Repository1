declare @Branch Varchar(50)
declare @From_date date
declare @To_date date

set @Branch='{2dea190d-8e60-46ac-90d7-36a741a6d8cc}' --//collections
set @From_date='20170105'
set @To_date='20170110'

SELECT distinct io_note_masterreference.nmr_id, 
       io_note_masterreference.nmr_date, 
       io_client_masterreference.cmr_name, 
	   iO_Product_MasterReference.RMR_SeqNumber,
      io_control_contacttype.xct_detail + ' - ' 
       + Isnull(io_client_contactdetail.ccd_areacode + ' ', '') 
       + Isnull(io_client_contactdetail.ccd_details, '') AS Expr1,
	  
       io_note_masterreference.nmr_detail, 
       c.cmr_name                                        AS Expr2
	   
	 -- dbo.[GetStaffAssociatedBranch] ( c.cmr_name  ) --as Expr3
FROM   io_note_masterreference with(nolock)
       LEFT OUTER JOIN IO_PRODUCT_MASTERREFERENCE with(nolock)
	   ON RMR_ID =  NMR_IDLink_Code
       LEFT OUTER JOIN io_client_masterreference with(nolock)
                    ON io_note_masterreference.nmr_idlink_cmr_for = 
                       io_client_masterreference.cmr_id 
     LEFT OUTER JOIN io_client_contactdetail with(nolock)
                    ON io_note_masterreference.nmr_idlink_xct = 
                       io_client_contactdetail.ccd_idlink_xct 
                       AND io_client_contactdetail.ccd_idlink_cmr = 
                           io_note_masterreference.nmr_idlink_cmr_for

		

       LEFT OUTER JOIN io_control_contacttype with(nolock)
                    ON io_client_contactdetail.ccd_idlink_xct = 
                       io_control_contacttype.xct_id 
       INNER JOIN (SELECT iO_Client_MasterReference_2.cmr_id, 
                          iO_Client_MasterReference_2.cmr_name 
                   FROM   io_client_masterreference AS 
                          iO_Client_MasterReference_2 with(nolock)
                          LEFT OUTER JOIN io_link_masterreference with(nolock)
                                       ON iO_Client_MasterReference_2.cmr_id = 
                                          io_link_masterreference.lmr_idlink_cmr 
                   WHERE  ( io_link_masterreference.lmr_idlink_association = 
                                    '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}' )  --//Structure\Branch to Staff
                          AND ( io_link_masterreference.lmr_idlink_code_id in 
                                (@Branch) ))
                                                                AS c 
               ON c.cmr_id = io_note_masterreference.nmr_idlink_cmr_from 
WHERE  ( io_note_masterreference.nmr_idlink_xnt = 
                '{81f0127b-dd17-4ad8-ac55-982c43493da5}' ) 
       AND (io_note_masterreference.nmr_date between @From_date and @To_date)
       AND ( io_note_masterreference.nmr_detail LIKE '%outbound%' 
              OR io_note_masterreference.nmr_detail LIKE '%inbound%' 
              OR io_note_masterreference.nmr_detail LIKE '%skip tracing%' 
              OR io_note_masterreference.nmr_detail LIKE '%Email E-%' ) 
UNION ALL 
SELECT distinct iO_Note_MasterReference_1.nmr_id, 
       iO_Note_MasterReference_1.nmr_date, 
       io_client_applicationclientdetails.cac_name, 
	   iO_Product_MasterReference.RMR_SeqNumber,
       iO_Control_ContactType_1.xct_detail + ' - ' 
       + Isnull(iO_Client_ContactDetail_1.ccd_areacode + ' ', '') 
       + Isnull(iO_Client_ContactDetail_1.ccd_details, '') AS Expr1, 
	  
       iO_Note_MasterReference_1.nmr_detail, 
       c_1.cmr_name  as Expr2
	  -- dbo.[GetStaffAssociatedBranch] ( c_1.cmr_name  ) --as Expr3
FROM   io_note_masterreference AS iO_Note_MasterReference_1 with(nolock)
LEFT OUTER JOIN IO_PRODUCT_MASTERREFERENCE with(nolock)
	   ON RMR_ID =  iO_Note_MasterReference_1.NMR_IDLink_Code
       INNER JOIN io_client_applicationclientdetails with(nolock)
               ON iO_Note_MasterReference_1.nmr_idlink_cmr_for = 
                  io_client_applicationclientdetails.cac_id 
       LEFT OUTER JOIN io_client_contactdetail AS iO_Client_ContactDetail_1 with(nolock)
                    ON iO_Note_MasterReference_1.nmr_idlink_xct = 
                                       iO_Client_ContactDetail_1.ccd_idlink_xct 
                       AND iO_Client_ContactDetail_1.ccd_idlink_cmr = 
                           iO_Note_MasterReference_1.nmr_idlink_cmr_for


       LEFT OUTER JOIN io_control_contacttype AS iO_Control_ContactType_1 with(nolock)
                    ON iO_Client_ContactDetail_1.ccd_idlink_xct = 
                       iO_Control_ContactType_1.xct_id 
       INNER JOIN (SELECT iO_Client_MasterReference_1.cmr_id, 
                          iO_Client_MasterReference_1.cmr_name 
                   FROM   io_client_masterreference AS 
                          iO_Client_MasterReference_1 with(nolock)
                          LEFT OUTER JOIN io_link_masterreference AS 
                                          iO_Link_MasterReference_1 with(nolock)
                                       ON iO_Client_MasterReference_1.cmr_id = 
iO_Link_MasterReference_1.lmr_idlink_cmr 
WHERE  ( iO_Link_MasterReference_1.lmr_idlink_association = 
'{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}' ) 
AND ( iO_Link_MasterReference_1.lmr_idlink_code_id in (@Branch)
)) AS c_1 
ON c_1.cmr_id = iO_Note_MasterReference_1.nmr_idlink_cmr_from 
WHERE  ( iO_Note_MasterReference_1.nmr_idlink_xnt = 
                '{81f0127b-dd17-4ad8-ac55-982c43493da5}' ) 
  AND ( iO_Note_MasterReference_1.nmr_date between @From_date and @To_date) 
       AND ( iO_Note_MasterReference_1.nmr_detail LIKE '%outbound%' 
              OR iO_Note_MasterReference_1.nmr_detail LIKE '%inbound%' 
              OR iO_Note_MasterReference_1.nmr_detail LIKE '%skip tracing%' 
              OR iO_Note_MasterReference_1.nmr_detail LIKE '%Email E-%' ) 



