FUNCTION zbapi_ctraccontractaccount_cr1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CTRACCREATEINFO) LIKE  BAPIFKKVKCI STRUCTURE  BAPIFKKVKCI
*"     VALUE(CTRACDETAIL) LIKE  BAPIFKKVKI STRUCTURE  BAPIFKKVKI
*"     VALUE(TESTRUN) TYPE  BAPICTRACAUX-TESTRUN OPTIONAL
*"     VALUE(VALIDFROM) TYPE  BAPICTRACAUX-VALID_FROM OPTIONAL
*"     VALUE(ZTERM) TYPE  DZTERM
*"  EXPORTING
*"     VALUE(CONTRACTACCOUNT) LIKE  BAPIFKKVK-CONT_ACCT
*"  TABLES
*"      CTRACPARTNERDETAIL STRUCTURE  BAPIFKKVKPI1
*"      CTRACCHARGESDISCOUNTS STRUCTURE  BAPIFKKVKP_CHGDISCI OPTIONAL
*"      CTRACLOCKDETAIL STRUCTURE  BAPIFKKVKLOCKSI1 OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2
*"      EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"      CTRACCORRRECEIVER STRUCTURE  BAPIFKKVKCORRI OPTIONAL
*"      CTRACTAXEXEMPTION STRUCTURE  BAPIFKKVKTAXI OPTIONAL
*"----------------------------------------------------------------------

  CONSTANTS:
    pare(32)   TYPE c VALUE 'Extensionin',                  "#EC NOTEXT
    parld(32)  TYPE c VALUE 'CtrACCorrReceiver',            "#EC NOTEXT
    parlt(32)  TYPE c VALUE 'CtrACTaxExemption',            "#EC NOTEXT
    parlc(32)  TYPE c VALUE 'CtrACLockDetail',              "#EC NOTEXT
    parcd(32)  TYPE c VALUE 'CtrACChargesDiscounts',        "#EC NOTEXT
    parv(32)   TYPE c VALUE 'ValidFrom',                    "#EC NOTEXT
    c_lenstruc TYPE i VALUE 30.
  DATA:
    sfkkvk_i                LIKE fkkvk_s_di,
    ifkkvkp_i               LIKE TABLE OF fkkvkp_s_di WITH HEADER LINE,
    error                   TYPE c,
    err_par                 TYPE syst-msgv2,
    err_table               LIKE TABLE OF bus0msg1 WITH HEADER LINE,
    key_table               LIKE TABLE OF busskeyval WITH HEADER LINE,
    ifkkvklock_i            LIKE TABLE OF fkkvklock_s_di WITH HEADER LINE,
    ifkkvkcorr_i            LIKE TABLE OF fkkvk_corr_s_di WITH HEADER LINE,
    ifkkvktax_i             LIKE TABLE OF fkkvk_taxex_s_di WITH HEADER LINE,
    ifkkvkpchgdisc_i        LIKE TABLE OF fkkvkp_chgdisc_s_di WITH HEADER LINE,
    applk                   TYPE applk_kk,
    i_fbstab                TYPE TABLE OF tfkfbc WITH HEADER LINE,
    wa_fkkvki               TYPE bapi_te_fkkvki,
    wa_fkkvkpi              TYPE bapi_te_fkkvkpi,
    lv_valdt                LIKE sy-datum,
    ls_bapifkkvkp_chgdiscix TYPE bapifkkvkp_chgdiscix.

  FIELD-SYMBOLS: <err_struct> TYPE bus0msg1.

* Note 1580711: protect fields not incl. in BAPI struct (passed in 1017)
  CALL FUNCTION 'FKK_BAPI_FILL_STRUCTURE'
    EXPORTING
      i_field_char = '/'
    CHANGING
      c_structure  = sfkkvk_i.
  CALL FUNCTION 'MAP2I_BAPIFKKVKI_TO_FKKVK_S_DI'
    EXPORTING
      bapifkkvki = ctracdetail
    CHANGING
      fkkvk_s_di = sfkkvk_i.

