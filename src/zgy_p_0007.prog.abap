*&---------------------------------------------------------------------*
*& Report ZGY_P_0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0007.

DATA:gv_client_id      TYPE string VALUE 'f799602c-baca-4b06-b4ce-8315a2e21908',
     gv_client_secret  TYPE string VALUE 'Fqq8Q~y4Yi~lxOctjDSiU3S6HyprlLQOYnNika-C',
     gv_tenant_id      TYPE string VALUE 'b3883928-8797-4629-ba1d-46a830bee1ed',
     gv_response       TYPE string,
     gv_access_token   TYPE string,
     gv_access_token_b TYPE string,
     gt_users          TYPE TABLE OF string,
     gv_user           TYPE string,
     go_http_client    TYPE REF TO if_http_client.

DATA:gv_url TYPE string.

DATA(lv_scope) = 'https://graph.microsoft.com/.default'.

gv_url ='https://login.microsoftonline.com/' && gv_tenant_id && '/oauth2/v2.0/token '.

CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url                = gv_url   " URL
  IMPORTING
    client             = go_http_client   " HTTP Client Abstraction
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4.

go_http_client->request->set_method('POST').
go_http_client->request->set_header_fields(
  VALUE #( ( name = 'Content-Type' value = 'application/x-www-form-urlencoded'  )
           ( name = 'Accept'       value = 'application/json' ) ) ) .

*go_http_client->request->set_header_field( name = 'Content-Type' value = 'application/x-www-form-urlencoded' ).

DATA(lv_body) = |client_id={ gv_client_id }&client_secret={ gv_client_secret }&grant_type=client_credentials&scope={ lv_scope }|.

go_http_client->request->set_cdata( lv_body ).

CALL METHOD go_http_client->send
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5.

IF sy-subrc = 0.
  CALL METHOD go_http_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
ENDIF.

DATA(lv_auth_response) = go_http_client->response->get_cdata( ).      "ACCESS TOKEN ALINDI !

DATA:lr_data TYPE REF TO data.

/ui2/cl_json=>deserialize(
  EXPORTING
    json             = lv_auth_response
  CHANGING
    data             = lr_data
).

IF lr_data IS BOUND.
  ASSIGN lr_data->* TO FIELD-SYMBOL(<data>).
  ASSIGN COMPONENT `ACCESS_TOKEN` OF STRUCTURE <data> TO FIELD-SYMBOL(<results>).
  ASSIGN <results>->* TO FIELD-SYMBOL(<table>).
ENDIF.

BREAK-POINT.

gv_access_token = <table>.
CONCATENATE 'Bearer' gv_access_token INTO gv_access_token_b SEPARATED BY space.

* GET USER LIST

*--------------------------------------------------------------------*


gv_url = 'https://graph.microsoft.com/v1.0/users'.

CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url                = gv_url   " URL
  IMPORTING
    client             = go_http_client   " HTTP Client Abstraction
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4.


*go_http_client->request->set_header_fields(
*  VALUE #( ( name = 'Content-Type' value = 'application/x-www-form-urlencoded'  )
*           ( name = 'Accept'       value = 'application/json' ) ) ) .
go_http_client->request->set_method( 'GET' ).
go_http_client->request->set_header_fields(
VALUE #(  ( name = 'Accept'        value = 'application/json' )
          ( name = 'Authorization' value = gv_access_token_b  ) ) ).

*cl_http_utility=>set_request_uri(
*request = go_http_client->request
*uri = 'https://graph.microsoft.com/v1.0/users' ).

CALL METHOD go_http_client->send
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5.

IF sy-subrc = 0.
  CALL METHOD go_http_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
ENDIF.
gv_response = go_http_client->response->get_cdata( ).

BREAK-POINT.


WRITE: gv_response.

*LOOP AT gt_users INTO gv_user.
*  WRITE: / gv_user.
*ENDLOOP.

IF gv_response IS NOT INITIAL.

  DATA: lv_destination TYPE rfcdest,
        lt_data        TYPE TABLE OF tab512,
        lt_fields      TYPE TABLE OF rfc_db_fld.

  lv_destination = 'LDAP_RFC'.
  "sm59
  "RFC Destination: LDAP_RFC
  "Connection Type: T (TCP/IP Connection)
  "Target Host: ldap.example.com
  "Target Service: 389

  CALL FUNCTION 'RFC_PING' DESTINATION lv_destination.
  .
  CALL FUNCTION 'RFC_READ_TABLE' DESTINATION lv_destination
    EXPORTING
      query_table    = ''
    TABLES
      data           = lt_data
      fields         = lt_fields
    EXCEPTIONS
      system_failure = 1
      OTHERS         = 2.
ENDIF.

*CALL FUNCTION 'LDAP_SEARCH'


CALL FUNCTION 'LDAP_READ'
* EXPORTING
*   BASE                = ''
*   BASE_STRING         =
*   SCOPE               = 2
*   FILTER              = '(objectclass=*)'
*   FILTER_STRING       =
*   TIMEOUT             =
*   ATTRIBUTES          =
* IMPORTING
*   LDAPRC              =
*   ENTRIES             =
* EXCEPTIONS
*   NO_AUTHORIZ         = 1
*   CONN_OUTDATE        = 2
*   LDAP_FAILURE        = 3
*   NOT_ALIVE           = 4
*   OTHER_ERROR         = 5
*   OTHERS              = 6
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
