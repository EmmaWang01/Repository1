
select * from dim.dim_TransactionType_ where TransactionTypeSubGroup = 'Dishonour - Loan'

--transactions 33
select * from fact.fact_Transaction T
left join dim.dim_Loan L on T.Loan_sKey=L.Loan_sKey
left join dim.dim_TransactionType_ TT on TT.TransactionType__sKey=T.TransactionType__sKey 
where TT.TransactionTypeID in
(
	'{244d60d7-2cef-4e24-8a7d-02c9cab998d1}',
	'{cde651a4-8f90-4baf-adc5-83e8499eaa3c}',
	'{e832ac26-3c19-41aa-871c-a08f9b698d69}',
	'{1d80d541-cd59-4e75-90d5-6c48e9c326ca}',
	'{1711bd64-942a-456a-b723-e65d3c877a89}'
)
and L.LoanID=1353111

--reversals 0
select * from fact.fact_Reversal where ReversalProductTransactionPK in
(
	select ProductTransactionPK from fact.fact_Transaction T
	left join dim.dim_Loan L on T.Loan_sKey=L.Loan_sKey
	left join dim.dim_TransactionType_ TT on TT.TransactionType__sKey=T.TransactionType__sKey 
	where TT.TransactionTypeID in
	(
		'{244d60d7-2cef-4e24-8a7d-02c9cab998d1}',
		'{cde651a4-8f90-4baf-adc5-83e8499eaa3c}',
		'{e832ac26-3c19-41aa-871c-a08f9b698d69}',
		'{1d80d541-cd59-4e75-90d5-6c48e9c326ca}',
		'{1711bd64-942a-456a-b723-e65d3c877a89}'
	)
	and L.LoanID=1353111
)