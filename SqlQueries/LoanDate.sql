/*
This is an attempt to record RCD id's as they are used. Feel free to update
6 - Settlement date
11 - Anticipated Discharge date
12 - Anticipated Settlement Date
30 - Document Sent
32 - Settlement Booked
41 - Reviewed
42 - Rollover
1008 - Commitment date
2000 - Money3\Dates\Identification Check Date plus 12 Months2 Field 15026
10001 - Capitalisation
130000 - set loc date
130001 - set Pre Approval
130002 - set Last Active 
130003 - Last Dishonour date
130004 - Arrears letter
130005 - Default letter
130006 - Payment Request Letter
130007 - Payment request 1st letter
130008 - set Disbursement Date
130009 - Last succesful date
130010 - set settlement Date Temporary
130020 - Payment Plan date
130021 - Special arrangement date
130022 - Special arrangement expiry date
130023 - Hardship expiry date
130024 - Hardship date
130040 - New Maturity payment schedule Date
130050 - Original Maturity date

106 - Lodge date
2 - Approve date
6 - Settlement date
3 - Discharge date


*/





Select RCD_CurrentStart 
From iO_Product_ControlDate 
Where RCD_IDLink_RMR = '@AccountID' 
And RCD_Type = 106 --//Lodge date

