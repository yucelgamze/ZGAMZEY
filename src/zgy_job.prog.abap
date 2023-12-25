*&---------------------------------------------------------------------*
*& Report ZGY_JOB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_job.
"sm37 ile tetiklenmiş job ları görüntülenir zgy_t_oop ye kayıt atılmış mı kontrol edilir.

DATA:gv_jobname  TYPE tbtcjob-jobname,
     gv_jobcount TYPE tbtcjob-jobcount.

DATA:gv_matnr TYPE matnr.

DATA:gt_mara TYPE TABLE OF mara,
     gs_mara TYPE mara.

START-OF-SELECTION.

  SELECT matnr
    FROM mara
    UP TO 20 ROWS
    INTO CORRESPONDING FIELDS OF TABLE gt_mara.

  LOOP AT gt_mara INTO gs_mara.

    gv_jobname = gs_mara-matnr.

    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = gv_jobname
      IMPORTING
        jobcount         = gv_jobcount
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.

    SUBMIT zgy_malzeme_log_for_job
    WITH   p_matnr = gs_mara-matnr
    VIA JOB gv_jobname NUMBER gv_jobcount
    AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = gv_jobcount
        jobname              = gv_jobname
        strtimmed            = abap_true
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        invalid_time_zone    = 9
        OTHERS               = 10.

  ENDLOOP.

  MESSAGE |Program Tamamlandı!| TYPE 'I'.


*   gv_jobname = 'JOB_TRIGGER_MALZEME_LOG_FOR_JOB'.
*
*  CALL FUNCTION 'JOB_OPEN'
*    EXPORTING
*      jobname          = gv_jobname
*    IMPORTING
*      jobcount         = gv_jobcount
*    EXCEPTIONS
*      cant_create_job  = 1
*      invalid_job_data = 2
*      jobname_missing  = 3
*      OTHERS           = 4.
*
*  SUBMIT zgy_malzeme_log_for_job
*  WITH   p_matnr = gv_matnr
*  VIA JOB gv_jobname NUMBER gv_jobcount
*  AND RETURN.
*
*  CALL FUNCTION 'JOB_CLOSE'
*    EXPORTING
*      jobcount             = gv_jobcount
*      jobname              = gv_jobname
*      strtimmed            = abap_true
*    EXCEPTIONS
*      cant_start_immediate = 1
*      invalid_startdate    = 2
*      jobname_missing      = 3
*      job_close_failed     = 4
*      job_nosteps          = 5
*      job_notex            = 6
*      lock_failed          = 7
*      invalid_target       = 8
*      invalid_time_zone    = 9
*      OTHERS               = 10.

*  MESSAGE |Program Tamamlandı!| TYPE 'I'.
