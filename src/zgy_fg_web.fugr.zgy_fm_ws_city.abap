FUNCTION zgy_fm_ws_city.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CITY_ID) TYPE  ZGY_DE_CITY_ID
*"     VALUE(IV_CITY_NAME) TYPE  ZGY_DE_CITY_NAME
*"  EXPORTING
*"     VALUE(EV_SUCCESS) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------
  DATA:ls_city TYPE zgy_city_list.

  ls_city-city_id      = iv_city_id.
  ls_city-city_name    = iv_city_name.
  ls_city-uname        = sy-uname.
  ls_city-datum        = sy-datum.
  ls_city-uzeit        = sy-uzeit.


  "SELECT COUNT(*) FROM zgy_city_list WHERE city_id EQ iv_city_id.

  SELECT SINGLE city_id
  FROM zgy_city_list
  WHERE city_id EQ @iv_city_id
  INTO @DATA(lv_city_id).

  IF sy-subrc EQ 0.
    ev_success = abap_false.
    ev_message = |Bu şehir ID kaydı mevcuttur!|.
  ELSE.

    INSERT zgy_city_list FROM ls_city.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      ev_success = abap_true.
      ev_message = |Kaydetme işlemi başarılı bir şekilde gerçekleştirilmiştir!|.
    ELSE.
      ROLLBACK WORK.
      ev_success = abap_false.
      ev_message = |Kaydetme işleminde HATA!|.
    ENDIF.

  ENDIF.




ENDFUNCTION.
