*&---------------------------------------------------------------------*
*& Report ZGY_NS_0024
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0024.

*TYPES:BEGIN OF gty_personel,
*        personel  TYPE char2,
*        departman TYPE char2,
*        tecrube   TYPE i,
*      END OF gty_personel.
*
*TYPES:gtt_personel TYPE TABLE OF gty_personel WITH KEY personel.
*
*DATA(lt_pers) = VALUE gtt_personel( ( personel = 'P1' departman = 'D1' tecrube = 1 )
*                                    ( personel = 'P2' departman = 'D2' tecrube = 2 )
*                                    ( personel = 'P3' departman = 'D2' tecrube = 3 )
*                                    ( personel = 'P4' departman = 'D1' tecrube = 4 )
*                                    ( personel = 'P5' departman = 'D3' tecrube = 5 )
*                                    ( personel = 'P6' departman = 'D1' tecrube = 6 )
*                                    ( personel = 'P7' departman = 'D2' tecrube = 7 ) ).

*LOOP AT lt_pers INTO DATA(ls_pers).
*  WRITE:/ ls_pers-departman.
*ENDLOOP.

*LOOP AT lt_pers INTO DATA(ls_pers) GROUP BY ( departman = ls_pers-departman ).
*  WRITE: / ls_pers-departman.
*ENDLOOP.

*DATA:gv_total TYPE i.
*LOOP AT lt_pers INTO DATA(ls_pers) GROUP BY ( departman = ls_pers-departman ).
*  WRITE:ls_pers-departman.
*  CLEAR:gv_total.
*  LOOP AT GROUP ls_pers INTO DATA(ls_line).
*    gv_total = gv_total + ls_line-tecrube.
*  ENDLOOP.
*
*  WRITE:gv_total.
*  SKIP.
*ENDLOOP.


*DATA:gv_toplam TYPE i.
*LOOP AT lt_pers INTO DATA(ls_pers) GROUP BY ( departman = ls_pers-departman ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_pers>).
*  IF <lfs_pers> IS ASSIGNED.
*    WRITE: / <lfs_pers>-departman.
*  ENDIF.
*
*  CLEAR:gv_toplam.
*  LOOP AT GROUP <lfs_pers> ASSIGNING FIELD-SYMBOL(<lfs_s_pers>).
*    IF <lfs_s_pers> IS ASSIGNED.
*      gv_toplam = gv_toplam + <lfs_s_pers>-tecrube.
*    ENDIF.
*  ENDLOOP.
*
*  WRITE:gv_toplam.
*  SKIP.
*
*ENDLOOP.

*--------------------------------------------------------------------*

TYPES:BEGIN OF gty_personel,
        personel  TYPE char2,
        departman TYPE char2,
        tecrube   TYPE i,
      END OF gty_personel.

TYPES:gtt_personel TYPE TABLE OF gty_personel WITH KEY personel.

TYPES:BEGIN OF gty_tecrube,
        departman TYPE char2,
        tecrube   TYPE i,
      END OF gty_tecrube.

DATA:gt_tecrube TYPE TABLE OF gty_tecrube,
     gs_tecrube TYPE gty_tecrube.

DATA(lt_pers) = VALUE gtt_personel( ( personel = 'P1' departman = 'D1' tecrube = 1 )
                                    ( personel = 'P2' departman = 'D2' tecrube = 2 )
                                    ( personel = 'P3' departman = 'D2' tecrube = 3 )
                                    ( personel = 'P4' departman = 'D1' tecrube = 4 )
                                    ( personel = 'P5' departman = 'D3' tecrube = 5 )
                                    ( personel = 'P6' departman = 'D1' tecrube = 6 )
                                    ( personel = 'P7' departman = 'D2' tecrube = 7 ) ).

LOOP AT lt_pers INTO DATA(ls_pers) GROUP BY ( departman = ls_pers-departman ).
  CLEAR:gs_tecrube.
  gs_tecrube-departman = ls_pers-departman.

  LOOP AT GROUP ls_pers INTO DATA(ls_line).
    gs_tecrube-tecrube = gs_tecrube-tecrube + ls_line-tecrube.
  ENDLOOP.

  APPEND gs_tecrube TO gt_tecrube.
ENDLOOP.

cl_demo_output=>display_data( gt_tecrube ).
BREAK gamzey.
