select * from iO_Client_MasterReference CM 
left Join (select CCD_IDLink_CMR, max(CCD_SeqNumber) as CCD_Seq from iO_Client_ContactDetail  where CCD_IDLink_XCT='{29411831-e939-4357-940a-44f55b4a5c9b}' group by CCD_IDLink_CMR)  as CCD
	On CM.CMR_ID=CCD.CCD_IDLink_CMR
left join iO_Client_ContactDetail CMobil with(nolock) on CCD.CCD_Seq=CMobil.CCD_SeqNumber 
where cm.CMR_SeqNumber='xxxx'