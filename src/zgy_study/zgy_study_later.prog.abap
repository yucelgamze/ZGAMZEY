*&---------------------------------------------------------------------*
*& Report ZVKT_RAP_0064
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT ZGY_STUDY_LATER.

INCLUDE ZGY_STUDY_LATER_TOP.
*INCLUDE: ZVKT_RAP_0064_top,
INCLUDE ZGY_STUDY_LATER_LCL.
*         ZVKT_RAP_0064_cls,
INCLUDE ZGY_STUDY_LATER_MDL.
*         ZVKT_RAP_0064_mdl.

START-OF-SELECTION.

  go_report = NEW lcl_report( ).
  go_report->start_of_selection( ).

  IF gt_output IS NOT INITIAL.
    CALL SCREEN 0100.
  ELSE.
    MESSAGE s001(zzy_0001) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
