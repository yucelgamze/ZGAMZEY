*&---------------------------------------------------------------------*
*& Report ZGY_SEARCH_HELP_OBJECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_search_help_object.

TABLES:zgy_t_personel.

"matchcode object ile search help
PARAMETERS:p_id TYPE zpers_id_de MATCHCODE OBJECT zgy_sh_per_sh.


"search help objesi data elemente gömülü halde
PARAMETERS:
  p_ad    TYPE zgy_de_per_ad,
  p_soyad TYPE zgy_de_per_soyad,
  p_yas   TYPE zgy_de_per_yas.


START-OF-SELECTION.
