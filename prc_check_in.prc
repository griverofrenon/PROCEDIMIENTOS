CREATE OR REPLACE PROCEDURE prc_check_in (pin_resv_name_id IN NUMBER,
                                          pin_resort IN VARCHAR2,
                                          pout_message OUT VARCHAR2)
IS
BEGIN

UPDATE reservation_name 
   SET resv_status = 'CHECKED IN',
       guarantee_code = 'CHECKED IN'
 WHERE resv_name_id = pin_resv_name_id
   AND resort = pin_resort;
   pout_message:='OK';
   
   
UPDATE reservation_daily_elements
  SET resv_status = 'CHECKED IN'  
   WHERE resv_daily_el_seq IN (SELECT resv_daily_el_seq  
                                 FROM reservation_daily_element_name
                                  WHERE resv_name_id = pin_resv_name_id);
   
   
   COMMIT;
   
  EXCEPTION
    WHEN OTHERS THEN
      pout_message:= 'Error: '||SQLERRM;
END;
/
