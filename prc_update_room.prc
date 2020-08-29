CREATE OR REPLACE PROCEDURE prc_update_room (pin_room IN NUMBER,
                                             pin_resv_name_id IN NUMBER,
                                             pout_error OUT VARCHAR2)
IS

v_room_class VARCHAR2(20);
v_room_category VARCHAR2(20);
v_room VARCHAR2(20);
BEGIN
  BEGIN
    SELECT room_class,
           room_category
      INTO v_room_class,
           v_room_category
      FROM ROOM
     WHERE room = pin_room;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
	......................

  UPDATE reservation_daily_elements
     SET room = pin_room,
         room_class = v_room_class,
         room_category = v_room_category
   WHERE resv_daily_el_seq IN (SELECT resv_daily_el_seq
                                 FROM reservation_daily_element_name
                                WHERE resv_name_id = pin_resv_name_id);
  COMMIT;
  pout_error:='OK';
 EXCEPTION
    WHEN OTHERS THEN
      pout_error:='Error: '||SQLERRM;
      ROLLBACK;
 END;
/