* Note 1580711: protect fields not incl. in BAPI struct (passed in 1017)
  CALL FUNCTION 'FKK_BAPI_FILL_STRUCTURE'
    EXPORTING
      i_field_char = '/'
    CHANGING
      c_structure  = ifkkvkp_i.
  LOOP AT ctracpartnerdetail.
    CALL FUNCTION 'MAP2I_BAPIFKKVKPI1_TO_FKKVKP_S'
      EXPORTING
        bapifkkvkpi1 = ctracpartnerdetail
      CHANGING
        fkkvkp_s_di  = ifkkvkp_i.
    APPEND ifkkvkp_i.
  ENDLOOP.
  IF ctraclockdetail IS REQUESTED.
    LOOP AT ctraclockdetail.
      IF ctraclockdetail-processing_mode <> 'I'.
        mac_err_exit2t return parld '022' space space.
      ENDIF.
      IF ctraclockdetail-lock_type <> '06'.
        DATA errpar LIKE sy-msgv1.
        errpar = ctraclockdetail-lock_type.
        mac_err_exit2t return parld '010' errpar space.
      ENDIF.
      CALL FUNCTION 'MAP2I_BAPIFKKVKLOCKSI1_TO_FKKV'
        EXPORTING
          bapifkkvklocksi1 = ctraclockdetail
        CHANGING
          fkkvklock_s_di   = ifkkvklock_i.
      APPEND ifkkvklock_i.
    ENDLOOP.
  ENDIF.
  mac_return_exit return.

  IF ctraccorrreceiver IS REQUESTED.
    LOOP AT ctraccorrreceiver.
      IF ctraccorrreceiver-processing_mode <> 'I'.
        mac_err_exit2t return parlc '022' space space.
      ENDIF.
      CALL FUNCTION 'MAP2I_BAPIFKKVKCORRI_TO_FKKVK_'
        EXPORTING
          bapifkkvkcorri  = ctraccorrreceiver
        CHANGING
          fkkvk_corr_s_di = ifkkvkcorr_i.
      APPEND ifkkvkcorr_i.
    ENDLOOP.
  ENDIF.
  mac_return_exit return.

  IF ctractaxexemption IS REQUESTED.
    LOOP AT ctractaxexemption.
      IF ctractaxexemption-processing_mode <> 'I'.
        mac_err_exit2t return parlt '022' space space.
      ENDIF.
      CALL FUNCTION 'MAP2I_BAPIFKKVKTAXI_TO_FKKVK_T'
        EXPORTING
          bapifkkvktaxi    = ctractaxexemption
        CHANGING
          fkkvk_taxex_s_di = ifkkvktax_i.
      APPEND ifkkvktax_i.
    ENDLOOP.
  ENDIF.
  mac_return_exit return.

  IF ctracchargesdiscounts IS REQUESTED.
    LOOP AT ctracchargesdiscounts.
      IF ctracchargesdiscounts-processing_mode <> 'I'.
        mac_err_exit2t return parcd '022' space space.
      ENDIF.
      CALL FUNCTION 'FKK_BAPI_FILL_STRUCTURE'
        EXPORTING
          i_field_char = 'X'
        CHANGING
          c_structure  = ls_bapifkkvkp_chgdiscix.
      CALL FUNCTION 'MAP2I_BAPIFKKVKP_CHGDISCI_TO_F'
        EXPORTING
          bapifkkvkp_chgdisci  = ctracchargesdiscounts
          bapifkkvkp_chgdiscix = ls_bapifkkvkp_chgdiscix
        CHANGING
          fkkvkp_chgdisc_s_di  = ifkkvkpchgdisc_i.
      APPEND ifkkvkpchgdisc_i.
    ENDLOOP.
  ENDIF.
  mac_return_exit return.

* costumer extensions
  LOOP AT extensionin.
    CASE extensionin-structure.
      WHEN 'BAPI_TE_FKKVKI'.
        SHIFT extensionin BY c_lenstruc PLACES LEFT.
        MOVE extensionin TO wa_fkkvki.                      "#EC ENHOK
        CATCH SYSTEM-EXCEPTIONS conversion_errors  = 1.
          MOVE-CORRESPONDING wa_fkkvki TO sfkkvk_i.
        ENDCATCH.
        IF sy-subrc <> 0.
          err_par = sy-tabix.
          mac_err_exit2t return pare '020' 'BAPI_TE_FKKVKI' err_par.
        ENDIF.
      WHEN 'BAPI_TE_FKKVKPI'.
        SHIFT extensionin BY c_lenstruc PLACES LEFT.
        MOVE extensionin TO wa_fkkvkpi.                     "#EC ENHOK
        READ TABLE ifkkvkp_i WITH KEY partner = wa_fkkvkpi-buspartner.
        IF sy-subrc <> 0.
          err_par = wa_fkkvkpi-buspartner.
          mac_err_exit2t return pare '021'
            err_par 'CTRACPARTNERDETAIL'.
        ENDIF.
        CATCH SYSTEM-EXCEPTIONS conversion_errors  = 1.
          MOVE-CORRESPONDING wa_fkkvkpi TO ifkkvkp_i.
        ENDCATCH.
        IF sy-subrc <> 0.
          err_par = sy-tabix.
          mac_err_exit2t return pare '020' 'BAPI_TE_FKKVKPI' err_par.
        ENDIF.
        MODIFY ifkkvkp_i INDEX sy-tabix.
    ENDCASE.
  ENDLOOP.
  mac_return_exit return.
