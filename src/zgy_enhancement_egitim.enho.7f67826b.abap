"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT_PREPARE\SE:BEGIN\EI
ENHANCEMENT 0 ZGY_ENHANCEMENT_EGITIM.
* For the purpose of learning the concept of the enhacement operations

*  DATA: ls_vbak TYPE vbak.
*
*  IF vbak-zegitim is INITIAL.
*    WRITE: 'vbak-zegitim is initial!'.
*  ENDIF.

*  SELECT SINGLE *
*    FROM vbak
*    INTO ls_vbak
*    WHERE vbeln eq vbak-vbeln.

    "hana syntax is not valid
*    SELECT SINGLE *
*    FROM vbak
*    INTO @DATA(ls_vbak_hana)
*    WHERE vbeln eq @vbak-vbeln.

ENDENHANCEMENT.
