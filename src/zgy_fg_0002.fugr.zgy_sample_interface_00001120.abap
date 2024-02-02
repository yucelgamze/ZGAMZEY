FUNCTION ZGY_SAMPLE_INTERFACE_00001120.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_BUKRS) LIKE  BKPF-BUKRS
*"     VALUE(I_BELNR) LIKE  BKPF-BELNR
*"     VALUE(I_GJAHR) LIKE  BKPF-GJAHR
*"     VALUE(I_BUZEI) LIKE  BSEG-BUZEI
*"     VALUE(I_AKTYP) LIKE  OFIWA-AKTYP OPTIONAL
*"  EXPORTING
*"     VALUE(E_XCHNG) LIKE  OFIWA-XCHNG
*"----------------------------------------------------------------------
ENDFUNCTION.
