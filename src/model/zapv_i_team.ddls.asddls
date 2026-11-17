@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Equipo'
define view entity ZAPV_I_Team
  as select from zapv_team
{
  key team_id as TeamId,
      name    as TeamName
}
