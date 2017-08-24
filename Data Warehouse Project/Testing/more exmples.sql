 
 --//example loan 3925 no reversals for this loan,  Total cash in should be 3654.25, dishonours should be 6. showing 6269.25 and 0 in pivot table
 
 --------total cash in queries. get 3654.25-0, which is correct
 select sum(credit-Debit) from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=3925)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionGroup='Cash in')
   and Reversal=0 and Ghost=0

 SELECT isnull(sum(credit-Debit),0)
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=3925)
  and Ghost=0


---------count of dishonour queries, get 6-0, which is correct
select count( [Debit]) from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=3925)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour')
  and Ghost=0

 SELECT COUNT ( [Credit] )
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=3925) 
  and ProductTransactionPK in (select ProductTransactionPK from fact.fact_Transaction where TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour'))
  and Ghost=0



--------------------------------------------------------------------------------------------------------------------------------------------------

--// example loan 348309, has reversals, total cash in 17991.82, dishonour count 12. showing $35,237.45 and 0 in excel povit table

 --------total cash in queries. get 17991.82-0, which is correct
 select sum(credit-Debit) from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=348309)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionGroup='Cash in')
   and Reversal=0 and Ghost=0

 SELECT isnull(sum(credit-Debit),0)
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=348309)
  and Ghost=0


---------count of dishonour queries, get 12-0, which is correct
select count( [Debit]) from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=348309)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour')
  and Ghost=0

 SELECT COUNT ( [Credit] )
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=348309) 
  and ProductTransactionPK in (select ProductTransactionPK from fact.fact_Transaction where TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour'))
  and Ghost=0