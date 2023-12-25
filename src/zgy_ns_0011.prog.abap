*&---------------------------------------------------------------------*
*& Report ZGY_NS_0011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0011.

*DATA:gv_sonuc TYPE i.

*gv_sonuc = sqrt( 9 ) + sqrt( 4 ) .
*
*WRITE:/ sqrt( 9 ),'+', sqrt( 4 ),'=',gv_sonuc.

*gv_sonuc = CONV i( sqrt( 9 ) ) + CONV i( sqrt( 4 ) ).
*
*WRITE:/ CONV i( sqrt( 9 ) ),'+',  CONV i( sqrt( 4 ) ),'=',gv_sonuc.

*******************************************************************************************

*DATA:gv_char    TYPE char200,
*     gv_xstring TYPE xstring,
*     gv_string  TYPE string.
*
*gv_char = 'hebelehübele'.
*gv_string = gv_char.
*
*gv_xstring = cl_abap_codepage=>convert_to( source = gv_string ).

*******************************************************************************************
*DATA:gv_char TYPE char20.

*gv_char = |lalalallalalal|.

*DATA(lv_xstring) = cl_abap_codepage=>convert_to( source = CONV string( gv_char ) ).
*DATA(lv_xstring) = cl_abap_codepage=>convert_to( source = CONV #( gv_char ) ).

*******************************************************************************************
TABLES:scarr.

TYPES:BEGIN OF gty_alv,
        carrid   TYPE  s_carr_id,
        carrname TYPE s_carrname,
      END OF gty_alv.

TYPES:gtt_alv TYPE TABLE OF gty_alv.

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      display_alv IMPORTING it_alv TYPE gtt_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD display_alv.
    cl_demo_output=>display_data( EXPORTING value = it_alv ).
  ENDMETHOD.
ENDCLASS.


TYPES:BEGIN OF gty_scarr,
        carrid   TYPE  s_carr_id,
        carrname TYPE s_carrname,
        currcode TYPE	s_currcode,
        url      TYPE  s_carrurl,
      END OF gty_scarr.

DATA:gt_scarr TYPE TABLE OF gty_scarr.

DATA:go_local TYPE REF TO lcl_class.

START-OF-SELECTION.

  go_local = NEW lcl_class( ).

  SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

  go_local->display_alv( it_alv = CONV #( gt_scarr ) ).
