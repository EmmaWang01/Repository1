select 
	[XSU_ID],
	xsu_detail,
	CASE 
	WHEN [XSU_ID] IN
	(
	'{8441da2e-2ace-4d19-9608-87a5c5acb5a8}'		--Money3\Current
	,'{9109145f-6143-4d0e-96b5-687edb0f1ad5}'		--Money3\Arrears - Arrears Letter
	,'{93ba842a-8662-4657-b464-11f609b8bed8}'		--Money3\Arrears - Special Arrangement
	,'{ae06255a-2fc5-4b90-a081-af3969dbdb82}'		--Money3\Arrears - Payment Plan
	,'{c42ce2db-8732-4d4b-8be2-b6ee111695e5}'		--Money3\Arrears - Hardship
	,'{0927edfd-d426-445d-90b8-5adebd0de1d3}'		--Money3\LACC - Hold
	,'{3eba49a2-2b63-40b0-8cb9-8159b77c91b3}'	    --Money3\Arrears - Do Not Action
	)
		THEN 'Active'
	WHEN [XSU_ID] IN
	('{56661393-78a1-4cda-8a7d-535fffa8fc5c}'		--Money3\Arrears - Default
	,'{b5b9da80-b0b3-4b63-ac48-57c9f3d36818}'		--Money3\Arrears - Hold
	)
		THEN 'Doubtful'
	WHEN [XSU_ID] IN 
	(
	'{0a168683-788f-4aeb-b04e-5e95075dd33d}'		--Money3\Discharged - Paid in full early discount
	,'{3f09eade-f2e7-4c4b-98d3-7513580cee49}'		--Money3\Discharged - Paid in Full

	,'{eed8f1a7-9615-483e-b234-47ce66f2ee23}'		--Money3\Discharged - Negotiated payout
	)
		THEN 'Discharged'
	WHEN [XSU_ID] IN 
	(
	'{05e4ceb3-1eee-456e-a497-1026c0768ede}'		--Money3\Application - Application Cancelled
	,'{abbd8f3f-51f3-4000-9052-ee6d81b8834c}'		--Money3\Application - Expired Application
	)
		THEN 'Cancelled'
	WHEN [XSU_ID] IN
	(
	'{1aad8074-9af8-4598-a033-c070cf3a49b9}'		--Money3\Application - Unsuccessful - Reason to be reviewed
	,'{2e16b85a-816e-471d-8078-30362ae88042}'		--Money3\Application - Unsuccessful
	,'{33aec218-855f-42fd-a0c7-ec808aa45520}'	--Money3\Declined
	,'{f71a73b4-e8de-4854-835d-bbffa381e994}'	--Money3\Declined - Current M3/CT Loan
	,'{fe7e56b6-c298-485a-9e8a-faa942040fa9}'	--Money3\Declined - Second SACC
	,'{1f40e956-07ef-48b3-87e4-8d83e99cd36c}'	--Money3\Rejected - Duplicate
	)
		THEN 'Declined'
	WHEN [XSU_ID] IN
	(
	'{06fae08f-35a9-4515-9d2c-757a8207a73c}'		--Money3\Collections\Active\Legal\Judgement
	,'{1edfeab9-8e15-4afd-926a-26c8befbaaed}'		--Money3\Collections\Active\DDR Attempt
	,'{4177f94f-193b-4190-b1c0-3036908dfef8}'		--Money3\Collections\Active\External
	,'{48f5ff0f-d997-4ffd-8f0d-06aa33a54b97}'		--Money3\Arrears - Recoveries
	,'{491185db-f116-403a-a86b-484be79c6433}'		--Money3\Collections\InActive\Dead File
	,'{4ccc61f0-a025-4a85-8164-1fad2812b297}'		--Money3\Collections\Active\Valid Phone
	,'{55c2ad7c-63d5-4130-8a87-b94c7184d42d}'		--Money3\Collections\Active\Still to Action
	,'{5e3bed22-27e9-46fd-9bd5-7b6471b02511}'		--Money3\Collections\Active\Investigating
	,'{7e186bd4-ec66-4f94-94b1-e23db8de2c0f}'		--Money3\Collections\Active\Part IX
	,'{86a692cf-76d5-4895-a833-9fbe9052e4d2}'		--Money3\Collections\Active\Legal\Court
	,'{89832085-8e39-457a-b2f6-3ea3e27e2ad6}'		--Money3\Collections\InActive\Settled
	,'{9549f014-69cb-42c7-9d1c-c2cabc8dd6ed}'		--Money3\Collections\Active\Part X
	,'{9a2d8920-3f6b-4176-b353-921015f1305f}'		--Money3\Collections\InActive\Dormant
	,'{a9ca9714-843f-4992-a666-9b30d67c9dfc}'		--Money3\Collections\InActive\Bankrupt
	,'{d2d7cf0d-2f12-4ded-be1e-f0c6a2b871ac}'		--Money3\Collections\Active\Veda Listing
	,'{db15ccef-67de-46e9-9efe-dbfbe2c490fb}'		--Money3\Collections\Active\Legal\Served
	,'{ed4bb803-271d-42db-9cef-6b0f6fb68832}'		--Money3\Collections\Active\Legal\Legal
	,'{f8527bf0-32f4-4fbe-9bbd-ff42001763ea}'		--Money3\Collections\Active\Do Not Action
	,'{ee3cdb17-f540-46bd-aa7e-c5fffb97b5e1}'		--Money3\Internal Current
	,'{42328faf-e454-402a-b0f5-99fe9ca3c64f}'		--Money3\Discharged - Written Off
	,'{4d75bf65-e93c-4741-b7df-bfea892112a2}'		--Money3\Collections\Active\Legal\Attachment
	,'{199b584a-177d-46be-bb48-84c81e374070}'		--Money3\Arrears - Recoveries - HOLD
	,'{5e0a955a-e37d-425d-a7c1-3cd984c6f3f2}'		--Money3\Collections\Active\Payment Plan
	,'{63451330-bf35-4232-8372-54866c2dfb88}'      --Money3\Application - Awaiting Employment Details
	,'{7336b604-7b34-496a-bff6-dd976ad16246}'      --Money3\Application - Awaiting Manual Payment
	,'{4ca7e1b9-a9f7-4d57-a174-7e92dfa0aca0}'      --Money3\Application - Bank Statements Lookup
	,'{0fb72887-048d-4a00-886c-70135fe9eba7}'      --Money3\Application - Expense Confirmed
	,'{3d530e0f-b5fc-499c-86f3-81fd66275aeb}'      --Money3\Application - Extra Documents Needed - Direct Debit Form Joint Account
	,'{ca22bbed-9e29-4377-9186-ca57464a1ad6}'      --Money3\Application - Inconsistent Salary/MACC in Arrears/Repeat Decline
	,'{c9b1502d-d31c-4413-b288-725295ba5cf8}'      --Money3\Application - Joint Direct Debit From Received
	,'{f7457725-efd3-4b69-9026-83904260ab43}'      --Money3\Application - Priority Customer Service Team
	,'{38b3073c-23fd-49f5-a206-98b909412c13}'      --Money3\Application - Review Completed
	,'{9e52b7e6-de76-4b12-98d8-43193eaff8e3}'      --Money3\Application - Under Review Manilla
	,'{73bc4009-351b-42a7-a08e-f530756688da}'      --Money3\PreApproval BankStatement

				
	)
		THEN 'BadDebt'
	WHEN [XSU_ID] IN
	(
	'{3a311bda-8d87-4226-a4fd-932396cc56d1}'		--Money3\Application - Incomplete Application
	,'{48621d98-a39b-4565-bceb-aadc59f9d213}'		--Money3\Application - Awaiting Emp/Rental
	,'{583cb447-e6e7-4317-9210-158a8a1776c5}'		--Money3\Application - Application Approved
	,'{5921226e-9db6-4778-9874-bca71521d9f5}'		--Money3\Application - Pre Approved
	,'{6a866fa9-ccd9-4a2e-bc65-552f7f7a9251}'		--Money3\Application - Awaiting Further Documents
	,'{95bdb1e1-c63f-40ec-89f9-6586d159ab71}'		--Money3\Application - Application Received
	,'{efd0d3e3-cb01-4df3-a0f2-4da0e211ee91}'		--ARMnet\Loan\Enquiry\Application
	,'{fe0193bd-1e14-4f7e-9a5b-52470ac526b2}'		--Money3\Application - Redirect
	,'{0c8e98df-fe14-4ceb-a093-0297d2aa377b}'		--Money3\Application - Awaiting Customer Contact
	,'{c3ee8d13-e466-465b-bf2d-89f182ebce21}'		--Money3\Application - Application Complete
	,'{22b68082-f44a-448d-871c-3f7c8436119f}'		--Money3\Settlements - Waiting on Docs/Credit Req
	,'{b1afb7ff-5a2c-4cf2-a1b9-209ad6069aa9}'		--Money3\Application - Personal Details
	,'{54b012ac-643e-44ca-9cf9-42f2838c0fad}'		--Money3\Application - Esign
	,'{d77d4723-0ddc-4f56-96ca-f5859515e9a2}'		--Money3\Settlements - Waiting on Welcome Call
	,'{dd165660-4a59-4eec-bfee-4652fff35fcd}'		--Money3\Settlements - Waiting on References
	,'{63cc0ced-d7ff-4fea-b19b-67e613bb86a5}'		--Money3\Application - Credit Guide
	,'{2a41940a-32cb-47ef-b62a-e955e713ded9}'		--Money3\Underwriting - OK for Settlement
	,'{8a82d464-3ffb-4230-b698-6cd859d89cad}'     --Money3\Application - Amended Esign
	,'{61691efc-034d-4d71-b9a3-d5dc9d705744}'     --Money3\Application - Arrears with other SACC confirmed
	,'{5de99cc1-143d-45f4-8895-47345836fb53}'     --Money3\Application - Awaiting Employment Check
	,'{2b41ac2a-f579-4854-b796-4bc9502a3343}'     --Money3\Application - Awaiting Rental Check
	,'{1ad102d3-0a3b-402c-b3ba-a852e3b40b72}'     --Money3\Application - Bank Details
	,'{d81f8a44-a367-4097-8f7d-4dfe25426115}'     --Money3\Application - C4 Assessment
	,'{9df795a5-a793-4784-a6d7-92edc9c9b145}'     --Money3\Application - C4 Review Completed
	,'{ba9b9c0f-4109-43cd-aa46-0187727beb3e}'     --Money3\Application - C4 Under Review
	,'{77d339c2-3b17-4610-859b-94c9a41a2b87}'     --Money3\Application - Debit From Received
	,'{9ca1c1c2-ea4d-4dbd-8aeb-45d74d114fa8}'     --Money3\Application - Employment Check Completed
	,'{7ef1089c-7b0b-4bd3-bbe0-acaf04f0c6ac}'     --Money3\Application - Employment Detail Confirmed
	,'{7ea2cd3f-4927-4aef-b631-09b6a9baa222}'     --Money3\Application - Extra Documents Needed
	,'{a637b224-dbfa-4034-b428-b671e1e08edb}'     --Money3\Application - Extra Documents Needed - Direct Debit Form
	,'{c8054dc5-e901-4426-b2cd-51914179377a}'     --Money3\Application - Extra Documents Needed - ID
	,'{1d0503ec-4cde-4cf7-b8a5-896f24b6987b}'     --Money3\Application - Extra Documents Needed - ID and BST
	,'{cba45277-ef65-4d9b-bc43-9c1e5b310468}'     --Money3\Application - Extra Documents Needed - Proof of Bank Account Ownership
	,'{1bbc4b6e-e20a-4e51-882e-7b03b1b1502d}'     --Money3\Application - Extra Documents Needed - Statement
	,'{3817d0a3-68b8-4b1d-80b2-8750af7e722b}'     --Money3\Application - Extra Documents Needed Payslip
	,'{d58c84d4-dd22-4144-baee-26151b99fda6}'     --Money3\Application - Loan Purpose Confirmed
	,'{0f93bdc2-2d17-4624-b367-385f6ac33eb6}'     --Money3\Application - Marked for Deletion
	,'{8eb1d726-0596-4a55-9495-afa903135837}'     --Money3\Application - Other SACC Confirmed
	,'{6fc99057-16fd-4935-9c10-96d48b33a02b}'     --Money3\Application - Payslip Received
	,'{714364ec-b26c-4690-a6aa-3961559454b2}'     --Money3\Application - Priority Assessment
	,'{61d7b142-f5d8-4f12-a547-769adf655da1}'     --Money3\Application - Proof of Bank Account Ownership Received
	,'{f53f8283-e75e-4c92-8b76-3e0759652700}'     --Money3\Application - Rental Check Complete
	,'{3bad9fee-0048-4398-bdfd-2811c4a1113d}'     --Money3\PreApproval ApplicationComplete
	,'{5ccdd4d2-5428-48c3-a4bf-78f429dbb22d}'     --Money3\PreApproval ExtraDocuments
	,'{197e5aee-a93f-4795-a0b1-6e005fed6b19}'     --Money3\PreApproval FurtherDetails
	,'{1b604970-ea4f-4b14-80aa-c0a2267f900f}'     --Money3\PreApproval PersonalDetails
	,'{bf8d8252-8276-46ac-ac34-290a43ad0b2b}'     --Money3\PreApproval QuickLead
	,'{3a859bea-5d1d-4b33-b018-ad21d72e8626}'	  --Money3\Ready to settle
	,'{07d20963-5380-4e7f-9ffb-e6422c881d24}'		--Money3\Pending Payment
	)
		THEN 'WIP'
	ELSE 'UNKNOWN'
	END AS StatusGroup
from iO_Control_StatusMaster
order by 3,2