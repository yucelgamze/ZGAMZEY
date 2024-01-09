*&---------------------------------------------------------------------*
*& Report ZGY_P_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0002_bk.

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



DATA:  lr_data          TYPE REF TO data.

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
*gv_access_token =
*|eyJ0eXAiOiJKV1QiLCJub25jZSI6IktwZVJXNkZhcEROZlk1VzI4UUphanZ5SzZpT2k1Uy| &&
*|1DLVJKV2RldjFNUXMiLCJhbGciOiJSUzI1NiIsIng1dCI6IjVCM25SeHRRN2ppOGVORGMz| &&
*|RnkwNUtmOTdaRSIsImtpZCI6IjVCM25SeHRRN2ppOGVORGMzRnkwNUtmOTdaRSJ9.eyJhd| &&
*|WQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHR| &&
*|wczovL3N0cy53aW5kb3dzLm5ldC9iMzg4MzkyOC04Nzk3LTQ2MjktYmExZC00NmE4MzBiZ| &&
*|WUxZWQvIiwiaWF0IjoxNzAzMjQyNTg1LCJuYmYiOjE3MDMyNDI1ODUsImV4cCI6MTcwMzM| &&
*|yOTI4NSwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFUUUF5LzhWQUFBQXNGc3pkQUlDU| &&
*|nFnOEt2bXMzWkYrajZwN1h1UkpPejRlZWZYUWlCSmszSXNpVDhXSjNTdUZmcVNnSW85S2p| &&
*|aOGIiLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6IkdyYXBoIEV4cGxvcmVyI| &&
*|iwiYXBwaWQiOiJkZThiYzhiNS1kOWY5LTQ4YjEtYThhZC1iNzQ4ZGE3MjUwNjQiLCJhcHB| &&
*|pZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IktvY2Fhc2xhbiIsImdpdmVuX25hbWUiOiJCd| &&
*|XJhayIsImlkdHlwIjoidXNlciIsImlwYWRkciI6IjIxMy43NC4xMTcuMTE3IiwibmFtZSI| &&
*|6IkJ1cmFrIEtvY2Fhc2xhbiIsIm9pZCI6IjM3ZjBiZTRlLTEwMDgtNDVlMi1hOGM2LTRmM| &&
*|zA0M2YyMDkxMyIsInBsYXRmIjoiMyIsInB1aWQiOiIxMDAzMjAwMjlGNERBOTRDIiwicmg| &&
*|iOiIwLkFTOEFLRG1JczVlSEtVYTZIVWFvTUw3aDdRTUFBQUFBQUFBQXdBQUFBQUFBQUFDd| &&
*|0FDVS4iLCJzY3AiOiJBUElDb25uZWN0b3JzLlJlYWRXcml0ZS5BbGwgQ2FsZW5kYXJzLlJ| &&
*|lYWQgQ2FsZW5kYXJzLlJlYWQuU2hhcmVkIENhbGVuZGFycy5SZWFkQmFzaWMgQ2FsZW5kY| &&
*|XJzLlJlYWRXcml0ZSBDYWxlbmRhcnMuUmVhZFdyaXRlLlNoYXJlZCBvcGVuaWQgcHJvZml| &&
*|sZSBVc2VyLkVuYWJsZURpc2FibGVBY2NvdW50LkFsbCBVc2VyLkV4cG9ydC5BbGwgVXNlc| &&
*|i5JbnZpdGUuQWxsIFVzZXIuTWFuYWdlSWRlbnRpdGllcy5BbGwgVXNlci5SZWFkIFVzZXI| &&
*|uUmVhZC5BbGwgVXNlci5SZWFkQmFzaWMuQWxsIGVtYWlsIiwic2lnbmluX3N0YXRlIjpbI| &&
*|mttc2kiXSwic3ViIjoiRGNkQmZneUMxSXVldHRoVEppQ0VZR2FlY1BEdVQxRGpDS0Q2ZzR| &&
*|jcU4tZyIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJFVSIsInRpZCI6ImIzODgzOTI4LTg3O| &&
*|TctNDYyOS1iYTFkLTQ2YTgzMGJlZTFlZCIsInVuaXF1ZV9uYW1lIjoiYnVyYWsua29jYWF| &&
*|zbGFuQHZla3RvcmEuY29tIiwidXBuIjoiYnVyYWsua29jYWFzbGFuQHZla3RvcmEuY29tI| &&
*|iwidXRpIjoiUEM4enJIeWxjRXV6VUZobWtaVklBQSIsInZlciI6IjEuMCIsIndpZHMiOls| &&
*|iNjJlOTAzOTQtNjlmNS00MjM3LTkxOTAtMDEyMTc3MTQ1ZTEwIiwiYjc5ZmJmNGQtM2VmO| &&
*|S00Njg5LTgxNDMtNzZiMTk0ZTg1NTA5Il0sInhtc19jYyI6WyJDUDEiXSwieG1zX3NzbSI| &&
*|6IjEiLCJ4bXNfc3QiOnsic3ViIjoiRVJFUDFxZ09FQVUxRlFLbmNVTTZiOVV5TTRfNmxzN| &&
*|W1heFRNRWdQTnNlcyJ9LCJ4bXNfdGNkdCI6MTQ0MTc0NTY5MH0.ajP6-HzBEAak4VgbjIA| &&
*|qvRqp1rE8JIm16cdL32bLbzcTA30_yU8KzGU9M0ybs_7jV_6Z_oaycPpeYcdSs_QmaLArs| &&
*|8lnmfZsG9g0PmpxSksK-h8Pb8HAWVqsdtJd-_Qy0VRrhT6BIiqZ89Lsk4ydEyFFOJoD_Hr| &&
*|TT2vki4kSMTsLqsf23Hyafy7A39iC9dG-aSX6261gTAscFwvb__FpptqvFKiEcnotxTRd7| &&
*|ZHuW4yPqcgIb5vZUpjjcf4qR6gnUdn3RinhisSPfGC_3PPjlsvEhl2EgV8f2jM1J1_sdFE| &&
*|EWti0wAp-RP17asSJVj44QOZbkDdTxnJ6E5WqlWVB3g|.


