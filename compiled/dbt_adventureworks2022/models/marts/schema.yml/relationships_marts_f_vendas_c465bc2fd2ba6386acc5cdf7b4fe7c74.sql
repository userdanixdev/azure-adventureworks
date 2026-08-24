
    
    

with child as (
    select produto_id as from_field
    from "free-sql-db-3211278"."marts"."marts_f_vendas"
    where produto_id is not null
),

parent as (
    select produto_id as to_field
    from "free-sql-db-3211278"."staging"."stg_dim_product"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


