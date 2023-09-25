SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_order_by_employee (v_employeeID IN VARCHAR) IS
v_orderId Orders.OrderID%TYPE;
v_orderDate Orders.OrderDate%TYPE;
v_total Orders.Total%TYPE;
v_totalCharges NUMBER(7,2);

CURSOR orderCursor IS
 SELECT OrderID, OrderDate, Total
 FROM Orders
 WHERE EmployeeID = v_employeeID;

BEGIN
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE('Order Solded by employee ID: ' || v_employeeID);
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(RPAD('Order ID', 15, ' ') || ' ' ||
                      RPAD('Order Date', 13, ' ') || ' ' ||
				RPAD('Total (RM)', 20, ' ') || ' ' ||
                      RPAD('Amount', 17, ' '));

 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));

v_totalCharges := 0;
OPEN orderCursor;
LOOP
FETCH orderCursor INTO v_orderID, v_orderDate, v_total;
IF (orderCursor%ROWCOUNT = 0) THEN
 DBMS_OUTPUT.PUT_LINE('No such employee found');
END IF;
EXIT WHEN orderCursor%NOTFOUND;

v_totalCharges := v_totalCharges + v_Total;

 DBMS_OUTPUT.PUT_LINE(RPAD(v_orderID, 15, ' ') || ' ' ||
                      RPAD(v_orderDate, 13, ' ') || ' ' ||
                      RPAD(v_total, 20, ' ') || ' ' ||
                      RPAD('RM' || TO_CHAR(v_totalCharges, '99,999.99'), 17, ' '));

END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of Sales Order : ' || orderCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total Amount Earn : ' || 'RM' || TO_CHAR(v_totalCharges, '999,999.99'));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 44, '=') || RPAD('End of File', 56, '='));

CLOSE orderCursor;
END;
/

cl scr
EXEC prc_show_order_by_employee ('E0010')