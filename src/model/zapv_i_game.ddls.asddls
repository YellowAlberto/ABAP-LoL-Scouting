@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Partida'
define view entity ZAPV_I_Game
  as select from zapv_game
  association [1..1] to ZAPV_I_Series     as _Series  on  $projection.SeriesId = _Series.SeriesId
  association [0..*] to ZAPV_I_GameTeam   as _Teams   on  $projection.SeriesId = _Teams.SeriesId
                                                      and $projection.GameSeq  = _Teams.GameSeq
  association [0..*] to ZAPV_I_GamePlayer as _Players on  $projection.SeriesId = _Players.SeriesId
                                                      and $projection.GameSeq  = _Players.GameSeq
  association [0..*] to ZAPV_I_Draft      as _Draft   on  $projection.SeriesId = _Draft.SeriesId
                                                      and $projection.GameSeq  = _Draft.GameSeq
{
  key series_id                    as SeriesId,
  key game_seq                     as GameSeq,
      game_id                      as GameId,
      patch                        as Patch,
      started_at                   as StartedAt,
      duration_sec                 as DurationSec,
      division( duration_sec, 60, 1 ) as DurationMin,
      is_valid                     as IsValid,
      blue_team_id                 as BlueTeamId,
      red_team_id                  as RedTeamId,
      winner_team_id               as WinnerTeamId,

      _Series,
      _Teams,
      _Players,
      _Draft
}
