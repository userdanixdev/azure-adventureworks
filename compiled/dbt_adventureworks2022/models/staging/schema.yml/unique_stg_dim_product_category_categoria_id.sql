
    
    

select
    categoria_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."staging"."stg_dim_product_category"
where categoria_id is not null
group by categoria_id
having count(*) > 1


