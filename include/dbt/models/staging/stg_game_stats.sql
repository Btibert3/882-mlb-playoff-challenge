with source as (
    select * from {{ source('mlb_raw', 'raw_game_stats') }}
),

renamed as (
    select
        game_id,
        side,
        runs,
        hits,
        errors,
        left_on_base,
        is_winner
    from source
)

select * from renamed