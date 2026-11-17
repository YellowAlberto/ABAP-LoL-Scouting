@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Serie'
define view entity ZAPV_I_Series
  as select from zapv_series
  association [0..*] to ZAPV_I_Game as _Games  on $projection.SeriesId = _Games.SeriesId
  association [0..1] to ZAPV_I_Team as _Team1  on $projection.Team1Id  = _Team1.TeamId
  association [0..1] to ZAPV_I_Team as _Team2  on $projection.Team2Id  = _Team2.TeamId
  association [0..1] to ZAPV_I_Team as _Winner on $projection.WinnerTeamId = _Winner.TeamId
{
  key series_id      as SeriesId,
      tournament_id  as TournamentId,
      series_format  as SeriesFormat,
      started_at     as StartedAt,
      finished       as IsFinished,
      team1_id       as Team1Id,
      team1_score    as Team1Score,
      team2_id       as Team2Id,
      team2_score    as Team2Score,
      winner_team_id as WinnerTeamId,
      imported_at    as ImportedAt,

      _Games,
      _Team1,
      _Team2,
      _Winner
}
