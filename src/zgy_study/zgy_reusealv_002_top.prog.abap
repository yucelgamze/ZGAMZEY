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
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         bstyp TYPE ebstyp,
         bsart TYPE esart,
         matnr TYPE matnr,
         menge TYPE bstmg,
         meins TYPE meins,
       END OF gty_list.

DATA: gt_list TYPE TABLE OF gty_list,
      gs_list TYPE gty_list.

DATA: gt_fcat TYPE slis_t_fieldcat_alv,
      gs_fcat TYPE slis_fieldcat_alv.

DATA: gs_layout TYPE slis_layout_alv.

DATA: gt_events TYPE slis_t_event,
      gs_event  TYPE slis_alv_event.
