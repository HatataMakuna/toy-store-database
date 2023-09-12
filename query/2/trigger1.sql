CREATE OR REPLACE TRIGGER trg_chkorder_before_promotion
BEFORE INSERT OR UPDATE ON Promotion
FOR EACH ROW

DECLARE
 v_noorders NUMBER;

BEGIN
SELECT COUNT(*) INTO v_noorders
FROM Orders
WHERE OrderDate BETWEEN :NEW.PromotionStartDate AND :NEW.PromotionEndDate;

IF (v_noorders > 0) THEN
 RAISE_APPLICATION_ERROR(-20001, 'Cannot create promotion when some orders have dates between start and end date.');
END IF;
END;
/