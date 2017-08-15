SELECT 
	LoanNo
	,NetReceived
	,SettlementDate
	,YEARMonth
	,REPLACE(YEARMonth,'M','')
	,'M'+CAST(Row_Number() OVER (PARTITION BY LoanNo ORDER BY YEARMonth ASC)- 1 AS VARCHAR) AS 'RowNumber' 
FROM 
	#TEST
WHERE 
	SettlementDate <= REPLACE(YEARMonth,'M','')