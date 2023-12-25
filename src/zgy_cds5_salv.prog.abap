*&---------------------------------------------------------------------*
*& Report ZGY_CDS5_SALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds5_salv.

START-OF-SELECTION.

  SELECT *
    FROM zgy_cds5( p_islem = '+',
                   p_sayi  = 10 )
    INTO TABLE @DATA(lt_cds5).

  cl_salv_table=>factory(
*    EXPORTING
*      list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      r_container    =     " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
    CHANGING
      t_table        = lt_cds5
  ).
*    CATCH cx_salv_msg.    "

  lo_alv->display( ).
