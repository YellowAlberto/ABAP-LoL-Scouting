CLASS zcl_apv_grid_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_apv_grid_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    SELECT SINGLE param_value FROM zapv_config
      WHERE param_name = 'API_KEY'
      INTO @DATA(lv_api_key).
    IF sy-subrc <> 0.
      out->write( 'No hay API key. Ejecuta antes ZCL_APV_SETUP_CONFIG.' ).
      RETURN.
    ENDIF.

    TRY.
        " 1. Destino: a que URL vamos
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url(
                                 i_url = 'https://api-op.grid.gg/central-data/graphql' ).

        " 2. Cliente HTTP para ese destino
        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        " 3. Peticion: cabeceras + cuerpo (igual que en Postman)
        DATA(lo_request) = lo_client->get_http_request( ).
        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'x-api-key'    i_value = CONV #( lv_api_key ) ).
        lo_request->set_text( `{"query":"{ titles { id name } }"}` ).

        " 4. Enviar con POST y leer la respuesta
        DATA(lo_response) = lo_client->execute( if_web_http_client=>post ).
        DATA(ls_status) = lo_response->get_status( ).
        out->write( |HTTP { ls_status-code } { ls_status-reason }| ).
        out->write( lo_response->get_text( ) ).

        lo_client->close( ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
        out->write( |Error: { lx_error->get_text( ) }| ).
    ENDTRY.

  ENDMETHOD.

  ENDCLASS.
