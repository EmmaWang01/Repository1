   IF OBJECT_ID('tempdb..#Loans') IS NOT NULL
            DROP TABLE #Loans

-- This need attributes removed
SELECT [ProductTransactionCode]
	, Debit - Credit AS TotalAmount	
	,[Debit]
	,[Credit]
	, Reversal
	,[EffectiveDatePK]
	,dt.TransactionTypePK
	,DT.TransactionName
	,dt.TransactionGroup
	, dt.TransactionTypeGroup
	,DD.[DateID]
	,DD.DateFull
	,DB.Branch
	, LT.BranchPK
	,DRB.[ReferringBranch]
	,LT.[ReferringBranchPK]
	,DLB.[LoanBranch] 
	,DL.LoanID
	, DL.LoanPK
	,LT.ProductPK
	, DP.[ProductShortName]Product
	,lt.NewLoan
	,lt.NewBorrower
	, S.StatusDetail
	, S.StatusGroup
	, S.StatusShortName
	, DC.[FirstName]
	, DC.LastName
	, dc.Sex
	,dc.clientno
INTO #Loans
FROM [ExtAPL].[FactLoanTrans] LT
INNER  JOIN [ExtAPL].[DimTransactionType] DT
	ON DT.TransactionTypePK = LT.TransactionTypePK
INNER JOIN [dbo].[DimDate] DD
	ON DD.DateID = LT.EffectiveDatePK
LEFT JOIN [ExtAPL].[DimBranch] DB
	ON DB.[BranchPK] = LT.[BranchPK]
INNER JOIN [ExtAPL].[DimProduct] DP
	ON DP.[ProductPK] = LT.[ProductPK]
	AND DP.Product NOT IN ('Money3\Cheque Cashing', 'Money3\MoneyGram','Admin\Master Till', 'Admin\Till' )
LEFT JOIN  [ExtAPL].[DimLoan] DL
	ON DL.[LoanPK] = LT.[LoanPK]
LEFT JOIN [ExtAPL].[DimReferringBranch] DRB
	ON DRB.[ReferringBranchPK] = lt.[ReferringBranchPK]
LEFT JOIN [ExtAPL].[DimLoanBranch] DLB
	ON DLB.[LoanBranchPK] = LT.[LoanBranchPK] 
LEFT JOIN [ExtAPL].[vwDimStatus] S
	ON S.[LoanPK] = LT.[LoanPK]
LEFT JOIN [ExtAPL].[DimCustomer] DC
	ON DC.[BorrowerPK] = LT.[BorrowerPK]

	  
IF OBJECT_ID('tempdb..#LastSuccessfulPayment') IS NOT NULL
DROP TABLE #LastSuccessfulPayment

SELECT DateFull
	,LastPaymentAmount
	,ClientNo
	,Branch
INTO #LastSuccessfulPayment
FROM (
	SELECT DateFull
		,TotalAmount LastPaymentAmount
		,ClientNo
		,Branch
		--,LoanID
		,row_number() OVER (PARTITION BY ClientNo,Branch ORDER BY DateFull DESC) AS 'rownumber'
	FROM #Loans
	WHERE Reversal IS NULL
		AND TransactionGroup = 'Cash in'
	) a
WHERE rownumber = 1

	  
IF OBJECT_ID('tempdb..#FirstSuccessfulPayment') IS NOT NULL
DROP TABLE #FirstSuccessfulPayment

SELECT DateFull
	,LastPaymentAmount
	,ClientNo
	,Branch
INTO #FirstSuccessfulPayment
FROM (
	SELECT DateFull
		,TotalAmount LastPaymentAmount
		,ClientNo
		,Branch
		--,LoanID
		,row_number() OVER (PARTITION BY ClientNo,Branch ORDER BY DateFull ASC) AS 'rownumber'
	FROM #Loans
	WHERE Reversal IS NULL
		AND TransactionGroup = 'Cash in'
	) a
WHERE rownumber = 1