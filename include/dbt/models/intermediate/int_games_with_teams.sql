with games as (
    select * from {{ ref('stg_games') }}
),

teams as (
    select * from {{ ref('stg_teams') }}
),

joined as (
    select
        g.game_id,
        g.game_date,
        g.venue,

        -- home team
        home.team_name   as home_team_name,
        home.league      as home_league,
        home.division    as home_division,

        -- away team
        -- TODO: add the away team columns here, using the away alias below

        g.home_score,
        g.away_score,
        g.home_winner

    from games g
    left join teams home on g.home_team_id = home.team_id

    -- TODO: join teams a second time for the away team
    --       give it a different alias so SQL knows which teams table you mean
)

select * from joined
