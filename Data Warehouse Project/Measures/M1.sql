'Transaction'[Number of Successful Payments]=[Number of Payments] - [Dishonours]


'Transaction'[Number of Payments]=CALCULATE(  COUNTA([Credit]),  TransactionType[TransactionTypeSubGroup] = "Repayment"    || TransactionType[TransactionTypeSubGroup] = "Repayment - Bpay" || TransactionType[TransactionTypeSubGroup] = "Repayment - Cash" || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit" || TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Credit" || TransactionType[TransactionTypeSubGroup] = "Repayment - Salary") - CALCULATE(  COUNTA([Debit]),  TransactionType[TransactionName] = "Payment Reversal" );


'Transaction'[Percentage of Successful Payments]=[Number of Successful Payments]/[Number of Payments];

'Transaction'[NAF]=Calculate(SUM([DebitLessCredit]),
    'TransactionType'[Transactions] = "Money3\Commission\Commission Paid - Internal"
    || 'TransactionType'[Transactions] = "Money3\Commission\Commission Paid - Direct Credit"
    || 'TransactionType'[Transactions] = "Money3\Commission\Commission Paid - Cheque"
    || 'TransactionType'[Transactions] = "Money3\Fee\Loan\Establishment Fee"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Loan Termination Insurance"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Equity Plus Insurance"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Comprehensive Insurance"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Loan Protection"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Marine Warranty"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Complete Car Care Cover"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Fire And Theft"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Total Assist"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Consumer Credit Insurance"

    || 'TransactionType'[Transactions] = "Money3\Insurance\Tyre"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Purchase Price Protection"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Cash Benefit"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Third Party Fire And Theft"
    || 'TransactionType'[Transactions] = "Money3\Insurance\GAP/Equity Insurance"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Third Party"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Extended Warranty"
    || 'TransactionType'[Transactions] = "Money3\Insurance\Walkaway Insurance"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\BPay"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\Cash Deferred"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\Cash Disbursement"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\Cheque"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\Direct Credit"
    || 'TransactionType'[Transactions] = "Money3\Disbursement\Initial Rental Amount"
    || 'TransactionType'[Transactions] = "Money3\Fee\Loan\Application Fee"
    || 'TransactionType'[Transactions] = "Money3\Fee\LOC\Application Fee"
    || 'TransactionType'[Transactions] = "Money3\Fee\Loan\Monthly Fee"
    || 'TransactionType'[Transactions] = "Money3\Fee\Loan\Credit Fee"
    || 'TransactionType'[Transactions] = "Money3\Fee\LOC\Credit Fee"
    );

	'Transaction'[Credit Amount_Less Reversals]=SUM('Transaction'[Credit])- SUM('Reversals'[Debit]);

	'Transaction'[Debit Amount_Less Reversals]=SUM('Transaction'[Debit]) - SUM('Reversals'[Credit]);

	'Transaction'[Total Amount_Less Reversals]=SUM('Reversals'[Debit])  + SUM('Reversals'[Credit]);

	'Transaction'[Cash In Via Direct Debit]=Calculate(SUM([Credit]),TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit") - Calculate(SUM(Reversals[Debit]),TransactionType[TransactionTypeSubGroup] = "Repayment - Direct Debit");


	'Transaction'[Cash In Via Cash Payment]=Calculate(SUM([Credit]),'TransactionType'[TransactionName] = "Payment Cash") - Calculate(SUM(Reversals[Debit]),TransactionType[TransactionTypeSubGroup] = "Payment Cash");


	'Transaction'[Establishment Fee]=CALCULATE(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Establishment Fee") + CALCULATE( SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Establishment Fee");

	'Transaction'[Application Fee]=CALCULATE(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Application Fee") + CALCULATE( SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Application Fee");


	'Transaction'[Additional Monthly Fee]=Calculate(Sum([DebitLessCredit]),'TransactionType'[TransactionName] = "Additional Monthly Fees") + Calculate(Sum(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Additional Monthly Fees");

	'Transaction'[Dishonour Fee]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Dishonour Fee") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Dishonour Fee");

	'Transaction'[Monthly Fee]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Monthly Fee") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Monthly Fee");


	'Transaction'[Default Fee]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Default Fee") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Default Fee");


	'Transaction'[ERD Discount]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "ERD Discount") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "ERD Discount");

	'Transaction'[Insurance Out]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionGroup] = "Insurance") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionGroup] = "Insurance");


	'Transaction'[Broker Fee]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionGroup] = "Broker Fee") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionGroup] = "Broker Fee");


	'Transaction'[Cash In Total]=Calculate(SUM('Transaction'[CreditLessDebit]),TransactionType[TransactionTypeGroup] = "Repayment") - Calculate(SUM('Reversals'[CreditLessDebit]),TransactionType[TransactionTypeGroup] = "Repayment");


	'Transaction'[Dishonours]=Calculate(COUNT([Debit]),TransactionType[TransactionTypeSubGroup] = "Dishonour") - Calculate(COUNT(Reversals[Debit]),TransactionType[TransactionTypeSubGroup] = "Dishonour");

	'Transaction'[Credit Fee]=Calculate(SUM([DebitLessCredit]),'TransactionType'[TransactionName] = "Credit Fee") + Calculate(SUM(Reversals[DebitLessCredit]),'TransactionType'[TransactionName] = "Credit Fee");