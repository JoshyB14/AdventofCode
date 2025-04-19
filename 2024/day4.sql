set variable input = '
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
';


create or replace table example as select regexp_split_to_table(trim(getvariable('input'), E'\n '), '\n\s*') as line;

with tokens AS (
        SELECT
            generate_subscripts(tokens, 1) as idx,
            idy,
            (idy - 1)*length(tokens) + idx as pos,
            unnest(tokens) as token,
            idx - idy as d1, 
            idx + idy as d2
        FROM (
            SELECT
                row_number() OVER () as idy,
                string_split(line, '') as tokens,
            FROM example
        )
),
slices AS (
        SELECT
            idx,
            idy,
            unnest([
                -- horizontal & vertical
                string_agg(token, '') OVER (PARTITION BY idy ORDER BY idx asc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY idy ORDER BY idx desc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY idx ORDER BY idy asc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY idx ORDER BY idy desc ROWS 3 PRECEDING),
                -- diagonal
                string_agg(token, '') OVER (PARTITION BY d1 ORDER BY pos asc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY d1 ORDER BY pos desc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY d2 ORDER BY pos asc ROWS 3 PRECEDING),
                string_agg(token, '') OVER (PARTITION BY d2 ORDER BY pos desc ROWS 3 PRECEDING)
            ]) as slice
        FROM tokens
),
boxes AS (
        SELECT
            idx,
            idy,
            string_agg(slice, '') OVER (PARTITION BY idx ORDER BY idy asc ROWS 2 PRECEDING) as box
        FROM (
            SELECT
                idx,
                idy,
                string_agg(token, '') OVER (PARTITION BY idy ORDER BY idx asc ROWS 2 PRECEDING) as slice
            FROM tokens
        )
),
solution AS (
        SELECT
            (SELECT count() FILTER (slice = 'XMAS') FROM slices) as part1,
            (SELECT count() FILTER (box SIMILAR TO 'M.M.A.S.S|M.S.A.M.S|S.S.A.M.M|S.M.A.S.M') FROM boxes) as part2
    )
select * from solution;