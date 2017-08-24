

select distinct  
	io_product_masterreference.rmr_id,
    rmr_seqnumber as LoanID,
    CMR.cmr_seqnumber as ClientID,
    xrp_detail as product,
    io_control_statusmaster.xsu_detail as status1,
    CMR.cmr_name as PrincipalBorrower,
	CCDMobile.CCD_Details as Mobile,
	CCDEmail.CCD_Details as Email,
    isnull(DSS_CashOut, 0) + isnull(DSS_Insurance, 0) + isnull(DSS_Brokerage, 0) as AmountOfCredit,
    br.CMR_Name as broker_contact,
    assessor.cmr_name as assessor_name,
    (
		select CMR_Name from iO_Client_MasterReference where CMR_ID = 
			(
				select lmr_idlink_cmr from iO_Link_MasterReference where LMR_SeqNumber =  max( approval_officer.LMR_SeqNumber)
			)
	)as approval_officer, 
    --approval_officer.CMR_Name as approval_officer,
    lodge_date.RCD_CurrentStart as lodgement_date,
    sett_date.RCD_CurrentStart as settlement_date,
    rcte_months as period,
    isnull(ad.total1,0.00) -isnull(bd.total1,0.00)- isnull(cd.total1,0.00) as Received_Payment,
    curr_value.sched_prin as schedule_principal,
    prin_balance.tyu as principal_balance,
    arrears.rcb_currentvalue as arrears,
                                 
    CASE   brc.CMR_IDLink_XCY
            WHEN   '{6a5b22e6-4df8-48b3-89d6-95a1af54c927}' 
            THEN   brc.CTC_CompanyName
            WHEN   '{05b3d1e5-dbf5-428e-a462-39c98b55d693}'
            THEN   brc.CTC_CompanyName
            when   '{ed88abf2-fb8f-491a-a5a9-2ca7a811dbcd}'
            THEN   brc.CTS_Name_1
            ELSE   CASE   ISNULL(CTI_IDLink_XCT,'')
                        WHEN   '' 
                        THEN   brc.CTI_FirstName + ' ' + brc.CTI_Surname 
                        ELSE   (Select       XCTi_Detail
                                        From   io_Control_ClientTitle
                                        Where  brc.CTI_IDLink_XCT = XCTi_ID)
                                        + ' ' + brc.CTI_FirstName + ' ' + brc.CTI_Surname
                        END
            END as broker_ 

from io_product_masterreference
left join io_datastorage_salesreport on rmr_id = dss_idlink_rmr
inner join io_link_masterreference borr on rmr_id = borr.lmr_idlink_code_id 
            and borr.lmr_idlink_association = '{146afcaa-059b-469e-a000-0103e84144dc}'
left join io_client_masterreference CMR on CMR.cmr_id = borr.lmr_idlink_cmr
/**mobile**/
left join
	(
		select 
			CCD_IDLink_CMR
			,CCD_Details
			,Row_number() over (Partition by CCD_IDLink_CMR Order by ccd_seqNumber desc) as 'rownumber'
		from iO_Client_ContactDetail
		where CCD_IDLink_XCT='{29411831-e939-4357-940a-44f55b4a5c9b}'
	)CCDMobile on CCDMobile.CCD_IDLink_CMR=CMR.CMR_ID and CCDMobile.rownumber=1
/**email**/
left join
	(
		select 
			CCD_IDLink_CMR
			,CCD_Details
			,ROW_NUMBER() over (Partition by CCD_IDLink_CMR order by CCD_SEQNumber Desc) as 'rownumber'
		from iO_Client_ContactDetail
		where CCD_IDLink_XCT='{f8d0cbcc-ad81-4ed2-a4eb-ec39ac35168c}'
	)CCDEmail on CCDEmail.CCD_IDLink_CMR=CMR.CMR_ID and CCDEmail.rownumber=1

left join io_link_masterreference Branch on Branch.LMR_IDLink_Code_ID = RMR_ID 
			and Branch.LMR_IDLink_Association in ( '{b55145aa-2697-43b5-9c6a-c4a0960823d8}')
left join io_client_masterreference c1 on c1.cmr_id = branch.lmr_idlink_cmr
left join 
    --sub query to fetch broker name
    (Select cmr_id,cmr_name,RMR_ID From iO_Link_MasterReference LEFT JOIN iO_Client_MasterReference ON CMR_ID = LMR_IDLink_CMR left join io_product_masterreference on rmr_id = LMR_IDLink_Code_ID
    Where lmr_idlink_association = '{14b7c3da-56b4-4c5e-8889-0af2df0a61d3}') as br on iO_Product_MasterReference.rmr_id = br.rmr_id
left join 
    --subquery to fetch assessor name
    (Select cmr_id,cmr_name,rmr_id From iO_Link_MasterReference LEFT JOIN iO_Client_MasterReference ON CMR_ID = LMR_IDLink_CMR
left join io_product_masterreference on rmr_id = LMR_IDLink_Code_ID
    Where lmr_idlink_association = '{d8dcb018-54c1-4ba3-8b28-66973a09dc45}') as assessor on iO_Product_MasterReference.rmr_id = assessor.rmr_id
