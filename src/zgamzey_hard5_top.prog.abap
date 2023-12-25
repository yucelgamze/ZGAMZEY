*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD5_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local    TYPE REF TO local,
     go_personal TYPE REF TO zpersonal_islemleri_c.

DATA:gv_pernr   TYPE p_pernr,
     gv_descp   TYPE zdescp_de,
     gv_success TYPE xfeld,
     gv_message TYPE bapi_msg.
