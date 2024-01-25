*&---------------------------------------------------------------------*
*& Include          ZGY_P_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    DATA(lt_domain) = VALUE dd07v_tab( ).

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = 'STATV'    "<<--- Supply domain name here
        text           = 'X'
        langu          = sy-langu
      TABLES
        dd07v_tab      = lt_domain
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

*    LOOP AT lt_domain INTO ls_domain .
*      DATA(desc) = ls_domain-ddtext.
*    ENDLOOP.

    SELECT
    vbak~vbeln
*      vbak~lifsk  AS lifsk_d,
*      vbak~faksk  AS faksk_d,
*      vbak~augru  AS augru_d,
*      vbap~abgru  AS abgru_d,
*      vbak~gbstk  AS gbstk_d,
*      vbak~lfstk  AS lfstk_d,
*      vbap~gbsta  AS gbsta_d,
*      vbap~lfsta  AS lfsta_d
    FROM vbak
*      LEFT JOIN vbap  ON vbak~vbeln EQ vbap~vbeln
    WHERE vbak~vbeln IN @so_vbeln
    INTO  TABLE @DATA(lt_itab).

    IF lt_itab IS NOT INITIAL.
      SELECT DISTINCT
      vbak~vbeln,
      vbkd~bstkd,
      vbak~audat,
      vbak~auart,
      vbap~posnr,
      vbak~kunnr,
      vbap~matnr,
      vbap~kwmeng,
      vbap~vrkme,
      vbap~netwr AS netwr_i,
      vbap~waerk,
      vbak~augru,
      vbak~bstnk,
      vbak~ernam,
      vbak~erdat,
      vbak~erzet,
      vbak~faksk,
      vbak~ktext,
      vbak~kurst,
      vbak~lifsk,
      vbak~netwr AS netwr_h,
      vbak~spart,
      vbak~vbtyp,
      vbak~vkbur,
      vbak~vkgrp,
      vbak~vkorg,
      vbak~vtweg,
      vbak~gbstk,
      vbak~lfstk,
      kna1~name1,
      vbap~abgru,
      vbap~arktx,
      vbap~charg,
      vbap~kbmeng,
      vbap~kmein,
      vbap~lgort,
      vbap~meins,
      vbap~netpr,
      vbap~shkzg,
      vbap~vstel,
      vbap~werks,
      vbap~zmeng,
      vbap~gbsta,
      vbap~lfgsa,
      vbkd~kursk,
      vbkd~prsdt,
      vbpa~parvw,
      vbpa~pernr,
      kna1~adrnr,
      vbep~etenr,
      vbep~edatu,
      vbep~wmeng,
      vbep~bmeng,
      vbep~cmeng,
      vbep~wadat,
      vbep~mbdat,
      vbep~ettyp,
      veda~vlaufz,
      veda~vlauez,
      veda~vlaufk,
      veda~vinsdat,
      veda~vabndat,
      veda~vuntdat,
      veda~vbegdat,
      veda~venddat,
      veda~vkuesch,
      veda~vaktsch,
      veda~veindat,
      veda~vwundat,
      veda~vkuepar,
      veda~vkuegru,
      veda~vbelkue,
      veda~vbedkue,
      veda~vdemdat,
      veda~vasda,
      vbak~lifsk  AS lifsk_d,  "*****
      vbak~faksk  AS faksk_d,
      vbak~augru  AS augru_d,
      vbap~abgru  AS abgru_d,
      vbak~gbstk  AS gbstk_d,
      vbak~lfstk  AS lfstk_d,
      vbap~gbsta  AS gbsta_d,
      vbap~lfsta  AS lfsta_d,  "*****
      tvkot~vtext AS so_name,
      tvtwt~vtext AS dist_ch,
      tspat~vtext AS div_name,
      tvakt~bezei,
      tvakt~spras,
      tvkot~spras,
      tvtwt~spras,
      tspat~spras,
      adrc~xpcpt  AS sold_to,
      adcp~xpcpt  AS partner,
      veda~vaktsch AS actiond
        FROM vbak
        LEFT JOIN vbkd  ON vbak~vbeln EQ vbkd~vbeln
        LEFT JOIN vbpa  ON vbkd~vbeln EQ vbpa~vbeln AND vbpa~parvw EQ 'AG'
        LEFT JOIN vbap  ON vbak~vbeln EQ vbap~vbeln
        LEFT JOIN veda  ON vbap~vbeln EQ veda~vbeln AND veda~vbeln EQ 40000000
        LEFT JOIN vbep  ON vbap~vbeln EQ vbep~vbeln
        LEFT JOIN kna1  ON vbak~kunnr EQ kna1~kunnr
        LEFT JOIN tvkot ON vbak~vkorg EQ tvkot~vkorg
        LEFT JOIN tvtwt ON vbak~vtweg EQ tvtwt~vtweg
        LEFT JOIN tspat ON vbak~spart EQ tspat~spart
        LEFT JOIN tvakt ON vbak~auart EQ tvakt~auart
        LEFT JOIN adrc  ON adrc~addrnumber EQ kna1~adrnr
        LEFT JOIN adcp  ON adrc~addrnumber EQ adcp~addrnumber
        FOR ALL ENTRIES IN @lt_itab
