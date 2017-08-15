select * from 
(
select 
	CMR.CMR_SeqNumber
	,FTNC_Numeric
	,FTN.FTNc_SeqNumber
	,row_number() OVER (PARTITION BY CMR.CMR_SeqNumber ORDER BY FTN.FTNc_SeqNumber DESC) AS 'rownumber'	
from iO_Client_MasterReference CMR 
INNER JOIN iO_Field_MasterReference FMR
	ON FMR.FMRc_IDLink_Code = CMR.CMR_ID
INNER JOIN iO_Control_FieldMaster CFM
	ON FMR.FMRc_IDLink_XFDC = CFM.XFDM_ID
INNER JOIN iO_Field_TypeNumeric FTN
	ON FMR.FMRc_ID = FTN.FTNc_IDLink_FMRc
WHERE CFM.XFDM_ID = '{25f47f80-ea86-4675-8143-feb9b021615d}'
--and CMR_SeqNumber='43762'
) as result
where result.rownumber=1


