

DECLARE @TEMPTABLE TABLE (
  [Loanpk]   [NVARCHAR] (50) NOT NULL PRIMARY KEY,
  [LoanNo] [int]  NULL,
  UNIQUE NONCLUSTERED ([LoanPK], [LoanNO]) 
  ) 

  insert into @TEMPTABLE
  select RMR_ID,RMR_SeqNumber
  from iO_Product_MasterReference

