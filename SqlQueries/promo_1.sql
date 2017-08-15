SELECT 
	CMR.CMR_SeqNumber
	,FTNC_Numeric
	,FTN.FTNc_SeqNumber
,row_number() OVER (PARTITION BY CMR.CMR_SeqNumber ORDER BY FTN.FTNc_SeqNumber DESC) AS 'rownumber'	
--INTO #Promo
FROM iO_Field_MasterReference FMR
INNER JOIN iO_Control_FieldMaster CFM
	ON FMR.FMRc_IDLink_XFDC = CFM.XFDM_ID
INNER JOIN iO_Client_MasterReference CMR
	ON FMR.FMRc_IDLink_Code = CMR.CMR_ID
INNER JOIN iO_Field_TypeNumeric FTN
	ON FMR.FMRc_ID = FTN.FTNc_IDLink_FMRc
WHERE CFM.XFDM_ID = '{25f47f80-ea86-4675-8143-feb9b021615d}' -- Guid for opt in/out of promotions
ORDER BY CMR.CMR_SeqNumber DESC