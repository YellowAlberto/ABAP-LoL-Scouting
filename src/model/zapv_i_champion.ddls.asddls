@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LoL - Campeon'
define view entity ZAPV_I_Champion
  as select from zapv_champion
{
  key champion_id as ChampionId,
      name        as ChampionName
}
