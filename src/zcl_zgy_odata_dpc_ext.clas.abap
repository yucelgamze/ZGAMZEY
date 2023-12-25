class ZCL_ZGY_ODATA_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_ODATA_DPC
  create public .

public section.
protected section.

  methods MATERIAL_ENTITY__GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_ODATA_DPC_EXT IMPLEMENTATION.


  METHOD material_entity__get_entityset.

*    DATA:ls_entityset LIKE LINE OF et_entityset.
    DATA:ls_entityset TYPE zcl_zgy_odata_mpc=>ts_material_structure.

    SELECT
      matnr,
      mtart
      FROM mara INTO TABLE @DATA(lt_mara).

    IF sy-subrc EQ 0.
      LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>).
        ls_entityset-material = <lfs_mara>-matnr.
        ls_entityset-material_type = <lfs_mara>-mtart.
*        MOVE-CORRESPONDING <lfs_mara> TO ls_entityset.
        APPEND ls_entityset TO et_entityset.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
