*&---------------------------------------------------------------------*
*& Report ZGY_P_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0005.

**Download internal table to Application server file(Unix)
*DATA: gt_0010 TYPE TABLE OF  sflight,
*      gs_0010 TYPE sflight.
*DATA: gv_path LIKE rlgrap-filename VALUE 'C:\Users\VKT\Downloads\download.xml'.
**Creates file if does not exist
*
*START-OF-SELECTION.
*
*  OPEN DATASET gv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "Encoding is required in later systems
*
*  IF sy-subrc = 0.
*    LOOP AT gt_0010 ASSIGNING FIELD-SYMBOL(<lfs_0010>).
*      TRANSFER <lfs_0010> TO gv_path.
*    ENDLOOP.
*  ENDIF.
*
*  CLOSE DATASET gv_path.
*  BREAK-POINT.

*--------------------------------------------------------------------*
*  SELECT *
*       FROM scarr
*       INTO TABLE @DATA(itab).
*  CALL TRANSFORMATION id SOURCE scarr = itab
*                         RESULT XML DATA(xml).
*
*  DATA(dset) = 'scarr.dat'.
*  OPEN DATASET dset FOR OUTPUT IN BINARY MODE.
*  IF sy-subrc = 0.
*    TRANSFER xml TO dset.
*  ENDIF.
*  CLOSE DATASET dset.

**--------------------------------------------------------------------*

*CLEAR xml.
*OPEN DATASET dset FOR INPUT IN BINARY MODE.
*READ DATASET dset INTO xml.
*CLOSE DATASET dset.
*
*CALL TRANSFORMATION id SOURCE XML xml
*                       RESULT scarr = itab.
*cl_demo_output=>display( itab ).
*
*DELETE DATASET dset.

*--------------------------------------------------------------------*

  DATA: lv_file_path    TYPE string VALUE 'C:\Users\VKT\Downloads\download.xml',
        lt_file_content TYPE TABLE OF string,
        lv_line         TYPE string.

  " Populate lt_file_content with the content you want to write to the file
  APPEND 'Line 1 of the file' TO lt_file_content.
  APPEND 'Line 2 of the file' TO lt_file_content.
  APPEND 'Line 3 of the file' TO lt_file_content.

  OPEN DATASET lv_file_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  IF sy-subrc = 0.
    LOOP AT lt_file_content INTO lv_line.
      " Write each line to the file
      TRANSFER lv_line TO lv_file_path.
    ENDLOOP.
    CLOSE DATASET lv_file_path.

    " File has been written successfully
    WRITE: / 'File written successfully.'.
  ELSE.
    " Handle errors if the file cannot be opened
    WRITE: / 'Error opening file.'.
  ENDIF.

*--------------------------------------------------------------------*

*  DATA: lv_file_path    TYPE string VALUE 'C:\Users\VKT\Downloads\upload.xml',
*        lt_file_content TYPE TABLE OF string,
*        lv_line         TYPE string.
*
*  OPEN DATASET lv_file_path FOR INPUT IN TEXT MODE ENCODING DEFAULT.
*
*  IF sy-subrc = 0.
*    DO.
*      READ DATASET lv_file_path INTO lv_line.
*      IF sy-subrc <> 0.
*        EXIT.
*      ENDIF.
*      APPEND lv_line TO lt_file_content.
*    ENDDO.
*    CLOSE DATASET lv_file_path.
*
*    " Now lt_file_content contains the lines of the file
*    LOOP AT lt_file_content INTO lv_line.
*      " Process each line as needed
*      WRITE: / lv_line.
*    ENDLOOP.
*
*  ELSE.
*    " Handle errors if the file cannot be opened
*    WRITE: / 'Error opening file.'.
*  ENDIF.
