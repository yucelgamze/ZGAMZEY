CLASS zgy_cl_tf DEFINITION PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_order_details FOR TABLE FUNCTION zgy_tf1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zgy_cl_tf IMPLEMENTATION.

  METHOD get_order_details BY DATABASE FUNCTION FOR HDB LANGUAGE
                           SQLSCRIPT OPTIONS READ-ONLY USING aufk afko afvv afvc.

    it_aufk = select mandt, aufnr, auart from aufk;

    it_afko = SELECT aufnr, aufpl FROM afko
                    WHERE aufnr IN ( SELECT aufnr FROM :it_aufk );

    it_hours = SELECT afvv.aufpl, afvv.aplzl, afvv.vgw01, afvv.vgw02, afvv.iedd, afvc.vornr
     from afvv as afvv
     inner join afvc as afvc
     on afvv.aufpl  = afvc.aufpl
     and afvv.aplzl = afvc.aplzl;

RETURN select hdr.mandt as client,
              hdr.aufnr as prod_order,
              hdr.auart as order_type,
              oper.aufpl as routing,
              hrs.aplzl as counter,
              hrs.vgw01 as std_value_1,
              hrs.vgw02 as std_value_2
              from :it_aufk as hdr
              inner join :it_afko as oper on hdr.aufnr = oper.aufnr
              left outer JOIN :it_hours as hrs on oper.aufpl = hrs.aufpl
              where hdr.auart =:p_order_type;

*    RETURN SELECT
*    mandt AS client,
*    aufnr AS prod_order,
*    auart AS order_type  FROM aufk
*    WHERE auart = :p_order_type;

  endmethod.
ENDCLASS.
