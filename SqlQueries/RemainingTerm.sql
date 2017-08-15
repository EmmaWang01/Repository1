
[RemainTerm] = DateDiff(m, getdate(), convert(DATETIME, MDAT.RCD_CurrentStart, 103)) + 1

LEFT JOIN iO_Product_ControlDate MDAT WITH (NOLOCK) ON MDAT.RCD_IDLink_RMR = base.LMR_IDLink_Code_ID
	AND MDAT.RCD_Type = 130040


select [RemainTerm]=DateDiff(m, getdate(), convert(DATETIME, RCD_CurrentStart, 103)) + 1
from iO_Product_ControlDate 
where RCD_Type = 130040 and RCD_IDLink_RMR=(select rmr_id from io_product_masterreference where rmr_seqnumber=1787170)