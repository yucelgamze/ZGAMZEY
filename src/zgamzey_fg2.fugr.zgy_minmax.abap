FUNCTION zgy_minmax.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

  SELECT vbeln,
    SUM( kwmeng ) AS sum,
    MAX( kwmeng ) AS max,
    MIN( kwmeng ) AS min,
    AVG( netpr ) AS avg
    FROM vbap
    INTO TABLE @DATA(lt_vbap)
    GROUP BY vbeln.



ENDFUNCTION.
