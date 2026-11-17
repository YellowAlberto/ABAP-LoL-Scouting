@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Estadisticas jugador por partida'
define view entity ZAPV_I_GamePlayer
  as select from zapv_game_player
  association [1..1] to ZAPV_I_Player   as _Player   on $projection.PlayerId   = _Player.PlayerId
  association [1..1] to ZAPV_I_Team     as _Team     on $projection.TeamId     = _Team.TeamId
  association [1..1] to ZAPV_I_Champion as _Champion on $projection.ChampionId = _Champion.ChampionId
{
  key series_id     as SeriesId,
  key game_seq      as GameSeq,
  key player_id     as PlayerId,
      team_id       as TeamId,
      champion_id   as ChampionId,
      kills         as Kills,
      deaths        as Deaths,
      assists       as Assists,
      kda           as Kda,
      kill_part_pct as KillParticipationPct,
      damage_dealt  as DamageDealt,
      damage_pct    as DamageSharePct,
      net_worth     as NetWorth,
      gold_earned   as GoldEarned,
      vision_score  as VisionScore,

      _Player,
      _Team,
      _Champion
}
