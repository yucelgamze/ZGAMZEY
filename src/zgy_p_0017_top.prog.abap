*&---------------------------------------------------------------------*
*& Include          ZGY_P_0017_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.
TYPES:BEGIN OF gty_xls,
        partner     TYPE char10, "muhatap tanıtıcı no
        type        TYPE char1,
        bu_group    TYPE char4,
        bpkind      TYPE char4,
        name_org1   TYPE char40,
        name_org2   TYPE char40,
        langu_corr  TYPE char1,
        bu_sort1    TYPE char20,
        street      TYPE zchar60,
        str_suppl1  TYPE char40,
        str_suppl2  TYPE char40,
        country     TYPE char3,
        smtp_addr   TYPE ad_smtpadr, "char241,
        stcd1       TYPE zchar60,
        stcd2       TYPE zchar60,
        langu       TYPE char1,
        vbund       TYPE char6, "VBUND Data Elemntinde RCOMP domain için Routine var!
        title_medi  TYPE char10, "hitap biçimi ?
        name_first  TYPE char40,
        name_last   TYPE char40,
        house_num1  TYPE char10,
        str_suppl3  TYPE char40,
        house_num2  TYPE char10,
        floor       TYPE char10, " ?
        post_code1  TYPE char10,
        city1       TYPE char40,
        city2       TYPE char40,
        region      TYPE char2, "regio, "char3,
        mob_number  TYPE char30,
        mob_number2 TYPE char30,
        tel_number  TYPE char30,
        tel_extens  TYPE char10,
        tel_number2 TYPE char30,
        fax_number  TYPE char30,
        fax_number2 TYPE char30,
        smtp_addr2  TYPE ad_smtpadr,
        deflt_comm  TYPE char10, "???
        natpers     TYPE char1,
        taxnumxl    TYPE char11,
        county      TYPE char20,
        bpext       TYPE char20,
      END OF gty_xls.

*TYPES:BEGIN OF gty_xls,
*        partner     TYPE char10, "muhatap tanıtıcı no MUHATAP GENEL VERILERI
*        type        TYPE char1,
*        bu_group    TYPE char4,
*        bpkind      TYPE char4,
*        name_org1   TYPE char40,
*        name_org2   TYPE char40,
*        langu_corr  TYPE char1,
*        bu_sort1    TYPE char20,
*        street      TYPE char60,
*        str_suppl1  TYPE char40,
*        str_suppl2  TYPE char40,
*        country     TYPE char3,
*        smtp_addr   TYPE ad_smtpadr, "char241,
*        stcd1       TYPE char60,
*        stcd2       TYPE char60,
*        langu       TYPE char1,
*        vbund       TYPE char6, "VBUND Data Elemntinde RCOMP domain için Routine var!
*        title_medi  TYPE char10, "hitap biçimi ?
*        name_first  TYPE char40,
*        name_last   TYPE char40,
*        house_num1  TYPE char10,
*        str_suppl3  TYPE char40,
*        house_num2  TYPE char10,
*        floor       TYPE char10, " ?
*        post_code1  TYPE char10,
*        city1       TYPE char40,
*        city2       TYPE char40,
*        region      TYPE char3,
*        mob_number  TYPE char30,
*        mob_number2 TYPE char30,
*        tel_number  TYPE char30,
*        tel_extens  TYPE char10,
*        tel_number2 TYPE char30,
*        fax_number  TYPE char30,
*        fax_number2 TYPE char30,
*        smtp_addr2  TYPE ad_smtpadr,
*        deflt_comm  TYPE char10, "???
*        natpers     TYPE char1,
*        taxnumxl    TYPE char11,
*        county      TYPE char40,
*        bukrs       TYPE char4, "SATICI -FI VERILERI
*        akont       TYPE char10,
*        zterm       TYPE char4,
*        repfr       TYPE char1,
*        zahls       TYPE char1,
*        zwels       TYPE char10,
*        altkn       TYPE char10,
*        pernr       TYPE char8,
*        xverr       TYPE char1,
*        knrzb       TYPE char10,
*        stenr       TYPE char10,
*        wt_withcd   TYPE char2,
*        ekorg       TYPE char4, "SAtıcı Mm Verileri
*        waers       TYPE char5,
*        webre       TYPE char1,
*        ekgrp       TYPE char3,
*        plifz       TYPE char3,
*        sperm       TYPE char1,
*        bkvid       TYPE char4, "muhatap bankları
*        banks       TYPE char3,
*        bankl       TYPE char15,
*        bank        TYPE char60,
*        branch      TYPE char60,
*        bankn       TYPE char18,
*        iban        TYPE iban,
*        koinh       TYPE char60,
*        xezer       TYPE char1,
*        swift       TYPE char20,
*      END OF gty_xls.
DATA:gt_xls TYPE TABLE OF gty_xls,
     gs_xls TYPE gty_xls.

DATA:gt_alv TYPE TABLE OF zfica_t0008,
     gs_alv TYPE zfica_t0008.

*DATA: gt_data     TYPE TABLE OF zalsmex_tabline,
DATA: gt_data     TYPE TABLE OF alsmex_tabline,
      gv_currline TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
  PARAMETERS:p_file TYPE localfile DEFAULT 'C:\Users\Vektora.cyberark07\Desktop\fica3.xlsx'.
SELECTION-SCREEN END OF BLOCK a.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.
