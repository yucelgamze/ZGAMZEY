*&---------------------------------------------------------------------*
*& Include          ZGY_WORK9_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REGISTER_F4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_f4 .
  DATA:lt_f4 TYPE lvc_t_f4,
       ls_f4 TYPE lvc_s_f4.

  CLEAR:ls_f4.
  ls_f4-fieldname = 'CARRNAME'.
  ls_f4-register  = abap_true.

  APPEND ls_f4 TO lt_f4.

  CALL METHOD go_alv_grid->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4.  " F4 Fields
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EXCLUDING
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_excluding .
  CLEAR:gv_excluding.
  gv_excluding = cl_gui_alv_grid=>mc_fc_detail.
  APPEND gv_excluding TO gt_excluding.

  CLEAR:gv_excluding.
  gv_excluding = cl_gui_alv_grid=>mc_fc_find.
  APPEND gv_excluding TO gt_excluding.

  CLEAR:gv_excluding.
  gv_excluding = cl_gui_alv_grid=>mc_fc_sort_asc.
  APPEND gv_excluding TO gt_excluding.

  CLEAR:gv_excluding.
  gv_excluding = cl_gui_alv_grid=>mc_fc_sort_dsc.
  APPEND gv_excluding TO gt_excluding.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .
  CLEAR:gs_sort.
  gs_sort-spos      = 1.
  gs_sort-fieldname = 'CURRCODE'.
  gs_sort-down      = abap_true.
  APPEND gs_sort TO gt_sort.

  CLEAR:gs_sort.
  gs_sort-spos      = 2.
  gs_sort-fieldname = 'CARRNAME'.
  gs_sort-up        = abap_true.
  APPEND gs_sort TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FILTER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_filter .
  CLEAR:gs_filter.
  gs_filter-tabname   = 'GT_ALV'.
  gs_filter-fieldname = 'CURRCODE'.
  gs_filter-sign      = 'I'. "/'E'
  gs_filter-option    = 'EQ'.
  gs_filter-low       = 'USD'.
*gs_filter-high      =
  APPEND gs_filter TO gt_filter.
ENDFORM.
