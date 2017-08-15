
---------------loan and branch/staff associations----------
Select
   	/*ID = LMR_ID,
    Name = CMR_Name,
    Detail = XLK_Detail*/
	*
From
        iO_Link_MasterReference
			LEFT JOIN iO_Control_LinkMaster ON XLK_ID = LMR_IDLink_Association
			LEFT JOIN iO_Client_MasterReference ON CMR_ID = LMR_IDLink_CMR
Where
        LMR_IDLink_Code_ID = '{0193ae3a-08fe-42fa-8169-fb1e36d28c96}'
Order By
        XLK_Detail

select * from iO_Product_MasterReference where RMR_ID='{0193ae3a-08fe-42fa-8169-fb1e36d28c96}'

--------------staff and branch association ---------------------------------------
select * from iO_Client_MasterReference where CMR_Name like '%Wang Emma%' --//{eef53352-8e92-4ea1-b3f2-fe7bc59a291d}
select * from iO_Control_LinkMaster where XLK_ID='{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}'

select * from iO_Link_MasterReference where LMR_IDLink_Association='{b351c3ab-033e-4a4a-9bc7-8bc5a63a837c}' and LMR_IDLink_CMR='{eef53352-8e92-4ea1-b3f2-fe7bc59a291d}'
--//{f5f91ed5-a110-4b9d-979d-64950e4d7a96}

select * from iO_Client_MasterReference where CMR_ID='{f5f91ed5-a110-4b9d-979d-64950e4d7a96}'
