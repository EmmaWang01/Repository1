select * from iO_Control_ProductBalance where XRBl_ID='{f6e26460-bf66-40fd-9bb2-112ebc2f2b07}'


select * from iO_Control_ProductBalance where XRBl_IDUser=117--104 --{57af2f0d-9ec7-46c7-9468-cf633f9b4930}

select * from iO_Control_ProductBalance where XRBl_ID in ('{fa9b4019-3380-435c-bcdd-40b78d39471e}','{57af2f0d-9ec7-46c7-9468-cf633f9b4930}','{f6e26460-bf66-40fd-9bb2-112ebc2f2b07}')


--103	Loan\Standard\Application {f6e26460-bf66-40fd-9bb2-112ebc2f2b07}  -- application amount
--104	Loan\Standard\Approved	{57af2f0d-9ec7-46c7-9468-cf633f9b4930}	--Approved amount (including fees such as application fee, commission paid and insurance)
--130015	Loan\Standard\New Application Amount {fa9b4019-3380-435c-bcdd-40b78d39471e}	-- Approved amount (fees not included, can be used as cash out?)
--117 Loan\Standard\Principal {cf421ec7-af23-474c-9f8f-46e6b899075f} -- Current Balance
--130012 total fees on APL loan summary screen

select a.RCB_IDLink_RMR, a.RCB_CurrentValue, b.RCB_CurrentValue, a.RCB_CurrentValue-b.RCB_CurrentValue as 'Diff', rmr.RMR_SeqNumber from iO_Product_ControlBalance a
left join iO_Product_ControlBalance b on a.RCB_IDLink_RMR=b.RCB_IDLink_RMR
left join iO_Product_MasterReference rmr on a.RCB_IDLink_RMR=rmr.RMR_ID
where a.RCB_CurrentValue>0 and  a.RCB_IDLink_XRBl='{57af2f0d-9ec7-46c7-9468-cf633f9b4930}' and b.RCB_IDLink_XRBl='{fa9b4019-3380-435c-bcdd-40b78d39471e}'



select RCB_CurrentValue from iO_Product_ControlBalance where RCB_IDLink_XRBl='{57af2f0d-9ec7-46c7-9468-cf633f9b4930}' and RCB_IDLink_RMR=(select rmr_id from iO_Product_MasterReference where RMR_SeqNumber=1278044)


