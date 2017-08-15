USE [M3_MAIN_REP]
GO

/****** Object:  StoredProcedure [dbo].[usp_REPORT_BranchDialler]    Script Date: 06/04/2017 3:37:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* =================================================================================================================
Author		:	Jai Jin Li
Date: 19/8/2016
Description	:	Report to give the balance for each customer that have dishonoured

 



===================================================================================================================*/
CREATE PROCEDURE [dbo].[usp_REPORT_BranchDialler]
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#Customer') IS NOT NULL
	DROP TABLE #Customer

SELECT CMR.CMR_ID AS 'ClientPK'
	,LTRIM(RTRIM(CMR.CMR_SeqNumber)) AS 'ClientNo'
	,LTRIM(RTRIM(CCT.XCTi_Detail)) AS 'Title'
	,LTRIM(RTRIM(CTI_FirstName)) AS 'FirstName'
	,LTRIM(RTRIM(CTI_MiddleName)) AS 'MiddleName'
	,LTRIM(RTRIM(CTI_Surname)) AS 'LastName'
	,CASE 
		WHEN CCT.XCTi_Detail = 'Mr'
			THEN 'Male' -- NULLS are Female 
		WHEN CCT.XCTi_Detail IN (
				'Ms'
				,'Mrs'
				,'Miss'
				)
			THEN 'Female'
		ELSE 'Unknown'
		END AS 'Sex'
	,CAST(CTI_DOB AS DATE) AS 'DOB'
	,LTRIM(RTRIM(Resi_Address.UnitNumber)) AS 'UnitNumber'
	,LTRIM(RTRIM(Resi_Address.StreetNumber)) AS 'StreetNumber'
	,LTRIM(RTRIM(Resi_Address.StreetName)) AS 'StreetName'
	,LTRIM(RTRIM(Resi_Address.City)) AS 'City'
	,LTRIM(RTRIM(Resi_Address.CAD_State)) AS 'State'
	,LTRIM(RTRIM(Resi_Address.XSYSpc_POSTCODE)) AS 'Postcode'
	,LTRIM(REPLACE(LTRIM(RTRIM(ISNULL(CCD_Phone.CCD_AreaCode, ''))), ' ', '') + ' ' + REPLACE(LTRIM(RTRIM(ISNULL(CCD_Phone.CCD_Details, ''))), ' ', '')) AS 'PhoneNumber'
	,LTRIM(REPLACE(LTRIM(RTRIM(ISNULL(CCD_Mobile.CCD_AreaCode, ''))), ' ', '') + ' ' + REPLACE(LTRIM(RTRIM(ISNULL(CCD_Mobile.CCD_Details, ''))), ' ', '')) AS 'Mobile'
	,LTRIM(REPLACE(LTRIM(RTRIM(ISNULL(CCD_Work.CCD_AreaCode, ''))), ' ', '') + ' ' + REPLACE(LTRIM(RTRIM(ISNULL(CCD_Work.CCD_Details, ''))), ' ', '')) AS 'WorkNumber'
	,LTRIM(RTRIM(CCD_Email.CCD_Details)) AS 'Email'
	,LTRIM(RTRIM(CTI_CurrentlyEmployed)) AS 'CurrentlyEmployed'
	,LTRIM(RTRIM(Employment.CompanyName)) AS 'Employer'
	,Employment.DateEmployed
	,Employment.WorkContact
	,Employment.EmploymentPosition
	,CMR.CMR_IDLink_XSYSlt as 'CurrentVedaScore'
INTO #Customer
FROM IO_Client_Masterreference CMR(NOLOCK)
INNER JOIN iO_Client_TypeIndividual CTI ON CTI.CTI_IDLink_CMR = CMR.CMR_ID
--//Client Address
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
	) Resi_Address ON Resi_Address.CAD_IDLink_CMR = CMR.CMR_ID
	AND Resi_Address.RowNumber = 1
--//Phone
LEFT JOIN (
	SELECT CCD_IDLink_CMR
		,CCD_AreaCode
		,CCD_Details
		,Row_Number() OVER (
			PARTITION BY CCD_IDLink_CMR ORDER BY CCD_SeqNumber DESC
			) AS 'RowNumber'
	FROM iO_Client_ContactDetail WITH (NOLOCK)
	WHERE CCD_IDLink_XCT = '{e97a2f58-e322-421d-afe6-7c175adfbace}'
	) CCD_Phone ON CCD_Phone.ccd_idlink_cmr = cmr_id
	AND CCD_Phone.rownumber = 1
--//Mobile
LEFT JOIN (
	SELECT CCD_IDLink_CMR
		,CCD_AreaCode
		,CCD_Details
		,Row_Number() OVER (
			PARTITION BY CCD_IDLink_CMR ORDER BY CCD_SeqNumber DESC
			) AS 'RowNumber'
	FROM iO_Client_ContactDetail(NOLOCK)
	WHERE CCD_IDLink_XCT = '{29411831-e939-4357-940a-44f55b4a5c9b}' --//Mobile
	) CCD_Mobile ON CCD_Mobile.ccd_idlink_cmr = cmr_id
	AND CCD_Mobile.rownumber = 1
--//Email
LEFT JOIN (
	SELECT CCD_IDLink_CMR
		,CCD_AreaCode
		,CCD_Details
		,Row_Number() OVER (
			PARTITION BY CCD_IDLink_CMR ORDER BY CCD_SeqNumber DESC
			) AS 'RowNumber'
	FROM iO_Client_ContactDetail CCD_Email(NOLOCK)
	WHERE CCD_IDLink_XCT = '{f8d0cbcc-ad81-4ed2-a4eb-ec39ac35168c}' --//Email
	) CCD_Email ON CCD_Email.ccd_idlink_cmr = cmr_id
	AND CCD_Email.rownumber = 1
--//Work
LEFT JOIN (
	SELECT CCD_IDLink_CMR
		,CCD_AreaCode
		,CCD_Details
		,Row_Number() OVER (
			PARTITION BY CCD_IDLink_CMR ORDER BY CCD_SeqNumber DESC
			) AS 'RowNumber'
	FROM iO_Client_ContactDetail CCD_Email(NOLOCK)
	WHERE CCD_IDLink_XCT = '{fde55d9b-a337-41e9-a08f-1cc2f013ee3a}' --//Work
	) CCD_Work ON CCD_Work.CCD_IDLink_CMR = CMR_ID
	AND CCD_Work.RowNumber = 1
