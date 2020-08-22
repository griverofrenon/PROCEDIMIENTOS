CREATE OR REPLACE PROCEDURE PRC_DUE_PAYMENT(pin_resv_name_id IN VARCHAR2,
                                                  pout_value OUT NUMBER,
                                                pout_message OUT VARCHAR2) IS

BEGIN
  SELECT NVL(SUM(GUEST_ACCOUNT_CREDIT),0) - NVL(SUM(GUEST_ACCOUNT_DEBIT),0)
  INTO pout_value
  FROM FINANCIAL_TRANSACTIONS
 WHERE resv_name_id = pin_resv_name_id;

  IF pout_value = 0 THEN
    UPDATE reservation_name rn
       SET resv_status = 'CHECKED OUT'
     WHERE rn.confirmation_no = pin_resv_name_id;
     COMMIT;
  END IF;

___________________---------

--PROBANDO GIT

  EXCEPTION
    WHEN OTHERS THEN
      pout_message := 'Error: '||SQLERRM;
END;
/
