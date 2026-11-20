CLASS zcl_apv_grid_client DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF c_endpoint,
        central_data TYPE zapv_config-param_name VALUE 'URL_CENTRAL_DATA',
        series_state TYPE zapv_config-param_name VALUE 'URL_SERIES_STATE',
      END OF c_endpoint.

    METHODS constructor
      RAISING zcx_apv_grid_error.

    "! Envia una consulta GraphQL y devuelve el JSON de la respuesta
    METHODS execute_query
      IMPORTING iv_endpoint    TYPE zapv_config-param_name
                iv_query       TYPE string
                iv_variables   TYPE string OPTIONAL
      RETURNING VALUE(rv_json) TYPE string
      RAISING   zcx_apv_grid_error.

  PRIVATE SECTION.
    DATA mv_api_key TYPE string.

    METHODS get_config
      IMPORTING iv_name         TYPE zapv_config-param_name
      RETURNING VALUE(rv_value) TYPE string
      RAISING   zcx_apv_grid_error.

    METHODS build_body
      IMPORTING iv_query       TYPE string
                iv_variables   TYPE string
      RETURNING VALUE(rv_body) TYPE string.
ENDCLASS.


CLASS zcl_apv_grid_client IMPLEMENTATION.

  METHOD constructor.
    mv_api_key = get_config( 'API_KEY' ).
  ENDMETHOD.


  METHOD execute_query.
    DATA(lv_url) = get_config( iv_endpoint ).

    TRY.
        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination(
                            cl_http_destination_provider=>create_by_url( lv_url ) ).

        DATA(lo_request) = lo_client->get_http_request( ).
        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'x-api-key'    i_value = mv_api_key ).
        lo_request->set_text( build_body( iv_query = iv_query iv_variables = iv_variables ) ).

        DATA(lo_response) = lo_client->execute( if_web_http_client=>post ).
        DATA(lv_status)   = lo_response->get_status( )-code.
        rv_json           = lo_response->get_text( ).
        lo_client->close( ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_http).
        RAISE EXCEPTION NEW zcx_apv_grid_error(
          iv_text  = |Error de conexion: { lx_http->get_text( ) }|
          previous = lx_http ).
    ENDTRY.

    IF lv_status = 429.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = 'Limite de peticiones superado (HTTP 429). Espera un minuto.' ).
    ELSEIF lv_status <> 200.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = |HTTP { lv_status }: { rv_json }| ).
    ENDIF.

    " GraphQL devuelve 200 aunque la consulta tenga errores: hay que mirar el JSON
    IF rv_json CS '"errors"'.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = |Error GraphQL: { rv_json }| ).
    ENDIF.
  ENDMETHOD.


  METHOD get_config.
    SELECT SINGLE param_value FROM zapv_config
      WHERE param_name = @iv_name
      INTO @DATA(lv_value).
    IF sy-subrc <> 0 OR lv_value IS INITIAL.
      RAISE EXCEPTION NEW zcx_apv_grid_error( iv_text = |Falta el parametro { iv_name } en ZAPV_CONFIG| ).
    ENDIF.
    rv_value = lv_value.
  ENDMETHOD.


  METHOD build_body.
    " El cuerpo es JSON: {"query":"...","variables":{...}}
    " Hay que escapar las comillas y barras de la consulta
    DATA(lv_query) = iv_query.
    REPLACE ALL OCCURRENCES OF `\` IN lv_query WITH `\\`.
    REPLACE ALL OCCURRENCES OF `"` IN lv_query WITH `\"`.
    REPLACE ALL OCCURRENCES OF |\n| IN lv_query WITH ` `.

    rv_body = `{"query":"` && lv_query && `"`.
    IF iv_variables IS NOT INITIAL.
      rv_body = rv_body && `,"variables":` && iv_variables.
    ENDIF.
    rv_body = rv_body && `}`.
  ENDMETHOD.

ENDCLASS.
