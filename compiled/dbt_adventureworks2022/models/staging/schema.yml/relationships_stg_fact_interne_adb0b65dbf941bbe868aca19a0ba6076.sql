
    
    

with child as (
    select data_envio_id as from_field
    from "free-sql-db-3211278"."staging"."stg_fact_internet_sales"
    where data_envio_id is not null
),

parent as (
    select data_id as to_field
    from "free-sql-db-3211278"."staging"."stg_dim_date"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