--//Employment
LEFT JOIN (
	SELECT CED_IDLink_CMR
		,CONVERT(VARCHAR(20), CED_StartDate, 103) AS 'DateEmployed'
		,CED_EmployerName_C AS 'CompanyName'
		,XCO_Detail AS 'EmploymentPosition'
		,REPLACE(LTRIM(RTRIM(ISNULL(CED_Verification_EmployerPhoneAreaCode, ''))), ' ', '') + ' ' + REPLACE(LTRIM(RTRIM(ISNULL(CED_Verification_EmployerPhone, ''))), ' ', '') AS 'WorkContact'
		,Row_Number() OVER (
			PARTITION BY CED_IDLink_CMR ORDER BY CED_SeqNumber DESC
			) AS 'RowNumber'
	FROM iO_Client_IndividualEmployment(NOLOCK)
	LEFT JOIN iO_Control_ClientOccupation(NOLOCK) ON CED_IDLink_Occupation_C = XCO_ID
	WHERE CED_EmployerName_C <> ''
		AND CED_PrimaryEmployment = 1
		AND CED_EmployerName_C IS NOT NULL
	) Employment ON Employment.CED_IDLink_CMR = CMR.CMR_ID
	AND Employment.RowNumber = 1
LEFT JOIN iO_Control_ClientGender(NOLOCK) CG ON CG.XCGn_ID = CTI.CTI_IDLink_XCGn
LEFT JOIN iO_Control_ClientTitle(NOLOCK) CCT ON CTI_IDLink_XCT = XCTi_ID

IF OBJECT_ID('tempdb..#Link') IS NOT NULL
	DROP TABLE #Link

SELECT LMR_IDLink_Code_ID
	,LMR_IDLink_CMR
	,LMR_IDLink_Association
	,LMR_SeqNumber
INTO #Link
FROM iO_Link_MasterReference
WHERE LMR_IDLink_Association IN (
		'{7e504c4d-821c-4623-a928-28ee65c3b8c8}' --//Loan\Branch Owning
		,'{69783579-9e83-4e82-bb25-7b3d52b0f99d}' --//Loan\Broker
		,'{5b3468c2-78d3-450d-bfe3-52c15a6a1d0c}' --//Loan\Referring Branch
		,'{d8dcb018-54c1-4ba3-8b28-66973a09dc45}' --//Loan\Assessor
		,'{146afcaa-059b-469e-a000-0103e84144dc}' --//Loan\Principal Borrower
		,'{d497b5f6-afd4-451a-81c6-fd82d8f09d0a}'	--//Loan\Collections Officer
		)

CREATE NONCLUSTERED INDEX [IX_iO_Link_MasterReference_RMR_CMR_XSC] ON [dbo].[#Link] (
	[LMR_IDLink_Code_ID] ASC
	,[LMR_IDLink_Association] ASC
	,[LMR_IDLink_CMR] ASC
	)

CREATE NONCLUSTERED INDEX [IX_iO_Link_MasterReference_Ass] ON [dbo].[#Link] ([LMR_IDLink_Association]) INCLUDE (
	[LMR_IDLink_Code_ID]
	,[LMR_IDLink_CMR]
	,[LMR_SeqNumber]
	)

IF OBJECT_ID('tempdb..#Loan') IS NOT NULL
	DROP TABLE #Loan;

SELECT PMR.RMR_ID AS 'LoanPK'
	,PMR.RMR_SeqNumber AS 'LoanID'
	,LMR.ClientPK AS 'ClientPK'
	,CPM.XRP_Detail AS 'ProductDetail'
	,CMR_Branch.BranchName AS 'LoanBranch'
	,XSU_Detail AS 'StatusDetail'
	,CMR_Assessor.AssessorName AS 'AssessorName'
	,CMR_LoanBroker.BrokerName AS 'BrokerName'
	,CMR_Refer.ReferralBranch AS 'ReferralBranch'
	,SettledDate.RCD_CurrentStart AS 'SettledDate'
	,Term.RLM_Term_Month LoanTermMonth
	,Freq.Frequency
	,CSC.XSCa_Detail AS 'PromoCode'
	,CMR_CollectionsOfficer.CollectionsOfficer as 'CollectionsOfficer'
INTO #Loan
FROM iO_Product_MasterReference PMR(NOLOCK)
INNER JOIN iO_Control_ProductMaster CPM(NOLOCK) ON CPM.XRP_ID = PMR.RMR_IDLINK_XRP
INNER JOIN iO_Control_StatusMaster CSM ON CSM.XSU_ID = RMR_IDLINK_XSU
INNER JOIN (
	SELECT LMR.LMR_IDLink_Code_ID AS 'LoanPK'
		,LMR.LMR_IDLink_CMR AS 'ClientPK'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR.LMR_IDLink_Code_ID ORDER BY LMR.LMR_Seqnumber DESC
			) AS 'RowNumber'
	FROM #Link LMR(NOLOCK)
	WHERE LMR.LMR_IDLink_Association = '{146afcaa-059b-469e-a000-0103e84144dc}' --//Loan\Principal Borrower
	) LMR ON LMR.LoanPK = PMR.RMR_ID
	AND LMR.RowNumber = 1
INNER JOIN (
	SELECT LMR_Branch.LMR_IDLink_Code_ID AS 'LoanPK'
		,CMR_Branch.CMR_Name AS 'BranchName'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR_Branch.LMR_IDLink_Code_ID ORDER BY LMR_Branch.LMR_Seqnumber DESC
			) AS 'RowNumber'
	FROM #Link LMR_Branch(NOLOCK)
	INNER JOIN iO_Client_MasterReference CMR_Branch(NOLOCK) ON CMR_Branch.CMR_ID = LMR_Branch.LMR_IDLINK_CMR
	WHERE LMR_Branch.LMR_IDLink_Association = '{7e504c4d-821c-4623-a928-28ee65c3b8c8}' --//Loan\Branch Owning
	) CMR_Branch ON CMR_Branch.LoanPK = PMR.RMR_ID
	AND CMR_Branch.RowNumber = 1
LEFT JOIN (
	SELECT LMR_Refer.LMR_IDLink_Code_ID AS 'LoanPK'
		,CMR_Refer.CMR_Name AS 'ReferralBranch'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR_Refer.LMR_IDLink_Code_ID ORDER BY LMR_Refer.LMR_Seqnumber DESC
			) AS 'RowNumber'
	FROM #Link LMR_Refer(NOLOCK)
	LEFT JOIN [dbo].[iO_Client_MasterReference] CMR_Refer(NOLOCK) ON CMR_Refer.CMR_ID = LMR_Refer.LMR_IDLINK_CMR
	WHERE LMR_Refer.LMR_IDLink_Association = '{5b3468c2-78d3-450d-bfe3-52c15a6a1d0c}' --//Loan\Referring Branch
	) CMR_Refer ON CMR_Refer.LoanPK = PMR.RMR_ID
	AND CMR_Refer.RowNumber = 1
