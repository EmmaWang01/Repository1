

declare @LoanBalance real
declare @LoanTotal real
declare @TermInMonths real
declare @Fees real

declare @Step1 real
declare @Step2 real
declare @Step3 real
declare @Step4 real
declare @Step5 real



if @LoanTotal = 0 set @Step1 = 0 else
	set @Step1 = @LoanBalance / @LoanTotal
if @Step1 > 1 set @Step1 = 1
set @Step2 = (1 + @TermInMonths) * (@TermInMonths / 2)
set @Step3 = @TermInMonths * @Step1
set @Step4 = (1 + @Step3) * (@Step3 / 2)
if @Step2 = 0 set @Step5 = 0 else
	set @Step5 = @Step4 / @Step2 * @Fees

select @Step5 -- setp5 is deferred Revenue


-- @LoanBalance, please see difinition for outstanding balance

-- see below for @LoanTotal
select RCB_CurrentValue from iO_Product_ControlBalance 
where RCB_IDLink_XRBl='{83e66690-1832-4fd5-855a-acbea23a6638}' --Loan\Money3\Total Loan
	and RCB_IDLink_RMR=(select rmr_id from iO_Product_MasterReference where RMR_SeqNumber=2)

--@TermInMonths
Select 
	TermMonth=RCTe_Years*12+RCTe_Months
From 
	iO_Product_ControlTerm 
Where 
	RCTe_IDLink_RMR= (select rmr_id from iO_Product_MasterReference where RMR_SeqNumber=2) And
	RCTe_Type = 1


-- @Fees
select RCB_CurrentValue 
from iO_Product_ControlBalance 
where RCB_IDLink_XRBl = 
'{47fb5de3-3091-4dc3-81b1-bc27ae64876e}'  -- total fees
and RCB_IDLink_RMR = (select rmr_id from iO_Product_MasterReference where RMR_SeqNumber=2)