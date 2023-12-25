*&---------------------------------------------------------------------*
*& Include          ZGY_REUSEALV_001_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT
    ekko~ebeln,
    ekpo~ebelp,
    ekko~bstyp,
    ekko~bsart,
    ekpo~matnr,
    ekpo~menge,
    ekpo~meins
    FROM ekko
    INNER JOIN ekpo ON ekko~ebeln EQ ekpo~ebeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_list.

  LOOP AT gt_list INTO gs_list.

    IF gs_list-ebelp EQ '10'.
      CLEAR:gs_cell_color.
      gs_cell_color-fieldname = 'MATNR'.
      gs_cell_color-color-col = 5.
      gs_cell_color-color-int = 1.
      gs_cell_color-color-inv = 0.
      APPEND gs_cell_color TO gs_list-cell_color.

      CLEAR:gs_cell_color.
      gs_cell_color-fieldname = 'EBELP'.
      gs_cell_color-color-col = 6.
      gs_cell_color-color-int = 0.
      gs_cell_color-color-inv = 0.
      APPEND gs_cell_color TO gs_list-cell_color.

      MODIFY gt_list FROM gs_list.
    ENDIF.

    IF gs_list-ebelp EQ '20'.
      gs_list-line_color = 'C300'.
      MODIFY gt_list FROM gs_list.
    ENDIF.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .

*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_program_name   = sy-repid
**     i_internal_tabname = 'GT_LIST'" data occurs yapısı ile tanımlanmış headerline'lı itab
*      i_structure_name = 'ZGY_REUSE_S_001'
**     I_CLIENT_NEVER_DISPLAY       = 'X'
*      i_inclname       = sy-repid
**     I_BYPASSING_BUFFER =
**     I_BUFFER_ACTIVE  =
*    CHANGING
*      ct_fieldcat      = gt_fcat.
** EXCEPTIONS
**     INCONSISTENT_INTERFACE       = 1
**     PROGRAM_ERROR      = 2
**     OTHERS             = 3
**          .
  PERFORM: set_fcat_method USING 'EBELN' 'SAS No' 'SAS No' 'SAS No'                               abap_true  '0' abap_false  abap_true,
           set_fcat_method USING 'EBELP' 'Kalem' 'Kalem' 'Kalem'                                  abap_true  '1' abap_false  abap_false,
           set_fcat_method USING 'BSTYP' 'Belge Tipi' 'Belge Tipi' 'Belge Tipi'                   abap_false '2' abap_false  abap_false,
           set_fcat_method USING 'BSART' 'Belge Türü' 'Belge Türü' 'Belge Türü'                   abap_false '3' abap_false  abap_false,
           set_fcat_method USING 'MATNR' 'Malzeme Numarası' 'Malzeme Numarası' 'Malzeme Numarası' abap_false '4' abap_true   abap_true,
           set_fcat_method USING 'MENGE' 'Miktar' 'Miktar' 'Miktar'                               abap_false '5' abap_false  abap_false,
           set_fcat_method USING 'MEINS' 'Ö. B.' 'Ölçü Birimi' 'Ölçü Birimi'                      abap_false '6' abap_false  abap_false.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_METHOD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_method USING p_fieldname
                           p_seltext_s
                           p_seltext_m
                           p_seltext_l
                           p_key
                           p_col_pos
                           p_do_sum
                           p_hotspot.
  CLEAR:gs_fcat.
  gs_fcat-fieldname = p_fieldname.
  gs_fcat-seltext_s = p_seltext_s.
  gs_fcat-seltext_m = p_seltext_m.
  gs_fcat-seltext_l = p_seltext_l.
  gs_fcat-key       = p_key.
  gs_fcat-col_pos   = p_col_pos.
  gs_fcat-do_sum    = p_do_sum.
  gs_fcat-hotspot   = p_hotspot.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  CLEAR: gs_layout.
  gs_layout-window_titlebar   = 'REUSE ALV PRACTISE'.
  gs_layout-zebra             = abap_true.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-box_fieldname     = 'SELKZ'.
  gs_layout-info_fieldname    = 'LINE_COLOR'.
  gs_layout-coltab_fieldname    = 'CELL_COLOR'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

  CLEAR:gs_event.
  gs_event-name   = slis_ev_top_of_page.
  gs_event-form   = 'TOP_OF_PAGE'.
  APPEND gs_event TO gt_events.


  CLEAR:gs_event.
  gs_event-name   = slis_ev_end_of_list.
  gs_event-form   = 'END_OF_LIST'.
  APPEND gs_event TO gt_events.

  CLEAR:gs_event.
  gs_event-name   = slis_ev_pf_status_set.
  gs_event-form   = 'PF_STATUS_SET'.
  APPEND gs_event TO gt_events.

