SET NOCOUNT ON

select  'a' a, 
        'b' b
into    #temp

select  *
from    #temp

drop table #temp