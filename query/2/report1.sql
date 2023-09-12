SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_delivery_by_employee (v_employeeID IN VARCHAR) IS
v_deliveryID Delivery.DeliveryID%TYPE;
v_deliveryDate Delivery.DeliveryDate%TYPE;
v_deliveryAddress Delivery.DeliveryAddress%TYPE;
v_deliveryCharges Delivery.DeliveryCharges%TYPE;
v_totalCharges NUMBER(7,2);

CURSOR deliveryCursor IS
 SELECT DeliveryID, DeliveryDate, DeliveryAddress, DeliveryCharges
 FROM Delivery
 WHERE EmployeeID = v_employeeID;

BEGIN
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('Deliveries by employee ID: ' || v_employeeID);
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(RPAD('Delivery ID', 15, ' ') || ' ' ||
                      RPAD('Delivery Date', 13, ' ') || ' ' ||
                      RPAD('Delivery Address', 20, ' ') || ' ' ||
                      RPAD('Delivery Charges', 17, ' '));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));

v_totalCharges := 0;
OPEN deliveryCursor;
LOOP
FETCH deliveryCursor INTO v_deliveryID, v_deliveryDate, v_deliveryAddress, v_deliveryCharges;
IF (deliveryCursor%ROWCOUNT = 0) THEN
 RAISE_APPLICATION_ERROR(-20000, 'No such employee found or no deliveries in charge by the employee');
END IF;
EXIT WHEN deliveryCursor%NOTFOUND;

v_totalCharges := v_totalCharges + v_deliveryCharges;

 DBMS_OUTPUT.PUT_LINE(RPAD(v_deliveryID, 15, ' ') || ' ' ||
                      RPAD(v_deliveryDate, 13, ' ') || ' ' ||
                      RPAD(v_deliveryAddress, 20, ' ') || ' ' ||
                      RPAD('RM' || TO_CHAR(v_totalCharges, '99,999.99'), 17, ' '));

END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of delivery: ' || deliveryCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total delivery charges: ' || 'RM' || TO_CHAR(v_totalCharges, '999,999.99'));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 44, '=') || RPAD('End of File', 56, '='));

CLOSE deliveryCursor;
END;
/

cl scr
ACCEPT v_employee CHAR FORMAT 'A6' PROMPT 'Enter employee ID (E0001 ~ E0100): '
EXEC prc_show_delivery_by_employee ('&v_employee')