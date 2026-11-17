"! Carga datos reales de ejemplo (Worlds 2026, serie 3012986: Gen.G vs Bilibili Gaming)
"! extraidos de la API Series State de GRID. Ejecutar con F9 en ADT.
"! Sirve para trabajar en las fases 1-2 sin depender de la API.
CLASS zcl_apv_demo_data DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS clear_tables.
    METHODS fill_master_data.
    METHODS fill_series.
ENDCLASS.


CLASS zcl_apv_demo_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    clear_tables( ).
    fill_master_data( ).
    fill_series( ).

    SELECT COUNT( * ) FROM zapv_game        INTO @DATA(lv_games).
    SELECT COUNT( * ) FROM zapv_game_player INTO @DATA(lv_players).
    SELECT COUNT( * ) FROM zapv_draft       INTO @DATA(lv_draft).
    out->write( |Datos cargados: { lv_games } partidas, { lv_players } filas de jugador, { lv_draft } acciones de draft.| ).
  ENDMETHOD.


  METHOD clear_tables.
    DELETE FROM zapv_draft.
    DELETE FROM zapv_game_player.
    DELETE FROM zapv_game_team.
    DELETE FROM zapv_game.
    DELETE FROM zapv_series.
    DELETE FROM zapv_champion.
    DELETE FROM zapv_player.
    DELETE FROM zapv_team.
    DELETE FROM zapv_tournament.
  ENDMETHOD.


  METHOD fill_master_data.
    DATA lt_tournaments TYPE STANDARD TABLE OF zapv_tournament WITH EMPTY KEY.
    DATA lt_teams       TYPE STANDARD TABLE OF zapv_team       WITH EMPTY KEY.
    DATA lt_players     TYPE STANDARD TABLE OF zapv_player     WITH EMPTY KEY.
    DATA lt_champions   TYPE STANDARD TABLE OF zapv_champion   WITH EMPTY KEY.

    lt_tournaments = VALUE #(
        ( tournament_id = '831635' name = 'Worlds - 2026 (Knockouts: Knockouts)' ) ).

    lt_teams = VALUE #(
        ( team_id = '47558' name = 'Gen.G Esports' )
        ( team_id = '356' name = 'BILIBILI GAMING' ) ).

    " La API no devuelve el rol (roles = []): lo mantenemos a mano en el maestro de jugadores
    lt_players = VALUE #(
        ( player_id = '21335' name = 'Kiin' team_id = '47558' player_role = 'TOP' )
        ( player_id = '21233' name = 'Canyon' team_id = '47558' player_role = 'JUNGLE' )
        ( player_id = '22132' name = 'Duro' team_id = '47558' player_role = 'SUPPORT' )
        ( player_id = '22958' name = 'Chovy' team_id = '47558' player_role = 'MID' )
        ( player_id = '22090' name = 'Ruler' team_id = '47558' player_role = 'BOT' )
        ( player_id = '27265' name = 'Viper' team_id = '356' player_role = 'BOT' )
        ( player_id = '25485' name = 'ON' team_id = '356' player_role = 'SUPPORT' )
        ( player_id = '21575' name = 'Knight' team_id = '356' player_role = 'MID' )
        ( player_id = '20759' name = 'Xun' team_id = '356' player_role = 'JUNGLE' )
        ( player_id = '24854' name = 'Bin' team_id = '356' player_role = 'TOP' ) ).

    lt_champions = VALUE #(
        ( champion_id = 'a493c24b-17f8-34e5-ba90-0bdb40523099' name = 'Akali' )
        ( champion_id = '9104bd4f-7d7d-3895-8151-d3210b34e3d2' name = 'Alistar' )
        ( champion_id = '6d94812f-ea1f-3460-80b7-c38518abb709' name = 'Ambessa' )
        ( champion_id = 'b3007001-25a5-3a10-91bc-0bdb5dac0ae7' name = 'Annie' )
        ( champion_id = '2bf2eedb-58ef-39d3-8be6-88508b55ffc3' name = 'Aurora' )
        ( champion_id = 'd5df6ed8-d7a4-3964-a295-cde171d889ae' name = 'Camille' )
        ( champion_id = 'b51404e9-0865-3237-90a7-9d8747f6bf30' name = 'Cassiopeia' )
        ( champion_id = 'bacc778e-19db-33cb-b045-500e57bde996' name = 'Cho''Gath' )
        ( champion_id = 'e7a28e21-1e51-3ff4-ae76-2e7dc7a69ace' name = 'Corki' )
        ( champion_id = '3a52e342-5377-32b9-935f-b54a66688acd' name = 'Ezreal' )
        ( champion_id = 'aeab401d-5c3e-38d6-8bb5-fe87f6db1a6f' name = 'Galio' )
        ( champion_id = '717061ba-4e85-30e1-9340-aef80368dfa0' name = 'Gnar' )
        ( champion_id = '3d6dd0f6-f96f-3375-84f6-86ac9ff68538' name = 'Gwen' )
        ( champion_id = 'bbd16ab8-92ed-3f82-8748-b23c20eca335' name = 'Jarvan IV' )
        ( champion_id = 'df57a4ea-3f1a-3e5f-9a38-4589c6966fde' name = 'Jax' )
        ( champion_id = 'fa136dcc-94b9-35e2-aaff-cc4c2c46f7a3' name = 'Jayce' )
        ( champion_id = '5748a92e-ed31-3fbf-854d-a37923f7c7ae' name = 'Jhin' )
        ( champion_id = '40cc8559-a028-35a5-a6dd-5e48c4601d66' name = 'K''Sante' )
        ( champion_id = '16e85313-6510-315b-83f5-13f437b191c3' name = 'Kai''Sa' )
        ( champion_id = 'a0cf8bf6-39d8-30fb-9dab-c1e8af747901' name = 'Kalista' )
        ( champion_id = '13af2c2a-1e39-3d26-a475-a9da5267b863' name = 'Karma' )
        ( champion_id = 'dad13cc6-586d-3cf3-b149-6c70969ab14c' name = 'Kindred' )
        ( champion_id = 'a0b6984e-e1ec-3e4c-a98d-34a6ba4aec9f' name = 'Lee Sin' )
        ( champion_id = '019f1759-e612-7308-b507-a491cdafebfe' name = 'Locke' )
        ( champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab' name = 'Lulu' )
        ( champion_id = 'e9dae12d-a8bd-3a92-9851-3a10c20acabd' name = 'Naafiri' )
        ( champion_id = 'ecbbe9a4-9956-3828-b9d1-e5c148eb7959' name = 'Nami' )
        ( champion_id = '5fb5f03b-af85-31e8-a476-bf7f73a4819a' name = 'Nautilus' )
        ( champion_id = '64a87acc-1566-3df6-ba47-c9847adb808d' name = 'Neeko' )
        ( champion_id = '5179b7c8-f751-3f66-b40d-6671d54aab37' name = 'Nocturne' )
        ( champion_id = '9b65df29-1753-3ea0-ab0f-6719b5c07fa7' name = 'Olaf' )
        ( champion_id = '8708d312-6987-35a9-90a5-db14b14babac' name = 'Orianna' )
        ( champion_id = 'e0e42b0a-7461-3143-b9a9-b70417c2384d' name = 'Pantheon' )
        ( champion_id = '1e6bddd1-a107-3db2-a589-5bec2044b11c' name = 'Poppy' )
        ( champion_id = '6bb5f68a-590f-320d-9757-74ef8d41277d' name = 'Qiyana' )
        ( champion_id = '31360e91-4470-348a-9a2b-ce10e9a107b1' name = 'Rakan' )
        ( champion_id = '431d18c8-1aee-3d01-8b0a-8e46172e7761' name = 'Renata Glasc' )
        ( champion_id = 'a6c6341f-f06c-3428-a0e3-797a0d0e2638' name = 'Renekton' )
        ( champion_id = '7552f226-fa3b-3053-b692-0dcdd9c79cf4' name = 'Rumble' )
        ( champion_id = '7889d995-c5bd-3d3a-a142-cbec510a328e' name = 'Seraphine' )
        ( champion_id = '5f3ce9cb-be45-3625-8c1d-e8068d6fee76' name = 'Sivir' )
        ( champion_id = '52ab36ab-7b94-31c7-afa5-e74badcd74ea' name = 'Skarner' )
        ( champion_id = '6b28be83-b1f2-3f1b-b887-85f87e172511' name = 'Sylas' )
        ( champion_id = 'a6ba29b1-2523-38e5-9a2c-69a35156f2df' name = 'Syndra' )
        ( champion_id = '14fada26-63ec-357f-8bf6-e2993edca107' name = 'Taliyah' )
        ( champion_id = '8c254736-e657-3ae4-8d0d-d322b2619582' name = 'Twisted Fate' )
        ( champion_id = 'ba84e95a-729e-3b6c-9473-ad5ab6d5c9d5' name = 'Vayne' )
        ( champion_id = '28c76f65-a320-3efc-8dbf-f5ccd8f30078' name = 'Vi' )
        ( champion_id = '39cd3cf0-4f19-3b16-a4fa-9b650bc71e9e' name = 'Viktor' )
        ( champion_id = '9530371e-3e7d-3e74-a17d-aa5ac56abf85' name = 'Wukong' )
        ( champion_id = 'e5eeaee9-eaa4-330f-85a1-e90230d9e0ad' name = 'Xayah' )
        ( champion_id = '2db51c3e-7bf3-3ea4-94bd-aac8567b0df9' name = 'Yunara' )
        ( champion_id = 'b4221d04-e00b-3e8a-8a6b-2d7cecc54ef7' name = 'Ziggs' ) ).

    INSERT zapv_tournament FROM TABLE @lt_tournaments.
    INSERT zapv_team       FROM TABLE @lt_teams.
    INSERT zapv_player     FROM TABLE @lt_players.
    INSERT zapv_champion   FROM TABLE @lt_champions.
  ENDMETHOD.


  METHOD fill_series.
    DATA lt_series       TYPE STANDARD TABLE OF zapv_series      WITH EMPTY KEY.
    DATA lt_games        TYPE STANDARD TABLE OF zapv_game        WITH EMPTY KEY.
    DATA lt_game_teams   TYPE STANDARD TABLE OF zapv_game_team   WITH EMPTY KEY.
    DATA lt_game_players TYPE STANDARD TABLE OF zapv_game_player WITH EMPTY KEY.
    DATA lt_draft        TYPE STANDARD TABLE OF zapv_draft       WITH EMPTY KEY.

    lt_series = VALUE #(
        ( series_id = '3012986' tournament_id = '831635' series_format = 'best-of-5' started_at = CONV utclong( '2026-11-14T19:44:04.5610000' ) finished = abap_true
          team1_id = '47558' team1_score = 1 team2_id = '356' team2_score = 3
          winner_team_id = '356' imported_at = utclong_current( ) ) ).

    lt_games = VALUE #(
        ( series_id = '3012986' game_seq = 1 game_id = '11f47aed-9a68-49a6-b3bf-56a8ef576fdb' patch = '16.20'
          started_at = CONV utclong( '2026-11-14T19:53:19.8000000' ) duration_sec = 2335 is_valid = abap_true
          blue_team_id = '47558' red_team_id = '356' winner_team_id = '47558' )
        ( series_id = '3012986' game_seq = 2 game_id = '8ada2d48-d46e-4d7d-8640-242641988080' patch = '16.20'
          started_at = CONV utclong( '2026-11-14T20:59:36.5710000' ) duration_sec = 3192 is_valid = abap_true
          blue_team_id = '47558' red_team_id = '356' winner_team_id = '356' )
        ( series_id = '3012986' game_seq = 3 game_id = '0355a5a1-54b9-4aa9-afac-01b4008130bb' patch = '16.20'
          started_at = CONV utclong( '2026-11-14T22:18:34.7410000' ) duration_sec = 2256 is_valid = abap_true
          blue_team_id = '47558' red_team_id = '356' winner_team_id = '356' )
        ( series_id = '3012986' game_seq = 4 game_id = 'f45b4eac-791d-464e-bb2e-1a5cdb10d1c0' patch = '16.20'
          started_at = CONV utclong( '2026-11-14T23:18:16.6500000' ) duration_sec = 2574 is_valid = abap_true
          blue_team_id = '356' red_team_id = '47558' winner_team_id = '356' ) ).

    lt_game_teams = VALUE #(
        ( series_id = '3012986' game_seq = 1 team_id = '47558' side = 'BLUE' won = abap_true
          kills = 19 deaths = 4 net_worth = 74505 gold_earned = 79917
          damage_dealt = 1250344 vision_score = '422.78'
          towers = 9 inhibitors = 2 dragons = 0 elder_dragons = 1
          barons = 3 heralds = 0 void_grubs = 2
          first_tower = abap_false first_dragon = abap_false first_herald = abap_false first_baron = abap_true )
        ( series_id = '3012986' game_seq = 1 team_id = '356' side = 'RED' won = abap_false
          kills = 4 deaths = 19 net_worth = 59261 gold_earned = 65912
          damage_dealt = 1129315 vision_score = '458.94'
          towers = 3 inhibitors = 0 dragons = 4 elder_dragons = 1
          barons = 0 heralds = 1 void_grubs = 1
          first_tower = abap_true first_dragon = abap_true first_herald = abap_true first_baron = abap_false )
        ( series_id = '3012986' game_seq = 2 team_id = '47558' side = 'BLUE' won = abap_false
          kills = 14 deaths = 19 net_worth = 79158 gold_earned = 94176
          damage_dealt = 1938271 vision_score = '639.55'
          towers = 4 inhibitors = 0 dragons = 3 elder_dragons = 1
          barons = 1 heralds = 1 void_grubs = 1
          first_tower = abap_false first_dragon = abap_false first_herald = abap_true first_baron = abap_false )
        ( series_id = '3012986' game_seq = 2 team_id = '356' side = 'RED' won = abap_true
          kills = 19 deaths = 14 net_worth = 84195 gold_earned = 99362
          damage_dealt = 1839122 vision_score = '650.73'
          towers = 11 inhibitors = 4 dragons = 4 elder_dragons = 0
          barons = 3 heralds = 0 void_grubs = 2
          first_tower = abap_true first_dragon = abap_true first_herald = abap_false first_baron = abap_true )
        ( series_id = '3012986' game_seq = 3 team_id = '47558' side = 'BLUE' won = abap_false
          kills = 8 deaths = 20 net_worth = 60706 gold_earned = 65662
          damage_dealt = 975870 vision_score = '497.90'
          towers = 4 inhibitors = 0 dragons = 2 elder_dragons = 0
          barons = 0 heralds = 1 void_grubs = 0
          first_tower = abap_false first_dragon = abap_true first_herald = abap_true first_baron = abap_false )
        ( series_id = '3012986' game_seq = 3 team_id = '356' side = 'RED' won = abap_true
          kills = 20 deaths = 8 net_worth = 67590 gold_earned = 73959
          damage_dealt = 1119836 vision_score = '466.02'
          towers = 10 inhibitors = 1 dragons = 4 elder_dragons = 0
          barons = 1 heralds = 0 void_grubs = 3
          first_tower = abap_true first_dragon = abap_false first_herald = abap_false first_baron = abap_true )
        ( series_id = '3012986' game_seq = 4 team_id = '47558' side = 'RED' won = abap_false
          kills = 11 deaths = 21 net_worth = 70565 gold_earned = 79780
          damage_dealt = 1403136 vision_score = '455.82'
          towers = 5 inhibitors = 0 dragons = 4 elder_dragons = 0
          barons = 1 heralds = 0 void_grubs = 3
          first_tower = abap_false first_dragon = abap_true first_herald = abap_false first_baron = abap_false )
        ( series_id = '3012986' game_seq = 4 team_id = '356' side = 'BLUE' won = abap_true
          kills = 21 deaths = 11 net_worth = 80544 gold_earned = 89603
          damage_dealt = 1438640 vision_score = '487.37'
          towers = 10 inhibitors = 2 dragons = 3 elder_dragons = 0
          barons = 2 heralds = 1 void_grubs = 0
          first_tower = abap_true first_dragon = abap_false first_herald = abap_true first_baron = abap_true ) ).

    lt_game_players = VALUE #(
        ( series_id = '3012986' game_seq = 1 player_id = '21335' team_id = '47558' champion_id = '9b65df29-1753-3ea0-ab0f-6719b5c07fa7'
          kills = 2 deaths = 1 assists = 13 kda = '15.00' kill_part_pct = '78.95'
          damage_dealt = 203335 damage_pct = '16.26' net_worth = 14000 gold_earned = 14620 vision_score = '42.62' )
        ( series_id = '3012986' game_seq = 1 player_id = '21233' team_id = '47558' champion_id = 'a0b6984e-e1ec-3e4c-a98d-34a6ba4aec9f'
          kills = 3 deaths = 2 assists = 13 kda = '8.00' kill_part_pct = '84.21'
          damage_dealt = 380909 damage_pct = '30.46' net_worth = 14800 gold_earned = 16279 vision_score = '83.17' )
        ( series_id = '3012986' game_seq = 1 player_id = '22132' team_id = '47558' champion_id = 'ecbbe9a4-9956-3828-b9d1-e5c148eb7959'
          kills = 1 deaths = 0 assists = 16 kda = '17.00' kill_part_pct = '89.47'
          damage_dealt = 20298 damage_pct = '1.62' net_worth = 9495 gold_earned = 10455 vision_score = '154.03' )
        ( series_id = '3012986' game_seq = 1 player_id = '22958' team_id = '47558' champion_id = 'a6ba29b1-2523-38e5-9a2c-69a35156f2df'
          kills = 6 deaths = 1 assists = 11 kda = '17.00' kill_part_pct = '89.47'
          damage_dealt = 224071 damage_pct = '17.92' net_worth = 14662 gold_earned = 15691 vision_score = '56.38' )
        ( series_id = '3012986' game_seq = 1 player_id = '22090' team_id = '47558' champion_id = 'e7a28e21-1e51-3ff4-ae76-2e7dc7a69ace'
          kills = 7 deaths = 0 assists = 8 kda = '15.00' kill_part_pct = '78.95'
          damage_dealt = 421731 damage_pct = '33.73' net_worth = 21548 gold_earned = 22872 vision_score = '86.58' )
        ( series_id = '3012986' game_seq = 1 player_id = '27265' team_id = '356' champion_id = 'a0cf8bf6-39d8-30fb-9dab-c1e8af747901'
          kills = 1 deaths = 5 assists = 3 kda = '0.80' kill_part_pct = '100.00'
          damage_dealt = 311959 damage_pct = '27.62' net_worth = 15080 gold_earned = 16129 vision_score = '81.98' )
        ( series_id = '3012986' game_seq = 1 player_id = '25485' team_id = '356' champion_id = '431d18c8-1aee-3d01-8b0a-8e46172e7761'
          kills = 0 deaths = 4 assists = 4 kda = '1.00' kill_part_pct = '100.00'
          damage_dealt = 29304 damage_pct = '2.59' net_worth = 7786 gold_earned = 9056 vision_score = '193.13' )
        ( series_id = '3012986' game_seq = 1 player_id = '21575' team_id = '356' champion_id = '019f1759-e612-7308-b507-a491cdafebfe'
          kills = 2 deaths = 2 assists = 1 kda = '1.50' kill_part_pct = '75.00'
          damage_dealt = 249317 damage_pct = '22.08' net_worth = 13416 gold_earned = 15420 vision_score = '67.98' )
        ( series_id = '3012986' game_seq = 1 player_id = '20759' team_id = '356' champion_id = 'bbd16ab8-92ed-3f82-8748-b23c20eca335'
          kills = 1 deaths = 4 assists = 3 kda = '1.00' kill_part_pct = '100.00'
          damage_dealt = 350896 damage_pct = '31.07' net_worth = 11752 gold_earned = 12911 vision_score = '64.80' )
        ( series_id = '3012986' game_seq = 1 player_id = '24854' team_id = '356' champion_id = '40cc8559-a028-35a5-a6dd-5e48c4601d66'
          kills = 0 deaths = 4 assists = 1 kda = '0.25' kill_part_pct = '25.00'
          damage_dealt = 187839 damage_pct = '16.63' net_worth = 11227 gold_earned = 12396 vision_score = '51.06' )
        ( series_id = '3012986' game_seq = 2 player_id = '21335' team_id = '47558' champion_id = 'ba84e95a-729e-3b6c-9473-ad5ab6d5c9d5'
          kills = 3 deaths = 4 assists = 3 kda = '1.50' kill_part_pct = '42.86'
          damage_dealt = 393785 damage_pct = '20.32' net_worth = 17550 gold_earned = 20268 vision_score = '102.97' )
        ( series_id = '3012986' game_seq = 2 player_id = '21233' team_id = '47558' champion_id = 'bacc778e-19db-33cb-b045-500e57bde996'
          kills = 2 deaths = 5 assists = 3 kda = '1.00' kill_part_pct = '35.71'
          damage_dealt = 459256 damage_pct = '23.69' net_worth = 13055 gold_earned = 16064 vision_score = '90.28' )
        ( series_id = '3012986' game_seq = 2 player_id = '22132' team_id = '47558' champion_id = '13af2c2a-1e39-3d26-a475-a9da5267b863'
          kills = 1 deaths = 2 assists = 11 kda = '6.00' kill_part_pct = '85.71'
          damage_dealt = 60663 damage_pct = '3.13' net_worth = 10688 gold_earned = 12928 vision_score = '283.03' )
        ( series_id = '3012986' game_seq = 2 player_id = '22958' team_id = '47558' champion_id = '8708d312-6987-35a9-90a5-db14b14babac'
          kills = 2 deaths = 6 assists = 5 kda = '1.17' kill_part_pct = '50.00'
          damage_dealt = 394446 damage_pct = '20.35' net_worth = 16343 gold_earned = 18951 vision_score = '93.32' )
        ( series_id = '3012986' game_seq = 2 player_id = '22090' team_id = '47558' champion_id = '3a52e342-5377-32b9-935f-b54a66688acd'
          kills = 6 deaths = 2 assists = 5 kda = '5.50' kill_part_pct = '78.57'
          damage_dealt = 630121 damage_pct = '32.51' net_worth = 21522 gold_earned = 25965 vision_score = '69.95' )
        ( series_id = '3012986' game_seq = 2 player_id = '27265' team_id = '356' champion_id = 'b4221d04-e00b-3e8a-8a6b-2d7cecc54ef7'
          kills = 3 deaths = 2 assists = 13 kda = '8.00' kill_part_pct = '84.21'
          damage_dealt = 593841 damage_pct = '32.29' net_worth = 20392 gold_earned = 22765 vision_score = '69.28' )
        ( series_id = '3012986' game_seq = 2 player_id = '25485' team_id = '356' champion_id = 'd5df6ed8-d7a4-3964-a295-cde171d889ae'
          kills = 1 deaths = 8 assists = 10 kda = '1.38' kill_part_pct = '57.89'
          damage_dealt = 44512 damage_pct = '2.42' net_worth = 10699 gold_earned = 14144 vision_score = '309.78' )
        ( series_id = '3012986' game_seq = 2 player_id = '21575' team_id = '356' champion_id = 'b51404e9-0865-3237-90a7-9d8747f6bf30'
          kills = 4 deaths = 1 assists = 12 kda = '16.00' kill_part_pct = '84.21'
          damage_dealt = 349120 damage_pct = '18.98' net_worth = 16708 gold_earned = 20921 vision_score = '83.60' )
        ( series_id = '3012986' game_seq = 2 player_id = '20759' team_id = '356' champion_id = 'e9dae12d-a8bd-3a92-9851-3a10c20acabd'
          kills = 8 deaths = 1 assists = 9 kda = '17.00' kill_part_pct = '89.47'
          damage_dealt = 553179 damage_pct = '30.08' net_worth = 19022 gold_earned = 22320 vision_score = '95.20' )
        ( series_id = '3012986' game_seq = 2 player_id = '24854' team_id = '356' champion_id = '717061ba-4e85-30e1-9340-aef80368dfa0'
          kills = 3 deaths = 2 assists = 6 kda = '4.50' kill_part_pct = '47.37'
          damage_dealt = 298470 damage_pct = '16.23' net_worth = 17374 gold_earned = 19212 vision_score = '92.87' )
        ( series_id = '3012986' game_seq = 3 player_id = '21335' team_id = '47558' champion_id = '6d94812f-ea1f-3460-80b7-c38518abb709'
          kills = 0 deaths = 3 assists = 2 kda = '0.67' kill_part_pct = '25.00'
          damage_dealt = 204155 damage_pct = '20.92' net_worth = 12310 gold_earned = 13034 vision_score = '74.39' )
        ( series_id = '3012986' game_seq = 3 player_id = '21233' team_id = '47558' champion_id = '9530371e-3e7d-3e74-a17d-aa5ac56abf85'
          kills = 0 deaths = 4 assists = 5 kda = '1.25' kill_part_pct = '62.50'
          damage_dealt = 311447 damage_pct = '31.91' net_worth = 11590 gold_earned = 12989 vision_score = '105.79' )
        ( series_id = '3012986' game_seq = 3 player_id = '22132' team_id = '47558' champion_id = '31360e91-4470-348a-9a2b-ce10e9a107b1'
          kills = 0 deaths = 4 assists = 5 kda = '1.25' kill_part_pct = '62.50'
          damage_dealt = 12103 damage_pct = '1.24' net_worth = 8479 gold_earned = 9279 vision_score = '202.79' )
        ( series_id = '3012986' game_seq = 3 player_id = '22958' team_id = '47558' champion_id = 'b3007001-25a5-3a10-91bc-0bdb5dac0ae7'
          kills = 4 deaths = 6 assists = 1 kda = '0.83' kill_part_pct = '62.50'
          damage_dealt = 154812 damage_pct = '15.86' net_worth = 12285 gold_earned = 13244 vision_score = '59.84' )
        ( series_id = '3012986' game_seq = 3 player_id = '22090' team_id = '47558' champion_id = '5748a92e-ed31-3fbf-854d-a37923f7c7ae'
          kills = 4 deaths = 3 assists = 3 kda = '2.33' kill_part_pct = '87.50'
          damage_dealt = 293353 damage_pct = '30.06' net_worth = 16042 gold_earned = 17116 vision_score = '55.08' )
        ( series_id = '3012986' game_seq = 3 player_id = '27265' team_id = '356' champion_id = '14fada26-63ec-357f-8bf6-e2993edca107'
          kills = 6 deaths = 1 assists = 11 kda = '17.00' kill_part_pct = '85.00'
          damage_dealt = 256789 damage_pct = '22.93' net_worth = 16057 gold_earned = 17436 vision_score = '57.57' )
        ( series_id = '3012986' game_seq = 3 player_id = '25485' team_id = '356' champion_id = '9104bd4f-7d7d-3895-8151-d3210b34e3d2'
          kills = 2 deaths = 1 assists = 16 kda = '18.00' kill_part_pct = '90.00'
          damage_dealt = 19234 damage_pct = '1.72' net_worth = 9184 gold_earned = 10400 vision_score = '193.60' )
        ( series_id = '3012986' game_seq = 3 player_id = '21575' team_id = '356' champion_id = '39cd3cf0-4f19-3b16-a4fa-9b650bc71e9e'
          kills = 5 deaths = 2 assists = 11 kda = '8.00' kill_part_pct = '80.00'
          damage_dealt = 248557 damage_pct = '22.20' net_worth = 14150 gold_earned = 15229 vision_score = '64.68' )
        ( series_id = '3012986' game_seq = 3 player_id = '20759' team_id = '356' champion_id = '28c76f65-a320-3efc-8dbf-f5ccd8f30078'
          kills = 4 deaths = 3 assists = 12 kda = '5.33' kill_part_pct = '80.00'
          damage_dealt = 386247 damage_pct = '34.49' net_worth = 15158 gold_earned = 16253 vision_score = '88.25' )
        ( series_id = '3012986' game_seq = 3 player_id = '24854' team_id = '356' champion_id = 'df57a4ea-3f1a-3e5f-9a38-4589c6966fde'
          kills = 3 deaths = 1 assists = 10 kda = '13.00' kill_part_pct = '65.00'
          damage_dealt = 209009 damage_pct = '18.66' net_worth = 13041 gold_earned = 14641 vision_score = '61.92' )
        ( series_id = '3012986' game_seq = 4 player_id = '21335' team_id = '47558' champion_id = '2bf2eedb-58ef-39d3-8be6-88508b55ffc3'
          kills = 0 deaths = 5 assists = 6 kda = '1.20' kill_part_pct = '54.55'
          damage_dealt = 224484 damage_pct = '16.00' net_worth = 12783 gold_earned = 13777 vision_score = '63.07' )
        ( series_id = '3012986' game_seq = 4 player_id = '21233' team_id = '47558' champion_id = 'e0e42b0a-7461-3143-b9a9-b70417c2384d'
          kills = 0 deaths = 5 assists = 5 kda = '1.00' kill_part_pct = '45.45'
          damage_dealt = 384199 damage_pct = '27.38' net_worth = 12026 gold_earned = 14090 vision_score = '80.32' )
        ( series_id = '3012986' game_seq = 4 player_id = '22132' team_id = '47558' champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab'
          kills = 0 deaths = 4 assists = 9 kda = '2.25' kill_part_pct = '81.82'
          damage_dealt = 13255 damage_pct = '0.94' net_worth = 9073 gold_earned = 10168 vision_score = '185.17' )
        ( series_id = '3012986' game_seq = 4 player_id = '22958' team_id = '47558' champion_id = 'a493c24b-17f8-34e5-ba90-0bdb40523099'
          kills = 5 deaths = 4 assists = 1 kda = '1.50' kill_part_pct = '54.55'
          damage_dealt = 289124 damage_pct = '20.61' net_worth = 15880 gold_earned = 17744 vision_score = '55.22' )
        ( series_id = '3012986' game_seq = 4 player_id = '22090' team_id = '47558' champion_id = 'e5eeaee9-eaa4-330f-85a1-e90230d9e0ad'
          kills = 6 deaths = 3 assists = 4 kda = '3.33' kill_part_pct = '90.91'
          damage_dealt = 492074 damage_pct = '35.07' net_worth = 20803 gold_earned = 24001 vision_score = '72.04' )
        ( series_id = '3012986' game_seq = 4 player_id = '27265' team_id = '356' champion_id = '2db51c3e-7bf3-3ea4-94bd-aac8567b0df9'
          kills = 6 deaths = 4 assists = 9 kda = '3.75' kill_part_pct = '71.43'
          damage_dealt = 421477 damage_pct = '29.30' net_worth = 21746 gold_earned = 23129 vision_score = '70.52' )
        ( series_id = '3012986' game_seq = 4 player_id = '25485' team_id = '356' champion_id = '64a87acc-1566-3df6-ba47-c9847adb808d'
          kills = 2 deaths = 1 assists = 13 kda = '15.00' kill_part_pct = '71.43'
          damage_dealt = 38229 damage_pct = '2.66' net_worth = 10401 gold_earned = 12011 vision_score = '232.38' )
        ( series_id = '3012986' game_seq = 4 player_id = '21575' team_id = '356' champion_id = '8c254736-e657-3ae4-8d0d-d322b2619582'
          kills = 2 deaths = 1 assists = 17 kda = '19.00' kill_part_pct = '90.48'
          damage_dealt = 298505 damage_pct = '20.75' net_worth = 17204 gold_earned = 20563 vision_score = '57.50' )
        ( series_id = '3012986' game_seq = 4 player_id = '20759' team_id = '356' champion_id = '5179b7c8-f751-3f66-b40d-6671d54aab37'
          kills = 3 deaths = 3 assists = 11 kda = '4.67' kill_part_pct = '66.67'
          damage_dealt = 368017 damage_pct = '25.58' net_worth = 14713 gold_earned = 16257 vision_score = '68.30' )
        ( series_id = '3012986' game_seq = 4 player_id = '24854' team_id = '356' champion_id = '3d6dd0f6-f96f-3375-84f6-86ac9ff68538'
          kills = 8 deaths = 2 assists = 9 kda = '8.50' kill_part_pct = '80.95'
          damage_dealt = 312412 damage_pct = '21.72' net_worth = 16480 gold_earned = 17643 vision_score = '58.67' ) ).

    lt_draft = VALUE #(
        ( series_id = '3012986' game_seq = 1 action_seq = 1 action_type = 'BAN' team_id = '47558' champion_id = '5179b7c8-f751-3f66-b40d-6671d54aab37' )
        ( series_id = '3012986' game_seq = 1 action_seq = 2 action_type = 'BAN' team_id = '356' champion_id = '6bb5f68a-590f-320d-9757-74ef8d41277d' )
        ( series_id = '3012986' game_seq = 1 action_seq = 3 action_type = 'BAN' team_id = '47558' champion_id = '8708d312-6987-35a9-90a5-db14b14babac' )
        ( series_id = '3012986' game_seq = 1 action_seq = 4 action_type = 'BAN' team_id = '356' champion_id = 'b51404e9-0865-3237-90a7-9d8747f6bf30' )
        ( series_id = '3012986' game_seq = 1 action_seq = 5 action_type = 'BAN' team_id = '47558' champion_id = '28c76f65-a320-3efc-8dbf-f5ccd8f30078' )
        ( series_id = '3012986' game_seq = 1 action_seq = 6 action_type = 'BAN' team_id = '356' champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab' )
        ( series_id = '3012986' game_seq = 1 action_seq = 7 action_type = 'PICK' team_id = '47558' champion_id = 'a0b6984e-e1ec-3e4c-a98d-34a6ba4aec9f' )
        ( series_id = '3012986' game_seq = 1 action_seq = 8 action_type = 'PICK' team_id = '356' champion_id = '431d18c8-1aee-3d01-8b0a-8e46172e7761' )
        ( series_id = '3012986' game_seq = 1 action_seq = 9 action_type = 'PICK' team_id = '356' champion_id = 'a0cf8bf6-39d8-30fb-9dab-c1e8af747901' )
        ( series_id = '3012986' game_seq = 1 action_seq = 10 action_type = 'PICK' team_id = '47558' champion_id = 'a6ba29b1-2523-38e5-9a2c-69a35156f2df' )
        ( series_id = '3012986' game_seq = 1 action_seq = 11 action_type = 'PICK' team_id = '47558' champion_id = '9b65df29-1753-3ea0-ab0f-6719b5c07fa7' )
        ( series_id = '3012986' game_seq = 1 action_seq = 12 action_type = 'PICK' team_id = '356' champion_id = '019f1759-e612-7308-b507-a491cdafebfe' )
        ( series_id = '3012986' game_seq = 1 action_seq = 13 action_type = 'BAN' team_id = '356' champion_id = '3a52e342-5377-32b9-935f-b54a66688acd' )
        ( series_id = '3012986' game_seq = 1 action_seq = 14 action_type = 'BAN' team_id = '47558' champion_id = 'df57a4ea-3f1a-3e5f-9a38-4589c6966fde' )
        ( series_id = '3012986' game_seq = 1 action_seq = 15 action_type = 'BAN' team_id = '356' champion_id = '7889d995-c5bd-3d3a-a142-cbec510a328e' )
        ( series_id = '3012986' game_seq = 1 action_seq = 16 action_type = 'BAN' team_id = '47558' champion_id = 'd5df6ed8-d7a4-3964-a295-cde171d889ae' )
        ( series_id = '3012986' game_seq = 1 action_seq = 17 action_type = 'PICK' team_id = '356' champion_id = '40cc8559-a028-35a5-a6dd-5e48c4601d66' )
        ( series_id = '3012986' game_seq = 1 action_seq = 18 action_type = 'PICK' team_id = '47558' champion_id = 'e7a28e21-1e51-3ff4-ae76-2e7dc7a69ace' )
        ( series_id = '3012986' game_seq = 1 action_seq = 19 action_type = 'PICK' team_id = '47558' champion_id = 'ecbbe9a4-9956-3828-b9d1-e5c148eb7959' )
        ( series_id = '3012986' game_seq = 1 action_seq = 20 action_type = 'PICK' team_id = '356' champion_id = 'bbd16ab8-92ed-3f82-8748-b23c20eca335' )
        ( series_id = '3012986' game_seq = 2 action_seq = 1 action_type = 'BAN' team_id = '356' champion_id = 'fa136dcc-94b9-35e2-aaff-cc4c2c46f7a3' )
        ( series_id = '3012986' game_seq = 2 action_seq = 2 action_type = 'BAN' team_id = '47558' champion_id = '5179b7c8-f751-3f66-b40d-6671d54aab37' )
        ( series_id = '3012986' game_seq = 2 action_seq = 3 action_type = 'BAN' team_id = '356' champion_id = '28c76f65-a320-3efc-8dbf-f5ccd8f30078' )
        ( series_id = '3012986' game_seq = 2 action_seq = 4 action_type = 'BAN' team_id = '47558' champion_id = '6bb5f68a-590f-320d-9757-74ef8d41277d' )
        ( series_id = '3012986' game_seq = 2 action_seq = 5 action_type = 'BAN' team_id = '356' champion_id = 'aeab401d-5c3e-38d6-8bb5-fe87f6db1a6f' )
        ( series_id = '3012986' game_seq = 2 action_seq = 6 action_type = 'BAN' team_id = '47558' champion_id = '5fb5f03b-af85-31e8-a476-bf7f73a4819a' )
        ( series_id = '3012986' game_seq = 2 action_seq = 7 action_type = 'PICK' team_id = '356' champion_id = 'b51404e9-0865-3237-90a7-9d8747f6bf30' )
        ( series_id = '3012986' game_seq = 2 action_seq = 8 action_type = 'PICK' team_id = '47558' champion_id = '3a52e342-5377-32b9-935f-b54a66688acd' )
        ( series_id = '3012986' game_seq = 2 action_seq = 9 action_type = 'PICK' team_id = '47558' champion_id = '13af2c2a-1e39-3d26-a475-a9da5267b863' )
        ( series_id = '3012986' game_seq = 2 action_seq = 10 action_type = 'PICK' team_id = '356' champion_id = 'd5df6ed8-d7a4-3964-a295-cde171d889ae' )
        ( series_id = '3012986' game_seq = 2 action_seq = 11 action_type = 'PICK' team_id = '356' champion_id = 'e9dae12d-a8bd-3a92-9851-3a10c20acabd' )
        ( series_id = '3012986' game_seq = 2 action_seq = 12 action_type = 'PICK' team_id = '47558' champion_id = 'bacc778e-19db-33cb-b045-500e57bde996' )
        ( series_id = '3012986' game_seq = 2 action_seq = 13 action_type = 'BAN' team_id = '47558' champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab' )
        ( series_id = '3012986' game_seq = 2 action_seq = 14 action_type = 'BAN' team_id = '356' champion_id = 'a6c6341f-f06c-3428-a0e3-797a0d0e2638' )
        ( series_id = '3012986' game_seq = 2 action_seq = 15 action_type = 'BAN' team_id = '47558' champion_id = 'a493c24b-17f8-34e5-ba90-0bdb40523099' )
        ( series_id = '3012986' game_seq = 2 action_seq = 16 action_type = 'BAN' team_id = '356' champion_id = '39cd3cf0-4f19-3b16-a4fa-9b650bc71e9e' )
        ( series_id = '3012986' game_seq = 2 action_seq = 17 action_type = 'PICK' team_id = '47558' champion_id = '8708d312-6987-35a9-90a5-db14b14babac' )
        ( series_id = '3012986' game_seq = 2 action_seq = 18 action_type = 'PICK' team_id = '356' champion_id = '717061ba-4e85-30e1-9340-aef80368dfa0' )
        ( series_id = '3012986' game_seq = 2 action_seq = 19 action_type = 'PICK' team_id = '356' champion_id = 'b4221d04-e00b-3e8a-8a6b-2d7cecc54ef7' )
        ( series_id = '3012986' game_seq = 2 action_seq = 20 action_type = 'PICK' team_id = '47558' champion_id = 'ba84e95a-729e-3b6c-9473-ad5ab6d5c9d5' )
        ( series_id = '3012986' game_seq = 3 action_seq = 1 action_type = 'BAN' team_id = '47558' champion_id = '5fb5f03b-af85-31e8-a476-bf7f73a4819a' )
        ( series_id = '3012986' game_seq = 3 action_seq = 2 action_type = 'BAN' team_id = '356' champion_id = '6bb5f68a-590f-320d-9757-74ef8d41277d' )
        ( series_id = '3012986' game_seq = 3 action_seq = 3 action_type = 'BAN' team_id = '47558' champion_id = 'a6c6341f-f06c-3428-a0e3-797a0d0e2638' )
        ( series_id = '3012986' game_seq = 3 action_seq = 4 action_type = 'BAN' team_id = '356' champion_id = 'fa136dcc-94b9-35e2-aaff-cc4c2c46f7a3' )
        ( series_id = '3012986' game_seq = 3 action_seq = 5 action_type = 'BAN' team_id = '47558' champion_id = '7889d995-c5bd-3d3a-a142-cbec510a328e' )
        ( series_id = '3012986' game_seq = 3 action_seq = 6 action_type = 'BAN' team_id = '356' champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab' )
        ( series_id = '3012986' game_seq = 3 action_seq = 7 action_type = 'PICK' team_id = '47558' champion_id = '6d94812f-ea1f-3460-80b7-c38518abb709' )
        ( series_id = '3012986' game_seq = 3 action_seq = 8 action_type = 'PICK' team_id = '356' champion_id = 'df57a4ea-3f1a-3e5f-9a38-4589c6966fde' )
        ( series_id = '3012986' game_seq = 3 action_seq = 9 action_type = 'PICK' team_id = '356' champion_id = '28c76f65-a320-3efc-8dbf-f5ccd8f30078' )
        ( series_id = '3012986' game_seq = 3 action_seq = 10 action_type = 'PICK' team_id = '47558' champion_id = '9530371e-3e7d-3e74-a17d-aa5ac56abf85' )
        ( series_id = '3012986' game_seq = 3 action_seq = 11 action_type = 'PICK' team_id = '47558' champion_id = 'b3007001-25a5-3a10-91bc-0bdb5dac0ae7' )
        ( series_id = '3012986' game_seq = 3 action_seq = 12 action_type = 'PICK' team_id = '356' champion_id = '39cd3cf0-4f19-3b16-a4fa-9b650bc71e9e' )
        ( series_id = '3012986' game_seq = 3 action_seq = 13 action_type = 'BAN' team_id = '356' champion_id = 'e5eeaee9-eaa4-330f-85a1-e90230d9e0ad' )
        ( series_id = '3012986' game_seq = 3 action_seq = 14 action_type = 'BAN' team_id = '47558' champion_id = '16e85313-6510-315b-83f5-13f437b191c3' )
        ( series_id = '3012986' game_seq = 3 action_seq = 15 action_type = 'BAN' team_id = '356' champion_id = '1e6bddd1-a107-3db2-a589-5bec2044b11c' )
        ( series_id = '3012986' game_seq = 3 action_seq = 16 action_type = 'BAN' team_id = '47558' champion_id = '5f3ce9cb-be45-3625-8c1d-e8068d6fee76' )
        ( series_id = '3012986' game_seq = 3 action_seq = 17 action_type = 'PICK' team_id = '356' champion_id = '9104bd4f-7d7d-3895-8151-d3210b34e3d2' )
        ( series_id = '3012986' game_seq = 3 action_seq = 18 action_type = 'PICK' team_id = '47558' champion_id = '31360e91-4470-348a-9a2b-ce10e9a107b1' )
        ( series_id = '3012986' game_seq = 3 action_seq = 19 action_type = 'PICK' team_id = '47558' champion_id = '5748a92e-ed31-3fbf-854d-a37923f7c7ae' )
        ( series_id = '3012986' game_seq = 3 action_seq = 20 action_type = 'PICK' team_id = '356' champion_id = '14fada26-63ec-357f-8bf6-e2993edca107' )
        ( series_id = '3012986' game_seq = 4 action_seq = 1 action_type = 'BAN' team_id = '47558' champion_id = '5fb5f03b-af85-31e8-a476-bf7f73a4819a' )
        ( series_id = '3012986' game_seq = 4 action_seq = 2 action_type = 'BAN' team_id = '356' champion_id = '6bb5f68a-590f-320d-9757-74ef8d41277d' )
        ( series_id = '3012986' game_seq = 4 action_seq = 3 action_type = 'BAN' team_id = '47558' champion_id = '52ab36ab-7b94-31c7-afa5-e74badcd74ea' )
        ( series_id = '3012986' game_seq = 4 action_seq = 4 action_type = 'BAN' team_id = '356' champion_id = 'fa136dcc-94b9-35e2-aaff-cc4c2c46f7a3' )
        ( series_id = '3012986' game_seq = 4 action_seq = 5 action_type = 'BAN' team_id = '47558' champion_id = 'dad13cc6-586d-3cf3-b149-6c70969ab14c' )
        ( series_id = '3012986' game_seq = 4 action_seq = 6 action_type = 'BAN' team_id = '356' champion_id = '7889d995-c5bd-3d3a-a142-cbec510a328e' )
        ( series_id = '3012986' game_seq = 4 action_seq = 7 action_type = 'PICK' team_id = '47558' champion_id = 'e5a58f35-4cf1-302e-85fc-e99e161c38ab' )
        ( series_id = '3012986' game_seq = 4 action_seq = 8 action_type = 'PICK' team_id = '356' champion_id = '5179b7c8-f751-3f66-b40d-6671d54aab37' )
        ( series_id = '3012986' game_seq = 4 action_seq = 9 action_type = 'PICK' team_id = '356' champion_id = '2db51c3e-7bf3-3ea4-94bd-aac8567b0df9' )
        ( series_id = '3012986' game_seq = 4 action_seq = 10 action_type = 'PICK' team_id = '47558' champion_id = 'e5eeaee9-eaa4-330f-85a1-e90230d9e0ad' )
        ( series_id = '3012986' game_seq = 4 action_seq = 11 action_type = 'PICK' team_id = '47558' champion_id = 'e0e42b0a-7461-3143-b9a9-b70417c2384d' )
        ( series_id = '3012986' game_seq = 4 action_seq = 12 action_type = 'PICK' team_id = '356' champion_id = '64a87acc-1566-3df6-ba47-c9847adb808d' )
        ( series_id = '3012986' game_seq = 4 action_seq = 13 action_type = 'BAN' team_id = '356' champion_id = '6b28be83-b1f2-3f1b-b887-85f87e172511' )
        ( series_id = '3012986' game_seq = 4 action_seq = 14 action_type = 'BAN' team_id = '47558' champion_id = 'a6c6341f-f06c-3428-a0e3-797a0d0e2638' )
        ( series_id = '3012986' game_seq = 4 action_seq = 15 action_type = 'BAN' team_id = '356' champion_id = '7552f226-fa3b-3053-b692-0dcdd9c79cf4' )
        ( series_id = '3012986' game_seq = 4 action_seq = 16 action_type = 'BAN' team_id = '47558' champion_id = 'aeab401d-5c3e-38d6-8bb5-fe87f6db1a6f' )
        ( series_id = '3012986' game_seq = 4 action_seq = 17 action_type = 'PICK' team_id = '356' champion_id = '3d6dd0f6-f96f-3375-84f6-86ac9ff68538' )
        ( series_id = '3012986' game_seq = 4 action_seq = 18 action_type = 'PICK' team_id = '47558' champion_id = 'a493c24b-17f8-34e5-ba90-0bdb40523099' )
        ( series_id = '3012986' game_seq = 4 action_seq = 19 action_type = 'PICK' team_id = '47558' champion_id = '2bf2eedb-58ef-39d3-8be6-88508b55ffc3' )
        ( series_id = '3012986' game_seq = 4 action_seq = 20 action_type = 'PICK' team_id = '356' champion_id = '8c254736-e657-3ae4-8d0d-d322b2619582' ) ).

    INSERT zapv_series      FROM TABLE @lt_series.
    INSERT zapv_game        FROM TABLE @lt_games.
    INSERT zapv_game_team   FROM TABLE @lt_game_teams.
    INSERT zapv_game_player FROM TABLE @lt_game_players.
    INSERT zapv_draft       FROM TABLE @lt_draft.
  ENDMETHOD.

ENDCLASS.

