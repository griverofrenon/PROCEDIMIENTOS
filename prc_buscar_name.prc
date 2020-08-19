CREATE OR REPLACE PROCEDURE prc_buscar_name(pin_resv_name_id IN NUMBER,
                                            pout_name_id OUT NUMBER,
                                            pout_mensaje OUT VARCHAR2) IS

BEGIN
    SELECT name_id
      INTO pout_name_id
      FROM reservation_name
     WHERE resv_name_id = pin_resv_name_id;
     pout_mensaje := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    pout_mensaje := 'Error: '||SQLERRM;
END;
/