*  CLEAR:gs_exclude.
*  gs_exclude-fcode = '&UMC'.
*  APPEND gs_exclude TO gt_exclude.
*
*  CLEAR:gs_sort.
*  gs_sort-spos      = 1.
*  gs_sort-tabname   = 'GT_LIST'.
*  gs_sort-fieldname = 'EBELN'.
*  gs_sort-down      = abap_true.
*  APPEND gs_sort TO gt_sort.
*
*  CLEAR: gs_filter.
*  gs_filter-tabname   = 'GT_LIST'.
*  gs_filter-fieldname = 'EBELP'.
*  gs_filter-sign0     = 'I'.
*  gs_filter-optio     = 'EQ'.
*  gs_filter-valuf_int = 20.
*  APPEND gs_filter TO gt_filter.

*  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
*    EXPORTING
**     I_INTERFACE_CHECK        = ' '
**     I_BYPASSING_BUFFER       =
**     I_BUFFER_ACTIVE          = ' '
*      i_callback_program       = sy-repid
*      i_callback_pf_status_set = 'PF_STATUS_SET'
*      i_callback_user_command  = 'USER_COMMAND'
**     I_STRUCTURE_NAME         =
*      is_layout                = gs_layout
*      it_fieldcat              = gt_fcat
*      it_excluding             = gt_exclude
**     IT_SPECIAL_GROUPS        =
*      it_sort                  = gt_sort
*      it_filter                = gt_filter
**     IS_SEL_HIDE              =
**     I_DEFAULT                = 'X'
**     I_SAVE                   = ' '
**     IS_VARIANT               =
*      it_events                = gt_events
**     IT_EVENT_EXIT            =
**     IS_PRINT                 =
**     IS_REPREP_ID             =
**     I_SCREEN_START_COLUMN    = 0
**     I_SCREEN_START_LINE      = 0
**     I_SCREEN_END_COLUMN      = 0
**     I_SCREEN_END_LINE        = 0
**     IR_SALV_LIST_ADAPTER     =
**     IT_EXCEPT_QINFO          =
**     I_SUPPRESS_EMPTY_DATA    = ABAP_FALSE
** IMPORTING
**     E_EXIT_CAUSED_BY_CALLER  =
**     ES_EXIT_CAUSED_BY_USER   =
*    TABLES
*      t_outtab                 = gt_list
** EXCEPTIONS
**     PROGRAM_ERROR            = 1
**     OTHERS                   = 2
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.



  gs_variant-variant = p_varian.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
*     i_callback_top_of_page   = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout                = gs_layout
      it_fieldcat              = gt_fcat
      it_excluding             = gt_exclude
*     IT_SPECIAL_GROUPS        =
      it_sort                  = gt_sort
      it_filter                = gt_filter
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = 'X'
*     IS_VARIANT               = gs_variant
      it_events                = gt_events
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
      i_screen_start_column    = 40
      i_screen_start_line      = 5
      i_screen_end_column      = 100
      i_screen_end_line        = 20
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = gt_list
* EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form TOP_OF_PAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM top_of_page .
  DATA: lt_header  TYPE slis_t_listheader,
        ls_header  TYPE slis_listheader,
        lv_date    TYPE char10,
        lv_lines   TYPE i,
        lv_lines_c TYPE char4.

  DESCRIBE TABLE gt_list LINES lv_lines.
  lv_lines_c = lv_lines.

