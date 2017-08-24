

----------------- formulas ----------
CREATE MEASURE 'LoanSnapshot'[Applications Count]=CALCULATE (
        [Count of Loans],
        USERELATIONSHIP ( Calendar[Calendar_sKey], LoanSnapshot[Lodgement_Date_sKey] )
    )
;

CREATE MEASURE 'LoanSnapshot'[Count of Loans]=COUNTROWS ( LoanSnapshot )
;

CREATE MEASURE 'LoanSnapshot'[Settled Loans Count]=CALCULATE (
        [Count of Loans],
        USERELATIONSHIP ( Calendar[Calendar_sKey], LoanSnapshot[Settlement_Date_sKey] )
    )
;


------------------ test duplicates-------------

use TEST_Money3_DW_Warehouse
-- applications count (all, including loans)

select RMR_SeqNumber from m3_main.dbo.iO_Product_MasterReference rmr
left join m3_main.dbo.iO_Link_MasterReference lmr on rmr.rmr_id=lmr.LMR_IDLink_Code_ID and lmr.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}' --or {7e504c4d-821c-4623-a928-28ee65c3b8c8}
left join m3_main.dbo.iO_Client_MasterReference cmr on cmr.CMR_ID=lmr.LMR_IDLink_CMR
where cmr.CMR_Name='Albury Branch'
and RMR_SeqNumber not in
(
select LoanID from fact.fact_Loan_Snapshot a 
left join dim.dim_Loan b on a.Loan_sKey=b.Loan_sKey
where Current_Branch_sKey=(select Branch_sKey from dim.dim_Branch where Branch='Albury')
)


select distinct LoanID from fact.fact_Loan_Snapshot a 
left join dim.dim_Loan b on a.Loan_sKey=b.Loan_sKey
where Current_Branch_sKey=(select Branch_sKey from dim.dim_Branch where Branch='Albury')
and LoanID not in
(
select RMR_SeqNumber from m3_main.dbo.iO_Product_MasterReference rmr
left join m3_main.dbo.iO_Link_MasterReference lmr on rmr.rmr_id=lmr.LMR_IDLink_Code_ID and lmr.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}' --or {7e504c4d-821c-4623-a928-28ee65c3b8c8}
left join m3_main.dbo.iO_Client_MasterReference cmr on cmr.CMR_ID=lmr.LMR_IDLink_CMR
where cmr.CMR_Name='Albury Branch'
)

with c as 
(
select 
	a.Loan_sKey
	,a.LoanPK
	,b.LoanID
	,ROW_NUMBER() over(partition by b.loanID,b.Loan_sKey order by b.loanID) as 'rowNumber' 
from fact.fact_Loan_Snapshot a 
left join dim.dim_Loan b on a.Loan_sKey=b.Loan_sKey
where Current_Branch_sKey=(select Branch_sKey from dim.dim_Branch where Branch='Albury')
)
select distinct Loan_sKey,LoanPK,LoanID from c where rowNumber>2



select * from fact.fact_Loan_Snapshot
where Loan_sKey in
(
1862361,
1923090,
1951426,
1974597,
1997246,
2050700,
2083403,
2091720,
2162973,
2198838,
2247697,
2253791,
2259266,
2270499,
2280303,
2327050,
2357515,
2413323,
2466236,
2482210,
2569178,
2592578,
2646252,
2710346,
2762265,
2767113,
2817383,
2824452,
2871317,
2883246,
2906721,
2943327,
3004079,
3005032,
3043520,
3084185,
3114494,
3121275,
3181495,
3244132,
3246583,
3335947,
3341873,
3361683,
3423707,
3451242,
3493131,
3524844,
3544764,
3555352,
3558509,
3613633
)


select * from dim.dim_Loan
where Loan_sKey in
(

1862361,
1923090,
1951426,
1974597,
1997246,
2050700,
2083403,
2091720,
2162973,
2198838,
2247697,
2253791,
2259266,
2270499,
2280303,
2327050,
2357515,
2413323,
2466236,
2482210,
2569178,
2592578,
2646252,
2710346,
2762265,
2767113,
2817383,
2824452,
2871317,
2883246,
2906721,
2943327,
3004079,
3005032,
3043520,
3084185,
3114494,
3121275,
3181495,
3244132,
3246583,
3335947,
3341873,
3361683,
3423707,
3451242,
3493131,
3524844,
3544764,
3555352,
3558509,
3613633

)



-----------------test loan count, application count----------------