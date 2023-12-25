*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGAMZEY_TM
*   generation date: 30.07.2023 at 11:01:54
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGAMZEY_TM         .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
