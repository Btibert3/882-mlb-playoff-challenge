with source as (
    select * from {{ source('mlb_raw', 'raw_teams') }}
),

renamed as (
    select
        team_id,
        name     as team_name,
        abbrev   as team_abbrev,
        league,
        division,
        location
    from source
)

select * from renamed