left join
    -- subquery to fetch approval_officer name 
    (Select  iO_Client_MasterReference.CMR_SeqNumber, LMR_SeqNumber, cmr_name, rmr_id From iO_Link_MasterReference LEFT JOIN iO_Client_MasterReference ON CMR_ID = iO_Link_MasterReference.LMR_IDLink_CMR left join io_product_masterreference on rmr_id = iO_Link_MasterReference.LMR_IDLink_Code_ID
    Where iO_Link_MasterReference.lmr_idlink_association = '{299646a4-d179-43c9-8fb0-4ac1af1d45b8}') as approval_officer on iO_Product_MasterReference.rmr_id = approval_officer.rmr_id

left join iO_Product_ControlDate on RCD_IDLink_RMR = io_product_masterreference .RMR_ID
left join iO_Product_ControlTerm on RCTe_idlink_rmr =io_product_masterreference .RMR_ID
left join
    (
		select  
			convert(decimal(10, 2)
			,sum(isnull(rtm_valuedb,0.00))-sum(isnull(rtm_valuecr,0.00))) as sched_prin,rtm_idlink_rmr
		from iO_Control_TransactionMaster
            inner join iO_Control_TransactionBalance on XTRMb_IDLink_XTRM = XTRM_ID 
            inner join io_product_transaction on rtm_idlink_xtrm = xtrm_id
		where XTRMb_IDLink_XRBl = '{2d7a7fa1-3bf3-4998-9e5f-f3cedda4a2e7}' 
				and rtm_datee <= getdate() 
		group by rtm_idlink_rmr
     ) as Curr_value on curr_value.Rtm_IDLink_RMR = io_product_masterreference.rmr_id
left join 
     (
		select  
			convert(decimal(10, 2)
			,sum(isnull(rtm_valuedb,0.00))-sum(isnull(rtm_valuecr,0.00))) as tyu,rtm_idlink_rmr
		from iO_Control_TransactionMaster
            inner join iO_Control_TransactionBalance on XTRMb_IDLink_XTRM = XTRM_ID 
            inner join io_product_transaction on rtm_idlink_xtrm = xtrm_id
		where
			XTRMb_IDLink_XRBl = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' 
			and rtm_datee <= getdate() 
		group by rtm_idlink_rmr
	)as Prin_balance on prin_balance.Rtm_IDLink_RMR =io_product_masterreference.rmr_id

left join
	(
		select  
			convert(decimal(10, 2)
			,sum(isnull(rtm_valuedb,0.00))-sum(isnull(rtm_valuecr,0.00))) as rcb_currentvalue,rtm_idlink_rmr
		from iO_Control_TransactionMaster
            inner join iO_Control_TransactionBalance on XTRMb_IDLink_XTRM = XTRM_ID 
            inner join io_product_transaction on rtm_idlink_xtrm = xtrm_id
		where
			XTRMb_IDLink_XRBl = '{b1f3d85e-c51f-4160-9ee5-933fca427dee}' 
			and rtm_datee <= getdate() 
		group by rtm_idlink_rmr
	)as arrears on  arrears.RTM_IDLink_RMR = io_product_masterreference.rmr_id
left join
	(
		select 
			lmr_id
			,CMR.CMR_IDLink_XCY
			,CTC.CTC_CompanyName
			,CTS_Name_1
			, CTI.CTI_FirstName
			,CTI.CTI_Surname
			,CTI.CTI_IDLink_XCT
			,lmr_idlink_code_id
         FROM io_link_Masterreference
         left join  io_Client_MasterReference CMR on cmr_id = lmr_idlink_cmr
         Left Join io_Client_TypeIndividual CTI ON CMR.CMR_ID = CTI.CTI_IDLink_CMR
         Left Join io_Client_TypeCompany CTC ON CMR.CMR_ID = CTC.CTC_IDLink_CMR
         left join iO_Client_TypeStandard on CTS_IDLink_CMR = cmr_id
         Where lmr_idlink_association = '{69783579-9e83-4e82-bb25-7b3d52b0f99d}'
	) as brc on brc.lmr_idlink_code_id = io_product_masterreference.rmr_id
left join 
       --lodge_date
     (
		Select 
			RCD_CurrentStart
			,rcd_idlink_rmr
       From iO_Product_ControlDate 
       where  RCD_Type = 106
	 )as lodge_date on  lodge_date.rcd_idlink_rmr = io_product_masterreference.rmr_id
       --settlement date
left join 
     (
		Select 
			RCD_CurrentStart 
			,RCD_IDLink_RMR 
       From 
       iO_Product_ControlDate 
       Where 
       RCD_Type = 6
	 ) as sett_date on sett_date.RCD_IDLink_RMR  = io_product_masterreference.rmr_id
