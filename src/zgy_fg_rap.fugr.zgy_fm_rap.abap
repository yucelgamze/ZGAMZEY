FUNCTION zgy_fm_rap.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_STRING) TYPE  ZGY_DE_ATTACHMENT
*"  EXPORTING
*"     REFERENCE(RT_DATA) TYPE  ZGY_TT_003
*"----------------------------------------------------------------------


  DATA:lo_excel TYPE REF TO zgy_cl_rap.

  CREATE OBJECT lo_excel
    EXPORTING
      iv_data = iv_string.

  rt_data = lo_excel->get_excel_data_v2( ).


ENDFUNCTION.
