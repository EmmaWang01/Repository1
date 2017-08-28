Use M3_MAIN 
set dateformat dmy 
SELECT  CMAssess.cmr_name as BrokerContact, 
COUNT(*) as [No], sum((DSS_ApplicationFees) +  (DSS_TotalInterest) + (DSS_MonthlyServiceFee)) as 'Fees',
 sum((DSS_CashOut) +  (DSS_Insurance) + (DSS_Brokerage)) as 'NAF' 
 FROM M3_MAIN.dbo.iO_DataStorage_SalesReport left JOIN iO_Product_MasterReference on DSS_LoanNumber = RMR_SeqNumber 
 left join iO_Link_MasterReference  ON RMR_ID = LMR_IDLink_Code_ID left JOIN iO_Client_MasterReference CM ON CM.CMR_ID = LMR_IDLink_Code_ID left JOIN iO_Control_LinkMaster ON XLK_ID = LMR_IDLink_Association left JOIN iO_Client_MasterReference CMAssess ON CMAssess.CMR_ID = LMR_IDLink_CMR 
 left join (SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID and  (iO_Link_MasterReference.LMR_IDLink_Association='{69783579-9e83-4e82-bb25-7b3d52b0f99d}')) as BR ON br.RMR_SeqNumber  = iO_DataStorage_SalesReport.DSS_LoanNumber where XLK_Detail = 'Loan\Broker  Contact' and br.Branch like 'Tannaster%' and DSS_SettlementDate between  convert(date, '01/'+cast((DATEPART(month, getdate())) as char(02))+'/2015') and GETDATE() and CMAssess.CMR_ID in 
 (
 '{fc0c4547-30c2-4f0a-92e7-70940009e9e3}','{938dd753-f827-498c-9341-c4bffd406f01}','{d4e437ca-b05e-4d24-bd54-ab24a8331b1d}','{41466703-e271-4634-abd0-b7dcd7d8e523}','{3f953ee4-a2e3-47a0-86e4-5cb7afe3499a}','{5dbd638a-2f91-4793-b49b-f5a6fa3b34fc}'
 )
group by CMAssess.cmr_name ORDER by fees DESC