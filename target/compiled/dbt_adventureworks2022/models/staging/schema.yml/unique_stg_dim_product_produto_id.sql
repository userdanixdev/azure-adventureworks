
    
    

select
    produto_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."staging"."stg_dim_product"
where produto_id is not null
group by produto_id
having count(*) > 1


