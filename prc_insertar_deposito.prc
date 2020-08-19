CREATE OR REPLACE PROCEDURE prc_insertar_deposito(pin_trx_code IN NUMBER,
                                              pin_currency IN VARCHAR2,
                                              pin_resv_name_id IN NUMBER,
                                              pin_user IN NUMBER,
                                              pin_reference IN VARCHAR2,
                                              pin_amount IN NUMBER,
                                              pin_name_tax_type IN VARCHAR2,
                                              pin_closure IN NUMBER,
                                              pin_comm_tajeta IN VARCHAR2 DEFAULT NULL,
                                              pout_error OUT VARCHAR2)

IS
v_tc_group VARCHAR2(20);
v_tc_subgroup VARCHAR2(20);
v_name_id NUMBER;
v_rate_code VARCHAR2(20);
v_recpt_no NUMBER;
v_departure DATE;
v_market_code VARCHAR2(40);
v_channel VARCHAR2(40);
v_cashier_credit NUMBER := NULL;
v_exchange NUMBER := 1;
v_euro NUMBER := 1;
v_posted_amount NUMBER;
v_amount NUMBER := pin_amount;
v_exchange_type VARCHAR2(20) := NULL;
v_exchange_date DATE;
v_amount_ori NUMBER;
v_forex_type VARCHAR2(10);
v_forex_comm_perc NUMBER;
v_forex_comm_amount NUMBER;
v_deposit NUMBER;
v_date DATE;


BEGIN
  --Buscando el group y el sub-group
  BEGIN
    SELECT tc_group,tc_subgroup
      INTO v_tc_group, v_tc_subgroup
      FROM trx$_codes
    WHERE trx_code = pin_trx_code;
  EXCEPTION
    WHEN OTHERS THEN
      null;
  END;

  SELECT resv_deposit_schedule_id,deposit_due_date
    INTO v_deposit,v_date
   FROM RESERVATION_DEPOSIT_SCHEDULE
  WHERE pin_resv_name_id = resv_name_id;

    BEGIN
    SELECT name_id, rate_code,departure,market_code,origin_of_booking
      INTO v_name_id, v_rate_code,v_departure,v_market_code,v_channel
      FROM name_reservation
    WHERE resv_name_id  = pin_resv_name_id;
    
      EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;




  IF pin_currency = 'CLP' THEN
    v_exchange := 1;
  END IF;

  SELECT MAX(recpt_no)
    INTO v_recpt_no
    FROM FINANCIAL_TRANSACTIONS;

  v_recpt_no := v_recpt_no + 1;



  INSERT INTO FINANCIAL_TRANSACTIONS
                            (recpt_no,
                            recpt_type,
                            room_class,
                            tax_inclusive_yn,
                            trx_no,
                            resort,
                            ft_subtype,
                            tc_group,
                            tc_subgroup,
                            trx_code,
                            trx_date,
                            business_date,
                            currency,
                            resv_name_id,
                            cashier_id,
                            folio_view,
                            quantity,
                            reference,
                            price_per_unit,
                            trx_amount,
                            name_id,
                            posted_amount,
                            market_code,
                            deferred_yn,
                            exchange_rate,
                            dep_led_credit,
                            tran_action_id,
                            fin_dml_seq_no,
                            folio_no,
                            insert_user,
                            insert_date,
                            update_user,
                            update_date,
                            resv_deposit_id,
                            name_tax_type,
                            display_yn,
                            coll_agent_posting_yn,
                            fiscal_trx_code_type,
                            deferred_taxes_yn,
                            posting_date,
                            original_resv_name_id,
                            closure_no,
                            posting_type,
                            remark
                            )
                     VALUES(v_recpt_no,
                            'RDR',
                            'ALL',
                            NULL,
                            TRX_DETAIL_SEQNO.nextval,
                            'HRS',
                            'FC',
                            v_tc_group,
                            v_tc_subgroup,
                            pin_trx_code,
                            v_date,
                            v_date,
                            pin_currency,
                            pin_resv_name_id,
                            pin_user,
                            1,
                            1,
                            pin_reference,
                            v_amount,
                            v_amount,
                            v_name_id,
                            NVL(v_amount_ori,pin_amount),
                            v_market_code,
                            'N',
                            v_exchange,
                            v_amount,
                            fin_action_id_seqno.nextval,
                            fin_dml_seqno.nextval,
                            folio_no_seqno.nextval,
                            pin_user,
                            v_date,
                            pin_user,
                            v_date,
                            v_deposit,
                            pin_name_tax_type,
                            'Y',
                            'N',
                            'P',
                            'N',
                            v_date,
                            pin_resv_name_id,
                            pin_closure,
                            'MANUAL',
                            pin_comm_tajeta
                            );
  pout_error:='OK';
  
  UPDATE reservation_name rn
     SET resv_status = 'CHECKED IN'
   WHERE rn.resv_name_id = pin_resv_name_id ;
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      pout_error:='Error: '||SQLERRM;
      ROLLBACK;
  END;
/
