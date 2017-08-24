/****** Script for SelectTopNRows command from SSMS  ******/
--Loan example LoanID 28, dishonour should be 1, shows -3 in excel


  --- to check data source run below query get dishonour transaction {8adf33ca-ee4d-42f3-b228-ade95e7f8d07}, this shows as  the dishonour in APL, but there is a reversal transaction for this one, but when check further, the reversal transaction is not existed in the database at all. 
  use M3_MAIN
  select * from iO_Product_Transaction a
left join iO_Control_TransactionMaster b on a.RTM_IDLink_XTRM=b.XTRM_ID
where RTM_IDLink_RMR=(select rmr_id from iO_Product_MasterReference where RMR_SeqNumber=28)
and XTRM_Detail like '%Dishonour%' and RTM_TypeGhost=0



-----formular 
CREATE MEASURE 'Transaction'[Dishonours] =
    CALCULATE (
        COUNT ( [Debit] ),
        TransactionType[TransactionTypeSubGroup] = "Dishonour",
        TransactionType[IsReversal] = "Transaction"
    )
        - CALCULATE (
            COUNT ( [Credit] ),
            TransactionType[TransactionTypeSubGroup] = "Dishonour"
        )

--to check first part of the above formula, run below query get 7 transactions, 6 are ghost, but are all reversal
use TEST_Money3_DW_Warehouse
select * from fact.fact_Transaction 
 where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=28)
  and TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour')
 

--to check second part of formula(reversal part), run below query get 3 transactions, all ghost
  SELECT *
  FROM [TEST_Money3_DW_Warehouse].[fact].[fact_Reversal]
  where Loan_sKey in (select Loan_sKey from dim.dim_Loan where LoanID=28) 
  and ProductTransactionPK in (select ProductTransactionPK from fact.fact_Transaction where TransactionType__sKey in (select TransactionType__sKey from dim.dim_TransactionType_ where TransactionTypeSubGroup='Dishonour'))


 



 