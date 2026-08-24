
    
    

select
    cliente_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."marts"."marts_d_clientes"
where cliente_id is not null
group by cliente_id
having count(*) > 1


