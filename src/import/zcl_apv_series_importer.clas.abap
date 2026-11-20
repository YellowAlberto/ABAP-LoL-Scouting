CLASS zcl_apv_series_importer DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_result,
        games   TYPE i,
        players TYPE i,
        draft   TYPE i,
      END OF ty_result.

    METHODS constructor
      RAISING zcx_apv_grid_error.

    "! Importa (o vuelve a importar) una serie completa. Idempotente.
    METHODS import_series
      IMPORTING iv_series_id     TYPE zapv_series-series_id
      RETURNING VALUE(rs_result) TYPE ty_result
      RAISING   zcx_apv_grid_error.

  PRIVATE SECTION.
    DATA mo_client TYPE REF TO zcl_apv_grid_client.

    METHODS query_series_state
      RETURNING VALUE(rv_query) TYPE string.

    METHODS get_objective
      IMPORTING it_objectives       TYPE zif_apv_grid_types=>tt_objective
                iv_type             TYPE string
      RETURNING VALUE(rs_objective) TYPE zif_apv_grid_types=>ty_objective.

    METHODS to_utclong
      IMPORTING iv_iso       TYPE string
      RETURNING VALUE(rv_ts) TYPE utclong.

    METHODS duration_to_seconds
      IMPORTING iv_iso            TYPE string
      RETURNING VALUE(rv_seconds) TYPE i.
ENDCLASS.


