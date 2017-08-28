USE [M3_MAIN_REP]
GO

/****** Object:  StoredProcedure [DW].[uspFactLoanTransaction]    Script Date: 28/08/2017 1:26:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================
-- Author		:	Dylan Harvey
-- Description	:	This is an interim stored procedure to load the fact transaction table. 
--					This procedure will need to be altered to use a merge statement and potentially be a delta load. 
--					The delta will need to be able to go back to the beginning of history as operations often change 
--					historical data manually and they cannot be relied upon to update the change date. 
--					They also do hard deletes so this needs to be considered.
-- History		:	2015-09-21 Sp Created by Dylan harvey 
--					2016-01-07 Changed cast for debit and credit to TRY_CONVERT due to float causing issues. DH
--					2016-03-01 Added a work around for declined customers, Added Processed date
--					2016-03-10 Changed RTM_TypeGhost to COALESCE 3, the deletion process of ghosed loans might need further invesagation - Performance issues?
-- 
-- ====================================================================================
CREATE PROCEDURE [DW].[uspFactLoanTransaction]
(
    @ExtractJobID INT
    ,@StartTime DateTime
)
AS
BEGIN
 
SET NOCOUNT ON
SET XACT_ABORT ON
 
    BEGIN TRY

	IF OBJECT_ID('tempdb..#TransLoad') IS NOT NULL
		DROP TABLE #TransLoad

SELECT
	PT.RTM_ID [ProductTransactionPK]
	, RTM_SeqNumber [ProductTransactionCode]
	, RMR_SeqNumber
	, (CASE WHEN COALESCE(PT.RTM_DateE, '') = ''  THEN '1900-01-01' ELSE PT.RTM_DateE END)  [EffectiveDate]	
	, (CASE WHEN COALESCE(PT.RTM_DateE, '') = ''  THEN '-1' ELSE CAST(CONVERT(VARCHAR(8), PT.RTM_DateE, 112) AS INT) END) [EffectiveDatePK]
	, (CASE WHEN COALESCE(PT.RTM_DateC, '') = ''  THEN '1900-01-01' ELSE PT.RTM_DateC END)  [ProcessedDate]
	, (CASE WHEN COALESCE(PT.RTM_DateC, '') = ''  THEN '-1' ELSE CAST(CONVERT(VARCHAR(8), PT.RTM_DateC, 112) AS INT) END)[ProcessedDatePK]
	, (CASE WHEN COALESCE(PT.RTM_IDLink_XTRM, '') = ''  THEN '-1' ELSE COALESCE(DT.TransactionTypePK, '-2') END) [TransactionTypePK]
	, (CASE WHEN COALESCE(PMR.RMR_IDLink_XRP, '') = ''  THEN '-1' ELSE COALESCE(DP.ProductPK, '-2') END) [ProductPK]
	, (CASE WHEN COALESCE(Branch.CMR_ID, '') = ''  THEN '-1' ELSE COALESCE(Branch.CMR_ID, '-2') END) [BranchPK]
	, (CASE WHEN COALESCE(ReferingBranch.CMR_ID, Branch.CMR_ID, '') = ''  THEN '-1' ELSE COALESCE(ReferingBranch.CMR_ID, Branch.CMR_ID, '-2') END) [ReferringBranchPK]
	, Case WHEN Branch.CMR_ID  IN ('{2dea190d-8e60-46ac-90d7-36a741a6d8cc}','{83eacf3e-127e-40cf-b211-384412be0da7}') THEN ReferingBranch.CMR_ID ELSE Branch.CMR_ID END AS [LoanBranchPK] -- If Branch is collections then make branch ReferingBranch -- This is not working properly
	, (CASE WHEN COALESCE(PrincipalBorrower.CMR_ID, '') = '' THEN '-1' ELSE PrincipalBorrower.CMR_ID END)  [BorrowerPK] -- Still need customer dimension
	 --Total new Loan Amount 
	 --Total fees
	, PMR.RMR_ID [LoanPK] -- GUID
	, NULL AS [NewBorrower]
	, NULL AS [NewLoan]
	, TRY_CONVERT (decimal(38,4),PT.RTM_ValueDB) [Debit]
	, TRY_CONVERT (decimal(38,4),PT.RTM_ValueCR) [Credit]
	, COALESCE (PT.RTM_TypeGhost, 3) RTM_TypeGhost
	, CASE	WHEN ISNULL(RTM_IDLink_Reversal,'') = '' THEN NULL
			ELSE 1
			END AS  Reversal
	INTO #TransLoad
	FROM  dbo.iO_Product_MasterReference PMR (NOLOCK) 
	LEFT JOIN dbo.iO_Product_Transaction PT (NOLOCK) 	
		ON PT.RTM_IDLink_RMR = PMR.RMR_ID
	LEFT JOIN [Interim_Reporting].[ExtAPL].[DimProduct] DP
		ON DP.[ProductPK] = PMR.RMR_IDLink_XRP					
	-- PrincipalBorrower
	LEFT JOIN	(SELECT CMR_PrincipalBorrower.CMR_ID, LMR_PrincipalBorrower.LMR_IDLink_Code_ID
				FROM dbo.iO_Link_MasterReference LMR_PrincipalBorrower (NOLOCK)  
				LEFT JOIN dbo.iO_Client_MasterReference CMR_PrincipalBorrower
					ON LMR_PrincipalBorrower.LMR_IDLink_CMR = CMR_PrincipalBorrower.CMR_ID
				WHERE LMR_PrincipalBorrower.LMR_IDLink_Association = '{146afcaa-059b-469e-a000-0103e84144dc}') PrincipalBorrower
		ON PrincipalBorrower.LMR_IDLink_Code_ID = PMR.RMR_ID 
	-- Branch	
	LEFT JOIN	(SELECT LMR_Branch.LMR_IDLink_Code_ID, CMR_Branch.CMR_ID
				FROM  dbo.iO_Link_MasterReference LMR_Branch (NOLOCK)  		
				LEFT JOIN dbo.iO_Client_MasterReference CMR_Branch (NOLOCK)  
					ON LMR_Branch.LMR_IDLink_CMR = CMR_Branch.CMR_ID
				WHERE  LMR_Branch.LMR_IDLink_Association = '{b55145aa-2697-43b5-9c6a-c4a0960823d8}') Branch
		ON Branch.LMR_IDLink_Code_ID = PMR.RMR_ID
	-- Refering Branch -- By LoanID
	LEFT JOIN	(SELECT LMR_ReferingBranch.LMR_IDLink_Code_ID, CMR_ReferingBranch.CMR_ID
				FROM dbo.iO_Link_MasterReference LMR_ReferingBranch 
				JOIN dbo.iO_Client_MasterReference CMR_ReferingBranch
					ON LMR_ReferingBranch.LMR_IDLink_CMR = CMR_ReferingBranch.CMR_ID
				WHERE LMR_ReferingBranch.LMR_IDLink_Association = '{5b3468c2-78d3-450d-bfe3-52c15a6a1d0c}') ReferingBranch
		ON  ReferingBranch.LMR_IDLink_Code_ID = PMR.RMR_ID	
	-- Transactions
	LEFT JOIN [Interim_Reporting].[ExtAPL].[DimTransactionType] DT (NOLOCK)  
		ON DT.TransactionTypePK = PT.RTM_IDLink_XTRM
	---- Date 
	--LEFT JOIN [Interim_Reporting].[dbo].[DimDate]	DD
	--	ON CAST(CONVERT(VARCHAR(8), PT.RTM_DateE, 112) AS INT) = DD.[DateID]
	--LEFT JOIN [Interim_Reporting].[dbo].[DimDate]	DC
	--	ON CAST(CONVERT(VARCHAR(8), PT.RTM_DateC, 112) AS INT) = DD.[DateID]

	
	IF OBJECT_ID('tempdb..#DeletedGhosts') IS NOT NULL
		DROP TABLE #DeletedGhosts

	SELECT ProductTransactionPK
		,ProductTransactionCode
		,RMR_SeqNumber
		,EffectiveDate
		,EffectiveDatePK 
		,ProcessedDate
		,ProcessedDatePK
		,TransactionTypePK
		,ProductPK
		,BranchPK
		,ReferringBranchPK
		,LoanBranchPK
		,BorrowerPK
		,LoanPK
		,NewBorrower
		,NewLoan
		,Debit
		,Credit
		,RTM_TypeGhost
		,Reversal
		,row_number() OVER (PARTITION BY RMR_SeqNumber ORDER BY EffectiveDate ASC) AS 'rownumber'	
	INTO #DeletedGhosts
	FROM #TransLoad TLG
	WHERE RTM_TypeGhost = 1
		AND NOT EXISTS (
			SELECT 1
			FROM #TransLoad TLN
			WHERE TLG.loanPK = TLN.loanPK
				AND TLN.RTM_TypeGhost IN (0,3)
			)





	-- Delete ghosted loan transactions
	--DELETE #TransLoad
	-- WHERE RTM_TypeGhost ='1' 

	--TRUNCATE TABLE [Interim_Reporting].[extAPL].FactLoanTrans

	IF OBJECT_ID('tempdb..#FactLoanTrans') IS NOT NULL
		DROP TABLE #FactLoanTrans

CREATE TABLE #FactLoanTrans (
	[ProductTransactionPK] [varchar](40) NULL,
	[ProductTransactionCode] [bigint] NULL,
	[EffectiveDate] [datetime] NULL,
	[EffectiveDatePK] [int] NULL,
	[ProcessedDate] [datetime] NULL,
	[ProcessedDatePK] [int] NULL,
	[TransactionTypePK] [varchar](50) NULL,
	[ProductPK] [varchar](40) NULL,
	[BranchPK] [varchar](50) NULL,
	[ReferringBranchPK] [varchar](50) NULL,
	[LoanBranchPK] [varchar](50) NULL,
	[BorrowerPK] [varchar](50) NULL,
	[StatusPK] [varchar](50) NULL,
	[LoanPK] [varchar](40) NOT NULL,
	[NewBorrower] [smallint] NULL,
	[NewLoan] [smallint] NULL,
	[Reversal] [int] NULL,
	[Debit] [decimal](38, 4) NULL,
	[Credit] [decimal](38, 4) NULL,
	[LoanAmount] [decimal](38, 4) NULL,
	[LoanApplication] [decimal](38, 4) NULL,
	[DeclinedCustCount] [int] NULL,
	[LoanInitiated] [int] NULL
) 

	INSERT INTO #FactLoanTrans WITH (TABLOCK)
	(
		[ProductTransactionPK]
		,[ProductTransactionCode]
		,[EffectiveDate]
		,[EffectiveDatePK]
		,[ProcessedDate]	
		,[ProcessedDatePK] 
		,[TransactionTypePK]
		,[ProductPK]
		,[BranchPK]
		,[ReferringBranchPK]
		,[LoanBranchPK]
		,[BorrowerPK]
		,[LoanPK]
		,[NewBorrower]
		,[NewLoan]
		,[Debit]
		,[Credit]
		,[Reversal])
		SELECT ProductTransactionPK
		,ProductTransactionCode
		,EffectiveDate
		,EffectiveDatePK
		,[ProcessedDate]	
		,[ProcessedDatePK] 
		,TransactionTypePK
		,ProductPK
		,fl.BranchPK
		,ReferringBranchPK
		,LoanBranchPK
		,BorrowerPK
		,LoanPK
		,NewBorrower
		,NewLoan
		,Debit		
		,Credit
		,Reversal  
		FROM 
				(SELECT ProductTransactionPK
					,ProductTransactionCode
					,EffectiveDate
					,EffectiveDatePK
					,[ProcessedDate]	
					,[ProcessedDatePK] 
					,TransactionTypePK
					,ProductPK
					,BranchPK
					,ReferringBranchPK
					,LoanBranchPK
					,BorrowerPK
					,LoanPK
					,NewBorrower
					,NewLoan
					,Debit
					,Credit
					,Reversal
					,row_number() OVER (PARTITION BY ProductTransactionPK ORDER BY EffectiveDate DESC) AS 'rownumber'	
				FROM #TransLoad 
				WHERE RTM_TypeGhost = 0
				)fl
				JOIN [Interim_Reporting].ExtAPL.[DimBranch] DB
	ON DB.[BranchPK] = fl.[BranchPK]
		AND rownumber = 1


-- Should probably add a source column for auditing 

	-- Deleted Loans for application numbers
	INSERT INTO #FactLoanTrans  WITH (TABLOCK)
	(
		[ProductTransactionPK]
		,[ProductPK]
		,[BranchPK]
		,[EffectiveDate]
		,[EffectiveDatePK]
		,[ProcessedDate]
		,[ProcessedDatePK]
		,[LoanPK]
		,[ReferringBranchPK]
		,[LoanBranchPK]
		,[BorrowerPK]
		,[Debit]
		,[Credit]
		)
	SELECT ProductTransactionPK
		,ProductPK
		,BranchPK
		,EffectiveDate
		,EffectiveDatePK
		,ProcessedDate
		,ProcessedDatePK
		,LoanPK
		,ReferringBranchPK
		,LoanBranchPK
		,BorrowerPK
		,0
		,0
	FROM #DeletedGhosts
	WHERE rownumber = 1


	-- Drop temp table to clear up tempdb space
	IF OBJECT_ID('tempdb..#DeletedGhosts') IS NOT NULL
		DROP TABLE #DeletedGhosts



		-- Drop table #RejectedLoans
	IF OBJECT_ID('tempdb..#StatusForRejectedLoans') IS NOT NULL
		DROP TABLE #StatusForRejectedLoans

-- This is a work around because the status tables have been set up incorrectly in APL

	SELECT StatusPK
		,StatusDateEnter
		,LoanPK
		INTO #StatusForRejectedLoans
	FROM (
		SELECT CSM.XSU_ID StatusPK
			,CAST(SMR_DateEnter AS DATE) StatusDateEnter
			,SMR.SMR_IDLink_Code LoanPK
			,row_number() OVER (
				PARTITION BY SMR.SMR_IDLink_Code
				ORDER BY SMR_SeqNumber ASC
				) AS 'rownumber'
		FROM dbo.iO_Status_MasterReference SMR(NOLOCK)
		INNER JOIN dbo.iO_Control_StatusMaster CSM(NOLOCK)
			ON SMR.SMR_IDLink_XSU = CSM.XSU_ID
		WHERE COALESCE(SMR.SMR_IDLink_Code, '') <> ''
		) S
	WHERE rownumber = 1


	-- Drop table #RejectedLoans
	IF OBJECT_ID('tempdb..#RejectedLoans') IS NOT NULL
		DROP TABLE #RejectedLoans

	SELECT '{' + CAST(NEWID() AS VARCHAR(40)) + '}' AS [ProductTransactionPK],
		fl.ProductPK,
		fl.BranchPk,
		fl.BorrowerPK,
		fl.LoanPK,
		DS.StatusDateEnter,
		DD.DateID,
		ds.StatusPK
	INTO #RejectedLoans
	FROM #TransLoad fl
	JOIN #StatusForRejectedLoans DS
		ON Fl.LoanPK = DS.LoanPK
	JOIN [Interim_Reporting].ExtAPL.[DimBranch] DB
		ON DB.[BranchPK] = fl.[BranchPK]
	LEFT JOIN [Interim_Reporting].[dbo].[DimDate] DD
		ON CAST(CONVERT(VARCHAR(8), DS.StatusDateEnter, 112) AS INT) = DD.[DateID]
	WHERE RTM_TypeGhost = 3

	-- Drop table to clear up tempdb space
	IF OBJECT_ID('tempdb..#TransLoad') IS NOT NULL
		DROP TABLE #TransLoad	

	INSERT INTO #FactLoanTrans  WITH (TABLOCK)
	(
		[ProductTransactionPK],
		[ProductPK],
		[BranchPK],
		[EffectiveDate],
		[EffectiveDatePK],
		[ProcessedDate],	
		[ProcessedDatePK],
		[LoanPK],
		[Debit],
		[Credit],
		[DeclinedCustCount]
		)
	SELECT [ProductTransactionPK],
		ProductPK,
		BranchPK,
		StatusDateEnter,
		DateID,
		StatusDateEnter,
		DateID,
		loanPK,
		[Debit],
		[Credit],
		[DeclinedCustCount]
	FROM (	SELECT [ProductTransactionPK],
				ProductPK,
				BranchPK,
				StatusDateEnter,
				DateID,
				loanPK,
				0 AS [Debit],
				0 AS [Credit],
				1 AS [DeclinedCustCount],
				row_number() OVER (PARTITION BY loanPK ORDER BY StatusDateEnter DESC) AS 'rownumber'
			FROM #RejectedLoans) A
	WHERE rownumber = 1


	---- Add deleted Ghosted loans
	--SELECT ProductTransactionPK
	--	,ProductTransactionCode
	--	,RMR_SeqNumber
	--	,EffectiveDate
	--	,EffectiveDatePK 
	--	,ProcessedDate
	--	,ProcessedDatePK
	--	,TransactionTypePK
	--	,ProductPK
	--	,BranchPK
	--	,ReferringBranchPK
	--	,LoanBranchPK
	--	,BorrowerPK
	--	,LoanPK
	--	,NewBorrower
	--	,NewLoan
	--	,Debit
	--	,Credit
	--	,RTM_TypeGhost
	--	,Reversal 	
	--FROM #DeletedGhosts

	
	
	--SELECT ProductTransactionPK
	--	,ProductTransactionCode
	--	,RMR_SeqNumber
	--	,EffectiveDate
	--	,EffectiveDatePK ProcessedDate
	--	,ProcessedDatePK
	--	,TransactionTypePK
	--	,ProductPK
	--	,BranchPK
	--	,ReferringBranchPK
	--	,LoanBranchPK
	--	,BorrowerPK
	--	,LoanPK
	--	,NewBorrower
	--	,NewLoan
	--	,Debit
	--	,Credit
	--	,RTM_TypeGhost
	--	,Reversal
	--	,row_number() OVER (PARTITION BY RMR_SeqNumber ORDER BY EffectiveDate ASC) AS 'rownumber'	
	--INTO #DeletedGhosts
	--FROM #TransLoad TLG
	--WHERE RTM_TypeGhost = 1
	--	AND NOT EXISTS (
	--		SELECT 1
	--		FROM #TransLoad TLN
	--		WHERE TLG.loanPK = TLN.loanPK
	--			AND TLN.RTM_TypeGhost IN (0,3)
	--		)




	-- Only counts cheques where not an existing customer, would have to implement new cheque cashing code to count correctly

	-- First Disbursement
	UPDATE FLT
	SET [NewLoan] = 1
	FROM #FactLoanTrans FLT
	JOIN 
		(SELECT ProductTransactionPK, LoanPK,
				row_number() over (partition by LoanPK order by EffectiveDatePK asc)
					as RowNum
		FROM #FactLoanTrans flt
		JOIN Interim_Reporting.[extAPL].DimTransactionType dt
			ON dt.TransactionTypePK = flt.TransactionTypePK
		JOIN Interim_Reporting.[extAPL].dimProduct dp
			ON dp.[ProductPK] = flt.[ProductPK]
		WHERE DT.TransactiontypeGroup = 'Disbursement'
		AND dp.[ProductShortName] <> 'Cheque Cashing') A
	ON a.LoanPK = FLT.LoanPK 
	AND a.ProductTransactionPK = FLT.ProductTransactionPK
	WHERE a.RowNum = 1

	-- Cheque Cashing count
	UPDATE FLT
	SET [NewLoan] = 1
		FROM #FactLoanTrans FLT
	JOIN 
		(SELECT ProductTransactionPK, LoanPK
				--row_number() over (partition by LoanPK order by EffectiveDatePK asc)
				--	as RowNum
		FROM #FactLoanTrans flt
		JOIN Interim_Reporting.[extAPL].DimTransactionType dt
			ON dt.TransactionTypePK = flt.TransactionTypePK
		JOIN Interim_Reporting.[extAPL].dimProduct dp
			ON dp.[ProductPK] = flt.[ProductPK]
		WHERE DT.TransactiontypeGroup = 'Disbursement'
		AND DT.TransactionTypePK <> '{175097b2-f5b8-453f-933e-22b136b5badb}' -- Money3\Disbursement\Cash Deferred, this is for cheque's with more than one payment
		AND dp.[ProductShortName] = 'Cheque Cashing') A
	ON a.LoanPK = FLT.LoanPK 
	AND a.ProductTransactionPK = FLT.ProductTransactionPK
	JOIN Interim_Reporting.ExtAPL.DimCurrentBranch db
		ON db.[BranchPK] = flt.[BranchPK]


-- Get original loan amount without fees
-- Fees need to be calculated from ProductTransaction table where the transaction type is a fee

	/* drop the temporary table if exists */
	IF OBJECT_ID('tempdb..#LoanBalance') IS NOT NULL
		DROP TABLE #LoanBalance

	SELECT PMR.rmr_id LoanPK
		,xrb.xrbl_detail LoanType
		,rcb_currentvalue CurrentValue
	INTO #LoanBalance
	FROM io_product_controlbalance rcb(NOLOCK)
	INNER JOIN io_control_productbalance xrb(NOLOCK)
		ON rcb.rcb_idlink_xrbl = xrb.xrbl_id
	INNER JOIN io_product_masterreference PMR(NOLOCK)
		ON RCB.rcb_idlink_rmr = PMR.rmr_id

			/* drop the temporary table if exists */
			IF OBJECT_ID('tempdb..#Fees') IS NOT NULL
				DROP TABLE #Fees

	SELECT LoanPK
		,[Loan\Standard\Application] AS [LoanApplication]
		,[Loan\Standard\New Application Amount] AS [NewApplicationAmount]
	INTO #Fees
	FROM (
		SELECT LoanPK
			,CurrentValue
			,LoanType
		FROM #LoanBalance (NOLOCK) 
		) s
	PIVOT(SUM(CurrentValue) FOR LoanType IN (
				[Loan\Standard\Application]
				,[Loan\Standard\New Application Amount]
				)) AS pivotTbl


