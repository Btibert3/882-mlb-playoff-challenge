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
        home.team_id     as home_team_id,
        home.team_name   as home_team_name,
        home.league      as home_league,
        home.division    as home_division,

        -- away team
        away.team_id     as away_team_id,
        away.team_name   as away_team_name,
        away.league      as away_league,
        away.division    as away_division,

        g.home_score,
        g.away_score,
        g.home_winner

    from games g
    left join teams home on g.home_team_id = home.team_id
    left join teams away on g.away_team_id = away.team_id
)

select * from joined