*        inner join @lt_itab as lt
        WHERE "vbak~vbeln IN @so_vbeln AND
              vbak~auart IN @so_auart AND
              vbak~kunnr IN @so_kunnr AND
              vbak~audat IN @so_audat AND
              vbap~matnr IN @so_matnr AND
              vbkd~bstkd IN @so_bstkd AND
              vbak~erdat IN @so_erdat AND

              vbak~vbeln EQ @lt_itab-vbeln AND
              tvakt~spras EQ 'T' AND
              tvkot~spras EQ 'T' AND
              tvtwt~spras EQ 'T' AND
              tspat~spras EQ 'T'
              INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
    ELSE.
      MESSAGE |Veri Bulunamamıştır!| TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
    SORT gt_alv BY vbeln.
    DELETE ADJACENT DUPLICATES FROM gt_alv COMPARING vbeln.

    IF lt_domain IS NOT INITIAL.

      LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
        IF <lfs_alv> IS ASSIGNED.
*          READ TABLE lt_domain INTO ls_domain INDEX 4 .


          READ TABLE lt_domain INTO DATA(ls_domain) WITH KEY domvalue_l = <lfs_alv>-lifsk_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-lifsk_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-faksk_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-faksk_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-augru_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-augru_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-abgru_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-abgru_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-gbstk_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-gbstk_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-lfstk_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-lfstk_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-gbsta_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-gbsta_d = CONV #( ls_domain-ddtext ).
          ENDIF.

          READ TABLE lt_domain INTO ls_domain WITH KEY domvalue_l = <lfs_alv>-lfsta_d .
          IF sy-subrc EQ 0.
            <lfs_alv>-lfsta_d = CONV #( ls_domain-ddtext ).
          ENDIF.

*        ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.
  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.
  METHOD set_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
*       I_BUFFER_ACTIVE  =
*       i_structure_name = 'ZSD_S_0001'
        i_structure_name = 'ZSD_S_0002'
*
      CHANGING
        ct_fieldcat      = gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 79
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'LIFSK_D'
                        scrtext_s  = 'Delivery B.D.'
                        scrtext_m  = 'Delivery Block Desc'
                        scrtext_l  = 'Delivery Block Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 80
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'FAKSK_D'
                        scrtext_s  = 'Billing B.D.'
                        scrtext_m  = 'Billing Block Desc'
                        scrtext_l  = 'Billing Block Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 81
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'AUGRU_D'
                        scrtext_s  = 'Order R.D.'
                        scrtext_m  = 'Order Reason Desc'
                        scrtext_l  = 'Order Reason Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 82
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'ABGRU_D'
                        scrtext_s  = 'Rejection R.D.'
                        scrtext_m  = 'Rejection Reason Desc'
                        scrtext_l  = 'Rejection Reason Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 83
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'GBSTK_D'
                        scrtext_s  = 'Overall S.D.'
                        scrtext_m  = 'Overall Status Desc'
                        scrtext_l  = 'Overall Status Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 84
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'LFSTK_D'
                        scrtext_s  = 'Delivery S.D.'
                        scrtext_m  = 'Delivery Status Desc'
                        scrtext_l  = 'Delivery Status Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 85
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'GBSTA_D'
                        scrtext_s  = 'O.S.ItemD.'
                        scrtext_m  = 'O.Status Item Desc'
                        scrtext_l  = 'Overall Status Item Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 86
                        datatype   = 'CHAR'
                        intlen     = 60
                        fieldname  = 'LFSTA_D'
                        scrtext_s  = 'D.S.ItemD.'
                        scrtext_m  = 'Delivery S. Item Desc'
                        scrtext_l  = 'Delivery Status Item Description').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 87
                        datatype   = 'CHAR'
                        intlen     = 20
                        fieldname  = 'SO_NAME'
                        scrtext_s  = 'SalesOrg.N.'
                        scrtext_m  = 'Sales Org. Name'
                        scrtext_l  = 'Sales Organization Name').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 88
                        datatype   = 'CHAR'
                        intlen     = 20
                        fieldname  = 'DIST_CH'
                        scrtext_s  = 'Dist.Ch.Name'
                        scrtext_m  = 'Dist. Channel Name'
                        scrtext_l  = 'Distribution Channel Name').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 89
                        datatype   = 'CHAR'
                        intlen     = 20
                        fieldname  = 'DIV_NAME'
                        scrtext_s  = 'Div. Name'
                        scrtext_m  = 'Division Name'
                        scrtext_l  = 'Division Name').
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 90
                        datatype   = 'CHAR'
                        intlen     = 20
                        fieldname  = 'BEZEI'
                        scrtext_s  = 'SD Type'
                        scrtext_m  = 'Sales Document Type'
                        scrtext_l  = 'Sales Document Type').
    APPEND gs_fcat TO gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
  ENDMETHOD.
  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
