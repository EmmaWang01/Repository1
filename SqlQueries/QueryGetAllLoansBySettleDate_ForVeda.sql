--//All Successful Payment Date
If OBJECT_ID('tempdb..#tempLastDate') is not null
 drop table #tempLastDate

Select * into #tempLastDate
From
(
SELECT 
	iO_Product_MasterReference.RMR_SeqNumber, 
	iO_Product_Transaction.RTM_Value, 
	iO_Product_Transaction.RTM_DateC,
	iO_Product_Transaction.RTM_IDLink_XTRM As 'TransTypeID'
FROM 
	dbo.iO_Control_TransactionMaster iO_Control_TransactionMaster, 
	dbo.iO_Product_MasterReference iO_Product_MasterReference, 
	dbo.iO_Product_Transaction iO_Product_Transaction
WHERE 
	iO_Product_Transaction.RTM_IDLink_RMR = iO_Product_MasterReference.RMR_ID 
	AND iO_Product_Transaction.RTM_IDLink_XTRM = iO_Control_TransactionMaster.XTRM_ID 
	and (iO_Product_Transaction.RTM_IDLink_Reversal ='' or iO_Product_Transaction.RTM_IDLink_Reversal is null)
	And iO_Control_TransactionMaster.XTRM_IDText Like 'Payment%' 
	And iO_Control_TransactionMaster.XTRM_IDText Not Like '%reversal%'
) As tem


Declare @DateDifference int
 
 set @DateDifference= 
	case 
		when DATENAME(weekday,GETDATE())='Monday' or DATENAME(weekday,GETDATE())='Tuesday' or DATENAME(weekday,GETDATE())='Wednesday'  or DATENAME(weekday,GETDATE())='Thursday' then 6
		else 4
	end

delete #tempLastDate 
where TransTypeID in
	(
		'{b426962b-3748-4bbf-9232-92ba164dc785}',
		'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
		'{468824e4-f92e-428c-8000-de9d68619d23}',
		'{3352de12-99f6-419e-8298-56650b8dbf96}',
		'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
		'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
		'{48b20755-ab94-464f-88b7-6194ccdc9b42}',
		'{77d7215b-a0ad-495a-86f5-e791f035f335}',
		'{9bb53719-af86-4935-8382-c7a103d375cf}',
		'{da9c356c-51b7-46e7-b637-22f2c2897a44}',
		'{df705e39-0448-487e-9668-237615051925}',
		'{e56e1c9e-241f-4338-ab3a-cde7af4ca8c0}'
	) 
	and (DATEADD (day, @DateDifference,convert(date,RTM_DateC))>=GETDATE())
/*****above temp table get all successful payments, order by date get latest*****/



if object_id('tempdb..#Loans') is not null
drop table #Loans

select 
	RMR_ID
	,RCD_CurrentStart 
	,RMR_SeqNumber
	,RMR_IDLink_XSU
	--,RMR_IDLink_XRP
	,XRP.XRP_Detail
	,Term.RLM_Term_Month
into #Loans
from io_product_masterreference RMR
inner join 
(
	select 
		RCD_IDLink_RMR
		,RCD_CurrentStart
	from io_product_controldate where RCD_Type=6--106
)  RCD on RCD.RCD_IDLink_RMR=RMR.RMR_ID
LEFT JOIN dbo.iO_Product_LoanMDT Term(NOLOCK) ON Term.RLM_IDLink_RMR = RMR.RMR_ID
left join io_control_productmaster XRP with(nolock) on XRP.XRP_ID=RMR.RMR_IDLink_XRP 
where RCD.RCD_CurrentStart between '20140701' and '20161231' 
and XRP.XRP_Detail in 
	(
		'Money3\FixedFlexi'
		,'Money3\MACC'
		,'Money3\Micro Motor'
		,'Money3\MonthlyLoan'
		,'Money3\Personal Loan'
	)

if OBJECT_ID('tempdb..#Clients') is not null
drop table #Clients

