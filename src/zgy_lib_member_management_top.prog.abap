*&---------------------------------------------------------------------*
*& Include          ZGY_LIB_MEMBER_MANAGEMENT_TOP
*&---------------------------------------------------------------------
TABLES:zgy_lib_book, zgy_lib_member, zgy_lib_borrow,
       zgy_lib_book_member, zgy_lib_return. "BU İKİSİ STRUCTURE->SEL MODE ÇİFT ID DE HATA

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.



DATA:gt_alv TYPE TABLE OF zgy_lib_member,
     gs_alv TYPE zgy_lib_member.


DATA:gv_member_id      TYPE	zgy_member_id_de,
     gv_member_name    TYPE zgy_member_name_de,
     gv_member_surname TYPE  zgy_member_surname_de,
     gv_pasive         TYPE  zgy_pasive_de.

DATA:gv_flag  TYPE xfeld,
     gv_flag2 TYPE xfeld,
     gv_found TYPE xfeld.

DATA:go_alv_grid2  TYPE REF TO cl_gui_alv_grid,
     go_container2 TYPE REF TO cl_gui_custom_container,
     gt_fcat2      TYPE lvc_t_fcat,
     gs_fcat2      TYPE lvc_s_fcat,
     gs_layout2    TYPE lvc_s_layo.

DATA:gt_alv2 TYPE TABLE OF zgy_lib_book_member,
     gs_alv2 TYPE zgy_lib_book_member.

DATA:go_alv_grid3  TYPE REF TO cl_gui_alv_grid,
     go_container3 TYPE REF TO cl_gui_custom_container,
     gt_fcat3      TYPE lvc_t_fcat,
     gs_fcat3      TYPE lvc_s_fcat,
     gs_layout3    TYPE lvc_s_layo.

DATA:gt_alv3 TYPE TABLE OF zgy_lib_return,
     gs_alv3 TYPE zgy_lib_return.
