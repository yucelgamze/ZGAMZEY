*&---------------------------------------------------------------------*
*& Report ZVKT_R_OOALV
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* " Bülent Özen / 05.07.2021 09:57:19 /  OOALV
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT zgy_study_later2.

INCLUDE zgy_study_later2_top.
*INCLUDE: zvkt_r_ooalv_3_top,
INCLUDE zgy_study_later2_lcl.
*         zvkt_r_ooalv_3_cls,
INCLUDE zgy_study_later2_mdl.
*         zvkt_r_ooalv_3_mdl.


START-OF-SELECTION.

  go_report = NEW lcl_report( ).
  go_report->start_of_selection( ).
