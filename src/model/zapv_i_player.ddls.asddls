@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Jugador'
define view entity ZAPV_I_Player
  as select from zapv_player
  association [0..1] to ZAPV_I_Team as _Team on $projection.TeamId = _Team.TeamId
{
  key player_id as PlayerId,
      name      as PlayerName,
      team_id   as TeamId,
      player_role as Role,

      _Team
}
