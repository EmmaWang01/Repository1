set dateformat dmy

SELECT  
       case
            when CMRBroker.cmr_name  in('AUSSIE CAR LOANS (MELBOURNE)') then 'AUSSIE CAR LOANS'
            
            when CMRBroker.cmr_name  in('CREDIT CHOICE FINANCE (BRISBANE)', 'CREDIT CHOICE FINANCE (COBURG)',
                                                      'CREDIT CHOICE FINANCE (PERTH)', 'CREDIT CHOICE FINANCE (SOUTHPORT)',
                                                      'CREDIT CHOICE FINANCE (TOOWOOMBA)', 'CREDIT CHOICE FINANCE (TOWNSVILLE)') then 'CREDIT CHOICE FINANCE'
            
            when CMRBroker.cmr_name  in('CREDIT ONE (SOUTHPORT)') then 'CREDIT ONE'
            when CMRBroker.cmr_name  in('CAPITALCORP FINANCE AND LEASING (BRISBANE)', 'CAPITALCORP FINANCE AND LEASING (CAIRNS)') then 'CAPITALCORP'
            when CMRBroker.cmr_name  in('I NEED FINANCE NOW (BLACKTOWN)', 'I NEED FINANCE NOW (GOLD COAST)') then 'I NEED FINANCE NOW'
            when CMRBroker.cmr_name  in('MONEY NOW (BRAYBROOK)', 'MONEY NOW (BRISBANE)', 'MONEY NOW (CAIRNS)', 'MONEY NOW (MACKAY)', 'MONEY NOW (MINCHINBURY)','MONEY NOW (ROCKHAMPTON)',
                                                      'MONEY NOW (MT WAVERLEY)', 'MONEY NOW (NEWCASTLE)', 'MONEY NOW (PERTH)', 'REGIONAL CREDIT','MONEY NOW (RINGWOOD)') then 'MONEY NOW'
            when CMRBroker.cmr_name  in('NATIONAL FINANCE CHOICE (BRAYBROOK)', 'NATIONAL FINANCE CHOICE (MOORABBIN)', 'NATIONAL FINANCE CHOICE (MT WAVERLEY)',
                                                      'NATIONAL FINANCE CHOICE (WOODCROFT)') then 'NFC'
            when CMRBroker.cmr_name  in('STRATTON FINANCE (BAYSIDE BRISBANE)', 'STRATTON FINANCE (MELBOURNE)', 'STRATTON FINANCE (SOUTH EAST METRO AND HILLS)',
          'STRATTON FINANCE (SYDNEY)') then 'STRATTON FINANCE'
            when CMRBroker.cmr_name  in('TANNASTER (CAMPBELLTOWN)', 'TANNASTER (CLAYTON)', 'TANNASTER (CRANBOURNE)', 'TANNASTER (FRANKSTON)', 'TANNASTER (GEELONG)',
            'TANNASTER (GLENORCHY)', 'TANNASTER (LEASE CONVERSION)', 'TANNASTER (MELTON)', 'TANNASTER (MORPHETT VALE)', 'TANNASTER (NORTHCOTE)',
            'TANNASTER (PFC DEVONPORT)', 'TANNASTER (PFC LAUNCESTON)', 'TANNASTER (PORT ADELAIDE)', 'TANNASTER (PRESTON)', 'TANNASTER (RESERVOIR)',
            'TANNASTER (ROSNY PARK)', 'TANNASTER (SALISBURY)', 'TANNASTER (ST ALBANS)', 'TANNASTER (SUNSHINE)', 'TANNASTER (THOMASTOWN)','TANNASTER (DANDENONG)',
            'TANNASTER (WEB CENTRE)', 'TANNASTER (WERRIBEE)', 'TANNASTER (WODONGA)', 'STAFF LOAN','TANNASTER (MICRO MOTOR)','TANNASTER (PFC HOBART)','TANNASTER (PROSPECT)') then 'MONEY3'
         else CMRBroker.CMR_Name
            end as 'Broker'
      , COUNT(*) as cnt,
      sum((DSS_CashOut) +  (DSS_Insurance) + (DSS_Brokerage)) as 'NAF'

