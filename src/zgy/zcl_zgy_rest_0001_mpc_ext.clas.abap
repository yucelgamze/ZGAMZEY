class ZCL_ZGY_REST_0001_MPC_EXT definition
  public
  inheriting from ZCL_ZGY_REST_0001_MPC
  create public .

public section.

  types:
    BEGIN OF ts_deep_entity,
          vbeln                TYPE vbeln,
          erdat                TYPE erdat,
          erzet                TYPE erzet,
          auart                TYPE auart,
          orderheadertoitemnav TYPE TABLE OF ts_orderitem WITH DEFAULT KEY,
        END OF ts_deep_entity .

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZGY_REST_0001_MPC_EXT IMPLEMENTATION.


  METHOD define.

    super->define( ).

    DATA: lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
          lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    lo_entity = model->get_entity_type( iv_entity_name = 'Files' ).

    IF lo_entity IS BOUND.
      lo_property = lo_entity->get_property( iv_property_name = 'Filename').
      lo_property->set_as_content_type( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
