*&---------------------------------------------------------------------*
*& Report ZGY_SATIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_satis_study.

INCLUDE ZGY_SATIS_STUDY_TOP.
*INCLUDE:zgy_satis_top,
INCLUDE ZGY_SATIS_STUDY_LCL.
*        zgy_satis_lcl,
INCLUDE ZGY_SATIS_STUDY_MDL.
*        zgy_satis_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
