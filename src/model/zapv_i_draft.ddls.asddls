@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Accion de draft (pick/ban)'
define view entity ZAPV_I_Draft
  as select from zapv_draft
  association [1..1] to ZAPV_I_Team     as _Team     on $projection.TeamId     = _Team.TeamId
  association [1..1] to ZAPV_I_Champion as _Champion on $projection.ChampionId = _Champion.ChampionId
{
  key series_id   as SeriesId,
  key game_seq    as GameSeq,
  key action_seq  as ActionSeq,
      action_type as ActionType,
      team_id     as TeamId,
      champion_id as ChampionId,
      // Fase del draft: 1-6 bans, 7-12 picks, 13-16 bans, 17-20 picks
      case
        when action_seq <= 12 then 1
        else 2
      end         as DraftPhase,

      _Team,
      _Champion
}
