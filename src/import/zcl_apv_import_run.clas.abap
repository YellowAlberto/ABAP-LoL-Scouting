CLASS zcl_apv_import_run DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_apv_import_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Anade aqui los ids de serie que quieras importar (los sacas de allSeries en Postman)
    DATA lt_series_ids TYPE STANDARD TABLE OF zapv_series-series_id WITH EMPTY KEY.
    " Play-ins y comienzo de la fase suiza (15 partidos)
*    lt_series_ids = VALUE #(
*      ( '3012943' ) ( '3012942' ) ( '3012944' ) ( '3012945' ) ( '3012946' )
*      ( '3012947' ) ( '3012948' ) ( '3012952' ) ( '3012955' ) ( '3012950' )
*      ( '3012951' ) ( '3012949' ) ( '3012953' ) ( '3012954' ) ( '3012960' ) ).

    " Fase suiza (16 partidos )
*    lt_series_ids = VALUE #(
*          ( '3012956' ) ( '3012961' ) ( '3012957' ) ( '3012962' ) ( '3012958' )
*          ( '3012959' ) ( '3012963' ) ( '3014636' ) ( '3014637' ) ( '3014638' )
*          ( '3014639' ) ( '3014640' ) ( '3014641' ) ( '3014642' ) ( '3014643' )
*          ( '3012964' ) ).

    "Final de la fase suiza y eliminatorias (15 partidos)
    lt_series_ids = VALUE #(
         ( '3012965' ) ( '3012968' ) ( '3012967' ) ( '3012969' ) ( '3012970' )
         ( '3012971' ) ( '3012972' ) ( '3012973' ) ( '3012976' ) ( '3012977' )
         ( '3012974' ) ( '3012975' ) ( '3012979' ) ( '3012978' ) ( '3012986' ) ).

    TRY.
        DATA(lo_importer) = NEW zcl_apv_series_importer( ).

        LOOP AT lt_series_ids INTO DATA(lv_id).
          TRY.
              DATA(ls_result) = lo_importer->import_series( lv_id ).
              out->write( |Serie { lv_id }: { ls_result-games } partidas, | &&
                          |{ ls_result-players } filas de jugador, { ls_result-draft } acciones de draft| ).
            CATCH zcx_apv_grid_error INTO DATA(lx_series).
              " Un error en una serie no detiene las demas
              out->write( |Serie { lv_id }: ERROR - { lx_series->get_text( ) }| ).
          ENDTRY.
        ENDLOOP.

      CATCH zcx_apv_grid_error INTO DATA(lx_setup).
        out->write( lx_setup->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
