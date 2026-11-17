@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Estadisticas por campeon'
define view entity ZAPV_I_ChampionStats
  as select from    zapv_draft     as d
    inner join      zapv_champion  as c  on  c.champion_id = d.champion_id
    left outer join zapv_game_team as gt on  gt.series_id  = d.series_id
                                         and gt.game_seq   = d.game_seq
                                         and gt.team_id    = d.team_id
{
  key d.champion_id as ChampionId,
      c.name        as ChampionName,

      sum( case d.action_type when 'PICK' then 1 else 0 end ) as Picks,
      sum( case d.action_type when 'BAN'  then 1 else 0 end ) as Bans,
      sum( case when d.action_type = 'PICK' and gt.won = 'X' then 1 else 0 end ) as Wins,
      count( * )                                              as PicksAndBans
}
group by
  d.champion_id,
  c.name
