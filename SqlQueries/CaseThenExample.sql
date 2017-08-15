SELECT 
	[termRange]=
	CASE 
         WHEN Term<1 THEN '<1'
         WHEN Term between 1 and 12 THEN '1 -- 12'
		 WHEN Term between 13 and 24 THEN '13 - 24'
		 WHEN Term between 25 and 36 THEN '25 - 36'
		 WHEN Term between 37 and 48 THEN '37 - 48'
		 WHEN Term between 49 and 60 THEN '49 - 60'
		 WHEN Term>60 THEN '>60'
         ELSE 'blank'
      END,
	  [LoanNo],[Principal Balance],[ostd balance],ProdStat2,Prod_Status
FROM [dbo].[lc_balance30092016]
where [Cash Out] is not null
--where ProdStat2 in('Active', 'Settled','BadDebt','Collections')
UNION ALL
SELECT 
	[termRange]=
	CASE 
         WHEN Term<1 THEN '<1'
         WHEN Term between 1 and 12 THEN '1 -- 12'
		 WHEN Term between 13 and 24 THEN '13 - 24'
		 WHEN Term between 25 and 36 THEN '25 - 36'
		 WHEN Term between 37 and 48 THEN '37 - 48'
		 WHEN Term between 49 and 60 THEN '49 - 60'
		 WHEN Term>60 THEN '>60'
         ELSE 'blank'
      END,
	  [LoanNo],[Principal Balance],[ostd balance],ProdStat2,Prod_Status
FROM [dbo].micromotor_balance30092016
where [Cash Out] is not null
--where ProdStat2 in('Active', 'Settled','BadDebt','Collections')
--group by [PurchaseValue]
/*group by [valueRange]
UNION ALL
SELECT 20161002 AS SnapshotDate, [Branch],[LoanNo],[SettleDate],[Prod_Type],[Prod_Status],[ProdStat2],[Cash Out],[OStd Balance],[Total Received],[Dishonoured],[Net Received],[Opening balance],[Principal Balance],[Ageing],[Bad Debt],[Arrears2],[1-30],[31-60],[61-90],[91+],[Vendor],[Security],[Vehicle Type],[Make],[Model],[Year],[Reg State],[GlassesValue],[PurchaseValue],[LVR],Term,DishonCnt,[State],IntRate,RemainTerm,Employer,Freq,Deposit,Insurance,[Fees Charged],TotalInterest,[Application Fee] 
FROM [dbo].[micromotor_balance02102016] 
where ProdStat2 in('Active', 'Settled')*/


