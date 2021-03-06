/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [TransactionTypeID]
      ,[Transaction]
      ,[TransactionCompany]
      ,[TransactionGroup]
      ,[TransactionTypeGroup]
      ,[TransactionTypeSubGroup]
      ,[TransactionName]
      ,[Additive]
      ,[IsReversal]
  FROM [MyTestDB].[dbo].[csv$]


  select * from csv$ where TransactionTypeID not in (select XTRM_ID from xtrm$)

 
 update csv$
 set Additive=1
 where TransactionTypeID in (select xtrm_id from xtrm$)

 update csv$
 set Additive=0
 where TransactionTypeID='{E0D583A7-2FD0-4FF5-9CBF-414844BDADEE}'

 update csv$ 
 set TransactionTypeGroup=TransactionGroup, TransactionTypeSubGroup=TransactionGroup
 where TransactionTypeID='{2058fce5-e25f-4aa8-b2f0-1ad0474a1ac0}'

 select * from csv$ where TransactionGroup='Interest'

 select * from csv$ where TransactionGroup like '%Additive%' or TransactionTypeGroup like '%Additive%' or TransactionTypeSubGroup like '%Additive%' 

 select * from xtrm$ where XTRM_ID='{5f4bc663-fa5b-4281-8b1f-4b34a82c2a8c}'


 select * from csv$ where TransactionTypeID not in (select xtrm_id from xtrm$) and Additive=1 and TransactionGroup in ('Fee','Penalties','Cash in','Cash Out', 'Interest')
  --select * from xtrm$ where XTRM_ID in (select TransactionTypeID from csv$)


--t1, isReversal='Transaction' and Additive=1 see Excel Transaction1
if OBJECT_ID('tempdb..#t1') is not null
drop table #t1
create table #t1(id nvarchar(40), detail nvarchar(200))

insert into #t1 (id, detail)
values 

