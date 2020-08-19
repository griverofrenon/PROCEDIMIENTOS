CREATE OR REPLACE PROCEDURE prc_attachment (pin_nombre_archivo IN VARCHAR2,
                                            pin_tipo_doc IN VARCHAR2,
                                            pin_link_type IN VARCHAR2,
                                            pin_name_id IN NUMBER,
                                            pin_resort IN VARCHAR2,
                                            pin_directorio IN VARCHAR2,
                                            pout_error OUT VARCHAR2)
IS

v_work NUMBER;
v_link NUMBER;
v_user NUMBER;
BEGIN

  --Buscando Secuencia para la tabla work_orders
  SELECT workorder_seqno.nextval
    INTO v_work
    FROM dual;

  --Buscando el Numero de Usuario
  BEGIN
    SELECT APP_USER_ID
      INTO v_user
      FROM application$_user
     WHERE app_user = USER;
  EXCEPTION
    WHEN OTHERS THEN
      v_user := 2;
  END;

  BEGIN
    INSERT INTO work_orders(wo_number,
                            created_date,
                            created_by,
                            problem_desc,
                            notes,
                            resort,
                            type_code,
                            update_user,
                            update_date,
                            insert_user,
                            insert_date,
                            tracecode,
                            act_class,
                            bfile_locator,
                            attachment_location,
                            global_yn)

                      VALUES(v_work,
                             SYSDATE,
                             v_user,
                             pin_nombre_archivo,
                             pin_tipo_doc,
                             pin_resort,
                             'ATTACHMENT',
                             NULL,
                             NULL,
                             v_user,
                             SYSDATE,
                             'OTHER',
                             'ATTACHMENT',
                             BFILENAME(pin_directorio,pin_nombre_archivo),
                             'BFILE',
                             'Y');                        
    EXCEPTION
      WHEN OTHERS THEN
        pout_error:='Error insertando la primera vez en la WORK_ORDERS'||SQLERRM;
    END;
-------------------------
  --Buscando Secuencia para la tabla activity$link
  SELECT workorder_seqno.nextval
    INTO v_link
    FROM dual;
  BEGIN
    INSERT INTO work_orders(wo_number,
                            act_type,
                            created_date,
                            created_by,
                            problem_desc,
                            notes,
                            assigned_to, 
                            completed_by,
                            completed_date,
                            resort,
                            type_code,
                            start_date,
                            end_date,
                            update_user,
                            update_date,
                            insert_user,
                            insert_date,
                            inactive_date,
                            completed_yn,
                            act_class,
                            author,
                            timezone_converted_yn)
                      VALUES(v_link,
                             'FOL',
                             SYSDATE,
                             v_user,
                             'Correspondence',
                             'Correspondence',
                             v_user,
                             v_user,
                             SYSDATE,
                             pin_resort,
                             'AC',
                             TRUNC(SYSDATE),
                             TRUNC(SYSDATE),
                             v_user,
                             SYSDATE,
                             v_user,
                             SYSDATE,
                             SYSDATE,
                             'Y',
                             'CORRESPONDENCE',
                             v_user,
                             'N');                       
    EXCEPTION
      WHEN OTHERS THEN
        pout_error:='Error insertando la segunda vez en la WORK_ORDERS'||SQLERRM;
    END;
-------------------------
--activity$link(ACTIVITY)

  BEGIN
    INSERT INTO activity$link (act_id,
                               link_type,
                               link_id,
                               act_resort,
                               insert_date,
                               insert_user,
                               update_date,
                               update_user,
                               attachment_yn)
                      VALUES  (v_work,
                              'ACTIVITY',
                               v_link,
                               pin_resort,
                               SYSDATE,
                               v_user,
                               SYSDATE,
                               v_user,
                               'Y');                        
  EXCEPTION
    WHEN OTHERS THEN
      pout_error:='Error insertando 1era vez en la Activity$link'||SQLERRM;
      ROLLBACK;
  END;

 ---------------------------------------
--activity$link(CONTACT)
  BEGIN
    INSERT INTO activity$link (act_id,
                               link_type,
                               link_id,
                               primary_yn,
                               act_resort,
                               inactive_date,
                               insert_date,
                               insert_user,
                               to_type)
                       VALUES  (v_link,
                               pin_link_type,
                               pin_name_id,
                               'Y',
                               pin_resort,
                               SYSDATE,
                               SYSDATE,
                               v_user,
                               'D');
  
  COMMIT;
  pout_error:='OK';
  EXCEPTION
    WHEN OTHERS THEN
      pout_error:='Error insertando 2da vez en la Activity$link'||SQLERRM;
      ROLLBACK;
  END;
END;
/
