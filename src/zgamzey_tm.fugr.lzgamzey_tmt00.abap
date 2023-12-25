*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDEP_T..........................................*
DATA:  BEGIN OF STATUS_ZDEP_T                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDEP_T                        .
CONTROLS: TCTRL_ZDEP_T
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZTITLE_T........................................*
DATA:  BEGIN OF STATUS_ZTITLE_T                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTITLE_T                      .
CONTROLS: TCTRL_ZTITLE_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDEP_T                        .
TABLES: *ZTITLE_T                      .
TABLES: ZDEP_T                         .
TABLES: ZTITLE_T                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
