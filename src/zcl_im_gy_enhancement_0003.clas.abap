class ZCL_IM_GY_ENHANCEMENT_0003 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_FI_ITEMS_CH_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_GY_ENHANCEMENT_0003 IMPLEMENTATION.


  METHOD if_ex_fi_items_ch_data~change_items.

    CONSTANTS:lc_fbl1n TYPE tcode VALUE 'FBL1N', "satıcı-> lfa1
              lc_fbl3n TYPE tcode VALUE 'FBL3N', "ana hesap->ska1 (text table skat)
              lc_fbl5n TYPE tcode VALUE 'FBL5N'. "müşteri->kna1

    SELECT
    lfa1~lifnr,
    kna1~kunnr,
    kna1~name1,
    lfa1~name1 AS lname1,
    bseg~koart,
    skat~txt20,
    skat~saknr
    FROM bseg
    LEFT JOIN kna1 ON bseg~kunnr EQ kna1~kunnr
    LEFT JOIN lfa1 ON bseg~lifnr EQ lfa1~lifnr
    LEFT JOIN skat ON bseg~hkont EQ skat~saknr
    INTO TABLE @DATA(gt_1650).

    LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<lfs_items>).
      IF NOT <lfs_items>-konto IS INITIAL.

        CASE sy-tcode.

          WHEN lc_fbl1n."satıcı-> lfa1

            READ TABLE gt_1650 INTO DATA(ls_1650) WITH KEY lifnr = <lfs_items>-konto.
            IF sy-subrc IS INITIAL.
              <lfs_items>-zgy_ek_alan = ls_1650-lname1.
              <lfs_items>-zgy_lifnr   = ls_1650-lifnr.
            ENDIF.

          WHEN lc_fbl3n."ana hesap->ska1 (text table skat)

            READ TABLE gt_1650 INTO ls_1650 WITH KEY saknr = <lfs_items>-konto.
            IF sy-subrc IS INITIAL.
              <lfs_items>-zgy_ek_alan = ls_1650-txt20.
            ENDIF.

          WHEN lc_fbl5n."müşteri->kna1

            READ TABLE gt_1650 INTO ls_1650 WITH KEY kunnr = <lfs_items>-konto.
            IF sy-subrc IS INITIAL.
              <lfs_items>-zgy_ek_alan = ls_1650-name1.
            ENDIF.

        ENDCASE.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