*User exit
  CALL FUNCTION 'FKK_GET_APPLICATION'
    IMPORTING
      e_applk = applk
    EXCEPTIONS
      OTHERS  = 2.
  CALL FUNCTION 'FKK_FUNC_MODULE_DETERMINE'
    EXPORTING
      i_applk  = applk
      i_fbeve  = '9501'
    TABLES
      t_fbstab = i_fbstab.
  LOOP AT i_fbstab.
    CALL FUNCTION i_fbstab-funcc
      EXPORTING
        i_vkonto              = ctraccreateinfo-cont_acct
        i_partner             = ctraccreateinfo-buspartner
*       Note                  =
*       1374995               =
*       ===================================================  =
        i_vktype              = ctraccreateinfo-acct_cat
*       ==================================================== =
*       End                   =
*       of                    =
*       Note                  =
      TABLES
        t_fkkvkp_di           = ifkkvkp_i
        t_fkkvklock_s_di      = ifkkvklock_i
        t_fkkvk_corr_s_di     = ifkkvkcorr_i
        t_fkkvkp_chgdisc_s_di = ifkkvkpchgdisc_i
      CHANGING
        i_fkkvk_di            = sfkkvk_i
      EXCEPTIONS
        error_message         = 1
        OTHERS                = 2.
  ENDLOOP.
  IF 1 = 2.
    SET EXTENDED CHECK OFF.
    CALL FUNCTION 'FKK_SAMPLE_9501'.
    SET EXTENDED CHECK ON.
  ENDIF.
* -- convert external dat to internal date representation
  IF NOT validfrom IS INITIAL.
    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
      EXPORTING
        date_external = validfrom
      IMPORTING
        date_internal = lv_valdt
      EXCEPTIONS
        OTHERS        = 1.
    mac_sy_err_exit_t return parv.
  ENDIF.

  IF NOT ctraccreateinfo-appl_area IS INITIAL.
    applk = ctraccreateinfo-appl_area.
  ENDIF.

  LOOP AT ifkkvkp_i ASSIGNING FIELD-SYMBOL(<lfs_ifkkvkp_i>).
    <lfs_ifkkvkp_i>-zahlkond = zterm.
  ENDLOOP.

*create account
  CALL FUNCTION 'VKK_FICA_DI'
    EXPORTING
      i_aktyp               = '01'
      i_vkonto              = ctraccreateinfo-cont_acct
      i_partner             = ctraccreateinfo-buspartner
      i_vktyp               = ctraccreateinfo-acct_cat
      i_applk               = applk
      i_vkona               = ctraccreateinfo-legacy_acct
      i_fkkvk_di            = sfkkvk_i
*     I_NODATA              = '/'
      i_xupdtask            = 'X'
      i_xcommit             = ' '
      i_xtest               = testrun
      i_valdt               = lv_valdt
      i_xkeep_memory        = 'X'
    IMPORTING
      e_xerror              = error
    TABLES
      t_fkkvkp_di           = ifkkvkp_i
      t_fkkvklock_s_di      = ifkkvklock_i
      t_fkkvk_corr_s_di     = ifkkvkcorr_i
      t_fkkvk_taxex_s_di    = ifkkvktax_i
      t_fkkvkp_chgdisc_s_di = ifkkvkpchgdisc_i
*     T_DATA                =
      t_message             = err_table
      t_keyvalue            = key_table.
  IF error IS INITIAL.
    READ TABLE key_table WITH KEY tabnm = 'FKKVK' fldnm = 'VKONT'.
    contractaccount = key_table-valint.
  ELSE.
    LOOP AT err_table ASSIGNING <err_struct>.
      CALL FUNCTION 'BALW_BAPIRETURN_GET2'
        EXPORTING
          type   = <err_struct>-msgty
          cl     = <err_struct>-arbgb
          number = <err_struct>-txtnr
          par1   = <err_struct>-msgv1
          par2   = <err_struct>-msgv2
          par3   = <err_struct>-msgv3
          par4   = <err_struct>-msgv4
        IMPORTING
          return = return.
      APPEND return.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