LEFT JOIN (
	SELECT LMR_Approval.LMR_IDLink_Code_ID AS 'LoanPK'
		,CMR_Approval.CMR_Name AS 'AssessorName'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR_Approval.LMR_IDLink_Code_ID ORDER BY LMR_Approval.LMR_Seqnumber DESC
			) AS 'rownumber'
	FROM #Link LMR_Approval(NOLOCK)
	LEFT JOIN [dbo].[iO_Client_MasterReference] CMR_Approval(NOLOCK) ON CMR_Approval.CMR_ID = LMR_Approval.LMR_IDLINK_CMR
	WHERE LMR_Approval.LMR_IDLink_Association = '{d8dcb018-54c1-4ba3-8b28-66973a09dc45}' --//Loan\Assessor
	) CMR_Assessor ON CMR_Assessor.LoanPK = PMR.RMR_ID
	AND CMR_Assessor.RowNumber = 1
LEFT JOIN (
	SELECT LMR_Broker.LMR_IDLink_Code_ID AS 'LoanPK'
		,CMR_Broker.CMR_Name AS 'BrokerName'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR_Broker.LMR_IDLink_Code_ID ORDER BY LMR_Broker.LMR_Seqnumber DESC
			) AS 'rownumber'
	FROM #Link LMR_Broker(NOLOCK)
	LEFT JOIN [dbo].[iO_Client_MasterReference] CMR_Broker(NOLOCK) ON CMR_Broker.CMR_ID = LMR_Broker.LMR_IDLINK_CMR
	WHERE LMR_Broker.LMR_IDLink_Association = '{69783579-9e83-4e82-bb25-7b3d52b0f99d}' --//Loan\Broker
	) CMR_LoanBroker ON CMR_LoanBroker.LoanPK = PMR.RMR_ID
	AND CMR_LoanBroker.RowNumber = 1


--Collections Officer
LEFT JOIN (
	
	SELECT LMR_CollectionsOfficer.LMR_IDLink_Code_ID AS 'LoanPK'
		,CMR_CollectionsOfficer.CMR_Name AS 'CollectionsOfficer'
		,ROW_NUMBER() OVER (
			PARTITION BY LMR_CollectionsOfficer.LMR_IDLink_Code_ID ORDER BY LMR_CollectionsOfficer.LMR_Seqnumber DESC
			) AS 'rownumber'
	FROM #Link LMR_CollectionsOfficer(NOLOCK)
	LEFT JOIN [dbo].[iO_Client_MasterReference] CMR_CollectionsOfficer(NOLOCK) ON CMR_CollectionsOfficer.CMR_ID = LMR_CollectionsOfficer.LMR_IDLINK_CMR
	WHERE LMR_CollectionsOfficer.LMR_IDLink_Association = '{d497b5f6-afd4-451a-81c6-fd82d8f09d0a}'	--//Loan\Collections Officer
	) CMR_CollectionsOfficer ON CMR_CollectionsOfficer.LoanPK = PMR.RMR_ID
	AND CMR_CollectionsOfficer.RowNumber = 1


LEFT JOIN dbo.iO_Product_ControlDate SettledDate with(NOLOCK) ON SettledDate.RCD_IDLink_RMR = PMR.RMR_ID
	AND SettledDate.RCD_Type = 6
LEFT JOIN (
	-- This should be payment details, -- other method is outstanding unprocessed payments, flag processed = 0
	SELECT RPSM_IDLink_RMR
		,xfr_detail [Frequency]
	FROM io_product_paymentschedulemaster WITH (NOLOCK)
	INNER JOIN iO_Control_Frequency(NOLOCK) ON XFR_ID = RPSm_IDLink_Frequency
	) AS Freq ON Freq.RPSM_IDLink_RMR = PMR.RMR_ID
LEFT JOIN dbo.iO_Product_LoanMDT Term(NOLOCK) ON Term.RLM_IDLink_RMR = PMR.RMR_ID
LEFT JOIN dbo.iO_Control_SalesCampaign CSC WITH (NOLOCK) ON CSC.XSCa_ID = Term.RLM_IDLink_XSCa

IF OBJECT_ID('tempdb..#Link') IS NOT NULL
	DROP TABLE #Link

--//Total Transaction Debit & Credit
IF OBJECT_ID('tempdb..#TEMPTRAN') IS NOT NULL
	DROP TABLE #TEMPTRAN;

SELECT RTM_IDLink_RMR AS 'LoanPK'
	,RTM_IDLink_XTRM AS 'TransactionPK'
	,RTM_TypeGhost
	,RTM_ValueDB
	,RTM_ValueCR
	,RTM_Value
	,RTM_IDLINK_Reversal
	,RTM_DateE
