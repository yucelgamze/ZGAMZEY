class ZCL_EXM_IM_ME_CHANGE_OUTTABCUS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_CHANGE_OUTTAB_CUS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EXM_IM_ME_CHANGE_OUTTABCUS IMPLEMENTATION.


  METHOD if_ex_me_change_outtab_cus~fill_outtab.

    FIELD-SYMBOLS: <fs_data> TYPE any.

    SELECT data FROM zgy_t_0019
          INTO TABLE @DATA(lt_0019).

    LOOP AT ch_outtab ASSIGNING FIELD-SYMBOL(<lfs_outtab>).
      READ TABLE lt_0019 INTO DATA(ls_0019) INDEX 1.
      IF sy-subrc IS INITIAL.
        ASSIGN COMPONENT 'DATA' OF STRUCTURE <lfs_outtab> TO <fs_data>.
        IF sy-subrc = 0.
          <fs_data> = ls_0019-data.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
