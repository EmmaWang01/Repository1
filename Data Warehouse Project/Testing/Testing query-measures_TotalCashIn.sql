/****** Script for SelectTopNRows command from SSMS  ******/
--Loan example LoanID 29, cash in total should be 12561.4400, but shows 300 in tabular

--below is the formula for cash in
CREATE MEASURE 'Transaction'[Cash In Total] =
    CALCULATE (
        SUM ( 'Transaction'[CreditLessDebit] ),
        TransactionType[TransactionGroup] = "Cash in",
        TransactionType[IsReversal] = "Transaction"
    )
        - CALCULATE (
            SUM ( 'Reversals'[CreditLessDebit] ),
            TransactionType[TransactionGroup] = "Cash in"
        )
 
--to check first part of the above formula, run below query, get sum of 12561.4400, it is actrually the correct cash in for this loan
 select * from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=29)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionGroup='Cash in')
   and ReversalProductTransactionPK='' and Ghost=0
 
 select sum(credit-Debit) from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=29)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionGroup='Cash in')
   and ReversalProductTransactionPK='' and Ghost=0




--to check second part of formula(reversal part), run below query, spoted 300, but it's a ghost transaction, should not be picked up
  SELECT *
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=29)


  select * from fact.fact_Reversal where ProductTransactionPK='{e9c9e31b-59ec-41cd-8888-a785db58f484}'


  select * from fact.fact_Transaction a 
  left join dim.dim_TransactionType_ b on a.TransactionType__sKey=b.TransactionType__sKey
  where ProductTransactionPK='{e9c9e31b-59ec-41cd-8888-a785db58f484}' 



  ----to sum up, seems like in tabular  below part did not calculated
  SUM ( 'Transaction'[CreditLessDebit] ),
        TransactionType[TransactionGroup] = "Cash in",
        TransactionType[IsReversal] = "Transaction"
---and below pard did not remove  the ghost,
  - CALCULATE (
            SUM ( 'Reversals'[CreditLessDebit] ),
            TransactionType[TransactionGroup] = "Cash in"

  