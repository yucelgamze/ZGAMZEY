*&---------------------------------------------------------------------*
*& Report ZGY_NS_0023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0023.
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_line IMPORTING iv_carrid          TYPE s_carr_id
               RETURNING VALUE(rv_carrname) TYPE s_carrname.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_line.
    SELECT SINGLE carrname
      FROM scarr
      INTO @rv_carrname
      WHERE carrid EQ @iv_carrid.
  ENDMETHOD.
ENDCLASS.

*DATA:go_local TYPE REF TO lcl_class.

*START-OF-SELECTION.

*CREATE OBJECT go_local.
*go_local->get_line( iv_carrid = 'AB' ).

*--------------------------------------------------------------------*
*START-OF-SELECTION.
*DATA(lo_local) = NEW lcl_class( ).
*
*lo_local->get_line( iv_carrid = 'AB' ).

*--------------------------------------------------------------------*

*DATA:go_local    TYPE REF TO lcl_class,
*     gv_carrname TYPE s_carrname.
*
*START-OF-SELECTION.
*
*  CREATE OBJECT go_local.
*  gv_carrname = go_local->get_line( iv_carrid = 'AB' ).
*
*  WRITE gv_carrname.
*--------------------------------------------------------------------*
START-OF-SELECTION.
*  DATA(lo_local) = NEW lcl_class( ).

*  DATA(lv_carrname) = lo_local->get_line( iv_carrid = 'AB' ).
  DATA(lv_carrname) = NEW lcl_class( )->get_line( iv_carrid = 'AB' ).
  WRITE:lv_carrname.

  IF  NEW lcl_class( )->get_line( iv_carrid = 'AB' ) EQ 'Air Berlin'.
    WRITE:/ |{ 'Veriler aynı!' CASE = (cl_abap_format=>c_upper) }|.
  ELSE.
    WRITE:/ |{ 'Veriler farklı!' CASE = (cl_abap_format=>c_upper) }|.
  ENDIF.
