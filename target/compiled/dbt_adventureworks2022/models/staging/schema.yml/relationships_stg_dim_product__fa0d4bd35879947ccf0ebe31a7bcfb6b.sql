
    
    

with child as (
    select categoria_id as from_field
    from "free-sql-db-3211278"."staging"."stg_dim_product_subcategory"
    where categoria_id is not null
),

parent as (
    select categoria_id as to_field
    from "free-sql-db-3211278"."staging"."stg_dim_product_category"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


