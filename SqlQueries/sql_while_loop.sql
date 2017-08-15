

--select * from zz_scheduledPayments where term=10

--select count(*) from zz_scheduledPayments where term is not null and monthlypayment is not null and M0>0 

/**go through zz_scheduledPayments table by term, update zz_scheduledPaymens using term**/

select distinct term into #term from zz_scheduledPayments  where term is not null and term>0 order by term




declare @TableID int
declare @termt as int


while exists (select * from #term)
begin

    select top 1 @TableID = term
    from #term
    order by term asc

	declare @a as int =0
    
	
	select top 1 @termt = Term
    from #term
    order by Term asc


	WHILE @a<@termt
	begin
		declare @str as Varchar(800)
		set @str='update zz_scheduledPayments set M'+cast(@a as char(3))+'=MonthlyPayment where Term='+cast(@TableID as char)
		EXEC (@str)
		Set @a=@a+1
	End
	--select @termt as 'term'
	--select @TableID as 'Loan'
    delete #term
    where term = @TableID

end

drop table #term
select * from #term


select * into Reporting_Loan.dbo.zz_temp_ScheduledReceived from zz_scheduledPayments 