CLASS zcl_apv_series_importer IMPLEMENTATION.

  METHOD constructor.
    mo_client = NEW #( ).
  ENDMETHOD.


  METHOD import_series.
    DATA ls_state_resp TYPE zif_apv_grid_types=>ty_series_state_response.
    DATA ls_info_resp  TYPE zif_apv_grid_types=>ty_series_info_response.

    DATA lt_games       TYPE STANDARD TABLE OF zapv_game        WITH EMPTY KEY.
    DATA lt_game_teams  TYPE STANDARD TABLE OF zapv_game_team   WITH EMPTY KEY.
    DATA lt_game_player TYPE STANDARD TABLE OF zapv_game_player WITH EMPTY KEY.
    DATA lt_draft       TYPE STANDARD TABLE OF zapv_draft       WITH EMPTY KEY.
    " Tablas ordenadas con clave unica: un mismo jugador o campeon sale en
    " varias partidas, pero aqui solo se guarda una vez
    DATA lt_teams     TYPE SORTED TABLE OF zapv_team     WITH UNIQUE KEY team_id.
    DATA lt_players   TYPE SORTED TABLE OF zapv_player   WITH UNIQUE KEY player_id.
    DATA lt_champions TYPE SORTED TABLE OF zapv_champion WITH UNIQUE KEY champion_id.

    DATA lv_seq    TYPE zapv_game-game_seq.
    DATA lv_blue   TYPE zapv_game-blue_team_id.
    DATA lv_red    TYPE zapv_game-red_team_id.
    DATA lv_winner TYPE zapv_game-winner_team_id.

    DATA(lv_id)        = CONV string( iv_series_id ).
    DATA(lv_variables) = |\{"id":"{ lv_id }"\}|.

    " ===== 1. Leer la serie de las dos APIs =====
    DATA(lv_json) = mo_client->execute_query(
                      iv_endpoint  = zcl_apv_grid_client=>c_endpoint-series_state
                      iv_query     = query_series_state( )
                      iv_variables = lv_variables ).
    /ui2/cl_json=>deserialize(
      EXPORTING json        = lv_json
                pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING  data        = ls_state_resp ).

    DATA(ls_state) = ls_state_resp-data-series_state.
    IF ls_state-id IS INITIAL.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = |La serie { lv_id } no existe o no tiene datos| ).
    ENDIF.
    IF ls_state-finished = abap_false.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = |La serie { lv_id } todavia no ha terminado| ).
    ENDIF.

    lv_json = mo_client->execute_query(
                iv_endpoint  = zcl_apv_grid_client=>c_endpoint-central_data
                iv_query     = `query($id: ID!) { series(id: $id) { id tournament { id name } } }`
                iv_variables = lv_variables ).
    /ui2/cl_json=>deserialize(
      EXPORTING json        = lv_json
                pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING  data        = ls_info_resp ).
    DATA(ls_tournament) = ls_info_resp-data-series-tournament.

    " ===== 2. Convertir el JSON en filas de nuestras tablas =====
    DATA(ls_team1) = VALUE zif_apv_grid_types=>ty_series_team( ls_state-teams[ 1 ] OPTIONAL ).
    DATA(ls_team2) = VALUE zif_apv_grid_types=>ty_series_team( ls_state-teams[ 2 ] OPTIONAL ).

    DATA(ls_series) = VALUE zapv_series(
      series_id      = iv_series_id
      tournament_id  = ls_tournament-id
      series_format  = ls_state-format
      started_at     = to_utclong( ls_state-started_at )
      finished       = ls_state-finished
      team1_id       = ls_team1-id
      team1_score    = ls_team1-score
      team2_id       = ls_team2-id
      team2_score    = ls_team2-score
      winner_team_id = COND #( WHEN ls_team1-won = abap_true THEN ls_team1-id ELSE ls_team2-id )
      imported_at    = utclong_current( ) ).

    LOOP AT ls_state-teams INTO DATA(ls_series_team).
      INSERT VALUE #( team_id = ls_series_team-id name = ls_series_team-name ) INTO TABLE lt_teams.
    ENDLOOP.

    LOOP AT ls_state-games INTO DATA(ls_game).
      lv_seq = ls_game-sequence_number.
      CLEAR: lv_blue, lv_red, lv_winner.

      " --- Equipos de la partida y sus jugadores ---
      LOOP AT ls_game-teams INTO DATA(ls_gt).
        CASE ls_gt-side.
          WHEN `blue`. lv_blue = ls_gt-id.
          WHEN `red`.  lv_red  = ls_gt-id.
        ENDCASE.
        IF ls_gt-won = abap_true.
          lv_winner = ls_gt-id.
        ENDIF.

        DATA(ls_dragon) = get_objective( it_objectives = ls_gt-objectives iv_type = `slayDragon` ).
        DATA(ls_elder)  = get_objective( it_objectives = ls_gt-objectives iv_type = `slayElderDragon` ).
        DATA(ls_baron)  = get_objective( it_objectives = ls_gt-objectives iv_type = `slayBaron` ).
        DATA(ls_herald) = get_objective( it_objectives = ls_gt-objectives iv_type = `slayRiftHerald` ).
        DATA(ls_grubs)  = get_objective( it_objectives = ls_gt-objectives iv_type = `slayVoidGrub` ).
        DATA(ls_tower)  = get_objective( it_objectives = ls_gt-objectives iv_type = `destroyTower` ).
        DATA(ls_inhib)  = get_objective( it_objectives = ls_gt-objectives iv_type = `destroyFortifier` ).

        APPEND VALUE #(
          series_id     = iv_series_id
          game_seq      = lv_seq
          team_id       = ls_gt-id
          side          = to_upper( ls_gt-side )
          won           = ls_gt-won
          kills         = ls_gt-kills
          deaths        = ls_gt-deaths
          net_worth     = ls_gt-net_worth
          gold_earned   = ls_gt-total_money_earned
          damage_dealt  = ls_gt-damage_dealt
          vision_score  = ls_gt-vision_score
          towers        = ls_tower-completion_count
          inhibitors    = ls_inhib-completion_count
          " slayDragon incluye el Dragon Ancestral: se resta
          dragons       = ls_dragon-completion_count - ls_elder-completion_count
          elder_dragons = ls_elder-completion_count
          barons        = ls_baron-completion_count
          heralds       = ls_herald-completion_count
          void_grubs    = ls_grubs-completion_count
          first_tower   = ls_tower-completed_first
          first_dragon  = ls_dragon-completed_first
          first_herald  = ls_herald-completed_first
          first_baron   = ls_baron-completed_first ) TO lt_game_teams.

        LOOP AT ls_gt-players INTO DATA(ls_p).
          APPEND VALUE #(
            series_id     = iv_series_id
            game_seq      = lv_seq
            player_id     = ls_p-id
            team_id       = ls_gt-id
            champion_id   = ls_p-character-id
            kills         = ls_p-kills
            deaths        = ls_p-deaths
            assists       = ls_p-kill_assists_given
            kda           = ls_p-kda_ratio
            kill_part_pct = ls_p-kill_participation
            damage_dealt  = ls_p-damage_dealt
            damage_pct    = ls_p-damage_percentage
            net_worth     = ls_p-net_worth
            gold_earned   = ls_p-total_money_earned
            vision_score  = ls_p-vision_score ) TO lt_game_player.

          " En una tabla con clave unica, INSERT ignora los duplicados
          INSERT VALUE #( player_id = ls_p-id name = ls_p-name team_id = ls_gt-id ) INTO TABLE lt_players.
          INSERT VALUE #( champion_id = ls_p-character-id name = ls_p-character-name ) INTO TABLE lt_champions.
        ENDLOOP.
      ENDLOOP.

      " --- Draft de la partida ---
      LOOP AT ls_game-draft_actions INTO DATA(ls_action).
        APPEND VALUE #(
          series_id   = iv_series_id
          game_seq    = lv_seq
          action_seq  = ls_action-sequence_number
          action_type = to_upper( ls_action-type )
          team_id     = ls_action-drafter-id
          champion_id = ls_action-draftable-id ) TO lt_draft.

        INSERT VALUE #( champion_id = ls_action-draftable-id name = ls_action-draftable-name ) INTO TABLE lt_champions.
      ENDLOOP.

      " --- La partida (despues de recorrer sus equipos) ---
      APPEND VALUE #(
        series_id      = iv_series_id
        game_seq       = lv_seq
        game_id        = ls_game-id
        patch          = ls_game-title_version-name
        started_at     = to_utclong( ls_game-started_at )
        duration_sec   = duration_to_seconds( ls_game-duration )
        is_valid       = ls_game-valid
        blue_team_id   = lv_blue
        red_team_id    = lv_red
        winner_team_id = lv_winner ) TO lt_games.
    ENDLOOP.

    " Jugadores: solo los nuevos, para no borrar el rol que mantienes a mano
    IF lt_players IS NOT INITIAL.
      SELECT player_id FROM zapv_player
        FOR ALL ENTRIES IN @lt_players
        WHERE player_id = @lt_players-player_id
        INTO TABLE @DATA(lt_existing).
      LOOP AT lt_existing INTO DATA(ls_existing).
        DELETE TABLE lt_players WITH TABLE KEY player_id = ls_existing-player_id.
      ENDLOOP.
    ENDIF.

    " ===== 3. Guardar: borrar lo anterior de esta serie e insertar de nuevo =====
    DELETE FROM zapv_draft       WHERE series_id = @iv_series_id.
    DELETE FROM zapv_game_player WHERE series_id = @iv_series_id.
    DELETE FROM zapv_game_team   WHERE series_id = @iv_series_id.
    DELETE FROM zapv_game        WHERE series_id = @iv_series_id.

    MODIFY zapv_series      FROM @ls_series.
    INSERT zapv_game        FROM TABLE @lt_games.
    INSERT zapv_game_team   FROM TABLE @lt_game_teams.
    INSERT zapv_game_player FROM TABLE @lt_game_player.
    INSERT zapv_draft       FROM TABLE @lt_draft.

    MODIFY zapv_team     FROM TABLE @lt_teams.
    MODIFY zapv_champion FROM TABLE @lt_champions.
    INSERT zapv_player   FROM TABLE @lt_players.
    IF ls_tournament-id IS NOT INITIAL.
      MODIFY zapv_tournament FROM @( VALUE zapv_tournament( tournament_id = ls_tournament-id
                                                            name          = ls_tournament-name ) ).
    ENDIF.

    rs_result = VALUE #( games   = lines( lt_games )
                         players = lines( lt_game_player )
                         draft   = lines( lt_draft ) ).
  ENDMETHOD.


  METHOD query_series_state.
    " La misma consulta que en Postman. Se une por partes porque un literal
    " de ABAP no puede pasar de 255 caracteres
    rv_query = `query($id: ID!) { seriesState(id: $id) { id format finished startedAt `
            && `teams { id name score won } `
            && `games { id sequenceNumber finished valid startedAt duration titleVersion { name } `
            && `draftActions { sequenceNumber type drafter { id } draftable { id name } } `
            && `teams { id name side won kills deaths netWorth structuresDestroyed `
            && `objectives { type completionCount completedFirst } `
            && `... on GameTeamStateLol { totalMoneyEarned damageDealt visionScore } `
            && `players { id name character { id name } kills deaths killAssistsGiven netWorth `
            && `... on GamePlayerStateLol { kdaRatio killParticipation damageDealt damagePercentage totalMoneyEarned visionScore } `
            && `} } } } }`.
  ENDMETHOD.


  METHOD get_objective.
    " Si el equipo no consiguio ese objetivo, devuelve una estructura vacia (0)
    rs_objective = VALUE #( it_objectives[ type = iv_type ] OPTIONAL ).
  ENDMETHOD.


  METHOD to_utclong.
    " '2026-11-14T19:44:04.561Z' -> utclong con 7 decimales
    IF iv_iso IS INITIAL.
      RETURN.
    ENDIF.
    DATA(lv_text) = replace( val = iv_iso sub = `Z` with = `` ).
    SPLIT lv_text AT `.` INTO DATA(lv_main) DATA(lv_frac).
    lv_frac = substring( val = lv_frac && `0000000` len = 7 ).
    TRY.
        rv_ts = CONV utclong( |{ lv_main }.{ lv_frac }| ).
      CATCH cx_sy_conversion_error.
        CLEAR rv_ts.
    ENDTRY.
  ENDMETHOD.


  METHOD duration_to_seconds.
    " 'PT38M55.481S' -> 2335 segundos
    DATA: lv_h TYPE string,
          lv_m TYPE string,
          lv_s TYPE string.
    FIND PCRE `PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)(?:\.\d+)?S)?` IN iv_iso
      SUBMATCHES lv_h lv_m lv_s.
    rv_seconds = CONV i( lv_h ) * 3600 + CONV i( lv_m ) * 60 + CONV i( lv_s ).
  ENDMETHOD.

ENDCLASS.
