
[Cash In Via Direct Debit]

CALCULATE( SUM[CreditLessDebit]



---------------------------------------------
--//[Number of Payments], remove "Repayment" subgroup, add "Repayment - Cheque" subgroup

CREATE MEASURE 'Transaction'[Number of Payments] =
    CALCULATE (
        COUNTA ( [Credit] ),
        TransactionType[IsReversal] = "Transaction",
         TransactionType[TransactionTypeSubGroup] = "Repayment" --remove
	TransactionType[TransactionTypeSubGroup] = "Repayment - Cheque"
            || TransactionType[TransactionTypeSubGroup] = "Repayment - Bpay"
            || TransactionType[TransactionTypeSubGroup] = "Repayment - Cash"
            || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit"
            || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Credit"
            || TransactionType[TransactionTypeSubGroup] = "Repayment - Salary"
    )
        - CALCULATE (
            COUNTA ( Reversals[Debit] ),
           	 TransactionType[TransactionTypeSubGroup] = "Repayment" --remove
		TransactionType[TransactionTypeSubGroup] = "Repayment - Cheque"
                || TransactionType[TransactionTypeSubGroup] = "Repayment - Bpay"
                || TransactionType[TransactionTypeSubGroup] = "Repayment - Cash"
                || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit"
                || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Credit"
                || TransactionType[TransactionTypeSubGroup] = "Repayment - Salary"
        ) 
;


-----------------------------------------------------
--//[Dishonours], format should be a whole number

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
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;