set nocount on -- this will enable excel to excute query with temptable 
declare @tempTabel table 
	(
		CMR_ID varchar(40),
		Assaciation_ID Varchar(40),
		CMR_Name varchar(512)
	);

insert into @tempTabel
SELECT DISTINCT 
	iO_Client_MasterReference.CMR_ID, 
	iO_Link_MasterReference.LMR_IDLink_Association, 
	iO_Client_MasterReference.CMR_Name

FROM iO_Link_MasterReference with(nolock) INNER JOIN
     iO_Client_MasterReference with(nolock) ON iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND 
     iO_Link_MasterReference.LMR_IDLink_Association = '{b55145aa-2697-43b5-9c6a-c4a0960823d8}' AND iO_Client_MasterReference.CMR_Name IS NOT NULL
select * from @tempTabel

