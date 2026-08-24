
    
    

select
    produto_id as unique_field,
    count(*) as n_records

from "free-sql-db-3211278"."marts"."marts_d_produtos"
where produto_id is not null
group by produto_id
having count(*) > 1


