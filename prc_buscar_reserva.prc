CREATE OR REPLACE PROCEDURE prc_buscar_reserva(pin_resv_name_id IN NUMBER,
                                               pin_resort IN VARCHAR2,
                                               pout_status OUT VARCHAR2,
                                               pout_children OUT NUMBER,
                                               pout_adult OUT NUMBER,
                                               pout_nights OUT NUMBER,
                                               pout_mensaje OUT VARCHAR2)
IS
BEGIN
  SELECT resv_status,
         children,
         adults,
         nights
   INTO
        pout_status,
        pout_children,
        pout_adult,
        pout_nights
   FROM name_reservation 
  WHERE resv_name_id = pin_resv_name_id
    AND RESORT = pin_resort;
    pout_mensaje := 'OK';
EXCEPTION
    WHEN OTHERS THEN
      pout_mensaje := 'Error: '||SQLERRM;
END;
/
