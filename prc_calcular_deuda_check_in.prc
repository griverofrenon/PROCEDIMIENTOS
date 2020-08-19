CREATE OR REPLACE PROCEDURE prc_calcular_deuda_check_in (pin_resv_name_id IN NUMBER,
                                               pout_monto OUT NUMBER,
                                               pout_msg OUT VARCHAR2)  IS
v_deposit NUMBER := 0;
v_pago NUMBER:= 0;

BEGIN

  SELECT deposit_amount
    INTO v_deposit
   FROM RESERVATION_DEPOSIT_SCHEDULE
  WHERE resv_name_id = pin_resv_name_id;

  SELECT NVL(SUM(trx_amount),0)
    INTO v_pago
    FROM FINANCIAL_TRANSACTIONS
   WHERE resv_name_id = pin_resv_name_id
     AND resv_deposit_id IS NOT NULL;
    

  pout_monto := NVL(v_deposit,0) - v_pago;
  EXCEPTION
    WHEN OTHERS THEN
      pout_monto := 0;
      pout_msg := ('Error: '||SQLERRM);
END;
/
