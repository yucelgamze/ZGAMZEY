*&---------------------------------------------------------------------*
*& Report ZGY_P_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0002.

DATA:gv_client_id     TYPE string VALUE 'acd7dc6d-46cd-41bb-938c-010081145c7b',
     gv_client_secret TYPE string VALUE '-yf8Q~Z00wvLHxiLsDwljI1VSCvmHT~ybY5G8cf-',
     gv_tenant_id     TYPE string VALUE 'b3883928-8797-4629-ba1d-46a830bee1ed',
     gv_response      TYPE string,
     gv_access_token  TYPE string,
     gt_users         TYPE TABLE OF string,
     gv_user          TYPE string,
     go_http_client   TYPE REF TO if_http_client.

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


BREAK-POINT.


"ŞİMDİ BURADA JSON PARSE YAPILMASI GEREKLİ

DATA:lo_json TYPE REF TO data.
/ui2/cl_json=>deserialize(
 EXPORTING
   json             = lv_auth_response
*    jsonx            =
*    pretty_name      =
*    assoc_arrays     =
*    assoc_arrays_opt =
  CHANGING
    data             = lo_json
).

*lv_token = lo_json->get( 'access_token' ).

*lo_json = 'acces_token' && lo_json.
*gv_access_token = CONV #( lo_json ).

**--------------------------------------------------------------------*
*DATA(lo_json_auth) = NEW cl_trex_json_deserializer( ).
*
*lo_json_auth->deserialize(
*  EXPORTING
*    json = lv_auth_response
*  IMPORTING
*    abap = gv_access_token
*).
**-------------------------------------------------------------------*

*DATA(lo_json) = cl_sxml_string_reader=>create( CONV #( lv_auth_response ) ).
*
*BREAK-POINT.
*lo_json->read_current_node( ).

gv_access_token = lv_auth_response.
*--------------------------------------------------------------------*
go_http_client->request->set_method( 'GET' ).
go_http_client->request->set_header_field( name = 'Authorization' value = 'Bearer ' && gv_access_token ).

cl_http_utility=>set_request_uri(
request = go_http_client->request
uri = 'https://graph.microsoft.com/v1.0/users' ).

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

LOOP AT gt_users INTO gv_user.
  WRITE: / gv_user.
ENDLOOP.


*--------------------------------------------------------------------*

"CREATE

*DATA(lv_user_data) = |{{"accountEnabled": true, "displayName": "John Doe", "mailNickname": "john.doe", "userPrincipalName": "john.doe@yourdomain.com"}}|.
