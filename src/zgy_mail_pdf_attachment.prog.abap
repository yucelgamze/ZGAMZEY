*&---------------------------------------------------------------------*
*& Report ZGY_MAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_mail_pdf_attachment.

DATA:go_gbt       TYPE REF TO cl_gbt_multirelated_service,
     go_bcs       TYPE REF TO cl_bcs,
     go_doc_bcs   TYPE REF TO cl_document_bcs,
     go_recipient TYPE REF TO if_recipient_bcs,
     gt_soli      TYPE TABLE OF soli,
     gs_soli      TYPE TABLE OF soli,
     gv_status    TYPE bcs_rqst,
     gv_content   TYPE string.

DATA:gt_scarr TYPE TABLE OF scarr,
     gs_scarr TYPE scarr.


DATA:gv_i_attachment_size	TYPE sood-objlen,
     gt_i_att_content_hex TYPE solix_tab,
     gv_att_content       TYPE string,
     gv_att_line          TYPE string.


START-OF-SELECTION.

  CREATE OBJECT go_gbt.

*  gv_content  = |Bu bir test emailidir!|.

  SELECT * FROM scarr INTO TABLE gt_scarr.



  gv_content =
          ' <!DOCTYPE>                                       '
          &&' <html>                                           '
          &&'     <head>                                       '
          &&'         <meta charset = "utf-8">                 '
          &&'         <style>                                  '
          &&'             th{                                  '
          &&'                 background-color:deepPink;       '
          &&'                 border:3px solid;                '
          &&'             }                                    '
          &&'                                                  '
          &&'             tr{                                  '
          &&'                 background-color:lightblue;      '
          &&'             }                                    '
          &&'                                                  '
          &&'             td{                                  '
          &&'                 border:2px solid;                '
          &&'             }                                    '
          &&'         </style>                                 '
          &&'     </head>                                      '
          &&'                                                  '
          &&'     <body>                                       '
          &&'         <table>                                  '
          &&'             <tr>                                 '
          &&'                 <th>Havayolu Kısa Tanım</th>                 '
          &&'                 <th>Havayolu Adı</th>                 '
          &&'                 <th>Havayolu Para Birimi</th>                 '
          &&'                 <th>Havayolu URL</th>                 '
          &&'             </tr>                                '.


  LOOP AT gt_scarr INTO gs_scarr.
    gv_content = gv_content
          &&'    <tr>                                 '
          &&'    <td>'&& gs_scarr-carrid &&'</td>                 '
          &&'    <td>'&& gs_scarr-carrname &&'</td>                 '
          &&'    <td>'&& gs_scarr-currcode &&'</td>                 '
          &&'    <td>'&& gs_scarr-url &&'</td>                 '
          &&'             </tr>                                '.
  ENDLOOP.

  gv_content = gv_content &&'         </table>          '
                          &&'     </body>               '
                          &&' </html>                   '.

  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.   " Objcont and Objhead as Table Type

  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
                 i_subject          = |PDF Test Mail Başlığı|

                 i_multirel_service = go_gbt ).

  "pdf attachment
******************************************************************************************
  DATA:gs_outputparams  TYPE  sfpoutputparams,
       gv_name          TYPE  fpname,
       gv_funcname      TYPE  funcname,
       gs_docparamtype  TYPE sfpdocparams,
       gs_formoutput    TYPE  fpformoutput,
       gv_output_length TYPE int4.

  gs_outputparams-preview   = ''.
  gs_outputparams-nodialog  = 'X'.
  gs_outputparams-dest      = 'LP01'.
  gs_outputparams-getpdf    = 'X'.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = gs_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  gv_name = 'ZGY_EGT_FORM'.
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = gv_name
    IMPORTING
      e_funcname = gv_funcname.

  "PDF çıktısının fonksiyonunun dinamik olarak çağırılması!!

*  CALL FUNCTION '/1BCDWB/SM00000448'
  CALL FUNCTION gv_funcname
    EXPORTING
      /1bcdwb/docparams  = gs_docparamtype
    IMPORTING
      /1bcdwb/formoutput = gs_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = gs_formoutput-pdf
    IMPORTING
      output_length = gv_output_length
    TABLES
      binary_tab    = gt_i_att_content_hex.

  "char12 vs integer ataması
  gv_i_attachment_size =  gv_output_length.

  go_doc_bcs->add_attachment(
    EXPORTING
      i_attachment_type     =  'PDF'                    " Document Class for Attachment
      i_attachment_subject  =  'attachment_name'        " Attachment Title
      i_attachment_size     =  gv_i_attachment_size     " Size of Document Content
      i_att_content_hex     =  gt_i_att_content_hex ).  " Content (Binary)

****************************************************************************************************************
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
