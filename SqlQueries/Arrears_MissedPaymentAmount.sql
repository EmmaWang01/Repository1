SELECT RCB_IDLINK_RMR AS 'LoanPK'
	,RCB_MissedPayment.RCB_CurrentValue

FROM iO_Product_ControlBalance RCB_MissedPayment WITH (NOLOCK)
LEFT JOIN iO_Control_ProductBalance XRBL_MissedPayment WITH (NOLOCK) ON XRBL_MissedPayment.XRBl_ID = RCB_MissedPayment.RCB_IDLink_XRBl
WHERE XRBL_MissedPayment.XRBl_Detail LIKE '%Arrears\Missed Payments\Total' --//Missed Payment Amount
and RCB_IDLINK_RMR='{224e604c-652f-4a01-b5f4-85719abe8375}'