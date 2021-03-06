USE M3_MAIN SET dateformat dmy 
SELECT 
'Weekly' AS 'Type' , 
BR.Branch , 
count ( * ) AS Cnt , 
( sum ( DSS_ApplicationFees ) + sum ( DSS_TotalInterest ) + sum ( DSS_MonthlyServiceFee ) ) AS Fees , 
( sum ( DSS_CashOut ) + sum ( DSS_Insurance ) + sum ( DSS_Brokerage ) ) AS NAF 
FROM M3_MAIN.dbo.iO_DataStorage_SalesReport 
LEFT JOIN 
( 
    SELECT 
    iO_Product_MasterReference.RMR_SeqNumber , 
    iO_Client_MasterReference.CMR_Name AS Branch 
    FROM 
    M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference , 
    M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference , 
    M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference 
    WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID 
    AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID 
    AND 
    ( iO_Link_MasterReference.LMR_IDLink_Association = '{b55145aa-2697-43b5-9c6a-c4a0960823d8}' ) 
) 
AS BR ON br.RMR_SeqNumber = DSS_LoanNumber 
WHERE 
--iO_DataStorage_SalesReport.DSS_SettlementDate BETWEEN dateadd ( wk , datediff ( wk , 0 , '1/1/' + cast ( datepart ( YY , getdate ( ) ) AS char ( 4 ) ) ) + ( datepart ( WK , getdate ( ) ) - 1 ) , 0 ) 
--AND dateadd ( wk , datediff ( wk , 5 , '1/1/' + cast ( datepart ( YY , getdate ( ) ) AS char ( 4 ) ) ) + ( datepart ( WK , getdate ( ) ) - 1 ) , 5 ) 
--AND 
br.Branch = '[TEAMNAME]' 
GROUP BY br.Branch 

