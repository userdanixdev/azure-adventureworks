
    
    

select
    data_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."staging"."stg_dim_date"
where data_id is not null
group by data_id
having count(*) > 1