*  CONCATENATE 'Raporda'
*               lv_lines_c
*               'adet kalem vardır.'
*               INTO ls_header-info
*               SEPARATED BY space.

  CONCATENATE sy-datum+6(2)
              '.'
              sy-datum+4(2)
              '.'
              sy-datum+0(4)
              INTO lv_date.

  CLEAR:ls_header.
  ls_header-typ  = 'H'.
  ls_header-info = 'Satınalma Sipariş Raporu'.
  APPEND ls_header TO lt_header.

  CLEAR:ls_header.
  ls_header-typ  = 'S'.
  ls_header-key  = 'Tarih:'.
  ls_header-info = lv_date.
  APPEND ls_header TO lt_header.

*  CLEAR:ls_header.
*  ls_header-typ  = 'A'.
*  ls_header-info = 'Raporda' && | | && lv_lines_c && | | && |adet kalem vardır.|.
*  APPEND ls_header TO lt_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form END_OF_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM end_of_list .
  DATA: lt_header  TYPE slis_t_listheader,
        ls_header  TYPE slis_listheader,
        lv_date    TYPE char10,
        lv_lines   TYPE i,
        lv_lines_c TYPE char4.

  DESCRIBE TABLE gt_list LINES lv_lines.
  lv_lines_c = lv_lines.

*  CONCATENATE 'Raporda'
*               lv_lines_c
*               'adet kalem vardır.'
*               INTO ls_header-info
*               SEPARATED BY space.

*  CONCATENATE sy-datum+6(2)
*              '.'
*              sy-datum+4(2)
*              '.'
*              sy-datum+0(4)
*              INTO lv_date.
*
*  CLEAR:ls_header.
*  ls_header-typ  = 'H'.
*  ls_header-info = 'Satınalma Sipariş Raporu'.
*  APPEND ls_header TO lt_header.
*
*  CLEAR:ls_header.
*  ls_header-typ  = 'S'.
*  ls_header-key  = 'Tarih:'.
*  ls_header-info = lv_date.
*  APPEND ls_header TO lt_header.

  CLEAR:ls_header.
  ls_header-typ  = 'A'.
  ls_header-info = 'Raporda' && | | && lv_lines_c && | | && |adet kalem vardır.|.
  APPEND ls_header TO lt_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PF_STATUS_SET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pf_status_set USING p_extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.

"SE41 TCODE saplsalv programı
*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM user_command USING p_ucomm     TYPE sy-ucomm
                        ps_selfield TYPE slis_selfield.

  DATA:lv_msg   TYPE char200,
       lv_index TYPE numc2.

  CASE p_ucomm.
    WHEN '&MSG'.

      LOOP AT gt_list INTO gs_list WHERE selkz EQ 'X'.
        lv_index = lv_index + 1.
      ENDLOOP.

      CONCATENATE lv_index
                  'sayı kadar satır seçilmiştir.'
                  INTO lv_msg
                  SEPARATED BY space.
      MESSAGE lv_msg TYPE 'I'.

    WHEN '&IC1'.
      CASE ps_selfield-fieldname.
        WHEN 'EBELN'.
          CONCATENATE ps_selfield-value
                      'Numaralı SAS tıklanmıştır.'
                      INTO lv_msg
                      SEPARATED BY space.
          MESSAGE lv_msg TYPE 'I'.
        WHEN 'MATNR'.
          CONCATENATE ps_selfield-value
                      'Numaralı Malzeme tıklanmıştır.'
                      INTO lv_msg
                      SEPARATED BY space.
          MESSAGE lv_msg TYPE 'I'.
      ENDCASE.
*      MESSAGE 'Çift tıklandı!' TYPE 'I'.
  ENDCASE.
ENDFORM.
