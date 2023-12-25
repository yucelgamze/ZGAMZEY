class ZCL_ZGY_DDL49 definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_DDL49 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZGY_DDL49| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20230923194949.
  endmethod.
ENDCLASS.
