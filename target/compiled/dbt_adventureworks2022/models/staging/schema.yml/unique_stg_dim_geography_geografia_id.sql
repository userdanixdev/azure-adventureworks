
    
    

select
    geografia_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."staging"."stg_dim_geography"
where geografia_id is not null
group by geografia_id
having count(*) > 1


