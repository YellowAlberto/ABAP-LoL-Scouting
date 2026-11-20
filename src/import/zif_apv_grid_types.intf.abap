INTERFACE zif_apv_grid_types PUBLIC.

  " ---------- Series State ----------
  TYPES:
    BEGIN OF ty_draft_action,
      sequence_number TYPE string,
      type            TYPE string,
      BEGIN OF drafter,
        id TYPE string,
      END OF drafter,
      BEGIN OF draftable,
        id   TYPE string,
        name TYPE string,
      END OF draftable,
    END OF ty_draft_action,
    tt_draft_action TYPE STANDARD TABLE OF ty_draft_action WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_objective,
      type             TYPE string,
      completion_count TYPE i,
      completed_first  TYPE abap_bool,
    END OF ty_objective,
    tt_objective TYPE STANDARD TABLE OF ty_objective WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_player,
      id                 TYPE string,
      name               TYPE string,
      BEGIN OF character,
        id   TYPE string,
        name TYPE string,
      END OF character,
      kills              TYPE i,
      deaths             TYPE i,
      kill_assists_given TYPE i,
      net_worth          TYPE i,
      kda_ratio          TYPE decfloat34,
      kill_participation TYPE decfloat34,
      damage_dealt       TYPE i,
      damage_percentage  TYPE decfloat34,
      total_money_earned TYPE i,
      vision_score       TYPE decfloat34,
    END OF ty_player,
    tt_player TYPE STANDARD TABLE OF ty_player WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_game_team,
      id                   TYPE string,
      name                 TYPE string,
      side                 TYPE string,
      won                  TYPE abap_bool,
      kills                TYPE i,
      deaths               TYPE i,
      net_worth            TYPE i,
      structures_destroyed TYPE i,
      objectives           TYPE tt_objective,
      total_money_earned   TYPE i,
      damage_dealt         TYPE i,
      vision_score         TYPE decfloat34,
      players              TYPE tt_player,
    END OF ty_game_team,
    tt_game_team TYPE STANDARD TABLE OF ty_game_team WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_game,
      id              TYPE string,
      sequence_number TYPE i,
      finished        TYPE abap_bool,
      valid           TYPE abap_bool,
      started_at      TYPE string,
      duration        TYPE string,
      BEGIN OF title_version,
        name TYPE string,
      END OF title_version,
      draft_actions   TYPE tt_draft_action,
      teams           TYPE tt_game_team,
    END OF ty_game,
    tt_game TYPE STANDARD TABLE OF ty_game WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_series_team,
      id    TYPE string,
      name  TYPE string,
      score TYPE i,
      won   TYPE abap_bool,
    END OF ty_series_team,
    tt_series_team TYPE STANDARD TABLE OF ty_series_team WITH EMPTY KEY.

  TYPES:
    BEGIN OF ty_series_state,
      id         TYPE string,
      format     TYPE string,
      finished   TYPE abap_bool,
      started_at TYPE string,
      teams      TYPE tt_series_team,
      games      TYPE tt_game,
    END OF ty_series_state.

  " Respuesta completa: { "data": { "seriesState": { ... } } }
  TYPES:
    BEGIN OF ty_series_state_response,
      BEGIN OF data,
        series_state TYPE ty_series_state,
      END OF data,
    END OF ty_series_state_response.

  " ---------- Central Data: torneo de una serie ----------
  " Respuesta: { "data": { "series": { "id": ..., "tournament": { ... } } } }
  TYPES:
    BEGIN OF ty_series_info_response,
      BEGIN OF data,
        BEGIN OF series,
          id TYPE string,
          BEGIN OF tournament,
            id   TYPE string,
            name TYPE string,
          END OF tournament,
        END OF series,
      END OF data,
    END OF ty_series_info_response.

ENDINTERFACE.
