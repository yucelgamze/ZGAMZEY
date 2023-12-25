*&---------------------------------------------------------------------*
*& Include          ZGY_CRUD_TABLE_CONTROL_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

TABLES:zgy_dil.
CONTROLS tc100 TYPE TABLEVIEW USING SCREEN 0100.

DATA:gt_dil TYPE TABLE OF zgy_dil,
     gs_dil TYPE zgy_dil,
     x(1)   TYPE c.
