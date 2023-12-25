*&---------------------------------------------------------------------*
*& Include          ZVKT_R_OOALV_TOP
*&---------------------------------------------------------------------*

CLASS lcl_report DEFINITION DEFERRED.

TABLES: vbak.
DATA: go_report TYPE REF TO lcl_report,
      gv_tabname    TYPE tabname,
      gt_output     TYPE TABLE OF vbak,
      gs_output     LIKE LINE  OF gt_output,
      gt_return     TYPE bapirettab,
      gs_return     TYPE bapiret2,
      gv_error      TYPE char1.

CONSTANTS: gc_output TYPE tabname VALUE 'VBAK'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Seçim Ekranı
  SELECT-OPTIONS: s_vbeln   FOR vbak-vbeln,
                  s_ernam   FOR vbak-ernam,
                  s_erdat   FOR vbak-erdat.
  SELECTION-SCREEN SKIP.
SELECTION-SCREEN END OF BLOCK b1.
