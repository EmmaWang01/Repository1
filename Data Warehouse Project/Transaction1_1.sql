/*
Select top 10000
RTM_IDLink_RMR
,cast(sum((isnull(rtm.RTM_ValueDB,0) - isnull(rtm.RTM_ValueCR,0))) as decimal (10,2)) as 'CurrentBlance'
from iO_Product_Transaction rtm 
 inner join iO_Control_TransactionBalance xtrmb on rtm.RTM_IDLink_XTRM = xtrmb.XTRMb_IDLink_XTRM 
where xtrmb.XTRMb_IDLink_XRBl = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' 
group by RTM_IDLink_RMR


select XTRM_ID,XTRM_Detail, XTRM_IDUser from iO_Control_TransactionMaster xtrm 
left join iO_Control_TransactionBalance xtrmb on xtrmb.XTRMb_IDLink_XTRM= xtrm.XTRM_ID
where xtrmb.XTRMb_IDLink_XRBl = '{cf421ec7-af23-474c-9f8f-46e6b899075f}' 
--and xtrm_detail not like '%Reversal%'
order by XTRM_IDUser


*/


/**below are the transactions not in XTRMB group(part of balance calculation) but originally had additive as 1 in Dylan's transaction csv**/

select top 1000 RTM_ValueCR, RTM_ValueDB, RTM_DateE, RMR_SeqNumber, RTM_TypeGhost
from iO_Product_Transaction rtm
left join iO_Product_MasterReference rmr on RTM_IDLink_RMR=rmr.RMR_ID
where rtm_idlink_xtrm in
(
'{a3a31f33-534a-4755-8abe-2dd8d3a73e35}' --discharge fee, leave additive as 1, 196 rows
--'{c6bb3791-3d10-407c-a8ff-f58cb4a445be}' --dishonour fee, leave additive as 1
--'{20ea1c5a-3f11-42ab-94bc-2d008413ffce}' -- special fee, 95 rows set to 0 because most are ghost transactions, but will miss some values, see example loan 51615, 2014-12-22 $744.30
--'{3a708976-2f8d-458c-bc45-dd23d1d4d2a0}' --moneyGram set additieve to 0
--'{a97c5fcc-5625-48d2-9aeb-463e7cf7ab58}' --moneyGram set additieve to 0
--'{8fd616f5-118f-4cc4-acfa-a9c48944edd8}' --moneyGram set additieve to 0
-- '{fb389b3e-43ec-4300-9445-c11403945d82}',--moneyGram set additieve to 0
-- '{1d80d541-cd59-4e75-90d5-6c48e9c326ca}' -- only 13 tansactions most are ghost, some being misused for cheque cashing , leave additive as 1
--'{274ab776-dbd9-4187-9621-2a5f08c68ab4}' -- only 12 transactions, small amount, leave additive as 1
--'{98284444-284e-44e1-a04b-7c4d6d984f8a}' -- rental, set additive to 0
--'{9d9bd706-59d5-4961-b8b6-377d4dd03c58}' --only 1 row, leave as additive 1
--'{ace232e8-0025-4daf-8535-4e31e55ce71f}' -- only 1 row, leave additive as 1
--'{5015f0a3-8759-462c-ae67-16796e541ab2}' --rental only 1 row, set additive as 0
-- '{8c250320-2b75-4174-b5d0-78d3ed2892e4}' --safe set to 0
-- '{3fdb41a1-c23f-4173-8fca-d2374962306e}' --Mothly account fee, only 11 rows, leave additive as 1
--'{19251fb5-5a82-4abf-bfc9-c6ee49cf34a4}' --safe set additive to 0
--'{369d0352-6702-44dc-86a5-aa1e63d43a28}' --payment, only 1 row, leave additive as 1
--'{c76d3e8d-782a-45b3-b95d-a0214fcc9c77}' --moneyGram set additive to 0
--'{192dd338-5c35-4d4e-92a5-ebe24c898df0}' --fee refund leave additive as 1 
--'{5B3054B0-B472-4DAA-9D17-986A69A9FF4E}' --redraw fee, only 3 rows leave additive as 1
--'{fb20e33c-ee26-42f9-9609-5935d705cd2f}' -- penalty interest only 3 rows, set additive to 0
)
order by RTM_Value desc, RTM_DateE