INTO #TEMPTRAN
FROM iO_Product_Transaction WITH (NOLOCK)
WHERE RTM_IDLink_XTRM IN (
		'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}' --//Money3\Loan\Payment\Proceeds from Repossession
		,'{0f57a357-5888-4946-a857-f568ab18042e}' --//Money3\Disbursement\Reversal\Cash Now Payment - Reversal
		,'{146d1eef-8056-4171-8f02-5c4192332904}' --//Money3\Loan\Payment\Payment - Reversal DebitCard - TransactionFee
		,'{175097b2-f5b8-453f-933e-22b136b5badb}' --//Money3\Disbursement\Cash Deferred
		,'{19bfaee2-b601-4077-9d6e-75589010c1f4}' --//Money3\Loan\Payment\Broker Clawback
		,'{2b59edef-b7fa-4033-a477-033ae9da122d}' --//Money3\Discharge\Reversal\Discharge Payment - Reversal
		,'{2cfef587-908c-48e9-8e5c-4d7788ab720c}' --//Money3\Disbursement\Reversal\Cheque Payment - Reversal
		,'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}' --//Money3\Loan\Payment\Payment Cheque
		,'{369d0352-6702-44dc-86a5-aa1e63d43a28}' --//Money3\LOC\Payment\Payment (Direct Debit) Capitalise next effective dates
		,'{3b78e2bc-412d-4e78-927a-e255975efbfd}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Do not use
		,'{468824e4-f92e-428c-8000-de9d68619d23}' --//Money3\LOC\Payment\Payment (Direct Debit) Capitalise Today
		,'{4b1b5721-c264-4daf-866a-9dc4d04517b8}' --//Money3\Disbursement\Reversal\Direct Credit - Reversal
		,'{4d6fd04e-d635-429c-9f74-bf03a5a049dc}' --//Money3\Disbursement\Direct Credit - $50 for Free
		,'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}' --//Money3\Disbursement\Cheque
		,'{55f13b88-c58a-4080-b1ac-3e34f60d0f46}' --//Money3\Disbursement\Cash Disbursement - $50 for Free
		,'{5d21b3ef-7739-4427-85a6-70a1677786f1}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Effective date next day
		,'{71b22e14-385f-45a8-a389-36559632ff65}' --//Money3\Disbursement\Direct Credit
		,'{755f7320-b81c-4268-aa94-38802e51505f}' --//Money3\Disbursement\Reversal\BPay Payment - Reversal
		,'{77d7215b-a0ad-495a-86f5-e791f035f335}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today
		,'{7b99c226-70ee-477d-a247-5491f344862b}' --//Money3\Loan\Payment\Payment Refinanced
		,'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}' --//Money3\Discharge\Discharge Payment\BPay
		,'{88d368ae-d2e3-4db4-9880-3de434f3b542}' --//Money3\Discharge\Discharge Payment\Cash
		,'{8ae7a940-e7de-47ba-a98e-6227241c4698}' --//Money3\LOC\Payment\Payment Reversal
		,'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}' --//Money3\Discharge\Discharge Payment\Cheque
		,'{914d2104-748b-47fe-b580-3e9939c39d2a}' --//Money3\LOC\Payment\Payment Reversal - Cash
		,'{9251d213-46b3-4ffe-a59e-675bc7ed8258}' --//Money3\Discharge\Discharge Payment\Direct Debit
		,'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}' --//Money3\Loan\Payment\Payment Cash
		,'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}' --//Money3\Loan\Payment\Payment Direct Credit Recieved
		,'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}' --//Money3\Loan\Payment\Insurance Payout
		,'{a8136ec2-6d41-4df2-97e2-a92baa39f139}' --//Money3\Loan\Payment\Payment BPay
		,'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}' --//Money3\Disbursement\Cash Disbursement
		,'{b264fbcd-976f-4328-b758-2f0f7520f0d6}' --//Money3\Loan\Payment\Payment Reversal - DebitCard
		,'{b426962b-3748-4bbf-9232-92ba164dc785}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise next effective dates - Old
		,'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}' --//Money3\Disbursement\Reversal\Cheque Total Amount - Reversal
		,'{be317f39-30b3-4469-a80f-b7443d107391}' --//Money3\Loan\Payment\Insurance Recall
		,'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}' --//Money3\LOC\Payment\Payment (Cash)
		,'{c71def8a-f18a-46d1-8650-94b2db4731b9}' --//Money3\Disbursement\BPay
		,'{d297a55e-aa3a-4928-8b38-a6da5c72562f}' --//Money3\Disbursement\Direct Credit - $20 Easter Promo Credit
		,'{d41c76d8-b5da-4580-a368-7a9b9ad2e333}' --//Money3\Loan\Payment\Payment - DebitCard-TransactionFee
		,'{d537a6a6-6d8a-4801-8f22-b6dd26a56cbe}' --//Money3\Disbursement\Reversal\Deferred Cash Payment - Reversal
		,'{d685de8f-4009-4968-9fe6-bd63de507376}' --//Money3\LOC\Payment\Payment (Salary)
		,'{d90943f6-a537-4e04-adc0-7a880260a940}' --//Money3\Loan\Payment\Payment Salary
		,'{d96fdc0b-ea82-46c3-9982-0bc4f155935c}' --//Money3\Loan\Payment\Payment Reversal
		,'{da9c356c-51b7-46e7-b637-22f2c2897a44}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today - Old
		,'{dc2c3e2a-1594-4058-b10f-73627855f28a}' --//Money3\Discharge\Discharge Payment\Direct Credit
		,'{df705e39-0448-487e-9668-237615051925}' --//Money3\Loan\Payment\Payment (Direct Debit)
		,'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}' --//Money3\Loan\Payment\Payment DebitCard
		,'{ef859b47-2820-4459-b033-4bd4d321251a}' --//Money3\Loan\Payment\Payment Reversal - Cash
		,'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}' --//Money3\LOC\Payment\Payment (Cheque)
		,'{fb12d670-dffe-40b2-97d6-6c82669029f4}' --//Money3\Disbursement\Cash Disbursement - $20 Easter Promo Cash
		,'{11b97a98-36e5-4be5-a012-aa9bb0b43b32}' --//Money3\Conversion\Original Application Fee
		,'{1f801a03-73e7-418f-b0d5-662c155e701d}' --//Money3\Fee\Reversal\Loan\Application Fee - Reversal
		,'{75cefbba-169a-426d-ad3c-440537c19498}' --//Money3\Fee\Reversal\Application Fee Waived - Reversal
		,'{7b4ea91e-c309-43f2-b890-5c252be34ae4}' --//Money3\Fee\Loan\Application Fee
		,'{9d9bd706-59d5-4961-b8b6-377d4dd03c58}' --//Loan\Fee\Application Fee Variable
		,'{a05b64c4-e2cb-4d3c-bac0-b3c7bf87960e}' --//Money3\Fee\Reversal\LOC\Application Fee - Reversal
		,'{a351f699-5865-4892-8ec5-93582959c20a}' --//Money3\Fee\Waived\Application Fee Waived
		,'{da07274d-ce3e-4ff2-b580-0ec41864f696}' --//Loan\Reverse\Fee\Application Fee
		,'{e2d6802b-a89c-484e-8c9d-cda0c9a268f3}' --//Money3\Fee\LOC\Application Fee
		,'{fa33558d-7892-4f3f-a1ae-4dfd0fd7a703}' --//Money3\Fee\Loan\Application Fee Discount
		)

IF OBJECT_ID('tempdb..#TEMPTRANApplication') IS NOT NULL
	DROP TABLE #TEMPTRANApplication;

SELECT LoanPK
	,TransactionPK
	,Isnull(sum(Isnull(RTM_ValueDB, 0)), 0) - Isnull(sum(Isnull(RTM_ValueCR, 0)), 0) AS 'ApplicationFee'