left join io_control_productmaster on xrp_id = io_product_masterreference.RMR_IDLink_XRP
left join io_product_transaction on io_product_transaction.rtm_idlink_rmr =io_product_masterreference.rmr_id
left join 
	(
		select 
			sum(isnull((rtm_value),0.00)) as total1 
			,rtm_idlink_rmr from io_product_transaction 
			where rtm_idlink_xtrm in 
			(
				'{3b78e2bc-412d-4e78-927a-e255975efbfd}',
				'{5d21b3ef-7739-4427-85a6-70a1677786f1}',
				'{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}',
				'{b426962b-3748-4bbf-9232-92ba164dc785}',
				'{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}',
				'{2f97e453-ddcd-49b7-958d-e85460e5c3cf}',
				'{f03763e2-eb24-4ca9-bef2-e525ade90ce8}',
				'{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}',
				'{d90943f6-a537-4e04-adc0-7a880260a940}',
				'{d685de8f-4009-4968-9fe6-bd63de507376}',
				'{88d368ae-d2e3-4db4-9880-3de434f3b542}',
				'{9251d213-46b3-4ffe-a59e-675bc7ed8258}',
				'{857a90f4-efa8-4c9f-abbf-19b7057a7b79}',
				'{a8136ec2-6d41-4df2-97e2-a92baa39f139}',
				'{9a77a79c-c8f7-494f-8e9f-48e304dfd652}',
				'{77d7215b-a0ad-495a-86f5-e791f035f335}',
				'{468824e4-f92e-428c-8000-de9d68619d23}',
				'{dc2c3e2a-1594-4058-b10f-73627855f28a}',
				'{9d57bb56-d2b6-4aef-9165-dcbdfa354997}',
				'{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}',
				'{369d0352-6702-44dc-86a5-aa1e63d43a28}',
				'{da9c356c-51b7-46e7-b637-22f2c2897a44}'
			)
			group by rtm_idlink_rmr
	) as ad on ad.rtm_idlink_rmr = io_product_masterreference.rmr_id
left join 
	(
		select 
			isnull(sum(isnull(rtm_value,0.00)),0.00) as total1,rtm_idlink_rmr
		from io_product_transaction
		where rtm_idlink_xtrm in 
								('{1711bd64-942a-456a-b723-e65d3c877a89}',
								'{1d80d541-cd59-4e75-90d5-6c48e9c326ca}',
								'{244d60d7-2cef-4e24-8a7d-02c9cab998d1}',
								'{bfad6a88-cb2f-49ca-9b88-c1f962b81111}',
								'{cde651a4-8f90-4baf-adc5-83e8499eaa3c}',
								'{e832ac26-3c19-41aa-871c-a08f9b698d69}',
								'{f63e5521-cbef-414c-89ed-d6aa29644687}')
		group by rtm_idlink_rmr
	)as bd on bd.rtm_idlink_rmr = io_product_masterreference.rmr_id
left join 
	(
		select 
			ISNULL(sum(isnull(rtm_value,0.00)),0.00) as total1,rtm_idlink_rmr
		from io_product_transaction
		where rtm_idlink_xtrm in ('{1fa76f6c-3a20-415d-a8e5-3a71efeef433}',
								'{8ae7a940-e7de-47ba-a98e-6227241c4698}',
								'{914d2104-748b-47fe-b580-3e9939c39d2a}',
								'{d96fdc0b-ea82-46c3-9982-0bc4f155935c}',
								'{ef859b47-2820-4459-b033-4bd4d321251a}')
		group by rtm_idlink_rmr
	) as cd on cd.rtm_idlink_rmr = io_product_masterreference.rmr_id 
left join 
	(
		select top 1 
			SMR_IDLink_XSU
			,smr_idlink_code
		from iO_Status_MasterReference
		where
		(      
			(smr_dateenter < dateadd(day,1,getdate())
				and smr_dateleave >= getdate())
			or
			(smr_dateenter <= dateadd(day,1,getdate())
				and smr_dateleave is null)
		)
	) as st on  st.smr_idlink_code =  io_product_masterreference.rmr_id
left join io_control_statusmaster on  xsu_id= RMR_IDLink_XSU
Where
	c1.cmr_name = @branch --'Geelong branch'
	and rmr_idlink_xrp not in ('{20f332f8-2884-4ed2-a31f-5238396dfb49}','{9666d08b-9952-467d-b47e-deb54b490120}')   
    and RCTe_Type = 1
group by 
	io_product_masterreference.rmr_id,rmr_seqnumber
	,xrp_detail
	,CMR.cmr_name
	,dss_cashout
	,dss_insurance
	,dss_brokerage
	,br.CMR_Name
	,assessor.cmr_name
	,lodge_date.RCD_CurrentStart
	,sett_date.RCD_CurrentStart
	,rcte_months
	,rtm_value
	,rtm_idlink_xtrm
	,arrears.rcb_currentvalue
	,brc.lmr_idlink_code_id
	,brc.CMR_IDLink_XCY
	,brc.CTI_IDLink_XCT
	,brc.CTC_CompanyName
	,brc.CTS_Name_1
	,brc.CTI_FirstName
	,brc.CTI_Surname
	,io_control_statusmaster.XSU_Detail
	,ad.total1,bd.total1
	,cd.total1
	,Curr_value.sched_prin
	,Prin_balance.tyu
	,CMR.cmr_seqnumber
	,CCDMobile.CCD_Details
	,CCDEmail.CCD_Details
order by rmr_seqnumber asc