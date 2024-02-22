class ZCL_ZGY_REST_0001_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_REST_0001_DPC
  create public .

public section.
protected section.

  methods ORDERHEADERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_REST_0001_DPC_EXT IMPLEMENTATION.


  METHOD orderheaderset_get_entityset.
    DATA:ls_entityset TYPE zcl_zgy_rest_0001_mpc=>ts_orderheader.

    SELECT * UP TO 10 ROWS FROM vbak
      INTO TABLE @DATA(lt_tab).

    LOOP AT lt_tab ASSIGNING FIELD-SYMBOL(<lfs_tab>).
      ls_entityset = CORRESPONDING #( <lfs_tab> ).
      APPEND ls_entityset TO et_entityset.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
