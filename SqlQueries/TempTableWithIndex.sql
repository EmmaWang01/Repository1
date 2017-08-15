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