select 
 CMR_ID
 ,CTI_FirstName
 ,CTI_Surname
 ,CTI_DOB
 ,CMR_SeqNumber
 ,isnull(CustomerGen.XCGn_Detail,'UnKnow') as 'Gender'
 ,Resi_Address.PropertyName as 'PropertyName'
	  ,Resi_Address.UnitNumber AS 'UnitNumber'
	  ,Resi_Address.StreetNumber AS 'StreetNumber'
	  ,Resi_Address.StreetName AS 'StreetName'
	  ,Resi_Address.StreetType AS 'StreetType'
	  ,Resi_Address.City AS 'City'
	  ,Resi_Address.CAD_State
	  ,Resi_Address.XSYSpc_POSTCODE AS 'Postcode'
	  ,[Precious Address]= case when  Pre_Address.UnitNumber !='' then Pre_Address.UnitNumber +'/'+Pre_Address.StreetNumber+' '+ Pre_Address.StreetName+' '+Pre_Address.City+' ' +Pre_Address.CAD_State +' '+ Pre_Address.XSYSpc_POSTCODE
	    else Pre_Address.UnitNumber +' '+Pre_Address.StreetNumber+' '+ Pre_Address.StreetName+' '+Pre_Address.City+' ' +Pre_Address.CAD_State +' '+ Pre_Address.XSYSpc_POSTCODE
	    end	
into #Clients
from
iO_Client_MasterReference CMR 
left join
(
	select CTI_IDLink_XCGn, XCGn_Detail, CTI_IDLink_CMR from iO_Client_TypeIndividual a
	left join iO_Control_ClientGender b on a.CTI_IDLink_XCGn=b.XCGn_ID 
)CustomerGen on CustomerGen.CTI_IDLink_CMR=CMR.CMR_ID
--Address
LEFT JOIN (
	SELECT CAD_IDLInk_CMR
		,isnull(CAD_PropertyName,'') as 'PropertyName'
		,COALESCE(LTRIM(RTRIM(CAD.CAD_UnitNumber)), LTRIM(RTRIM(CAD.CAD_SuiteNumber)), '') AS 'UnitNumber'
		,LTRIM(RTRIM(CAD.CAD_StreetNumber)) AS 'StreetNumber'
		--,LTRIM(REPLACE(LTRIM(RTRIM(ISNULL(CAD.CAD_StreetName, ''))), ' ', ''))  AS 'StreetName'
		,ISNULL(CAD.CAD_StreetName, '') AS 'StreetName'
		--,REPLACE(LTRIM(RTRIM(ISNULL(XSYSst.XSYSst_Description, ''))), ' ', '') AS 'StreetType'
		,ISNULL(XSYSst.XSYSst_Description, '')  AS 'StreetType'
		--,LTRIM(RTRIM(XSYSpc.XSYSpc_CITY)) AS 'City'
		,ISNULL(XSYSpc.XSYSpc_CITY,'') AS 'CITY'
		,CAD.CAD_State
		,XSYSpc.XSYSpc_POSTCODE
		,Row_Number() OVER (
			PARTITION BY CAD_IDLInk_CMR ORDER BY CAD_Seqnumber DESC
			) AS 'RowNumber'
	FROM [iO_Client_AddressDetail ] CAD(NOLOCK)
	--//Street
	LEFT JOIN iO_Control_SystemStreetTypes XSYSst(NOLOCK) ON CAD.CAD_IDLink_StreetType = XSYSst.XSYSst_ID
	--//Postcode
	LEFT JOIN iO_Control_SystemPostcode XSYSpc(NOLOCK) ON XSYSpc.XSYSpc_ID = CAD.CAD_City
	WHERE CAD.CAD_IDLink_XAT = '{382c4074-1b80-4a5f-abc0-221571215da6}' --residential address	
	) Resi_Address ON Resi_Address.CAD_IDLink_CMR = CMR.CMR_ID
	AND Resi_Address.RowNumber = 1

--previous address
LEFT JOIN (
	SELECT CAD_IDLInk_CMR
		,COALESCE(LTRIM(RTRIM(CAD.CAD_UnitNumber)), LTRIM(RTRIM(CAD.CAD_SuiteNumber)), '') AS 'UnitNumber'
		,LTRIM(RTRIM(CAD.CAD_StreetNumber)) AS 'StreetNumber'
		,LTRIM(REPLACE(LTRIM(RTRIM(ISNULL(CAD.CAD_StreetName, ''))), ' ', '') + ' ' + REPLACE(LTRIM(RTRIM(ISNULL(XSYSst.XSYSst_Description, ''))), ' ', '')) AS 'StreetName'
		,LTRIM(RTRIM(XSYSpc.XSYSpc_CITY)) AS 'City'
		,CAD.CAD_State
		,XSYSpc.XSYSpc_POSTCODE
		,Row_Number() OVER (
			PARTITION BY CAD_IDLInk_CMR ORDER BY CAD_Seqnumber DESC
			) AS 'RowNumber'
	FROM [iO_Client_AddressDetail ] CAD(NOLOCK)
	--//Street
	LEFT JOIN iO_Control_SystemStreetTypes XSYSst(NOLOCK) ON CAD.CAD_IDLink_StreetType = XSYSst.XSYSst_ID
	--//Postcode
	LEFT JOIN iO_Control_SystemPostcode XSYSpc(NOLOCK) ON XSYSpc.XSYSpc_ID = CAD.CAD_City
	WHERE CAD.CAD_IDLink_XAT = '{382c4074-1b80-4a5f-abc0-221571215da6}' --residential address	
	) Pre_Address ON Pre_Address.CAD_IDLink_CMR = CMR.CMR_ID
	AND Pre_Address.RowNumber = 2