INTO #TEMPTRANApplication
FROM #TEMPTRAN
WHERE TransactionPK IN (
		'{11b97a98-36e5-4be5-a012-aa9bb0b43b32}' --//Money3\Conversion\Original Application Fee
		,'{1f801a03-73e7-418f-b0d5-662c155e701d}' --//Money3\Fee\Reversal\Loan\Application Fee - Reversal
		,'{75cefbba-169a-426d-ad3c-440537c19498}' --//Money3\Fee\Reversal\Application Fee Waived - Reversal
		,'{7b4ea91e-c309-43f2-b890-5c252be34ae4}' --//Money3\Fee\Loan\Application Fee
		,'{9d9bd706-59d5-4961-b8b6-377d4dd03c58}' --//Loan\Fee\Application Fee Variable
		,'{a05b64c4-e2cb-4d3c-bac0-b3c7bf87960e}' --//Money3\Fee\Reversal\LOC\Application Fee - Reversal
		,'{a351f699-5865-4892-8ec5-93582959c20a}' --//Money3\Fee\Waived\Application Fee Waived
		,'{da07274d-ce3e-4ff2-b580-0ec41864f696}' --//Loan\Reverse\Fee\Application Fee
		,'{e2d6802b-a89c-484e-8c9d-cda0c9a268f3}' --//Money3\Fee\LOC\Application Fee
		,'{fa33558d-7892-4f3f-a1ae-4dfd0fd7a703}' --//Money3\Fee\Loan\Application Fee Discount
		)
GROUP BY LoanPK
	,TransactionPK

IF OBJECT_ID('tempdb..#TEMPTRANOther') IS NOT NULL
	DROP TABLE #TEMPTRANOther;

SELECT LoanPK
	,TransactionPK
	,RTM_ValueDB
	,RTM_ValueCR
INTO #TEMPTRANOther
FROM #TEMPTRAN
WHERE TransactionPK IN (
		'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}' --//Money3\Loan\Payment\Proceeds from Repossession
		,'{0f57a357-5888-4946-a857-f568ab18042e}' --//Money3\Disbursement\Reversal\Cash Now Payment - Reversal
		,'{146d1eef-8056-4171-8f02-5c4192332904}' --//Money3\Loan\Payment\Payment - Reversal DebitCard - TransactionFee
		,'{175097b2-f5b8-453f-933e-22b136b5badb}' --//Money3\Disbursement\Cash Deferred
		,'{19bfaee2-b601-4077-9d6e-75589010c1f4}' --//Money3\Loan\Payment\Broker Clawback
		,'{2b59edef-b7fa-4033-a477-033ae9da122d}' --//Money3\Discharge\Reversal\Discharge Payment - Reversal
		,'{2cfef587-908c-48e9-8e5c-4d7788ab720c}' --//Money3\Disbursement\Reversal\Cheque Payment - Reversal
		,'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}' --//Money3\Loan\Payment\Payment Cheque
		,'{369d0352-6702-44dc-86a5-aa1e63d43a28}' --//Money3\LOC\Payment\Payment (Direct Debit) Capitalise next effective dates
		,'{3b78e2bc-412d-4e78-927a-e255975efbfd}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Do not use
		,'{468824e4-f92e-428c-8000-de9d68619d23}' --//Money3\LOC\Payment\Payment (Direct Debit) Capitalise Today
		,'{4b1b5721-c264-4daf-866a-9dc4d04517b8}' --//Money3\Disbursement\Reversal\Direct Credit - Reversal
		,'{4d6fd04e-d635-429c-9f74-bf03a5a049dc}' --//Money3\Disbursement\Direct Credit - $50 for Free
		,'{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}' --//Money3\Disbursement\Cheque
		,'{55f13b88-c58a-4080-b1ac-3e34f60d0f46}' --//Money3\Disbursement\Cash Disbursement - $50 for Free
		,'{5d21b3ef-7739-4427-85a6-70a1677786f1}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Effective date next day
		,'{71b22e14-385f-45a8-a389-36559632ff65}' --//Money3\Disbursement\Direct Credit
		,'{755f7320-b81c-4268-aa94-38802e51505f}' --//Money3\Disbursement\Reversal\BPay Payment - Reversal
		,'{77d7215b-a0ad-495a-86f5-e791f035f335}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today
		,'{7b99c226-70ee-477d-a247-5491f344862b}' --//Money3\Loan\Payment\Payment Refinanced
		,'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}' --//Money3\Discharge\Discharge Payment\BPay
		,'{88d368ae-d2e3-4db4-9880-3de434f3b542}' --//Money3\Discharge\Discharge Payment\Cash
		,'{8ae7a940-e7de-47ba-a98e-6227241c4698}' --//Money3\LOC\Payment\Payment Reversal
		,'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}' --//Money3\Discharge\Discharge Payment\Cheque
		,'{914d2104-748b-47fe-b580-3e9939c39d2a}' --//Money3\LOC\Payment\Payment Reversal - Cash
		,'{9251d213-46b3-4ffe-a59e-675bc7ed8258}' --//Money3\Discharge\Discharge Payment\Direct Debit
		,'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}' --//Money3\Loan\Payment\Payment Cash
		,'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}' --//Money3\Loan\Payment\Payment Direct Credit Recieved
		,'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}' --//Money3\Loan\Payment\Insurance Payout
		,'{a8136ec2-6d41-4df2-97e2-a92baa39f139}' --//Money3\Loan\Payment\Payment BPay
		,'{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}' --//Money3\Disbursement\Cash Disbursement
		,'{b264fbcd-976f-4328-b758-2f0f7520f0d6}' --//Money3\Loan\Payment\Payment Reversal - DebitCard
		,'{b426962b-3748-4bbf-9232-92ba164dc785}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise next effective dates - Old
		,'{b7ec81a0-9aac-4261-b8f5-7f8f42920abe}' --//Money3\Disbursement\Reversal\Cheque Total Amount - Reversal
		,'{be317f39-30b3-4469-a80f-b7443d107391}' --//Money3\Loan\Payment\Insurance Recall
		,'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}' --//Money3\LOC\Payment\Payment (Cash)
		,'{c71def8a-f18a-46d1-8650-94b2db4731b9}' --//Money3\Disbursement\BPay
		,'{d297a55e-aa3a-4928-8b38-a6da5c72562f}' --//Money3\Disbursement\Direct Credit - $20 Easter Promo Credit
		,'{d41c76d8-b5da-4580-a368-7a9b9ad2e333}' --//Money3\Loan\Payment\Payment - DebitCard-TransactionFee
		,'{d537a6a6-6d8a-4801-8f22-b6dd26a56cbe}' --//Money3\Disbursement\Reversal\Deferred Cash Payment - Reversal
		,'{d685de8f-4009-4968-9fe6-bd63de507376}' --//Money3\LOC\Payment\Payment (Salary)
		,'{d90943f6-a537-4e04-adc0-7a880260a940}' --//Money3\Loan\Payment\Payment Salary
		,'{d96fdc0b-ea82-46c3-9982-0bc4f155935c}' --//Money3\Loan\Payment\Payment Reversal
		,'{da9c356c-51b7-46e7-b637-22f2c2897a44}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today - Old
		,'{dc2c3e2a-1594-4058-b10f-73627855f28a}' --//Money3\Discharge\Discharge Payment\Direct Credit
		,'{df705e39-0448-487e-9668-237615051925}' --//Money3\Loan\Payment\Payment (Direct Debit)
		,'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}' --//Money3\Loan\Payment\Payment DebitCard
		,'{ef859b47-2820-4459-b033-4bd4d321251a}' --//Money3\Loan\Payment\Payment Reversal - Cash
		,'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}' --//Money3\LOC\Payment\Payment (Cheque)
		,'{fb12d670-dffe-40b2-97d6-6c82669029f4}' --//Money3\Disbursement\Cash Disbursement - $20 Easter Promo Cash
		)

