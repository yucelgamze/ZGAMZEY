*&---------------------------------------------------------------------*
*& Report ZGY_CHATGPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_chatgpt.

PARAMETERS:p_soru TYPE string.

DATA:gv_cevap      TYPE string,
     gv_data       TYPE string,
     gv_payload_x  TYPE xstring,
     gv_max_tokens TYPE i.

DATA:go_http_client TYPE REF TO if_http_client,
     gv_response    TYPE string,
     gv_auth        TYPE string.

CONSTANTS:gv_url TYPE string VALUE 'https://api.openai.com/v1/engines/davinci/completions'.

gv_max_tokens = 500.
gv_data = '{' && '"prompt":' && '"' && p_soru && '",' && '"max_tokens":' && gv_max_tokens && '}'.

CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    text   = gv_data
  IMPORTING
    buffer = gv_payload_x
  EXCEPTIONS
    failed = 1
    OTHERS = 2.

" HTTP client'ı URL kullanarak oluşturma:
CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url                = gv_url
  IMPORTING
    client             = go_http_client
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4.

"request:
go_http_client->request->set_method('POST').

"headerlar:
go_http_client->request->set_header_field(
  EXPORTING
    name  = 'Content-Type'
    value = 'application/x-www-form-urlencoded'
).
go_http_client->request->set_header_field(
  EXPORTING
    name  = 'Accept'
    value = 'application/json'
).
go_http_client->request->set_header_field(
EXPORTING
name  = 'Authorization'
value = 'Bearer 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'
).
go_http_client->request->set_form_field(
  EXPORTING
    name  = 'prompt'
    value = p_soru
).
go_http_client->request->set_data(
  EXPORTING
    data = gv_payload_x ).

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

IF sy-subrc <> 0.
  gv_response = go_http_client->response->get_cdata( ).
  gv_cevap = gv_response.
ELSE.
  gv_response = go_http_client->response->get_cdata( ).
  IF gv_response IS NOT INITIAL.
    gv_cevap = gv_response.
  ELSE.
    gv_cevap = |Call başarılı ancak cevap alınmadı!|.
  ENDIF.
ENDIF.

MESSAGE gv_cevap TYPE 'I'.
