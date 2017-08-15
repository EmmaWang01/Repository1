
select * from iO_Control_StatusMaster where XSU_IDUser in
 (
	197,198,199,266,130018,130032,130019,130020,130021,130022,130023,130025,130026,
	800058,800054,800059,800052,800053,660313,800051,800060,800057,800061,800056,800055	
 )



select
Case

When @Field(130002) = 660310 then 1		/*	Enquiry	*/
When @Field(130002) = 1 then 1			/*	Money3\Application - Incomplete Application	*/
When @Field(130002) = 2 then 1			/*	Money3\Application - Marked for Deletion	*/
When @Field(130002) = 197 then 2		/*	Money3\Debt Recovery\1-31			*/	
When @Field(130002) = 198 then 2		/*	Money3\Debt Recovery\External			*/
When @Field(130002) = 199 then 2		/*	Money3\Debt Recovery\P/Plans			*/
When @Field(130002) = 248 then 1		/*	Money3\Application - Application Received	*/
When @Field(130002) = 266 then 2		/*	Money3\Current					*/
When @Field(130002) = 268 then 1		/*	Money3\Application - Unsuccessful		*/
When @Field(130002) = 130003 then 1		/*	Money3\Application - Pending			*/	
When @Field(130002) = 130004 then 1		/*	Money3\Application - Application Approved	*/
When @Field(130002) = 130005 then 3		/*	Money3\Discharged - Paid in Full		*/
When @Field(130002) = 130006 then 1		/*	Money3\Application - Application Cancelled	*/
When @Field(130002) = 130011 then 1		/*	Money3\Application - Awaiting Further Documents	*/
When @Field(130002) = 130012 then 1		/*	Money3\Application - Pre Approved		*/
When @Field(130002) = 130013 then 1		/*	Money3\Application - Pending Settlement		*/
When @Field(130002) = 130014 then 1		/*	Money3\Application - Withdrawn/Cancelled	*/
When @Field(130002) = 130015 then 1		/*	Money3\Application - Redirect			*/		
When @Field(130002) = 130016 then 3		/*	Money3\Discharged - Paid in full early discount	*/
When @Field(130002) = 130017 then 3		/*	Money3\Discharged - Negotiated payout		*/
When @Field(130002) = 130018 then 2		/*	Money3\Arrears - Hold				*/
When @Field(130002) = 130032 then 2		/*	Money3\LACC - Hold				*/
When @Field(130002) = 130019 then 2		/*	Money3\Arrears - Payment Plan			*/
When @Field(130002) = 130020 then 2		/*	Money3\Arrears - Arrears Letter			*/
When @Field(130002) = 130021 then 2		/*	Money3\Arrears - Default			*/
When @Field(130002) = 130022 then 2		/*	Money3\Arrears - Recoveries			*/
When @Field(130002) = 130023 then 2		/*	Money3\Discharged - Written Off			*/
When @Field(130002) = 130024 then 3		/*	Money3\Internal Current				*/
When @Field(130002) = 130025 then 2		/*	Money3\Arrears - Special Arrangement		*/
When @Field(130002) = 130026 then 2		/*	Money3\Arrears - Hardship			*/
When @Field(130002) = 130028 then 1		/*	Money3\Settlements - Waiting on Additional Credit Req*/
When @Field(130002) = 130029 then 1		/*	Money3\Settlements - Waiting on References	*/
When @Field(130002) = 130030 then 1		/*	Money3\Settlements - Waiting on Welcome Call	*/
When @Field(130002) = 800050 then 1		/*	Money3\Application - Unsuccessful - To Be Reviewed*/
When @Field(130002) = 80011  then 1		/*	Money3\Application - Awaiting Emp/Rental	*/		
When @Field(130002) = 800058 then 2		/*	Money3\Collections\Active\Legal\Judgement	*/
When @Field(130002) = 800054 then 2		/*	Money3\Collections\Active\External		*/
When @Field(130002) = 800063 then 3		/*	Money3\Collections\InActive\Dead File		*/
When @Field(130002) = 800059 then 2		/*	Money3\Collections\Active\Legal\Attachment	*/
When @Field(130002) = 800052 then 2		/*	Money3\Collections\Active\Still to Action	*/
When @Field(130002) = 800053 then 2		/*	Money3\Collections\Active\Payment Plan		*/
When @Field(130002) = 660313 then 2		/*	Money3\Collections\Active\DDR Attempt		*/
When @Field(130002) = 800051 then 2		/*	Money3\Collections\Active\Investigating		*/
When @Field(130002) = 800060 then 2		/*	Money3\Collections\Active\Part IX		*/
When @Field(130002) = 800057 then 2		/*	Money3\Collections\Active\Legal\Court		*/
When @Field(130002) = 800062 then 3		/*	Money3\Collections\InActive\Settled		*/
When @Field(130002) = 800061 then 2		/*	Money3\Collections\Active\Part X		*/
When @Field(130002) = 800065 then 3		/*	Money3\Collections\InActive\Dormant		*/
When @Field(130002) = 800064 then 3		/*	Money3\Collections\InActive\Bankrupt		*/
When @Field(130002) = 800056 then 2		/*	Money3\Collections\Active\Legal\Served		*/
When @Field(130002) = 800055 then 2		/*	Money3\Collections\Active\Legal\Legal		*/
When @Field(130002) = 660316 then 1		/*	Money3\Application - Bank Details	*/	
When @Field(130002) = 660321 then 1		/*	Money3\Application - Bank Statements Lookup	*/	
When @Field(130002) = 660319 then 1		/*	Money3\Application - Esign	*/	
When @Field(130002) = 660318 then 1		/*	Money3\Application - Credit Guide	*/		
When @Field(130002) = 660324 then 1		/*	Money3\Application - Extra Documents Needed	*/	
When @Field(130002) = 660320 then 1		/*	Money3\Application - Amended Esign	*/	
When @Field(130002) = 660315 then 1		/*	Money3\Application - Personal Details	*/	
When @Field(130002) = 660322 then 1		/*	Money3\Application - Application Complete	*/	
When @Field(130002) = 660317 then 1		/*	Money3\Application - C4 Assessment	*/
When @Field(130002) = 660337 then 1		/*	Money3\Application - Extra Documents Needed - ID	*/	
When @Field(130002) = 660338 then 1		/*	Money3\Application - Extra Documents Needed - Statement	*/	
When @Field(130002) = 660339 then 1		/*	Money3\Application - Extra Documents Needed - ID & Statement	*/	

else 1

end

/* 
1 = Credit Status/Pre Current
2 = Current/Arrears
4 = Settlement Status/Pre Current (approval aloud)
3 = Discharged
5 = Pre Assessment
*/