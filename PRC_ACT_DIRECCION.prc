CREATE OR REPLACE PROCEDURE PRC_ACT_DIRECCION(pin_resv_name_id IN NUMBER,
                                              pin_address VARCHAR2,
                                              pin_city VARCHAR2,
                                              pin_country VARCHAR2,
                                              pin_number VARCHAR2,
                                              pin_patente VARCHAR2,
                                              pout_message OUT VARCHAR2) IS
v_name_id NUMBER;
BEGIN
  BEGIN
    SELECT name_id
    INTO v_name_id
    FROM reservation_name
    WHERE resv_name_id = pin_resv_name_id;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    END;  

  UPDATE name_address
     SET address1 = pin_address ,
         city = pin_city,
         country = pin_country
   WHERE name_id = v_name_id;

   UPDATE reservation_name
      SET udfc05 = pin_patente
    WHERE resv_name_id = pin_resv_name_id;

  COMMIT;

  pout_message := 'OK';
EXCEPTION
WHEN OTHERS THEN
  pout_message := ('Error: '||SQLERRM);
  ROLLBACK;
END;
/
