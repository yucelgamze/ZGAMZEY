*&---------------------------------------------------------------------*
*& Report ZGY_CDS_SALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds1_salv.

START-OF-SELECTION.

  SELECT *
    FROM zgy_cds1
    INTO TABLE @DATA(lt_cds1).

  cl_salv_table=>factory(
*    EXPORTING
*      list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      r_container    =     " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
    CHANGING
      t_table        = lt_cds1
  ).
*    CATCH cx_salv_msg.    "

  lo_alv->display( ).
