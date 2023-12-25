*&---------------------------------------------------------------------*
*& Include          ZGY_LIB_BOOK_MANAGEMENT_TOP
*&---------------------------------------------------------------------*

TABLES:zgy_lib_book.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.



DATA:gt_alv TYPE TABLE OF zgy_lib_book,
     gs_alv TYPE zgy_lib_book.

DATA:gv_book_id     TYPE zgy_book_id_de,
     gv_book_name	  TYPE  zgy_book_name_de,
     gv_book_writer TYPE  zgy_book_writer_de.

DATA:gv_found TYPE xfeld,
     gv_flag  TYPE xfeld.
