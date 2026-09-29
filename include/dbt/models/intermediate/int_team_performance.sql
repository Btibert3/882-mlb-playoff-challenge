with game_stats as (
    select * from {{ ref('stg_game_stats') }}
),

games as (
    select * from {{ ref('int_games_with_teams') }}
),

-- Each game has two rows in stg_game_stats (home + away).
-- Join to games to resolve team_id and opponent runs for each side.
home_stats as (
    select
        g.home_team_id          as team_id,
        'home'                  as side,
        gs.runs                 as runs_scored,
        opp.runs                as runs_allowed,
        gs.hits,
        gs.errors,
        gs.is_winner            as won
    from game_stats gs
    join games g    on gs.game_id = g.game_id and gs.side = 'home'
    join game_stats opp on opp.game_id = gs.game_id and opp.side = 'away'
),

away_stats as (
    select
        g.away_team_id          as team_id,
        'away'                  as side,
        gs.runs                 as runs_scored,
        opp.runs                as runs_allowed,
        gs.hits,
        gs.errors,
        gs.is_winner            as won
    from game_stats gs
    join games g    on gs.game_id = g.game_id and gs.side = 'away'
    join game_stats opp on opp.game_id = gs.game_id and opp.side = 'home'
),

combined as (
    select * from home_stats
    union all
    select * from away_stats
),

aggregated as (
    select
        team_id,
        count(*)                                        as games_played,
        sum(case when won then 1 else 0 end)            as wins,
        sum(case when not won then 1 else 0 end)        as losses,
        round(
            sum(case when won then 1 else 0 end) * 1.0 / count(*), 3
        )                                               as win_pct,
        sum(runs_scored)                                as total_runs_scored,
        sum(runs_allowed)                               as total_runs_allowed,
        sum(runs_scored) - sum(runs_allowed)            as run_differential,
        round(avg(runs_scored), 2)                      as avg_runs_per_game,
        -- home/away splits
        sum(case when side = 'home' and won then 1 else 0 end) as home_wins,
        sum(case when side = 'home' then 1 else 0 end)         as home_games,
        sum(case when side = 'away' and won then 1 else 0 end) as away_wins,
        sum(case when side = 'away' then 1 else 0 end)         as away_games,
        sum(hits)                                       as total_hits,
        sum(errors)                                     as total_errors
    from combined
    group by team_id
)

select * from aggregated