--//Last Successful Payment Date
IF OBJECT_ID('tempdb..#Loan_LastPayment') IS NOT NULL
	DROP TABLE #Loan_LastPayment;

SELECT LoanPK
	,CONVERT(VARCHAR(20), RTM_DateE, 103) AS 'LastDate'
	,Row_Number() OVER (
		PARTITION BY LoanPK ORDER BY RTM_DateE DESC
		) AS 'RowNumber'
	,RTM_Value AS [LastSuccessfulPaymentAmount]
INTO #Loan_LastPayment
FROM #TEMPTRAN
WHERE (
		RTM_IDLINK_Reversal = ''
		OR RTM_IDLINK_Reversal IS NULL
		)
	AND TransactionPK IN (
		'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}' --//Money3\Loan\Payment\Proceeds from Repossession
		,'{19bfaee2-b601-4077-9d6e-75589010c1f4}' --//Money3\Loan\Payment\Broker Clawback
		,'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}' --//Money3\Loan\Payment\Payment Cheque
		,'{3b78e2bc-412d-4e78-927a-e255975efbfd}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Do not use
		,'{5d21b3ef-7739-4427-85a6-70a1677786f1}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Effective date next day
		,'{77d7215b-a0ad-495a-86f5-e791f035f335}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today
		,'{7b99c226-70ee-477d-a247-5491f344862b}' --//Money3\Loan\Payment\Payment Refinanced
		,'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}' --//Money3\Loan\Payment\Payment Cash
		,'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}' --//Money3\Loan\Payment\Payment Direct Credit Recieved
		,'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}' --//Money3\Loan\Payment\Insurance Payout
		,'{a8136ec2-6d41-4df2-97e2-a92baa39f139}' --//Money3\Loan\Payment\Payment BPay
		,'{b426962b-3748-4bbf-9232-92ba164dc785}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise next effective dates - Old
		,'{be317f39-30b3-4469-a80f-b7443d107391}' --//Money3\Loan\Payment\Insurance Recall
		,'{d90943f6-a537-4e04-adc0-7a880260a940}' --//Money3\Loan\Payment\Payment Salary
		,'{da9c356c-51b7-46e7-b637-22f2c2897a44}' --//Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today - Old
		,'{e1365ab7-7216-4d36-9127-8a46e6d7cb02}' --//Money3\Loan\Payment\Payment DebitCard
		)
	AND rtm_typeghost = 0

--//Arrears
IF OBJECT_ID('tempdb..#TempRCB_MissedPayment') IS NOT NULL
	DROP TABLE #TempRCB_MissedPayment

SELECT RCB_IDLINK_RMR AS 'LoanPK'
	,RCB_MissedPayment.RCB_CurrentValue
INTO #TempRCB_MissedPayment
FROM iO_Product_ControlBalance RCB_MissedPayment WITH (NOLOCK)
LEFT JOIN iO_Control_ProductBalance XRBL_MissedPayment WITH (NOLOCK) ON XRBL_MissedPayment.XRBl_ID = RCB_MissedPayment.RCB_IDLink_XRBl
WHERE XRBL_MissedPayment.XRBl_Detail LIKE '%Arrears\Missed Payments\Total' --//Missed Payment Amount

--//Cash Out
IF OBJECT_ID('tempdb..#TempCashOut') IS NOT NULL
	DROP TABLE #TempCashOut;

SELECT RCB_IDLink_RMR AS 'LoanPK'
	,isnull((rcb_currentValue), 0) AS 'CashOutAmt'
INTO #TempCashOut
FROM iO_Product_ControlBalance WITH (NOLOCK)
WHERE rcb_idlink_xrbl = '{fa9b4019-3380-435c-bcdd-40b78d39471e}' --//Loan\Standard\New Application Amount

--//Total Dishonour
IF OBJECT_ID('tempdb..#TEMPDISHONOUR') IS NOT NULL
	DROP TABLE #TEMPDISHONOUR;

SELECT RTM.RTM_IDLink_RMR AS 'LoanPK'
	,Isnull(sum(Isnull(RTM_ValueDB, 0)), 0) - Isnull(sum(Isnull(RTM_ValueCR, 0)), 0) AS 'Dishonour'
	,COUNT(RTM.RTM_IDLink_RMR) AS 'DishonourCount'
INTO #TEMPDISHONOUR
FROM iO_Product_Transaction RTM WITH (NOLOCK)
INNER JOIN iO_Control_TransactionMaster CTM WITH (NOLOCK) ON RTM.RTM_IDLink_XTRM = CTM.XTRM_ID
INNER JOIN iO_Control_TransactionGL CTGl WITH (NOLOCK) ON CTGl.XTRMgl_IDLink_XTRM = RTM.RTM_IDLink_XTRM
WHERE (
		CTM.XTRM_Detail LIKE 'Money3\Loan\Payment\Repayment Dishonour%'
		OR CTM.XTRM_Detail LIKE 'Money3\LOC\Payment\Repayment Dishonour%'
		)
	AND RTM.RTM_TypeGhost = 0
GROUP BY RTM.RTM_IDLink_RMR

--//Total Received
IF OBJECT_ID('tempdb..#TEMPRECEIVED') IS NOT NULL
	DROP TABLE #TEMPRECEIVED;

SELECT TR.LoanPK
	,((Isnull(sum(Isnull(rtm_valuedb, 0)), 0) - Isnull(sum(Isnull(rtm_valuecr, 0)), 0)) - max(cashout.cashoutamt)) * - 1 AS Received