CONCATENATE 'Bearer' gv_access_token INTO gv_access_token_b SEPARATED BY space.


*gv_url = 'https://graph.microsoft.com/v1.0/me'.
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
go_http_client->request->set_header_field( name = 'Accept' value = 'application/json' ).
go_http_client->request->set_header_field( name  = 'Authorization' value = gv_access_token ).
*go_http_client->request->set_header_field( name  = 'Authorization' value = gv_access_token_b ).

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


*--------------------------------------------------------------------*

"CREATE

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

go_http_client->request->set_method('POST').
go_http_client->request->set_header_fields(
  VALUE #( ( name = 'Content-Type'   value = 'application/json' )
           ( name = 'Authorization'  value = gv_access_token  ) ) ) .

DATA(lv_user) =
'{' &&
  '"accountEnabled": true,' &&
  '"displayName": "Dummy2",' &&
  '"mailNickname": "dummy2",' &&
  '"userPrincipalName": "dummy2@vektora.com",' &&
  '"passwordProfile" :' && '{' &&
    '"forceChangePasswordNextSignIn": true,' &&
    '"password": "1234Asd."' &&
  '}' &&
'}'.



go_http_client->request->set_cdata( lv_user ).

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

DATA(lv_create_response) = go_http_client->response->get_cdata( ).

DATA:lr_data_create TYPE REF TO data.

/ui2/cl_json=>deserialize(
  EXPORTING
    json             = lv_create_response
  CHANGING
    data             = lr_data_create
).

IF lr_data_create IS BOUND.
  ASSIGN lr_data_create->* TO FIELD-SYMBOL(<data_create>).
  ASSIGN COMPONENT `ID` OF STRUCTURE <data_create> TO FIELD-SYMBOL(<results_create>).
  ASSIGN <results_create>->* TO FIELD-SYMBOL(<table2>).
ENDIF.

WRITE:<table2>.

BREAK-POINT.
