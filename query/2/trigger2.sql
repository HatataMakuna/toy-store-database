CREATE OR REPLACE TRIGGER trg_delete_employee_chk
BEFORE DELETE ON Employee
FOR EACH ROW

DECLARE
 v_nodeliveries Delivery.EmployeeID%TYPE;
 v_noorders Orders.EmployeeID%TYPE;

BEGIN
SELECT COUNT(*) INTO v_nodeliveries
FROM Delivery
WHERE EmployeeID = :OLD.EmployeeID;

SELECT COUNT(*) INTO v_noorders
FROM Orders
WHERE EmployeeID = :OLD.EmployeeID;

IF (v_nodeliveries > 0 OR v_noorders > 0) THEN
 RAISE_APPLICATION_ERROR(-20003, 'Cannot delete employee with delivery or order in charge');
END IF;
END;
/

DELETE FROM Employee WHERE EmployeeID = 'E0099';