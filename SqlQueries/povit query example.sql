SELECT RCB_IDLink_RMR AS 'LoanPK'
		,RMR_Seqnumber
		,StatusName
		,(ISNULL([Money3\Fee\WaiveCr], 0) + ISNULL([Money3\Conversion\Original Waived Credit], 0)) AS 'WaiveCr'
		,(ISNULL([Money3\LOC\Disbursement\Direct Credit - Drawdown], 0) + ISNULL([Money3\Conversion\Original Total Draw Down], 0) + + ISNULL([Money3\LOC\Disbursement\Cash Disbursement - Drawdown], 0)) - (ISNULL([Money3\LOC\Disbursement\Direct Credit - Drawdown - Reversal], 0) + ISNULL([Money3\LOC\Disbursement\Reversal\Cash Disbursement Payment Drawdown- Reversal], 0)) AS 'Drawdown'
		,ISNULL([Money3\Fee\LOC\Drawdown Fee], 0) AS 'DrawdownFee'
		,(ISNULL([Money3\Conversion\Opening Balance], 0) + ISNULL([Money3\Disbursement\Cash Disbursement], 0) + ISNULL([Money3\Disbursement\Cheque], 0) + ISNULL([Money3\Disbursement\Direct Credit], 0) + ISNULL([Money3\Disbursement\BPay], 0) + ISNULL([Money3\Disbursement\Initial Rental Amount], 0) + ISNULL([Money3\Conversion\Original Loan Amount], 0)) - (ISNULL([Money3\Disbursement\Reversal\BPay Payment - Reversal], 0) + ISNULL([Money3\Disbursement\Reversal\Cash Now Payment - Reversal], 0) + ISNULL([Money3\Disbursement\Reversal\Cheque Payment - Reversal], 0) + ISNULL([Money3\Disbursement\Reversal\Cheque Total Amount - Reversal], 0) + ISNULL([Money3\Disbursement\Reversal\Deferred Cash Payment - Reversal], 0) + ISNULL([Money3\Disbursement\Reversal\Direct Credit - Reversal], 0) + ISNULL([Money3\Discharge\Discharge Disbursement\Cash], 0) + ISNULL([Money3\Discharge\Discharge Disbursement\Direct Credit], 0) + ISNULL([Money3\Refund\Refund Cash Disbursement], 0) + ISNULL([Money3\Refund\Refund Direct Credit], 0)) AS 
		'Cashout'
		,ISNULL([Money3\Disbursement\Initial Rental Amount], 0) AS 'Rental'
	FROM (
		SELECT RTM_IDLink_RMR AS 'RCB_IDLink_RMR'
			,productTransaction.RTM_Value AS 'Amount'
			,CTM.XTRM_Detail AS 'APL_TransactionDetail'
			,XSU_Detail AS 'StatusName'
			,RMR_Seqnumber
		FROM [dbo].[iO_Product_Transaction] productTransaction
		INNER JOIN [dbo].[iO_Control_TransactionMaster] CTM ON CTM.XTRM_ID = productTransaction.RTM_IDLink_XTRM
		LEFT JOIN [dbo].[iO_Control_TransactionBalance] CTBl ON CTBl.XTRMb_IDLink_XTRM = CTM.XTRM_ID
		LEFT JOIN [dbo].[iO_Control_ProductBalance] CPB ON CPB.XRBl_ID = XTRMb_IDLink_XRBl
		LEFT JOIN IO_Product_masterreference ON RMR_ID = RTM_IDLink_RMR
		LEFT JOIN IO_Control_StatusMaster ON XSU_ID = RMR_IDLink_XSU
		WHERE CPB.XRBl_ID = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' --//Loan\Standard\Principal
		) Tblsource
	PIVOT(SUM(Tblsource.Amount) FOR tblSource.APL_TransactionDetail IN (
				[Money3\Conversion\Opening Balance]
				,[Money3\Conversion\Original Loan Amount]
				,[Money3\Conversion\Original Total Draw Down]
				,[Money3\Conversion\Original Waived Credit]
				,[Money3\Disbursement\Cash Disbursement]
				,[Money3\Disbursement\Cheque]
				,[Money3\Disbursement\Direct Credit]
				,[Money3\Disbursement\Initial Rental Amount]
				,[Money3\Disbursement\Reversal\BPay Payment - Reversal]
				,[Money3\Disbursement\Reversal\Cash Now Payment - Reversal]
				,[Money3\Disbursement\Reversal\Cheque Payment - Reversal]
				,[Money3\Disbursement\Reversal\Cheque Total Amount - Reversal]
				,[Money3\Disbursement\Reversal\Deferred Cash Payment - Reversal]
				,[Money3\Disbursement\Reversal\Direct Credit - Reversal]
				,[Money3\Discharge\Discharge Disbursement\Cash]
				,[Money3\Discharge\Discharge Disbursement\Direct Credit]
				,[Money3\Fee\Loan\Credit Fee]
				,[Money3\Fee\LOC\Drawdown Fee]
				,[Money3\Fee\Reversal\Drawdown Fee - Reversal]
				,[Money3\Fee\WaiveCr]
				,[Money3\Fee\Waived\Money3 Waived (Credit)]
				,[Money3\LOC\Disbursement\Cash Disbursement - Drawdown]
				,[Money3\LOC\Disbursement\Direct Credit - Drawdown - Reversal]
				,[Money3\LOC\Disbursement\Direct Credit - Drawdown]
				,[Money3\LOC\Disbursement\Reversal\Cash Disbursement Payment Drawdown- Reversal]
				,[Money3\Refund\Refund Cash Disbursement]
				,[Money3\Refund\Refund Direct Credit]
				,[Money3\Disbursement\BPay]
				)) AS PivotTable
	where RMR_SeqNumber=601076