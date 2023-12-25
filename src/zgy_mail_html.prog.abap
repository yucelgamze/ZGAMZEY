*&---------------------------------------------------------------------*
*& Report ZGY_MAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_mail_html.

DATA:go_gbt       TYPE REF TO cl_gbt_multirelated_service,
     go_bcs       TYPE REF TO cl_bcs,
     go_doc_bcs   TYPE REF TO cl_document_bcs,
     go_recipient TYPE REF TO if_recipient_bcs,
     gt_soli      TYPE TABLE OF soli,
     gs_soli      TYPE TABLE OF soli,
     gv_status    TYPE bcs_rqst,
     gv_content   TYPE string,
     gv_lines     TYPE int4,
     gt_scarr     TYPE TABLE OF scarr.

START-OF-SELECTION.

  CREATE OBJECT go_gbt.

*  gv_content  = |Bu bir test emailidir!|.

*  SELECT * FROM scarr INTO TABLE gt_scarr.
*  DESCRIBE TABLE gt_scarr LINES gv_lines.

  "bu describe table ile aynı yapı satır sayısını topluyor.

  SELECT COUNT(*) FROM scarr
    INTO gv_lines.

  gv_content =
   ' <!DOCTYPE>                                          '
  &&' <html>                                             '
  &&'     <head>                                         '
  &&'         <meta charset = "utf-8">                   '
  &&'         <style>                                    '
  &&'             p{                                     '
  &&'                 background-color:deepPink;         '
  &&'                 border:3px solid;                  '
  &&'             }                                      '
  &&'         </style>                                   '
  &&'     </head>                                        '
  &&'                                                    '
  &&'     <body>                                         '
  &&'         Merhabalar;                                '
  &&'         <p>test 1</p>                              '
  &&'         <p>SCARR tablosunda '&&  gv_lines &&' kadar satır vardır</p>                              '
  &&'     </body>                                        '
  &&' </html>                                            '.

  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.   " Objcont and Objhead as Table Type

  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
                 i_subject          = |Test Mail Başlığı|

                 i_multirel_service = go_gbt ).

  go_recipient = cl_cam_address_bcs=>create_internet_address(
                    i_address_string = |gamze.yucel@vektora.com| ).

  go_bcs = cl_bcs=>create_persistent( ).
  go_bcs->set_document( i_document = go_doc_bcs ).
  go_bcs->add_recipient( i_recipient = go_recipient ).

  gv_status = 'N'.

  CALL METHOD go_bcs->set_status_attributes
    EXPORTING
      i_requested_status = gv_status.   " Requested Status

  go_bcs->send( ).
  COMMIT WORK.
  IF sy-subrc EQ 0.
    MESSAGE |Mail gönderme işlemi başarılı bir şekilde gerçekleştirilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.