('{d4acf53c-e9e7-446b-8652-207166685e1a}','Money3\Cheque Cashing\Cheque Total Amount'),
('{4ebe6dff-e539-4da3-9177-e0ad340f2c5b}','Money3\Cheque Cashing\Fee'),
('{520934ac-5bd5-4e45-a58e-3105edb2ced9}','Money3\Commission\Commission Paid - Direct Credit'),
('{18d5d62b-66e2-4e2c-96d8-d8cd49ff256c}','Money3\Commission\Commission Paid - Internal'),
('{c71def8a-f18a-46d1-8650-94b2db4731b9}','Money3\Disbursement\BPay'),
('{175097b2-f5b8-453f-933e-22b136b5badb}','Money3\Disbursement\Cash Deferred'),
('{aba6a0b0-7a7f-4ef0-9176-ac5c6afa983c}','Money3\Disbursement\Cash Disbursement'),
('{4fbe3466-0c1b-4b48-b755-fc6b650ecbe8}','Money3\Disbursement\Cheque'),
('{71b22e14-385f-45a8-a389-36559632ff65}','Money3\Disbursement\Direct Credit'),
('{7c9ab385-4985-45ad-87e2-19af9f3d6478}','Money3\Discharge\Discharge Disbursement\Cash'),
('{968fefb0-adc6-4512-8f83-9d8fda90b039}','Money3\Discharge\Discharge Disbursement\Direct Credit'),
('{857a90f4-efa8-4c9f-abbf-19b7057a7b79}','Money3\Discharge\Discharge Payment\BPay'),
('{88d368ae-d2e3-4db4-9880-3de434f3b542}','Money3\Discharge\Discharge Payment\Cash'),
('{8b80a451-3d1a-4097-81ea-959dd2f0d8f6}','Money3\Discharge\Discharge Payment\Cheque'),
('{dc2c3e2a-1594-4058-b10f-73627855f28a}','Money3\Discharge\Discharge Payment\Direct Credit'),
('{9251d213-46b3-4ffe-a59e-675bc7ed8258}','Money3\Discharge\Discharge Payment\Direct Debit'),
('{a3a31f33-534a-4755-8abe-2dd8d3a73e35}','Money3\Fee\Discharge\Discharge Fee'),
('{ffe5fc6b-64ce-42c0-9236-bfcb0c8f02d9}','Money3\Fee\Discharge\Discount on Full Dischage'),
('{ca79a319-7f18-4b98-9033-b8ca3beb3ef3}','Money3\Fee\Discharge\Negotiated Payout on Discharge'),
('{ee9ffc6e-0bbb-4c7d-bce5-228e0f3f9c9c}','Money3\Fee\Loan\Additional Monthly Fees'),
('{7b4ea91e-c309-43f2-b890-5c252be34ae4}','Money3\Fee\Loan\Application Fee'),
('{438a59aa-1d0a-48cf-a55a-6abd2807eed1}','Money3\Fee\Loan\Arrears Letter Fee'),
('{5d85970a-fcd2-4e44-8367-8e7c85f90f30}','Money3\Fee\Loan\Arrears Letter Fee - New'),
('{53df8e13-3cca-4c0d-a682-9015181fa860}','Money3\Fee\Loan\Caveat Fee'),
('{7e4dc81d-b294-4d73-8fbb-f43aa564f8bd}','Money3\Fee\Loan\Credit Fee'),
('{f37874ea-230b-4795-b6bb-fff27bda2b2f}','Money3\Fee\Loan\Default Fee'),
('{798f3a7c-3d4c-4aeb-8b3c-1e295b5b9b55}','Money3\Fee\Loan\Dishonour Fee (NSF) - Loan'),
('{13981284-b6e9-4eaa-b31e-9d33287e2b12}','Money3\Fee\Loan\Monthly Account Fee'),
('{ea33d505-c29c-4afa-9018-303ac7a7ab89}','Money3\Fee\Loan\Monthly Fee'),
('{ce88d442-c040-4d3b-8929-7a34b7c65b29}','Money3\Fee\Loan\Non Payment Fee  - Loan'),
('{15df6716-e868-445c-b242-a9045263a625}','Money3\Fee\Loan\Non Payment Fee  - Loan New'),
('{524db6fd-1c71-47ab-9c8f-1d1841f05a29}','Money3\Fee\Loan\Reschedule Fee'),
('{b8f7bbf0-92bf-4f32-9ce3-c9e1283b4077}','Money3\Fee\Loan\TotalLACCFees'),
('{5146d224-dac4-41e4-93e3-38f13abf388f}','Money3\Fee\Loan\TotalMonthyFees'),
('{6a745a95-fe3e-4a69-8fb3-204be5a0c7a4}','Money3\Fee\Loan\Variation Default Fee'),
('{66fccdf2-8609-4402-b55c-3c5026eacaa6}','Money3\Fee\Loan\Variation Fee'),
('{e2d6802b-a89c-484e-8c9d-cda0c9a268f3}','Money3\Fee\LOC\Application Fee'),
('{bf8c8181-dc96-4e7e-8f2d-c1034c07822c}','Money3\Fee\LOC\Arrears Fee - New'),
('{929f0b0e-8777-40b8-84fb-868d4ba0d971}','Money3\Fee\LOC\Credit Fee'),
('{a951a02c-9b8b-4564-995b-5225c5085f6b}','Money3\Fee\LOC\Default Fee'),
('{8e18b754-8b9d-4142-a018-cfca7b4082cf}','Money3\Fee\LOC\Dishonour Fee'),
('{c6bb3791-3d10-407c-a8ff-f58cb4a445be}','Money3\Fee\LOC\Dishonour Fee (NSF) - LOC'),
('{4ef265f0-8346-4a84-a2b7-a90a68f217b9}','Money3\Fee\LOC\Drawdown Fee'),
('{8da9b6a5-78f6-4036-904e-508a11b6df37}','Money3\Fee\LOC\Non Payment Fee - LOC'),
('{6c0aa92f-83a8-4bad-b163-827e7dd3e54f}','Money3\Fee\LOC\Variation Default Fee'),
('{e1aea824-6817-4d4e-9d12-60ebbfa11a0d}','Money3\Fee\Merchant Agent Fee'),
('{20ea1c5a-3f11-42ab-94bc-2d008413ffce}','Money3\Fee\Special Fee'),
('{f66f2981-ad69-4b51-903b-a2e7eafedc8e}','Money3\Fee\Waive'),
('{7586a77d-1c5b-489f-bcad-4f6cd70e23c5}','Money3\Fee\Waived\Dishonour Fee Waived'),
('{a95480c7-62f7-4147-9d58-0c4859c1dfb0}','Money3\Fee\WaiveDb'),
('{060c5979-653a-4cfd-89ce-d56e4e202aa8}','Money3\Loan\Interest\Interest'),
('{0ca10d4f-b3ad-4841-96ca-73db5a8fe6c8}','Money3\Loan\Interest\Penalty Interest - Loan'),
('{19bfaee2-b601-4077-9d6e-75589010c1f4}','Money3\Loan\Payment\Broker Clawback'),
('{9d57bb56-d2b6-4aef-9165-dcbdfa354997}','Money3\Loan\Payment\Insurance Payout'),
('{be317f39-30b3-4469-a80f-b7443d107391}','Money3\Loan\Payment\Insurance Recall'),
('{3b78e2bc-412d-4e78-927a-e255975efbfd}','Money3\Loan\Payment\Payment (Direct Debit) Capitalise Do not use'),
('{5d21b3ef-7739-4427-85a6-70a1677786f1}','Money3\Loan\Payment\Payment (Direct Debit) Capitalise Effective date next day'),
('{b426962b-3748-4bbf-9232-92ba164dc785}','Money3\Loan\Payment\Payment (Direct Debit) Capitalise next effective dates - Old'),
('{77d7215b-a0ad-495a-86f5-e791f035f335}','Money3\Loan\Payment\Payment (Direct Debit) Capitalise Today'),
('{d41c76d8-b5da-4580-a368-7a9b9ad2e333}','Money3\Loan\Payment\Payment - DebitCard-TransactionFee'),
('{a8136ec2-6d41-4df2-97e2-a92baa39f139}','Money3\Loan\Payment\Payment BPay'),
('{95df5a7c-ba97-45cd-a732-cf9eb4cf4fd0}','Money3\Loan\Payment\Payment Cash'),
('{2f97e453-ddcd-49b7-958d-e85460e5c3cf}','Money3\Loan\Payment\Payment Cheque'),
('{e1365ab7-7216-4d36-9127-8a46e6d7cb02}','Money3\Loan\Payment\Payment DebitCard'),
('{9a77a79c-c8f7-494f-8e9f-48e304dfd652}','Money3\Loan\Payment\Payment Direct Credit Recieved'),
('{7b99c226-70ee-477d-a247-5491f344862b}','Money3\Loan\Payment\Payment Refinanced'),
('{d90943f6-a537-4e04-adc0-7a880260a940}','Money3\Loan\Payment\Payment Salary'),
('{0d09ef16-c8c6-4fd7-aa07-4d40ce7a3d60}','Money3\Loan\Payment\Proceeds from Repossession'),
('{244d60d7-2cef-4e24-8a7d-02c9cab998d1}','Money3\Loan\Payment\Repayment Dishonour Manual'),
('{cde651a4-8f90-4baf-adc5-83e8499eaa3c}','Money3\Loan\Payment\Repayment Dishonour Manual'),
('{e832ac26-3c19-41aa-871c-a08f9b698d69}','Money3\Loan\Payment\Repayment Dishonour NEW'),
('{e94f9a24-9b1e-4275-a740-4fd51c4d3f71}','Money3\LOC\Disbursement\Cash Disbursement - Drawdown'),
('{775161d1-ab1e-435b-93c6-8e6d53fd8bfe}','Money3\LOC\Disbursement\Direct Credit - Drawdown'),
('{c1b0f505-72bd-4f1d-ac11-f45d77e4bf7d}','Money3\LOC\Payment\Payment (Cash)'),
('{f03763e2-eb24-4ca9-bef2-e525ade90ce8}','Money3\LOC\Payment\Payment (Cheque)'),
('{468824e4-f92e-428c-8000-de9d68619d23}','Money3\LOC\Payment\Payment (Direct Debit) Capitalise Today'),
('{d685de8f-4009-4968-9fe6-bd63de507376}','Money3\LOC\Payment\Payment (Salary)'),
('{3a708976-2f8d-458c-bc45-dd23d1d4d2a0}','Money3\MoneyGram\Disbursement\Amount Sent'),
('{a97c5fcc-5625-48d2-9aeb-463e7cf7ab58}','Money3\MoneyGram\Disbursement\Cash (Received)'),
('{8fd616f5-118f-4cc4-acfa-a9c48944edd8}','Money3\MoneyGram\Disbursement\Cash (Sent)'),
('{fb389b3e-43ec-4300-9445-c11403945d82}','Money3\MoneyGram\Disbursement\MoneyGram Fee'),
('{10dd208f-f453-4323-af7f-ef3a2a44df86}','Money3\Insurance\Equity Plus Insurance'),
('{4b133079-a16a-4859-86e5-34b2963bce5e}','Money3\Insurance\Comprehensive Insurance'),
('{64228cb1-9fde-4d45-9d9c-ac93b8177fb5}','Money3\Fee\ERD Discount'),
('{ab16bf8d-a13b-4af4-9ecf-f52aac361f22}','Money3\Rental\Lease Abandoned - Vehicle Returned'),
('{ebe294bf-5609-4ab7-b904-b1576c2fc836}','Money3\Insurance\GAP/Equity Insurance'),
('{f1d448c2-d6dd-4e45-bb47-bab3f955d30a}','Money3\Insurance\Extended Warranty'),
('{1d80d541-cd59-4e75-90d5-6c48e9c326ca}','Money3\Loan\Payment\Repayment Dishonour - Cheque'),
('{274ab776-dbd9-4187-9621-2a5f08c68ab4}','Money3\Discharge\Discharge Disbursement\Cheque'),
('{335c9ed6-5f11-4ca3-929c-46ecae08d729}','Money3\Rental\Loan Add Ons'),
('{5edc0205-20a8-4e8d-872f-3a12b24ad271}','Money3\Fee\Loan\Tax Agent Fee'),
('{6a4dfee3-1090-4ae2-9421-079da332406c}','Money3\Fee\Loan\Establishment Fee'),
('{a078d5d1-36d7-4b6f-b9c7-7a1649efaa90}','Money3\Rental\Adjust Up - Initial Rental Amount'),
('{b024482a-6f8c-48af-bc0c-7b4ec926db1b}','Money3\Insurance\Total Assist'),
('{d271376c-6495-43a6-8d21-1df2784400a5}','Money3\Insurance\Cash Benefit'),
('{03f89803-662f-4234-bf8e-b59296b4961f}','Money3\Insurance\Loan Termination Insurance'),
('{1711bd64-942a-456a-b723-e65d3c877a89}','Money3\Loan\Payment\Repayment Dishonour OLD'),
('{355d522c-02fb-4392-92fe-d5a32a8df435}','Money3\Fee\Auction House Fee'),
('{532699e4-14a2-47c9-bc3f-3cc6f16ca813}','Money3\Rental\Adjust Down - Initial Rental Amount'),
('{5f4bc663-fa5b-4281-8b1f-4b34a82c2a8c}','Money3\Loan\Interest\Interest Adjustment (CR)'),
('{844b24ea-96c6-4a34-8e29-02f05406db15}','Money3\Rental\Fines'),
('{86b90c31-7d4c-407d-ac5e-ab39a83ab88e}','Money3\Insurance\Loan Protection'),
('{8d8555e4-a6b5-4b89-a097-4ce6e11ed478}','Money3\Fee\WaiveCr'),
('{98284444-284e-44e1-a04b-7c4d6d984f8a}','Money3\Rental\Payment Direct Credit Recieved'),
('{b3452828-3b39-485b-80ef-7a680a02a7ff}','Money3\Conversion\Original Loan Amount'),
('{ca70780d-3010-4011-8263-5fa438d612db}','Money3\Insurance\Consumer Credit Insurance'),
('{cfaa6035-dc9e-49fd-ba1e-4917282f86a4}','Money3\Insurance\Tyre'),
('{d07f93a7-f98c-42b8-9953-a9a62879035e}','Money3\Insurance\Purchase Price Protection'),
('{f6260e2e-aa78-400a-8c8d-17af33ae0aaf}','Money3\Conversion\Original Received (since loan started)'),
('{258561e7-1a5c-46df-a5fc-b565b854bd69}','Money3\Rental\Termination Adjustment'),
('{3ad692bd-b95c-4076-a92c-6df406dd7d15}','Money3\Disbursement\Initial Rental Amount'),
('{9bba1416-e284-49b7-9eb8-9338afa9d139}','Money3\Insurance\Marine Warranty'),
('{a09e0d9c-fe06-4404-b3b6-d454248bbae8}','Money3\Insurance\Complete Car Care Cover'),
('{c151b776-f6c8-4f36-aa5a-bab1cdb7e7c7}','Money3\Fee\Rentals\Vehicle Penalty Fee'),
('{f332dcd2-e166-4b3a-92ab-be98a61be431}','Money3\Insurance\Walkaway Insurance'),
('{020b0792-9879-4efe-82c5-bfc3d36d1a53}','Money3\Fee\Waived\Money3 Waived (Credit)'),
('{7906e72d-a07d-483f-a827-77e5ea6340b6}','Loan\AUFee\Dishonour Fee'),
('{9d9bd706-59d5-4961-b8b6-377d4dd03c58}','Loan\Fee\Application Fee Variable'),
('{ace232e8-0025-4daf-8535-4e31e55ce71f}','Loan\Payment\Repayment (Salary Payment)'),
('{5015f0a3-8759-462c-ae67-16796e541ab2}','Money3\Fee\Rentals\Whitegoods Penalty Fee'),
('{8c250320-2b75-4174-b5d0-78d3ed2892e4}','Cash\Transfer Out'),
('{3fdb41a1-c23f-4173-8fca-d2374962306e}','Money3\Fee\Loan\Monthly Account Fee - Payment'),
('{67440f09-f0ef-4371-9613-f58645bef916}','Money3\Rental\Excess Charge'),
('{19251fb5-5a82-4abf-bfc9-c6ee49cf34a4}','Cash\Transfer In'),
('{369d0352-6702-44dc-86a5-aa1e63d43a28}','Money3\LOC\Payment\Payment (Direct Debit) Capitalise next effective dates'),
('{c76d3e8d-782a-45b3-b95d-a0214fcc9c77}','Money3\MoneyGram\Disbursement\Amount Received'),
('{797c1245-adc5-4d1e-ba29-8b006431c89a}','Money3\Refund\Refund Direct Credit'),
('{6089ea50-f311-4e49-a0e2-ee3a3929b957}','Money3\Refund\Refund Cash Disbursement'),
('{a3b0de41-3a2b-4ce4-8172-92f5151ce2ca}','Money3\Insurance\Fire And Theft'),
('{192dd338-5c35-4d4e-92a5-ebe24c898df0}','Money3\Fee\Reversal\Fee Refund'),
('{da055382-b433-4c13-aa25-9d78d9515881}','Money3\Insurance\Third Party Fire And Theft'),
('{5B3054B0-B472-4DAA-9D17-986A69A9FF4E}','Loan\Fee\Redraw Fee'),
('{fb20e33c-ee26-42f9-9609-5935d705cd2f}','Money3\Loan\Interest\Penalty Interest - LOC'),
('{11b97a98-36e5-4be5-a012-aa9bb0b43b32}','Money3\Conversion\Original Application Fee'),
('{164ae593-c995-4046-a049-921960de3d5d}','Money3\Conversion\Original Total Draw Down'),
('{2e598b60-1587-4a4f-9565-436d6e935a03}','Money3\Conversion\Original Additional Credit Fee'),
('{5ee84a21-7157-4672-bdf1-bf48f75c74e0}','Money3\Conversion\Original Monthly Admin Fee'),
('{66f238c2-1390-487f-bc96-35a832dc6477}','Money3\Conversion\Original Monthly Fee'),
('{83c4bb7a-81f0-4b52-afa0-3ef43c3601fb}','Money3\Conversion\Original Interest Charged'),
('{a90e7573-9b7b-4432-81a1-0a58bd1d4892}','Money3\Conversion\Original Penalty Fee'),
('{b52654dd-8195-43aa-a520-7f258e665ebe}','Money3\Refund\Easter Promo Refund'),
('{bd306aa5-d106-4094-9a79-f62671e99d76}','Money3\Conversion\Original Waived Credit'),
('{d996effd-3ef3-4b52-8df6-e5d943d0f9d4}','Money3\Conversion\Original Credit Fee'),
('{df705e39-0448-487e-9668-237615051925}','Money3\Loan\Payment\Payment (Direct Debit)'),
('{ee590c96-93c9-4362-a422-029d1e1e8a78}','Money3\Insurance\Third Party'),
('{f41aa263-f898-4b1e-a055-570f940c5500}','Money3\Conversion\Original Other Fees'),
('{fa33558d-7892-4f3f-a1ae-4dfd0fd7a703}','Money3\Fee\Loan\Application Fee Discount')



select * from #t1 where id not in
(select XTRM_ID from xtrm$)-- where XTRM_Detail not like '%Revers%')



  select * from csv$ where [Transaction] like '%Refund%' or [Transaction] like '%Dishonour%' or [Transaction] like '%Waive%' or [Transaction] like '%Discount%'

  select * from csv$ where Additive=0
  and TransactionTypeID not in (select TransactionTypeID from csv$ where TransactionGroup like '%Additive%' or TransactionTypeGroup like '%Additive%' or TransactionTypeSubGroup like '%Additive%' )