FROM M3_MAIN.dbo.iO_DataStorage_SalesReport DSSales
      left join
      (SELECT iO_Product_MasterReference.RMR_SeqNumber,
                  iO_Client_MasterReference.CMR_Name AS Branch
            FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, 
                  M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, 
                  M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference
            WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID 
                  AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID 
                        AND (iO_Link_MasterReference.LMR_IDLink_Association='{7e504c4d-821c-4623-a928-28ee65c3b8c8}')
                        
      ) as BR ON br.RMR_SeqNumber  = DSSales.DSS_LoanNumber 

    left join iO_Link_MasterReference as BrokerLink on BrokerLink.lmr_idlink_code_id = DSSales.dss_idlink_rmr
    and brokerLink.LMR_IDLink_Association = '{69783579-9e83-4e82-bb25-7b3d52b0f99d}' --Loan\Broker
    left join io_client_masterreference as CMRBroker on CMRBroker.cmr_id = BrokerLink.LMR_IDLink_CMR
where 
      DATEADD(mm,DATEDIFF(mm,0,dssales.DSS_SettlementDate),0)=DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) -- Current Month
      and br.Branch = 'Loan Centre'
group by (  case
            when CMRBroker.cmr_name  in('AUSSIE CAR LOANS (MELBOURNE)') then 'AUSSIE CAR LOANS'
            
            when CMRBroker.cmr_name  in('CREDIT CHOICE FINANCE (BRISBANE)', 'CREDIT CHOICE FINANCE (COBURG)',
                                                      'CREDIT CHOICE FINANCE (PERTH)', 'CREDIT CHOICE FINANCE (SOUTHPORT)',
                                                      'CREDIT CHOICE FINANCE (TOOWOOMBA)', 'CREDIT CHOICE FINANCE (TOWNSVILLE)') then 'CREDIT CHOICE FINANCE'
            
            when CMRBroker.cmr_name  in('CREDIT ONE (SOUTHPORT)') then 'CREDIT ONE'
            when CMRBroker.cmr_name  in('CAPITALCORP FINANCE AND LEASING (BRISBANE)', 'CAPITALCORP FINANCE AND LEASING (CAIRNS)') then 'CAPITALCORP'
            when CMRBroker.cmr_name  in('I NEED FINANCE NOW (BLACKTOWN)', 'I NEED FINANCE NOW (GOLD COAST)') then 'I NEED FINANCE NOW'
            when CMRBroker.cmr_name  in('MONEY NOW (BRAYBROOK)', 'MONEY NOW (BRISBANE)', 'MONEY NOW (CAIRNS)', 'MONEY NOW (MACKAY)', 'MONEY NOW (MINCHINBURY)','MONEY NOW (ROCKHAMPTON)',
                                                      'MONEY NOW (MT WAVERLEY)', 'MONEY NOW (NEWCASTLE)', 'MONEY NOW (PERTH)', 'REGIONAL CREDIT','MONEY NOW (RINGWOOD)') then 'MONEY NOW'
            when CMRBroker.cmr_name  in('NATIONAL FINANCE CHOICE (BRAYBROOK)', 'NATIONAL FINANCE CHOICE (MOORABBIN)', 'NATIONAL FINANCE CHOICE (MT WAVERLEY)',
                                                      'NATIONAL FINANCE CHOICE (WOODCROFT)') then 'NFC'
            when CMRBroker.cmr_name  in('STRATTON FINANCE (BAYSIDE BRISBANE)', 'STRATTON FINANCE (MELBOURNE)', 'STRATTON FINANCE (SOUTH EAST METRO AND HILLS)',
          'STRATTON FINANCE (SYDNEY)') then 'STRATTON FINANCE'
            when CMRBroker.cmr_name  in('TANNASTER (CAMPBELLTOWN)', 'TANNASTER (CLAYTON)', 'TANNASTER (CRANBOURNE)', 'TANNASTER (FRANKSTON)', 'TANNASTER (GEELONG)',
            'TANNASTER (GLENORCHY)', 'TANNASTER (LEASE CONVERSION)', 'TANNASTER (MELTON)', 'TANNASTER (MORPHETT VALE)', 'TANNASTER (NORTHCOTE)',
            'TANNASTER (PFC DEVONPORT)', 'TANNASTER (PFC LAUNCESTON)', 'TANNASTER (PORT ADELAIDE)', 'TANNASTER (PRESTON)', 'TANNASTER (RESERVOIR)',
            'TANNASTER (ROSNY PARK)', 'TANNASTER (SALISBURY)', 'TANNASTER (ST ALBANS)', 'TANNASTER (SUNSHINE)', 'TANNASTER (THOMASTOWN)','TANNASTER (DANDENONG)',
            'TANNASTER (WEB CENTRE)', 'TANNASTER (WERRIBEE)', 'TANNASTER (WODONGA)', 'STAFF LOAN','TANNASTER (MICRO MOTOR)','TANNASTER (PFC HOBART)','TANNASTER (PROSPECT)') then 'MONEY3'
         else CMRBroker.CMR_Name
            end)
