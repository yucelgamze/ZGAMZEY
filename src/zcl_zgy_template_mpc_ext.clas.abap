class ZCL_ZGY_TEMPLATE_MPC_EXT definition
  public
  inheriting from ZCL_ZGY_TEMPLATE_MPC
  create public .

public section.

  types:
    BEGIN OF ts_deep_entity,
        ebeln             TYPE ebeln,
        bukrs             TYPE bukrs,
        aedat             TYPE erdat,
        ernam             TYPE ernam,
        poheadertoitemnav TYPE TABLE OF ts_poitem WITH DEFAULT KEY,
      END OF ts_deep_entity .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZGY_TEMPLATE_MPC_EXT IMPLEMENTATION.
ENDCLASS.
