
EXEC master..xp_cmdshell @sqlcmd1



DECLARE @filename NVARCHAR(256)

SET @filename = 'md D:\Extracts'

EXEC xp_cmdshell @filename

SET @filename = 'del D:\Extracts\Cashtrain\CashTrainM3ODump_' + REPLACE(CONVERT(VARCHAR(10), (GETDATE()), 112), '/', '') + '.csv'

EXEC xp_cmdshell @filename

-- EXPORT NEW CSV FILES
DECLARE @sqlCmd1 VARCHAR(8000)

SELECT @sqlcmd1 = 'sqlcmd -S . -d M3_MAIN_REP -E -s"|" -W -Q "SET NOCOUNT ON;SELECT ISNULL(CustGUID,'''') CustGUID, ISNULL(CustID,'''') CustID,ISNULL(BranchName,'''') BranchName,ISNULL(LoanID,'''') LoanID,ISNULL(FirstName,'''') FirstName,ISNULL(LastName,'''') LastName, LoanAmount,LoanApplication,ISNULL(Mobile,'''') Mobile,ISNULL(Email,'''') Email,ISNULL([State],'''') State,ScheduledPaymentDate ScheduledPaymentDate,SettledDate SettledDate,LodgementDate,ISNULL(StatusShortName,'''') StatusShortName,ISNULL(SuccPercLoan,0) SuccPercLoan,ISNULL(WIPLodgedInTheLast6Days,'''') WIPLodgedInTheLast6Days,ISNULL(DeclinedCust25Days,'''') DeclinedCust25Days,ISNULL(DeclinedCust40Days,'''') DeclinedCust40Days,ISNULL(DeclinedCust50Days,'''') DeclinedCust50Days, ISNULL(DeclinedCust60Days,'''') DeclinedCust60Days,DeclineReason,ISNULL(MembersArea,'''') MembersArea,ISNULL(RemainingPayment,'''') [RemainingPayment] ,ISNULL(ActiveSACCLoans, '''')ActiveSACCLoans  FROM [temptbl_CashTrainActiveCancelledDischarged] WHERE BranchName IN (''Cashtrain Branch'',''Money3 Online'')" | findstr /V /C:"-" /B > D:\Extracts\Cashtrain\CashTrainM3ODump_' + REPLACE(CONVERT(VARCHAR(10), (GETDATE()), 112), '/', 
		'') + '.csv'

EXEC master..xp_cmdshell @sqlcmd1
