select isnull( Max(XSC_Detail), 'N/A')
From iO_Control_SalesChannel
Left join  iO_Field_TypeString ON iO_Field_TypeString.FTSc_String = iO_Control_SalesChannel.XSC_ID
Left join iO_Field_MasterReference with(nolock) ON iO_Field_MasterReference.FMRc_ID = iO_Field_TypeString.FTSc_IDLink_FMRc
Left join iO_Client_MasterReference on iO_Field_MasterReference.FMRc_IDLink_Code = iO_Client_MasterReference.CMR_ID
where CMR_ID=(select cmr_id from iO_Client_MasterReference where CMR_SeqNumber=699256)