INTO #TEMPRECEIVED
FROM #TEMPTRANOther TR
LEFT JOIN #TempCashOut CashOut ON CashOut.LoanPK = TR.LoanPK
GROUP BY TR.LoanPK

--//Net Received
IF OBJECT_ID('tempdb..#TempNet_Received') IS NOT NULL
	DROP TABLE #TempNet_Received

SELECT PMR.RMR_ID AS 'LoanPK'
	,cast(isnull(Received.received, 0) AS MONEY) - cast(ISNULL(Dishonour.Dishonour, 0) AS MONEY) AS 'NET_RECIEVED'
INTO #TempNet_Received
FROM IO_Product_Masterreference PMR
LEFT JOIN #TEMPRECEIVED received WITH (NOLOCK) ON PMR.RMR_ID = received.LoanPK
LEFT JOIN #TEMPDISHONOUR Dishonour ON Dishonour.LoanPK = PMR.RMR_ID

--//Notes
IF OBJECT_ID('tempdb..#TEMPNOTEDATE') IS NOT NULL
	DROP TABLE #TEMPNOTEDATE;

SELECT NMR_IDLink_Code AS 'LoanPK'
	,Max(NMR.NMR_Date) AS NoteDate
INTO #TEMPNOTEDATE
FROM dbo.iO_Note_MasterReference NMR
WHERE NMR.NMR_Detail <> 'System Audit%'
	AND NMR.NMR_Detail <> 'Note on repayment schedule'
	AND NMR.NMR_Detail <> 'Cash On Hand%'
	AND NMR.NMR_Detail <> 'Documents for%'
	AND NMR.NMR_Detail <> 'Conversion'
GROUP BY NMR_IDLink_Code

--//Next Payment Date
IF OBJECT_ID('tempdb..#TEMPNEXTPAYMENT') IS NOT NULL
	DROP TABLE #TEMPNEXTPAYMENT

SELECT RPSD_IDLink_RMR AS 'LoanPK'
	,rpsd_paymentduedate
	,row_number() OVER (
		PARTITION BY rpsd_idlink_rmr ORDER BY rpsd_paymentduedate
		) AS 'rownumber'
INTO #TEMPNEXTPAYMENT
FROM iO_Product_PaymentScheduleDetail
WHERE rpsd_PaymentProcessed = 0
ORDER BY rpsd_paymentduedate ASC

--Current Status Date
IF OBJECT_ID('tempdb..#TEMPCurrentStatusDate') IS NOT NULL
	DROP TABLE #TEMPCurrentStatusDate

SELECT SMR_IDLink_Code AS 'LoanPK'
	,convert(VARCHAR, cast(SMR_DateEnter AS DATE), 103) AS 'CurrentStatusDate'
INTO #TEMPCurrentStatusDate
FROM iO_Status_MasterReference WITH (NOLOCK)
WHERE SMR_DateLeave IS NULL

--//Last Transaction Note
IF OBJECT_ID('tempdb..#TransactionNote') IS NOT NULL
	DROP TABLE #TransactionNote;

SELECT LoanPK
	,LastTransactionNote
	,ROW_NUMBER() OVER (
		PARTITION BY LoanPK ORDER BY RTM_SeqNumber DESC
		) AS 'RowNumber'
INTO #TransactionNote
FROM (
	SELECT RTM_IDLink_RMR AS 'LoanPK'
		,RTM_Note AS 'LastTransactionNote'
		,RTM_SeqNumber
	FROM iO_Product_Transaction WITH (NOLOCK)
	LEFT JOIN iO_Product_MasterReference WITH (NOLOCK) ON RMR_ID = RTM_IDLink_RMR
	WHERE RTM_TypeGhost = 0
		AND LEN(CAST(RTM_Note AS VARCHAR(50))) > 1
	) Tbl

----//MAIN QUERY

TRUNCATE TABLE [M3_Main_Rep].[dbo].[ZZ_Branch_Dialer]

INSERT INTO [M3_Main_Rep].[dbo].[ZZ_Branch_Dialer] (
	[ClientNo]
	,[LoanID]
	,[First Name]
	,[Surname]
	,[Date of Birth]
	,[LoanType]
	,[ResidentialAddress]
	,[Email]
	,[Mobile]
	,[Home_phone]
	,[Work_phone]
	,[Current_Status]
	,[LastDateOfStatus]
	,[LoanAmount]
	,[ApplicationFee]
	,[BrokerageFee]
	,[Balance]
	,[Total Arrears Balance]
	,[Branch_Name]
	,[Assessor_Name]
	,[Broker_Name]
	,[Last_Payment_Date]
	,[Actual Arrears Balance]
	,[Payment Frequency]
	,[Loan_Age]
	,[TermMonths]
	,[NET_RECIEVED]
	,[Last_Note_Date]
	,[SettleDate]
	,[Next Payment Date]
	,[Last_Successful_payment_amount]
	,[DishonourCount]
	,[PromoCode]
	,[DeferredRevenue]
	,[LastTransactionNote]
	,[Collections_Officer] --need to be same as table
	,[Veda Score]
	,[Last_Successful_Payment_Date2]
	)
