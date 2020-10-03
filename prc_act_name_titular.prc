CREATE OR REPLACE PROCEDURE prc_act_name_titular (pin_resv_name_id IN NUMBER,
                                                 pin_user IN NUMBER,
                                                 pin_nombre IN VARCHAR2,
                                                 pin_apellido IN VARCHAR2,
                                                 pin_nationality IN VARCHAR2,
                                                 pin_language IN VARCHAR2,
                                                 pin_name_type IN VARCHAR2,
                                                 pin_summ IN VARCHAR2,
                                                 pin_gender IN VARCHAR2,
                                                 pin_resort IN VARCHAR2,
                                                 pin_passport IN VARCHAR2,
                                                 pin_birth_place IN VARCHAR2,
                                                 pin_birthdate IN DATE,
                                                 pin_city IN VARCHAR2,
                                                 pin_country IN VARCHAR2,
                                                 pin_address IN VARCHAR2,
                                                 pout_message OUT VARCHAR2) IS
                                                 
v_name_id NUMBER;
v_name2 NUMBER;
JASDJOASOJDNPASOnDOASN
BEGIN
  --Buscando el name_id 
  BEGIN
    SELECT name_id
    INTO v_name_id
    FROM reservation_name
    WHERE resv_name_id = pin_resv_name_id;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    END;
    -------------------------------------
  --Actualizando la tabla name  
  UPDATE NAME
     SET insert_user  = pin_user,
          insert_date = SYSDATE,
          update_user = pin_user,
          update_date = SYSDATE,
          first = pin_nombre,
          last = pin_apellido,
          nationality = pin_nationality,
          language = pin_language,
          history_yn = 'N',
          active_yn = 'Y',
          name_type = pin_name_type,
          cash_bl_ind = 'N' ,
          summ_ref_cc = pin_summ,
          gender = pin_gender,
          guest_priv_yn = 'N',
          email_yn = 'N',
          resort_registered = pin_resort,
          phone_yn = 'N',
          sms_yn = 'N',
          chain_code = 'CHA',
          profile_privacy_flg = 'N',
          replace_address = 'N',
          passport = pin_passport ,
          birth_date = pin_birthdate,
          birth_place = pin_birth_place
      WHERE name_id = v_name_id;
  
  --------------------------------------------------
  UPDATE name_address
     SET address1 = pin_address ,
         city = pin_city,
         country = pin_country,
         language_code = pin_language
   WHERE name_id = v_name_id;
  COMMIT;
  pout_message := 'OK';
EXCEPTION
WHEN OTHERS THEN
  pout_message := ('Error: '||SQLERRM);
END;
/
