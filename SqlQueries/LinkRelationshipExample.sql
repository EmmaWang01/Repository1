select * from io_link_masterreference 
left join iO_Control_LinkMaster on io_link_masterreference.lmr_idlink_association=iO_Control_LinkMaster.XLK_ID
left join iO_Client_MasterReference on iO_Client_MasterReference.CMR_ID=io_link_masterreference.LMR_IDLink_CMR
where lmr_idlink_association= '{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'