SELECT DC.ClientNo AS 'ClientNo'
	,DL.LoanID AS 'LoanID'
	,DC.FirstName AS 'First Name'
	,DC.LastName AS 'Surname'
	,CONVERT(VARCHAR(20), DC.DOB, 103) AS 'Date of Birth'
	,DL.ProductDetail AS 'LoanType'
	,LTRIM(RTRIM(CAST(ISNULL(DC.UnitNumber, '') AS VARCHAR) + ' ' + CAST(ISNULL(DC.StreetNumber, '') AS VARCHAR) + ' ' + CAST(ISNULL(DC.StreetName, '') AS VARCHAR) + ' ' + CAST(ISNULL(DC.City, '') AS VARCHAR) + ' ' + CAST(ISNULL(DC.[State], '') AS VARCHAR) + ' ' + CAST(ISNULL(DC.Postcode, '') AS VARCHAR))) AS 'Address'
	,DC.Email AS 'Email'
	,DC.Mobile AS 'Mobile'
	,DC.PhoneNumber AS 'Home_phone'
	,DC.WorkNumber AS 'Work_phone'
	,DL.StatusDetail AS 'Current_Status'
	,TCSD.CurrentStatusDate AS 'LastDateOfStatus'
	,PCB_Loan.RCB_CurrentValue AS 'LoanAmount'
	,TTA.ApplicationFee
	,PTM_Brokerage.RTM_Value AS 'BrokerageFee'
	,PCB_Principal.RCB_CurrentValue AS 'Balance'
	,TMP.RCB_CurrentValue AS 'Total Arrears Balance'
	,DL.LoanBranch AS 'Branch_Name'
	,DL.AssessorName AS 'Assessor_Name'
	,DL.BrokerName AS 'Broker_Name'
	
	,LLP.LastDate AS 'Last_Payment_Date'
	--,[Last_Payment_Date]=dbo.GetLastDateOfSuccessfulPayment(DL.LoanID)
	,CASE 
		WHEN PCB_Principal.RCB_CurrentValue < TMP.RCB_CurrentValue
			THEN PCB_Principal.RCB_CurrentValue
		ELSE TMP.RCB_CurrentValue
		END AS 'Actual Arrears Balance'
	,DL.Frequency AS 'Payment Frequency'
	,TDA.Ageing AS 'Loan_Age'
	,DL.LoanTermMonth
	,TNR.NET_RECIEVED AS 'NET_RECIEVED'
	,CONVERT(VARCHAR(20), TND.NoteDate, 103) AS 'Last_Note_Date'
	,CONVERT(VARCHAR(20), DL.SettledDate, 103) AS 'SettleDate'
	,CONVERT(VARCHAR(20), TNP.rpsd_paymentduedate, 103) AS 'Next Payment Date'
	,LLP.LastSuccessfulPaymentAmount AS 'Last_Successful_payment_amount'
	,TDH.DishonourCount
	,DL.PromoCode
	,ZDR.DeferredRevenue
	,TN.LastTransactionNote
	,DL.CollectionsOfficer AS 'Collections_Officer'
	,DC.CurrentVedaScore AS 'Veda Score'
	,LSP.LastDate AS 'Last_Successful_Payment_Date2'
FROM #Loan DL WITH (NOLOCK)
--//Loan Detail
INNER JOIN #Customer DC ON DC.ClientPK = DL.ClientPK
INNER JOIN iO_Product_ControlBalance PCB_Principal WITH (NOLOCK) ON PCB_Principal.RCB_IDLink_RMR = DL.LoanPK
	AND PCB_Principal.RCB_IDLink_XRBl = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' --//Loan\Standard\Principal
LEFT JOIN iO_Product_ControlBalance PCB_Loan ON PCB_Loan.RCB_IDLink_RMR = DL.LoanPK
	AND PCB_Loan.RCB_IDLink_XRBl = '{fa9b4019-3380-435c-bcdd-40b78d39471e}' --//Loan\Standard\New Application Amount
LEFT JOIN #TEMPCurrentStatusDate TCSD ON TCSD.LoanPK = DL.LoanPK
--//Loan Age
LEFT JOIN TempDaysAgeing TDA WITH (NOLOCK) ON TDA.RMR_ID = DL.LoanPK
--//Net Recieved
LEFT JOIN #TempNet_Received TNR ON TNR.LoanPK = DL.LoanPK
--//Note Date
LEFT JOIN #TEMPNOTEDATE TND WITH (NOLOCK) ON TND.LoanPK = DL.LoanPK
LEFT JOIN #TEMPTRANApplication TTA WITH (NOLOCK) ON TTA.LoanPK = DL.LoanPK
--//Payment
LEFT JOIN #Loan_LastPayment LLP WITH (NOLOCK) ON DL.LoanPK = LLP.LoanPK
	AND LLP.rownumber = 1
LEFT JOIN #TEMPNEXTPAYMENT TNP ON TNP.LoanPK = DL.LoanPK
	AND TNP.rownumber = 1
--//Arrears
LEFT JOIN #TempRCB_MissedPayment TMP ON DL.LoanPK = TMP.LoanPK
LEFT JOIN #TEMPDISHONOUR TDH ON TDH.LoanPK = DL.LoanPK
LEFT JOIN M3_MAIN_REP.dbo.ZZ_Deferred_Revenue ZDR ON ZDR.LoanPK = DL.LoanPK
LEFT JOIN #TransactionNote TN ON TN.LoanPk = DL.LoanPK
	AND TN.RowNumber = 1
LEFT JOIN iO_Product_Transaction PTM_Brokerage ON PTM_Brokerage.RTM_IDLink_RMR = DL.LoanPK
	AND RTM_IDLink_XTRM = '{520934ac-5bd5-4e45-a58e-3105edb2ced9}' --//Money3\Commission\Commission Paid - Direct Credit
--//Last SuccessfulPayment Date
Left Join ZZ_Loan_LastPayment LSP on LSP.LoanNo=DL.LoanID

IF OBJECT_ID('tempdb..#Customer') IS NOT NULL
	DROP TABLE #Customer

IF OBJECT_ID('tempdb..#Link') IS NOT NULL
	DROP TABLE #Link

IF OBJECT_ID('tempdb..#Loan') IS NOT NULL
	DROP TABLE #Loan;

IF OBJECT_ID('tempdb..#TEMPTRAN') IS NOT NULL
	DROP TABLE #TEMPTRAN;

IF OBJECT_ID('tempdb..#TEMPTRANApplication') IS NOT NULL
	DROP TABLE #TEMPTRANApplication;

IF OBJECT_ID('tempdb..#TEMPTRANOther') IS NOT NULL
	DROP TABLE #TEMPTRANOther;

IF OBJECT_ID('tempdb..#Loan_LastPayment') IS NOT NULL
	DROP TABLE #Loan_LastPayment;

IF OBJECT_ID('tempdb..#TempRCB_MissedPayment') IS NOT NULL
	DROP TABLE #TempRCB_MissedPayment

IF OBJECT_ID('tempdb..#TempCashOut') IS NOT NULL
	DROP TABLE #TempCashOut;

IF OBJECT_ID('tempdb..#TEMPDISHONOUR') IS NOT NULL
	DROP TABLE #TEMPDISHONOUR;

IF OBJECT_ID('tempdb..#TEMPRECEIVED') IS NOT NULL
	DROP TABLE #TEMPRECEIVED;

IF OBJECT_ID('tempdb..#TempNet_Received') IS NOT NULL
	DROP TABLE #TempNet_Received

IF OBJECT_ID('tempdb..#TEMPNOTEDATE') IS NOT NULL
	DROP TABLE #TEMPNOTEDATE;

IF OBJECT_ID('tempdb..#TEMPNEXTPAYMENT') IS NOT NULL
	DROP TABLE #TEMPNEXTPAYMENT

IF OBJECT_ID('tempdb..#TEMPCurrentStatusDate') IS NOT NULL
	DROP TABLE #TEMPCurrentStatusDate

IF OBJECT_ID('tempdb..#TransactionNote') IS NOT NULL
	DROP TABLE #TransactionNote;

GO


