USE M3_MAIN 
SELECT 
'Monthly' AS 'Type' , 
BR.Branch , 
count ( * ) AS Cnt , 
( sum ( DSS_ApplicationFees ) + sum ( DSS_TotalInterest ) + sum ( DSS_MonthlyServiceFee ) ) AS MTDFees , 
( sum ( DSS_CashOut ) + sum ( DSS_Insurance ) + sum ( DSS_Brokerage ) ) AS MTDNAF 
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
WHERE dateadd ( mm , datediff ( mm , 0 , DSS_SettlementDate ) , 0 ) = dateadd ( mm , datediff ( mm , 0 , getdate ( ) ) , 0 ) 
AND br.Branch = '[TEAMNAME]' 
GROUP BY br.Branch 

