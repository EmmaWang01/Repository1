


Declare @Temp As Table (Id Int,Name Varchar(100))

Insert Into @Temp values(1,'A'),(1,'B'),(1,'C'),(1,'D'),(1,'E'),(1,'F'),(1,'G'),(1,'H'),(1,'I'),(1,'J'),(1,'K')

select * from @temp

Select 
		','+ z.Name 
from @Temp Z  For XML Path('') 


Select 
    R.ID, 
    stuff((Select ','+ z.Name from @Temp Z Where R.Id =Z.Id For XML Path('')),1,1,'')
from @Temp R
Group by R.ID