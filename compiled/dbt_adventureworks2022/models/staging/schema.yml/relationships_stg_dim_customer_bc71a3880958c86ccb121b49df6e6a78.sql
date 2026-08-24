
    
    

with child as (
    select geografia_id as from_field
    from "free-sql-db-3211278"."staging"."stg_dim_customer"
    where geografia_id is not null
),

parent as (
    select geografia_id as to_field
    from "free-sql-db-3211278"."staging"."stg_dim_geography"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


