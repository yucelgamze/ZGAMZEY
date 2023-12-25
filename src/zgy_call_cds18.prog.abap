*&---------------------------------------------------------------------*
*& Report ZGY_CALL_CDS18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_call_cds18.

SELECT *
  FROM zgy_cds18
  INTO TABLE @DATA(lt_cds18).
*  WHERE matkl EQ 'L004'.

cl_salv_table=>factory(
*    EXPORTING
*      list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      r_container    =     " Abstract Container for GUI Controls
*      container_name =
  IMPORTING
    r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
  CHANGING
    t_table        = lt_cds18
).
*    CATCH cx_salv_msg.    "

lo_alv->display( ).


** with ddl name
*cl_salv_gui_table_ida=>create_for_cds_view( 'ZGY_DDL18' )->fullscreen( )->display( ).
