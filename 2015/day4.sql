set variable example = '
ckczppom
';

-- extract input to lines in table
create or replace table input as select regexp_split_to_table(trim(getvariable('example'), E'\n '), '\n\s*') as line;

.timer on -- duckdb cli timer
-- Run Time (s): real 241.645 user 510.018751 sys 317.536221
with recursive nums as (
    select
        1 as id
    union all
    select
        id+1
    from nums
    where id<10000000
),
hash as (
    select
        id,
        md5(line || id::text) as hashed_value
    from nums, input
),
solution_part1 as (
    select id, hashed_value from hash
    where hashed_value like '00000%'
    order by id
    limit 1
),
solution_part2 as (
    select id, hashed_value from hash
    where hashed_value like '000000%'
    order by id
    limit 1
)
select
    'part1' as part,
    hashed_value as answer
from solution_part1
union all 
select
    'part2' as part,
    hashed_value as answer
from solution_part2;