CREATE NONCLUSTERED INDEX [IX_FeesAmount]
ON [dbo].[#Fees] ([LoanPK])
INCLUDE ([LoanApplication],[NewApplicationAmount])

-- Add original loan amount without fees
UPDATE FLT
SET [LoanAmount] = F.[NewApplicationAmount]
	,[LoanApplication] = F.[LoanApplication]
FROM #FactLoanTrans FLT
JOIN #Fees	F
	ON F.LoanPK = FLT.LoanPK
WHERE [NewLoan] = 1

	/* drop the temporary table if exists */
	IF OBJECT_ID('tempdb..#NewBorrower') IS NOT NULL
		DROP TABLE #NewBorrower

	-- Set flag for new borrowers
	-- borrowers with a new loan, the customers first disbursement will be considered as the trigger for becoming a New borrower.
	SELECT ProductTransactionPK, BorrowerPK,LoanPK, EffectiveDatePK,
					row_number() over (partition by BorrowerPK order by EffectiveDatePK asc)
						as RowNum
	INTO #NewBorrower
	FROM #FactLoanTrans
	WHERE NewLoan = 1

	-- Set new borrower
	UPDATE FLT
	SET NewBorrower = 1
	FROM #FactLoanTrans FLT
	JOIN #NewBorrower NB
		ON FLT.ProductTransactionPK = NB.ProductTransactionPK
		AND FLT.BorrowerPK = nb.BorrowerPK
		WHERE NB.RowNum = 1

	-- Get the start of every 'Loan' and flag it. This will only set one flag per loanID, multi draw loans will not be recorded i.e. cheques, Line of Credit and redraws
	UPDATE FLT
	SET [LoanInitiated] = 1
	FROM #FactLoanTrans FLT
	JOIN 
	(SELECT [ProductTransactionPK]      
		  ,row_number() OVER (PARTITION BY [LoanPK] ORDER BY EffectiveDate ASC) AS 'rownumber'	
	FROM #FactLoanTrans) AS [LoanInitiated]
		ON FLT.[ProductTransactionPK] = [LoanInitiated].[ProductTransactionPK]
	WHERE[LoanInitiated].rownumber = 1;


	TRUNCATE TABLE  [Interim_Reporting].[ExtAPL].[FactLoanTrans]

	INSERT INTO [Interim_Reporting].[ExtAPL].[FactLoanTrans]  WITH (TABLOCK)
			   ([ProductTransactionPK]
			   ,[ProductTransactionCode]
			   ,[EffectiveDate]
			   ,[EffectiveDatePK]
			   ,[ProcessedDate]
			   ,[ProcessedDatePK]
			   ,[TransactionTypePK]
			   ,[ProductPK]
			   ,[BranchPK]
			   ,[ReferringBranchPK]
			   ,[LoanBranchPK]
			   ,[BorrowerPK]
			   ,[StatusPK]
			   ,[LoanPK]
			   ,[NewBorrower]
			   ,[NewLoan]
			   ,[Reversal]
			   ,[Debit]
			   ,[Credit]
			   ,[LoanAmount]
			   ,[LoanApplication]
			   ,[DeclinedCustCount]
			   ,[LoanInitiated]
			   ,[ExtractLoadTime]
			   ,[ExtractJobId])
		SELECT 	[ProductTransactionPK]
			   ,[ProductTransactionCode]
			   ,[EffectiveDate]
			   ,[EffectiveDatePK]
			   ,[ProcessedDate]
			   ,[ProcessedDatePK]
			   ,[TransactionTypePK]
			   ,[ProductPK]
			   ,[BranchPK]
			   ,[ReferringBranchPK]
			   ,[LoanBranchPK]
			   ,[BorrowerPK]
			   ,[StatusPK]
			   ,[LoanPK]
			   ,[NewBorrower]
			   ,[NewLoan]
			   ,[Reversal]
			   ,[Debit]
			   ,[Credit]
			   ,[LoanAmount]
			   ,[LoanApplication]
			   ,[DeclinedCustCount]
			   ,[LoanInitiated]
			   ,@StartTime 
			   ,@ExtractJobID
		FROM #FactLoanTrans fl

		--SELECT COUNT (DISTINCT(LoanPK)), SUM([LoanInitiated]) , SUM(NewLoan)
		--FROM [Interim_Reporting].[ExtAPL].[FactLoanTrans] 


		/*
		-- Potentially use this for filtering views for load rather than the fact table. Needs more work, look into indexes and if it speeds up the load into Power BI 
		DROP TABLE #Valid
		SELECT DISTINCT db.BranchPK, loanPK, BorrowerPK, db.[BranchStateCode] 
		INTO #Valid
		FROM #FactLoanTrans fl
		JOIN [Interim_Reporting].[ExtAPL].[DimCurrentBranch] db
			ON db.BranchPK = fl.BranchPK
		*/

	/* drop the temporary table if exists */
	IF OBJECT_ID('tempdb..#FactLoanTrans') IS NOT NULL
		DROP TABLE #FactLoanTrans


    END TRY
 
    BEGIN CATCH
        /* rollback transaction if there is open transaction */
        IF @@TRANCOUNT > 0   ROLLBACK TRANSACTION
 
        /* throw the catched error to trigger the error in SSIS package */
        DECLARE @ErrorMessage NVARCHAR(4000),
                @ErrorNumber INT,
                @ErrorSeverity INT,
                @ErrorState INT,
                @ErrorLine INT,
                @ErrorProcedure NVARCHAR(200)
 
        /* Assign variables to error-handling functions that capture information for RAISERROR */
        SELECT  @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(),
            @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-')
 
        /* Building the message string that will contain original error information */
        SELECT  @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, '
         + 'Message: ' + ERROR_MESSAGE()
 
        /* Raise an error: msg_str parameter of RAISERROR will contain the original error information */
        RAISERROR (@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber,
            @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)
    END CATCH
 
    --Finally Section
        /* clean up the temporary table */
 
        IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
            DROP TABLE #Temp
 
 
 
END

GO


