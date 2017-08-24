

select
	loan.LoanID
	,fact.ApplicationAmount
	,fact.Cash_Out
	,fact.Income
	,fact.Expenses
	,Scalendar.DDMONYYYY as settlementDate
	,Lcalendar.DDMONYYYY as LodgementDate
from fact.fact_Loan_Snapshot fact
left join dim.dim_Loan loan on fact.Loan_sKey=loan.Loan_sKey
left join dim.dim_Calendar Scalendar on fact.Settlement_Date_sKey=Scalendar.Calendar_sKey
left join dim.dim_Calendar Lcalendar on fact.Lodgement_Date_sKey=Lcalendar.Calendar_sKey
where Current_Branch_sKey=(select Branch_sKey from dim.dim_Branch where Branch='Loan Centre')