*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local TYPE REF TO lcl_class.
DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

TYPES:BEGIN OF gty_alv,
        vbeln  TYPE	vbak-vbeln,
        erdat  TYPE	vbak-erdat,
        auart  TYPE vbak-auart,
        posnr  TYPE	vbap-posnr,
        matnr  TYPE	vbap-matnr,
        arktx  TYPE	vbap-arktx,
        kwmeng TYPE	vbap-kwmeng,
        vrkme  TYPE	vbap-vrkme,
        netwr  TYPE	vbap-netwr,
        waerk  TYPE	vbap-waerk,
      END OF gty_alv.

DATA:gt_alv TYPE TABLE OF gty_alv,
     gs_alv TYPE gty_alv.

DATA:gt_table TYPE zgy_tt_0024,
     gs_table TYPE zgy_s_0024.
