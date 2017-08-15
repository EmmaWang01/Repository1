if OBJECT_ID('tempdb..#LoansDrawDown1') is not null
drop table #LoansDrawDown1

SELECT RCB_IDLink_RMR AS 'LoanPK'
		,RMR_Seqnumber
		
		,(ISNULL([Money3\LOC\Disbursement\Direct Credit - Drawdown], 0) + ISNULL([Money3\Conversion\Original Total Draw Down], 0) + isnull([Loan\AUPrincipal\AU Loan Redraw],0) + ISNULL([Money3\LOC\Disbursement\Cash Disbursement - Drawdown], 0) + isnull([Loan\Principal\Loan Redraw],0)) 
		
		- (ISNULL([Money3\LOC\Disbursement\Direct Credit - Drawdown - Reversal], 0) + ISNULL([Money3\LOC\Disbursement\Reversal\Cash Disbursement Payment Drawdown- Reversal], 0) + ISNULL([Money3\LOC\Disbursement\Reversal\EFT Payment Drawdown - Reversal], 0) + isnull([Loan\AUPrincipal\Loan Redraw Reversal],0) + isnull([Loan\Reverse\Principal\Principal Redraw (CR)],0)) AS 'Drawdown'
into #LoansDrawDown1		
	FROM (
		SELECT RTM_IDLink_RMR AS 'RCB_IDLink_RMR'
			,productTransaction.RTM_Value AS 'Amount'
			,CTM.XTRM_Detail AS 'APL_TransactionDetail'
			
			,RMR_Seqnumber
		FROM [dbo].[iO_Product_Transaction] productTransaction
		INNER JOIN [dbo].[iO_Control_TransactionMaster] CTM ON CTM.XTRM_ID = productTransaction.RTM_IDLink_XTRM
		LEFT JOIN IO_Product_masterreference ON RMR_ID = RTM_IDLink_RMR
		LEFT JOIN IO_Control_StatusMaster ON XSU_ID = RMR_IDLink_XSU
		where CTM.XTRM_ID in 
		(
			'{0df77ffb-a446-44fa-8425-b401a7b880da}',
			'{164ae593-c995-4046-a049-921960de3d5d}',
			'{28610cc8-ade1-4b25-8a76-e777d6f0014d}',
			'{360f0924-92dd-4e5d-bff5-0026526f5645}',
			'{775161d1-ab1e-435b-93c6-8e6d53fd8bfe}',
			'{87d5ebc3-f4cc-4412-a56a-a06f50ae0e59}',
			'{968b75f2-9a40-45cb-b01e-d8a782062dcf}',
			'{9f3fded2-344d-4f5c-8e26-efe4ed0b247f}',
			'{a4a28893-6098-450f-a805-a329f2a73f97}',
			'{e94f9a24-9b1e-4275-a740-4fd51c4d3f71}'	--All Drawdown, redraw types
		)

		) Tblsource
	PIVOT(SUM(Tblsource.Amount) FOR tblSource.APL_TransactionDetail IN (
					[Money3\LOC\Disbursement\Reversal\EFT Payment Drawdown - Reversal],
					[Money3\Conversion\Original Total Draw Down],
					[Loan\AUPrincipal\AU Loan Redraw],
					[Money3\LOC\Disbursement\Reversal\Cash Disbursement Payment Drawdown- Reversal],
					[Money3\LOC\Disbursement\Direct Credit - Drawdown],
					[Loan\AUPrincipal\Loan Redraw Reversal],
					[Loan\Reverse\Principal\Principal Redraw (CR)],
					[Money3\LOC\Disbursement\Direct Credit - Drawdown - Reversal],
					[Loan\Principal\Loan Redraw],
					[Money3\LOC\Disbursement\Cash Disbursement - Drawdown]

				)) AS PivotTable

	--select count(*) as 'totalLoanNumber', sum(drawdown) as 'SumOfDrawdown' from #LoansDrawDown1
