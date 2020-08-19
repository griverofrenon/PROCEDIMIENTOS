CREATE OR REPLACE PROCEDURE prc_ins_acom_res (pin_user IN NUMBER,
                                         pin_nombre IN VARCHAR2,
                                         pin_apellido IN VARCHAR2,
                                         pin_nationality IN VARCHAR2,
                                         pin_language IN VARCHAR2,
                                         pin_name_type IN VARCHAR2,
                                         pin_summ IN VARCHAR2,
                                         pin_gender IN VARCHAR2,
                                         pin_resort IN VARCHAR2,
                                         pin_passport IN VARCHAR2,
                                         pin_documento IN VARCHAR2,
                                         pin_birth_place IN VARCHAR2,
                                         pin_birthdate IN DATE,
                                         pin_city IN VARCHAR2,
                                         pin_country IN VARCHAR2,
                                         pin_address IN VARCHAR2,
                                         pin_resv_name_id IN NUMBER,
                                         pout_name_id OUT NUMBER,
                                         pout_message OUT VARCHAR2) IS
 v_secuencia_name NUMBER;
 v_secuencia_addres NUMBER;
 v_status VARCHAR2(20);
 v_code VARCHAR2(20);
 v_begin DATE;
 v_end DATE;
 v_name_id NUMBER;
 v_name_dos NUMBER;

BEGIN
  BEGIN   
  SELECT name_id 
    INTO v_name_id
    FROM name_reservation
   WHERE passport = pin_passport
      OR tax1_no = pin_documento;
  EXCEPTION
    WHEN OTHERS THEN
      v_name_id := NULL;
  END; 
    

  
  IF (v_name_id IS NOT NULL) THEN
     --Actualizando la tabla name  
    UPDATE NAME
       SET  update_user = pin_user,
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
  END IF;
  
  IF (v_name_id IS NULL) THEN
      v_secuencia_name := name_seqno.nextval;
     v_secuencia_addres:= name_address_seqno.nextval;
    INSERT INTO NAME(
                    name_id,
                    insert_user,
                    insert_date,
                    update_user,
                    update_date,
                    first,
                    last,
                    nationality,
                    language,
                    history_yn,
                    active_yn,
                    name_type,
                    sname,
                    sfirst,
                    cash_bl_ind,
                    summ_ref_cc,
                    gender,
                    guest_priv_yn,
                    email_yn,
                    resort_registered,
                    phone_yn,
                    sms_yn,
                    chain_code,
                    profile_privacy_flg,
                    replace_address,
                    passport,
                    tax1_no,
                    birth_date,
                    birth_place)
              VALUES
                  (v_secuencia_name,
                  pin_user,
                  SYSDATE,
                  pin_user,
                  SYSDATE,
                  pin_nombre,
                  pin_apellido,
                  pin_nationality,
                  pin_language,
                  'N',
                  'Y',
                  pin_name_type,
                  pin_apellido,
                  pin_nombre,
                  'N',
                  pin_summ,
                  pin_gender,
                  'N',
                  'N',
                  pin_resort,
                  'N',
                  'N',
                  'CHA',
                  'N',
                  'N',
                  pin_passport,
                  pin_documento,
                  pin_birthdate,
                  pin_birth_place);

    INSERT INTO name_address
                (address_id,
                name_id,
                address_type,
                insert_date,
                insert_user,
                update_date,
                update_user,
                address1,
                city,
                country,
                primary_yn,
                language_code,
                last_updated_resort)
        VALUES
              (v_secuencia_addres,
              v_secuencia_name,
              'AR ADDRESS',
              TRUNC(SYSDATE),
              pin_user,
              TRUNC(SYSDATE),
              pin_user,
             pin_address,
              pin_city,
              pin_country,
              'Y',
              pin_language,
              pin_resort);
    END IF;
----------------------------------------------------------
    BEGIN
      SELECT begin_date, end_date,
             resv_status,guarantee_code
        INTO v_begin, v_end, v_status,v_code
        FROM reservation_name
       WHERE resv_name_id = pin_resv_name_id;
    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END;

-------------------------------------------------------------------
INSERT INTO reservation_name (
              resort,
              resv_name_id,
              name_id,
              name_usage_type,
              insert_date,
              insert_user,
              update_user,
              update_date,
              resv_status ,
              begin_date,
              end_date,
              financially_responsible_yn,
              parent_resv_name_id,
              guarantee_code,
              trunc_begin_date,
              trunc_end_date,
              sguest_name,
              insert_action_instance_id,
              business_date_created,
              sguest_firstname,
              guest_last_name,
              guest_first_name)
        VALUES
              ('HRS',
              reservation_name_seqno.nextval,
              NVL(v_name_id,v_secuencia_name),
              'AG',
              SYSDATE,
              pin_user,
              pin_user,
              SYSDATE,
              v_status,
              v_begin,
              v_end,
              'N',
              pin_resv_name_id,
              v_code,
              TRUNC(v_begin),
              TRUNC(v_end),
              UPPER(pin_nombre),
              reservation_action_seqno.nextval,
              SYSDATE,
              UPPER(pin_apellido),
              pin_nombre,
              pin_apellido);
  
  pout_name_id:= NVL(v_name_id,v_secuencia_name);
  pout_message := 'OK';
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  pout_message := ('Error: '||SQLERRM);
  ROLLBACK;
END;
/
