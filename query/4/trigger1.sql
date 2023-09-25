/*
Purpose: The purpose of this trigger is to make payment, that means user not able to pay after that day. This will check and validate in all time. Once the user key-in wrong data, it might showing error message.
*/
CREATE OR REPLACE TRIGGER trg_create_NewPayment
BEFORE INSERT ON Payment
FOR EACH ROW

DECLARE
  v_idcount NUMBER;
  v_PaymentID Payment.PaymentID%TYPE;
  v_PaymentMethod Payment.PaymentMethod%TYPE;
  v_PaymentDate Payment.PaymentDate%TYPE;
  v_PaymentTime Payment.PaymentTime%TYPE;

BEGIN
  SELECT COUNT(*) INTO v_idcount
  FROM Payment
  WHERE PaymentID = :NEW.PaymentID;

IF (v_idcount > 0) THEN
  RAISE_APPLICATION_ERROR(-20001, 'The Payment ID Your Selected: (' || :NEW.PaymentID || ') Already Exist');
  ELSE
    IF (REGEXP_LIKE(:NEW.PaymentID, '^PY[0-9]{4}$')) THEN
   DBMS_OUTPUT.PUT_LINE('test');
  ELSE
   RAISE_APPLICATION_ERROR(-20001, 'The Payment ID Your Selected: (' || :NEW.PaymentID || ') is not related what we provide. You allow to do like PY0401');
END IF;
END IF;
IF (:NEW.PaymentMethod != 'Cash' AND :NEW.PaymentMethod != 'Debit Card' AND :NEW.PaymentMethod != 'Credit Card' AND :NEW.PaymentMethod != 'E-wallet') THEN
  RAISE_APPLICATION_ERROR(-20002, 'The Payment Method Your Selected: (' || :NEW.PaymentMethod || ') is not related what we provide');
 END IF;
 
 IF (:NEW.PaymentDate > SYSDATE) THEN
    RAISE_APPLICATION_ERROR(-20003, 'The Payment DATE Your Selected: (' || :NEW.PaymentDate|| ') should before than (' || SYSDATE || ') that provided');

 
ELSE
  UPDATE Payment
  SET PaymentID = :NEW.PaymentID
  WHERE PaymentID = :NEW.PaymentID;
  END IF;
END;
/

/*
Valid
INSERT INTO Payment VALUES ('PY0800', 'Cash', '23-APR-2022', '05:30:32');

InValid
INSERT INTO Payment VALUES ('PY0407', 'Cash', '23-APR-2023', '05:30:32');
*/