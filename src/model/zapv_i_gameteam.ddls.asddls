@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Estadisticas equipo por partida'
define view entity ZAPV_I_GameTeam
  as select from zapv_game_team
  association [1..1] to ZAPV_I_Team as _Team on $projection.TeamId = _Team.TeamId
{
  key series_id     as SeriesId,
  key game_seq      as GameSeq,
  key team_id       as TeamId,
      side          as Side,
      won           as Won,
      kills         as Kills,
      deaths        as Deaths,
      net_worth     as NetWorth,
      gold_earned   as GoldEarned,
      damage_dealt  as DamageDealt,
      vision_score  as VisionScore,
      towers        as Towers,
      inhibitors    as Inhibitors,
      dragons       as Dragons,
      elder_dragons as ElderDragons,
      barons        as Barons,
      heralds       as Heralds,
      void_grubs    as VoidGrubs,
      first_tower   as FirstTower,
      first_dragon  as FirstDragon,
      first_herald  as FirstHerald,
      first_baron   as FirstBaron,

      _Team
}
