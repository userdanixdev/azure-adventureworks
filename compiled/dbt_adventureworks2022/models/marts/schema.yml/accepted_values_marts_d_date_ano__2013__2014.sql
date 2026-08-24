
    
    

with all_values as (

    select
        ano as value_field,
        count(*) as n_records

    from "free-sql-db-3211278"."marts"."marts_d_date"
    group by ano

)

select *
from all_values
where value_field not in (
    '2013','2014'
)


