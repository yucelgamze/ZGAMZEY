*&---------------------------------------------------------------------*
*& Report ZGY_API_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_api_test.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
PARAMETERS: p_inv TYPE belnr_d DEFAULT '12345'.
SELECTION-SCREEN: END OF BLOCK b1.

START-OF-SELECTION.

*HTTP Client Abstraction
  DATA  lo_client TYPE REF TO if_http_client.

*Data variables for storing response in xstring and string
  DATA  : lv_xstring   TYPE xstring,
          lv_string    TYPE string,
          lv_node_name TYPE string.

  CLEAR : lv_xstring, lv_string, lv_node_name.

*Pass the URL to get Data
  lv_string = |https://XXXXXX.com/api/XXXXX/{ p_inv }|.

*Creation of New IF_HTTP_Client Object
  cl_http_client=>create_by_url(
  EXPORTING
    url                = lv_string
  IMPORTING
    client             = lo_client
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    ).

  IF sy-subrc IS NOT INITIAL.
* Handle errors
  ENDIF.

  lo_client->propertytype_logon_popup = lo_client->co_disabled.
  lo_client->request->set_method( 'GET' ).


  CALL METHOD lo_client->request->set_header_field
    EXPORTING
      name  = 'XXXXXXXX'
      value = ' XXXXXXXX '.


  CALL METHOD lo_client->request->set_header_field
    EXPORTING
      name  = 'Accept'
      value = 'application/xml'.

*Structure of HTTP Connection and Dispatch of Data
  lo_client->send( ).
  IF sy-subrc IS NOT INITIAL.
* Handle errors
  ENDIF.

*Receipt of HTTP Response
  lo_client->receive( ).
  IF sy-subrc IS NOT INITIAL.
* Handle errors
  ENDIF.

END-OF-SELECTION.

*Return the HTTP body of this entity as binary data
  lv_xstring = lo_client->response->get_data( ).

**Displays XML File
  CALL METHOD cl_abap_browser=>show_xml
    EXPORTING
      xml_xstring = lv_xstring
      size        = cl_abap_browser=>large.
