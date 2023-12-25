*&---------------------------------------------------------------------*
*& Report ZGY_NS_0013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0013.

TYPES:BEGIN OF gty_customer,
        customer TYPE i,
        name     TYPE char20,
        country  TYPE char2,
      END OF gty_customer.

TYPES:BEGIN OF gty_countries,
        customer_name TYPE char20,
        country       TYPE char2,
      END OF gty_countries.

TYPES:BEGIN OF gty_city,
        customer_name TYPE char20,
        country       TYPE char2,
        city          TYPE char20,
      END OF gty_city.

DATA:gt_customer  TYPE TABLE OF gty_customer,
     gs_customer  TYPE gty_customer,
     gt_countries TYPE TABLE OF gty_countries,
     gs_countries TYPE gty_countries,
     gt_city      TYPE TABLE OF gty_city.

gt_customer = VALUE #( ( customer = 1 name = 'NAME1' country = 'US' )
                       ( customer = 2 name = 'NAME2' country = 'TR' )
                       ( customer = 3 name = 'NAME3' country = 'GB' )
                       ( customer = 4 name = 'NAME4' country = 'DE' ) ).

gt_city = VALUE #( ( customer_name = 'N1' country = 'US'city = 'C1')
                   ( customer_name = 'N2' country = 'TR'city = 'C2')
                   ( customer_name = 'N3' country = 'GB'city = 'C3')
                   ( customer_name = 'N4' country = 'DE'city = 'C4') ).


*LOOP AT gt_customer INTO gs_customer.
*  MOVE-CORRESPONDING gs_customer TO gs_countries.
*  APPEND gs_countries TO gt_countries.
*ENDLOOP.

*gt_countries = VALUE #( FOR ls_customer IN gt_customer ( country = ls_customer-country ) ).
*gt_countries = VALUE #( FOR ls_customer IN gt_customer WHERE ( customer GE 2 ) ( country = ls_customer-country ) ).

*gt_countries = VALUE #( FOR ls_customer IN gt_customer
*                            ( customer_name = ls_customer-name
*                              country       = ls_customer-country ) ).

"kartezyen çarpım yapıyor iç içe for
gt_countries = VALUE #( FOR ls_city     IN gt_city
                        FOR ls_customer IN gt_customer WHERE ( customer LT 3 )
                            ( customer_name = ls_city-customer_name
                              country       = ls_customer-country ) ).

BREAK gamzey.