--dob
left join iO_Client_TypeIndividual CTI on CTI.CTI_IDLink_CMR=CMR.CMR_ID


/*************Main Query****************/

select 
	Clients.CMR_SeqNumber as 'ClientNO'
	,Loans.RMR_SeqNumber as 'LoanNo'
	,CMRB.CMR_Name as 'Branch'
	,[Branch Group] =  case when CMRB.CMR_Name in ('Micro Motor' , 'Loan Centre' ,'Direct Secured Finance' ,'Rentals Branch','Personal Loans') then 'Broker'
							when CMRB.CMR_Name in ('Direct Unsecured Finance','Cashtrain Branch','Money3 Online') then 'CashTrain\Online'
							when CMRB.CMR_Name='Collections Branch' then 'Collections'
							Else 'Branch'
						End
	,RBCMR.cmr_name as 'RefBranch'
	--,XRP.XRP_Detail as 'LoanType'
	,Loans.XRP_Detail as 'LoanType'
	,Loans.RCD_CurrentStart as 'SettleDate'
	,Clients.CTI_Surname as 'Surname'
	,Clients.CTI_FirstName as 'FristName'
	,Clients.Gender as 'Gender'
	,Clients.CTI_DOB as 'DOB'
	,Clients.PropertyName as 'PropertyName'
	,Clients.UnitNumber AS 'UnitNumber'
	  ,Clients.StreetNumber AS 'StreetNumber'
	  ,Clients.StreetName AS 'StreetName'
	  ,Clients.StreetType AS 'StreetType'
	  ,Clients.City AS 'City'
	  ,Clients.CAD_State as 'State'
	  ,Clients.Postcode AS 'Postcode'
	  ,Clients.[Precious Address] as 'Previous Address'

	--,Loans.* 
	--,Clients.*
	
	
	,XSU_Detail as 'Status'
	,[Status Group]=CASE 
					WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Current'
							,'Arrears - Special Arrangement'
							,'Arrears - Arrears Letter'
							,'Arrears - Hardship'
							,'Arrears - Hold'
							,'Arrears - Payment Plan'
							,'Payment Plan'
							,'Arrears - Default'
							,'Arrears - Do Not Action'
							)
						THEN 'Active'
					WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Discharged - Paid in full early discount'
							,'Discharged - Paid in Full'
							,'Discharged - Negotiated payout'
							,'Discharged - Written Off'
							)
						THEN 'Discharge'
					WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Application - Application Cancelled'
							,'Application - Withdrawn/Cancelled'
							,'Application - Expired Application'
							,'Complaints Cancelled'
							,'Returning - New Loan'
							
							)
						THEN 'Cancelled'
					/*WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Part IX'
							,'Bankrupt'
							)
						THEN 'Collections'*/
					WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Application - Unsuccessful'
							,'Application - Unsuccessful - Reason to be reviewed'
							,'Declined'
							,'Declined - Current M3/CT Loan'
							,'Declined - Second SACC'
							)
						THEN 'Declined'
					/*WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Arrears - Default'
							,'Arrears - Recoveries'
							)
						THEN 'BadDebt'*/
					WHEN reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0))) IN (
							'Application - Pre Approved'
							,'Application - Application Approved'
							,'Application - Awaiting Further Documents'
							,'Application - Awaiting Emp/Rental'
							,'Application - Application Received'
							,'Application - Incomplete Application'
							,'Application'
							,'Application - Redirect'
							,'Application - Personal Details'
							,'Application - Extra Documents Needed - Proof of Bank Account Ownership'
							,'Application - Other SACC Confirmed'
							,'Underwriting - Pending Payment'
							,'Underwriting - OK for Settlement'
							,'Settlements - Waiting on Welcome Call'
							)
						THEN 'WIP'
						when xsu_detail like 'Money3\Collections%' then 'BadDebts'
					ELSE reverse(left(reverse(XSU_Detail), isnull(charindex('\', reverse(XSU_Detail)) - 1, 0)))
				END
	
	
	,RCD_Lodge.RCD_CurrentStart as 'LodgeDate'
	,WOF.SMR_DateEnter AS 'WOF Date'
	,cast(WOF.WOF_Balance as money) AS 'WOF Amount'
	,RCBLoanAmount.RCB_CurrentValue as 'Loan Amount'
	
	,LLP.RTM_DateC as 'Last_Successful_PaymentDate'--Last_successful_payment_amount
	,LLP.RTM_Value as 'Last_Successful_PaymentAmount'--Last_successful_payment_date
	,Loans.RLM_Term_Month as 'TermMonth'--TermMonths

	,CBalance.CurrentBalance as 'CurrentBalance'
	,[New Customer]=Case 
			When DWF.NewCustomer=1 Then 'New'
			Else 'Existing'
			End
from #Loans Loans
Left join iO_Link_MasterReference CMRLink with(nolock) on CMRLink.LMR_IDLink_Code_ID=Loans.RMR_ID and CMRLink.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}'
Left Join iO_Client_MasterReference CMRB with(nolock) on CMRB.CMR_ID=CMRLink.LMR_IDLink_CMR

left join iO_Control_StatusMaster XSU with(nolock) on XSU.XSU_ID=Loans.RMR_IDLink_XSU

left join iO_Link_MasterReference LmrClient with(nolock) on LmrClient.LMR_IDLink_Code_ID=Loans.RMR_ID
and LmrClient.LMR_IDLink_Association='{146afcaa-059b-469e-a000-0103e84144dc}' --//Loan/primary Client
left join #Clients Clients on Clients.CMR_ID=LmrClient.LMR_IDLink_CMR

--left join io_control_productmaster XRP with(nolock) on XRP.XRP_ID=Loans.RMR_IDLink_XRP 

left join iO_Link_MasterReference refBL with(nolock) on refBL.LMR_IDLink_code_ID=Loans.RMR_ID and refBL.lmr_idlink_association='{5b3468c2-78d3-450d-bfe3-52c15a6a1d0c}'
left join io_client_masterreference RBCMR with(nolock) on RBCMR.CMR_ID=refBL.LMR_IDLInk_CMR

left join io_product_controldate RCD_Lodge on RCD_Lodge.RCD_IDLink_RMR=Loans.rmr_id and RCD_Lodge.RCD_Type=106

--WOF
left join [ZZ_WOF_Date] as WOF on WOF.RMR_SeqNumber=Loans.RMR_SeqNumber

--loan amount
left join iO_Product_ControlBalance RCBLoanAmount with(nolock) on RCBLoanAmount.RCB_IDLink_RMR=loans.RMR_ID and RCBLoanAmount.RCB_IDLink_XRBl='{fa9b4019-3380-435c-bcdd-40b78d39471e}'

Left join
(
select 
	RTM_IDLink_RMR
	,cast(sum((isnull(rtm.RTM_ValueDB,0) - isnull(rtm.RTM_ValueCR,0))) as decimal (10,2)) as 'CurrentBalance'
from iO_Product_Transaction rtm inner join iO_Control_TransactionBalance xtrmb on rtm.RTM_IDLink_XTRM = xtrmb.XTRMb_IDLink_XTRM 
where xtrmb.XTRMb_IDLink_XRBl = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' 
group by  RTM_IDLink_RMR
) CBalance on CBalance.RTM_IDLink_RMR=Loans.RMR_ID

Left Join 
		(
			Select LoanPK, sum(NewBorrower) as NewCustomer from [Interim_Reporting].[ExtAPL].[FactLoanTrans] Group By LoanPK
		)DWF on DWF.[LoanPK]=Loans.RMR_ID


left join
(
	select 
		RMR_SeqNumber, 
		RTM_Value, 
		RTM_DateC,
		ROW_NUMBER() over(partition by RMR_SeqNumber order by RTM_DateC Desc) as 'RowNumber'
	from #tempLastDate
) LLP on LLP.RMR_SeqNumber=Loans.RMR_SeqNumber and LLP.RowNumber=1

where XSU_Detail  not like '%Application%' and XSU_Detail  not like '%Declined%'



/*where (CMRB.CMR_Name='Micro Motor' or (CMRB.CMR_Name='Collections Branch' and RBCMR.cmr_name='Micro Motor') ) and RCD_Settle.RCD_CurrentStart between '20150701' and '20150930'*/

--example of no lodge date 1980894


