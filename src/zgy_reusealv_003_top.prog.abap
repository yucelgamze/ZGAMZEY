*&---------------------------------------------------------------------*
*& Include          ZGY_REUSEALV_001_TOP
*&---------------------------------------------------------------------*
TABLES:ekko,ekpo.

* reuse alv header lineli bir itab tanımı istediği için data occurs yapısı ile tanımlama yapılır headerline demek içerisinde
* hem structure barındıyor hem de itab gibi davranıyor.

*DATA: BEGIN OF gt_list occurs 0,
*         ebeln like ekko-ebeln,
*         ebelp like ekpo-ebelp,
*         bstyp like ekko-bstyp,
*         bsart like ekko-bsart,
*         matnr like ekpo-matnr,
*         menge like ekpo-menge,
*         meins like ekpo-meins,
*END OF gt_list.

TYPES: BEGIN OF gty_list,
         selkz      TYPE char1,
         ebeln      TYPE ebeln,
         ebelp      TYPE ebelp,
         bstyp      TYPE ebstyp,
         bsart      TYPE esart,
         matnr      TYPE matnr,
         menge      TYPE bstmg,
         meins      TYPE meins,
         line_color TYPE char4,
         cell_color TYPE slis_t_specialcol_alv,
       END OF gty_list.

DATA:gs_cell_color TYPE slis_specialcol_alv.

DATA: gt_list TYPE TABLE OF gty_list,
      gs_list TYPE gty_list.

DATA: gt_fcat TYPE slis_t_fieldcat_alv,
      gs_fcat TYPE slis_fieldcat_alv.

DATA: gs_layout TYPE slis_layout_alv.

DATA: gt_events TYPE slis_t_event,
      gs_event  TYPE slis_alv_event.

DATA: gt_exclude TYPE slis_t_extab,
      gs_exclude TYPE slis_extab.

DATA: gt_sort TYPE slis_t_sortinfo_alv,
      gs_sort TYPE slis_sortinfo_alv.

DATA: gt_filter TYPE slis_t_filter_alv,
      gs_filter TYPE slis_filter_alv.

DATA: gs_variant TYPE disvariant.
DATA: gs_variant_get TYPE disvariant,
      gv_exit        TYPE char1.
PARAMETERS:p_varian TYPE disvariant-variant.
