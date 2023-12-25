*&---------------------------------------------------------------------*
*& Report ZGY_MALZEME_LOG_FOR_JOB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_malzeme_log_for_job.

"sm36 ile job oluşturulur ve sm37 ile job tetiği görüntülenir

DATA:gs_matnr_log TYPE zgy_t_oop.
PARAMETERS:p_matnr TYPE matnr.

START-OF-SELECTION.

  WAIT UP TO 10 SECONDS.

  gs_matnr_log-zguid  = cl_system_uuid=>create_uuid_c32_static( ). "metot dinamik bir şekilde 32 karakterli guid id üretiyor
  gs_matnr_log-matnr  = p_matnr.
  gs_matnr_log-uname  = sy-uname.
  gs_matnr_log-datum  = sy-datum.
  gs_matnr_log-uzeit  = sy-uzeit.

  INSERT zgy_t_oop FROM gs_matnr_log.
  IF sy-subrc EQ 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.
