[Number of Successful Payments] -- no change
[Number of Payments] -- no change
[NAF] -- no change


-- Cash In Via Direct Debit
CREATE MEASURE 'Transaction'[Cash In Via Direct Debit]=CALCULATE (
        SUM ( [CreditLessDebit] ),
        TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit",
        TransactionType[IsReversal] = "Transaction",
        'Transaction'[Ghost] = 0
    )
        + CALCULATE (
            SUM ( Reversals[CreditLessDebit] ),
            'Reversals'[Ghost] = 0,
            TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit"
        )+ CALCULATE (
        SUM ( [CreditLessDebit] ),
        TransactionType[TransactionTypeSubGroup] = "Dishonour - Loan",
        TransactionType[IsReversal] = "Transaction",
        'Transaction'[Ghost] = 0
    ) + CALCULATE (
            SUM ( Reversals[CreditLessDebit] ),
            'Reversals'[Ghost] = 0,
            TransactionType[TransactionTypeSubGroup] = "Dishonour - Loan"
        )
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Cash in Via Cash Payment
CREATE MEASURE 'Transaction'[Cash In Via Cash Payment]=CALCULATE (
        SUM ( [CreditLessDebit] ),
        'TransactionType'[TransactionName] = "Payment - Cash",
        TransactionType[IsReversal] = "Transaction",
        'Transaction'[Ghost] = 0
    )
        + CALCULATE (
            SUM ( Reversals[CreditLessDebit] ),
            TransactionType[TransactionTypeSubGroup] = "Payment - Cash",
            'Reversals'[Ghost] = 0
        )
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;


-- Establishment Fee
CREATE MEASURE 'Transaction'[Establishment Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Establishment Fee",
        'Transaction'[Ghost] = 0
    )
      
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;


-- Application Fee
CREATE MEASURE 'Transaction'[Application Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Application Fee",
        'Transaction'[Ghost] = 0,
    )       
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Additional Monthly Fee
CREATE MEASURE 'Transaction'[Additional Monthly Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Additional Monthly Fee",
        'Transaction'[Ghost] = 0,
    )
      
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Dishonour Fee
CREATE MEASURE 'Transaction'[Dishonour Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Dishonour Fee",
        'Transaction'[Ghost] = 0,
    )
        
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Monthly Fee
CREATE MEASURE 'Transaction'[Monthly Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Monthly Fee",
        'Transaction'[Ghost] = 0,
    )

CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Default Fee
CREATE MEASURE 'Transaction'[Default Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "Default Fee",
        'Transaction'[Ghost] = 0, 
    )
       
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;


-- ERD Discount
CREATE MEASURE 'Transaction'[ERD Discount]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionTypeSubGroup] = "ERD Discount",
        'Transaction'[Ghost] = 0,
    )
        
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Insurance Out
CREATE MEASURE 'Transaction'[Insurance Out]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionGroup] = "Insurance",
        'Transaction'[Ghost] = 0,  
    )
     
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

--Commission Paid
CREATE MEASURE 'Transaction'[Commission Paid]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionGroup] = "Commission",
        'Transaction'[Ghost] = 0,
    )
      
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;


-- cash in total
CREATE MEASURE 'Transaction'[Cash In Total]=CALCULATE (
        SUM ( 'Transaction'[CreditLessDebit] ),
        TransactionType[TransactionGroup] = "Cash in",
        'Transaction'[Ghost] = 0,
    )
        
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;

-- Dishonour Count
CREATE MEASURE 'Transaction'[Dishonours]=CALCULATE (
        COUNTROWS ( 'Transaction' ),
        TransactionType[TransactionTypeSubGroup] = "Dishonour - Loan",
        'Transaction'[Ghost] = 0,
        TransactionType[IsReversal] = "Transaction"
    )
        - CALCULATE (
            COUNTROWS ( 'Reversals' ),
            'Reversals'[Ghost] = 0,
            TransactionType[TransactionTypeSubGroup] = "Dishonour - Loan"
        )
;

-- Credit Fee
CREATE MEASURE 'Transaction'[Credit Fee]=CALCULATE (
        SUM ( [DebitLessCredit] ),
        'TransactionType'[TransactionName] = "Credit Fee",
        'Transaction'[Ghost] = 0,
       
    )
       
CALCULATION PROPERTY CURRENCY
    ACCURACY = 2
    THOUSANDSEPARATOR = True
    FORMAT = '\$#,0.00;-\$#,0.00;\$#,0.00'
    ADDITIONALINFO = 'LCID="3081" DisplayName="$ English (Australia)" Symbol="$" PositivePattern="0" NegativePattern="1"'
;
