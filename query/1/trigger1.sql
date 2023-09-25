SET linesize 120
SET pagesize 100
CREATE OR REPLACE TRIGGER trg_NewCustomer
BEFORE INSERT ON Customer
FOR EACH ROW
DECLARE
v_CustomerCount NUMBER;
v_CustomerID Customer.CustomerID%TYPE;
BEGIN
SELECT COUNT(*) INTO v_CustomerCount
FROM Customer
WHERE CustomerID = :NEW.CustomerID;
IF (v_CustomerCount > 0) THEN
    RAISE_APPLICATION_ERROR(-20000, 'The Customer ID ' || :NEW.CustomerID || ' Already Exist');   
END IF;
END;
/