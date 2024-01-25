FUNCTION zgy_sample_interface_00001650.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"  EXPORTING
*"     VALUE(E_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"----------------------------------------------------------------------

  TABLES : bseg,lfa1,kna1,skat.

  e_postab = i_postab.

  SELECT SINGLE lfa1~lifnr,
    kna1~kunnr,
    kna1~name1,
    kna1~name2,
    lfa1~name1 AS lname1,
    lfa1~name2 AS lname2,
    bseg~koart,
    skat~txt20
    FROM bseg
    LEFT JOIN kna1 ON bseg~kunnr EQ kna1~kunnr
    LEFT JOIN lfa1 ON bseg~lifnr EQ lfa1~lifnr
    LEFT JOIN skat ON bseg~hkont EQ skat~saknr
    INTO @DATA(gs_1650)
  WHERE bukrs = @e_postab-bukrs AND
    ( bseg~koart EQ 'D' OR bseg~koart EQ 'K' OR bseg~koart EQ 'S' ).

  IF gs_1650-koart EQ 'D'.
*    e_postab-zgy_kunnr = gs_1650-kunnr.
    e_postab-zgy_name1 = gs_1650-name1 && | | && gs_1650-name2.

  ELSEIF gs_1650-koart EQ 'K'.
    e_postab-zgy_lifnr = gs_1650-lifnr.
    e_postab-zgy_name1 = gs_1650-lname1 && | | && gs_1650-lname2.

  ELSEIF gs_1650-koart EQ 'S'.
    e_postab-zgy_name1 = gs_1650-txt20.
  ENDIF.
*--------------------------------------------------------------------*
  DATA: lv_ogr_id TYPE zgy_de_0013.

  SELECT SINGLE ogrenci_id FROM zgy_t_0017
    INTO lv_ogr_id
    WHERE gjahr EQ i_postab-gjahr.

  e_postab-ogrenci_id = lv_ogr_id.
*--------------------------------------------------------------------*

ENDFUNCTION.
