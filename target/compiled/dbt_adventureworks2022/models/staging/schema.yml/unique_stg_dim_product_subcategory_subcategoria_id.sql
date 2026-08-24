
    
    

select
    subcategoria_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."staging"."stg_dim_product_subcategory"
where subcategoria_id is not null
group by subcategoria_id
having count(*) > 1


