*&---------------------------------------------------------------------*
*& Report ZGY_SEARCH_HELP_FUNCTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_search_help_function.

TYPES:BEGIN OF gty_per,
        personal_id    TYPE zpers_id_de,
        personal_ad    TYPE zgy_de_per_ad,
        personal_soyad TYPE zgy_de_per_soyad,
        personal_yas   TYPE zgy_de_per_yas,
      END OF gty_per.

DATA: gt_pers       TYPE TABLE OF   gty_per,
      gt_return_tab TYPE TABLE OF   ddshretval,
      gt_mapping    TYPE TABLE OF   dselc,
      gs_mapping    TYPE    dselc.

DATA:gv_id TYPE numc5.
DATA:gt_per2        TYPE TABLE OF   gty_per,
     gt_return_tab2 TYPE TABLE OF   ddshretval,
     gt_mapping2    TYPE TABLE OF   dselc,
     gs_mapping2    TYPE    dselc.

PARAMETERS:
  p_id    TYPE numc5,
  p_ad    TYPE char20,
  p_soyad TYPE char30,
  p_yas   TYPE numc3.

SELECT-OPTIONS:so_id FOR gv_id.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_id-low.
  PERFORM f4if_int_table_value_request.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_id-high.
  PERFORM f4if_int_table_value_request.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_id.


  SELECT
  per~personal_id ,
  per~personal_ad,
  per~personal_soyad,
  per~personal_yas
  FROM zgy_t_personel AS per
  INTO CORRESPONDING FIELDS OF TABLE @gt_pers.

  gs_mapping-fldname  = 'F0001'.
  gs_mapping-dyfldname = 'P_ID'.
  APPEND gs_mapping TO gt_mapping.

  gs_mapping-fldname  = 'F0002'.
  gs_mapping-dyfldname = 'P_AD'.
  APPEND gs_mapping TO gt_mapping.

  gs_mapping-fldname  = 'F0003'.
  gs_mapping-dyfldname = 'P_SOYAD'.
  APPEND gs_mapping TO gt_mapping.

  gs_mapping-fldname  = 'F0004'.
  gs_mapping-dyfldname = 'P_YAS'.
  APPEND gs_mapping TO gt_mapping.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PERSONAL_ID'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'P_ID'
      value_org       = 'S'
    TABLES
      value_tab       = gt_pers
      return_tab      = gt_return_tab
      dynpfld_mapping = gt_mapping
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& Form F4IF_INT_TABLE_VALUE_REQUEST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4if_int_table_value_request .

  SELECT
per~personal_id ,
per~personal_ad,
per~personal_soyad,
per~personal_yas
FROM zgy_t_personel AS per
INTO CORRESPONDING FIELDS OF TABLE @gt_per2.

  gs_mapping-fldname  = 'F0001'.
  gs_mapping-dyfldname = 'SO_ID'.
  APPEND gs_mapping2 TO gt_mapping2.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'PERSONAL_ID'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'SO_ID'
      value_org       = 'S'
    TABLES
      value_tab       = gt_per2
      return_tab      = gt_return_tab2
      dynpfld_mapping = gt_mapping2
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
