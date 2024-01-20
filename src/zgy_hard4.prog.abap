*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard4.

INCLUDE ZGY_HARD4_TOP.
*INCLUDE:zgamzey_hard4_top,
INCLUDE ZGY_HARD4_LCL.
*        zgamzey_hard4_lcl,
INCLUDE ZGY_HARD4_MDL.
*        zgamzey_hard4_moduls.

INITIALIZATION.
  CREATE OBJECT go_local.
  button = 'Örnek Excel'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file. "PARAMETRE İÇİN SEARCH HELP FONKSİYONU
  go_local->call_func_f4_filename( ).

AT SELECTION-SCREEN.
  CASE sscrfields. " sscrfields ->save the function code of a pushbutton inserted in selection-screen or
                                                    "a command to related to a radiobutton or a checkbox.
    WHEN 'BUT1'.
      go_local->download_excel( ).
  ENDCASE.

START-OF-SELECTION.
  go_local->convert_excel( ).
  go_local->add_excel( ).
  go_local->call_screen( ).
