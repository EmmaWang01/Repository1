


select rmr.RMR_SeqNumber, rtm.RTM_Value,rtm.RTM_DateE from iO_Product_Transaction rtm 
left join iO_Product_MasterReference rmr on rmr.rmr_id=rtm.RTM_IDLink_RMR
where RTM_IDLink_XTRM = '{f66f2981-ad69-4b51-903b-a2e7eafedc8e}' --Money3\Fee\Waive
order by RTM_DateC desc

-- system waived in APL? 


select rmr.RMR_SeqNumber, rtm.RTM_Value,rtm.RTM_DateE from iO_Product_Transaction rtm 
left join iO_Product_MasterReference rmr on rmr.rmr_id=rtm.RTM_IDLink_RMR
where RTM_IDLink_XTRM = '{a95480c7-62f7-4147-9d58-0c4859c1dfb0}' --Money3\Fee\WaiveDb
order by RTM_DateC desc

--system waived

select rmr.RMR_SeqNumber, rtm.RTM_Value,rtm.RTM_DateE from iO_Product_Transaction rtm 
left join iO_Product_MasterReference rmr on rmr.rmr_id=rtm.RTM_IDLink_RMR
where RTM_IDLink_XTRM = '{8d8555e4-a6b5-4b89-a097-4ce6e11ed478}' --Money3\Fee\WaiveCr
order by RTM_DateC desc

--system waived


select rmr.RMR_SeqNumber, rtm.RTM_Value,rtm.RTM_DateE from iO_Product_Transaction rtm 
left join iO_Product_MasterReference rmr on rmr.rmr_id=rtm.RTM_IDLink_RMR
where RTM_IDLink_XTRM = '{192dd338-5c35-4d4e-92a5-ebe24c898df0}' --Money3\Fee\Reversal\Fee Refund
order by RTM_DateC desc
-- cant distingush refund for which fee, some time to used as fee waive?


select rmr.RMR_SeqNumber, rtm.RTM_Value, rtm.rtm_valueDB,rtm.RTM_DateE from iO_Product_Transaction rtm 
left join iO_Product_MasterReference rmr on rmr.rmr_id=rtm.RTM_IDLink_RMR
where RTM_IDLink_XTRM = '{64228cb1-9fde-4d45-9d9c-ac93b8177fb5}' --erd discount
order by RTM_DateC desc
