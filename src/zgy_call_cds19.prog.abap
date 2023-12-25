*&---------------------------------------------------------------------*
*& Report ZGY_CALL_CDS18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_call_cds19.

PARAMETERS:p_mtart TYPE mtart,
           p_matkl TYPE matkl.

SELECT *
  FROM zgy_cds19( p_mtype = @p_mtart, p_mgroup = @p_matkl )
  INTO TABLE @DATA(lt_cds19).


  cl_salv_table=>factory(
*    EXPORTING
*      list_display   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      r_container    =     " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table   =  DATA(lo_alv)   " Basis Class Simple ALV Tables
    CHANGING
      t_table        = lt_cds19
  ).
*    CATCH cx_salv_msg.    "

  lo_alv->display( ).
