CLASS zgy_class_tf DEFINITION PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_order_details FOR TABLE FUNCTION zgy_cds28.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zgy_class_tf IMPLEMENTATION.

  METHOD get_order_details BY DATABASE FUNCTION FOR HDB LANGUAGE
                           SQLSCRIPT OPTIONS READ-ONLY USING aufk.
    RETURN SELECT
    mandt AS client,
    aufnr AS prod_order,
    auart AS order_type  FROM aufk
    WHERE auart = :p_order_type;

  ENDMETHOD.

ENDCLASS.
