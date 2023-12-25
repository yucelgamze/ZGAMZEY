*&---------------------------------------------------------------------*
*& Report ZGY_OPEN_SQL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_open_sql_sharepoint.

TABLES:zgy_t_persons, zgy_t_salary.

DATA:gt_table TYPE TABLE OF zgy_t_persons,
     gs_table TYPE zgy_t_persons.


SELECT *
  FROM zgy_t_persons
  INTO TABLE @DATA(lt_table).

SELECT *
  FROM zgy_t_persons
  INTO TABLE gt_table.

SELECT
personal_id,
personal_ad ,
personal_soyad,
personal_yas
FROM zgy_t_persons
INTO TABLE @DATA(lt_table2).

BREAK gamzey.
