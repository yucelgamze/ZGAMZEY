class ZGY_CL_RAP definition
  public
  final
  create public .

public section.

  class-data MO_XLSX_DOCUMENT type ref to CL_XLSX_DOCUMENT .
  class-data MO_XLSX_WORKBOOKPART type ref to CL_XLSX_WORKBOOKPART .
  class-data MO_EXCEL_V2 type ref to CL_FDT_XL_SPREADSHEET .

  methods CONSTRUCTOR
    importing
      !IV_DATA type XSTRING .
  methods GET_EXCEL_DATA_V2
    returning
      value(RT_DATA) type ZGY_TT_003 .
protected section.

  data MO_IXML type ref to IF_IXML .
private section.
ENDCLASS.



CLASS ZGY_CL_RAP IMPLEMENTATION.


  METHOD constructor.

    TRY.
        mo_xlsx_document     = cl_xlsx_document=>load_document( iv_data ).
        mo_xlsx_workbookpart = mo_xlsx_document->get_workbookpart( ).
        mo_excel_v2          = NEW cl_fdt_xl_spreadsheet(
            document_name     = 'file'
            xdocument         = iv_data
*          mime_type         =
        ).
*        CATCH cx_fdt_excel_core.  "


      CATCH cx_openxml_not_found.
      CATCH cx_openxml_format.

    ENDTRY.

  ENDMETHOD.


  METHOD get_excel_data_v2.
    DATA:lv_number TYPE i VALUE 4.
    FIELD-SYMBOLS: <fs_excel_data> TYPE table.

    mo_excel_v2->if_fdt_doc_spreadsheet~get_worksheet_names(
      IMPORTING
        worksheet_names = DATA(lt_worksheets)
    ).

    DATA(ls_first) = mo_excel_v2->if_fdt_doc_spreadsheet~get_itab_from_worksheet(
                     worksheet_name   =  lt_worksheets[ 1 ]
*                     iv_caller       =
*                     iv_get_language =
                 ).

    ASSIGN ls_first->* TO <fs_excel_data>.

    LOOP AT <fs_excel_data> ASSIGNING FIELD-SYMBOL(<fss_excel_data>) FROM 2.

      APPEND INITIAL LINE TO rt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      rt_data : table , <fs_data> : structure

      DO lv_number TIMES.
        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_field>).
        ASSIGN COMPONENT sy-index OF STRUCTURE <fss_excel_data> TO FIELD-SYMBOL(<fs_field2>).

        <fs_field> = <fs_field2>.

        UNASSIGN: <fs_field>, <fs_field2>.
      ENDDO.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
