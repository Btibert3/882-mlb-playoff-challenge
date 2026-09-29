with source as (
    select * from {{ source('mlb_raw', 'raw_games') }}
),

renamed as (
    select
        game_id,
        game_date,
        home_team_id,
        away_team_id,
        venue,
        home_score,
        away_score,
        home_winner
    from source
    qualify row_number() over (partition by game_id order by game_date) = 1 
)

select * from renamed