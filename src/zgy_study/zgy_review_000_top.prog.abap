*&---------------------------------------------------------------------*
*& Include          ZEGT_VKT_BLNTO_0O02_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS: icon.

CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS handle_data_changed
                  FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.

*    METHODS handle_on_f4
*                  FOR EVENT onf4 OF cl_gui_alv_grid
*      IMPORTING e_fieldname
*                  es_row_no
*                  er_event_data.
*
*    CLASS-METHODS:
*      handle_top_of_page
*            FOR EVENT top_of_page OF cl_gui_alv_grid
*        IMPORTING
*            e_dyndoc_id.

ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
*  METHOD handle_on_f4.
*    PERFORM handle_on_f4 USING e_fieldname es_row_no er_event_data.
*
*  ENDMETHOD.

  METHOD handle_data_changed.
    PERFORM handle_data_changed USING er_data_changed.

  ENDMETHOD.
*  METHOD handle_top_of_page.
*    PERFORM f_event_top_of_page USING e_dyndoc_id.
*
*  ENDMETHOD.
ENDCLASS.

*ALV Tanımlamaları
DATA: gs_stable   TYPE        lvc_s_stbl,
      gs_fcat     TYPE        lvc_s_fcat,
      gt_fcat     TYPE        lvc_t_fcat,
      go_alv_grid TYPE REF TO cl_gui_alv_grid,
      gs_layout   TYPE        lvc_s_layo.

DATA: gt_output TYPE TABLE OF zegt_vkt_s010,
      gs_output TYPE          zegt_vkt_s010.

TYPES: BEGIN OF gty_msg,
         icon           LIKE icon-id,
         mess(100),
         doc_number(10),
       END OF   gty_msg.
DATA: gt_msg TYPE TABLE OF gty_msg,
      gs_msg TYPE          gty_msg.

DATA go_event TYPE REF TO lcl_event_receiver.
