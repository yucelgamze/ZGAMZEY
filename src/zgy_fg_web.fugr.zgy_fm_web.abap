FUNCTION zgy_fm_web.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ILK_TARIH) TYPE  ERDAT
*"     VALUE(IV_SON_TARIH) TYPE  ERDAT
*"  EXPORTING
*"     VALUE(ET_SATIS_KALEM) TYPE  ZGY_TT_SATIS_KALEM
*"     VALUE(ET_SUCCESS) TYPE  XFELD
*"----------------------------------------------------------------------
  DATA:lt_kalem TYPE TABLE OF zgy_s_kalem,
       ls_kalem TYPE zgy_s_kalem,
       lt_belge TYPE zgy_tt_satis_kalem,
       ls_belge TYPE zgy_s_sat.

  SELECT
    vbak~vbeln,
    vbak~auart,
    vbak~erdat,
    vbak~netwr,
    vbak~waerk,
    vbak~vkorg,
    vbak~vkgrp,
    vbak~gsber,
    vbap~vbeln AS vbeln2,
    vbap~posnr,
    vbap~matnr,
    vbap~charg,
    vbap~matkl,
    vbap~zmeng,
    vbap~meins,
    vbap~netwr AS netwr2,
    vbap~waerk AS waerk2,
    vbap~spart,
    vbap~gsber AS gsber2,
    vbap~kdmat
    FROM vbak
    LEFT JOIN vbap
    ON vbak~vbeln EQ vbap~vbeln
    WHERE vbak~erdat BETWEEN  @iv_ilk_tarih AND @iv_son_tarih
    INTO TABLE @DATA(lt_satis) UP TO 500 ROWS.

  LOOP AT lt_satis ASSIGNING FIELD-SYMBOL(<gfs_satis>)
    GROUP BY ( vbeln = <gfs_satis>-vbeln ). "vbelnler aynıysa tekrar etmesin

*    ls_belge-vbeln = <gfs_satis>-vbeln .
*    ls_belge-auart = <gfs_satis>-auart .
*    ls_belge-erdat = <gfs_satis>-erdat .
*    ls_belge-netwr = <gfs_satis>-netwr .
*    ls_belge-waerk = <gfs_satis>-waerk .
*    ls_belge-vkorg = <gfs_satis>-vkorg .
*    ls_belge-vkgrp = <gfs_satis>-vkgrp .
*    ls_belge-gsber = <gfs_satis>-gsber .
    MOVE-CORRESPONDING <gfs_satis> TO ls_belge.

    LOOP AT GROUP <gfs_satis> ASSIGNING FIELD-SYMBOL(<gfs_kalem>).
      MOVE-CORRESPONDING <gfs_kalem> TO ls_kalem.
      APPEND ls_kalem TO lt_kalem.
      CLEAR: ls_kalem.
    ENDLOOP.
*    INSERT LINES OF lt_kalem INTO TABLE  ls_belge-vbap_kalem.
    ls_belge-vbap_kalem = lt_kalem.
    CLEAR:lt_kalem.
    APPEND ls_belge TO lt_belge.
    CLEAR:ls_belge.
  ENDLOOP.

  IF sy-subrc EQ 0.
    INSERT LINES OF lt_belge INTO TABLE et_satis_kalem.
    et_success = abap_true.
    SORT et_satis_kalem ASCENDING BY vbeln.
*     ASCENDING posnr.
    MESSAGE |VBAK ve VBAP tablosundaki tüm kalemlerin ilgili verileri alınarak VBELN  ascending olarak sıralanmıştır| TYPE 'I' DISPLAY LIKE 'S'.
  ELSE.
    et_success = abap_false.
    MESSAGE |HATA!!!| TYPE 'I' DISPLAY LIKE 'W'.
  ENDIF.

ENDFUNCTION.
