FUNCTION zgy_fm_0005.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_TITLE) TYPE  CHAR30 OPTIONAL
*"     VALUE(I_FIRTNAME) TYPE  CHAR30 OPTIONAL
*"     VALUE(I_LASTNAME) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(E_NAME) TYPE  STRING
*"----------------------------------------------------------------------


  e_name = | { i_title } { i_firtname } { i_lastname } |.


ENDFUNCTION.
