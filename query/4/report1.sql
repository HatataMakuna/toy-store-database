/*
Purpose: The purpose of this report is to showing History of payment & order details. It might allow user key-in the order date and the system will auto calculate the total amount in the target order data what you choose.
*/

SET SERVEROUTPUT ON
SET linesize 200
SET pagesize 200
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_order_by_oID (v_startOrderID IN VARCHAR, v_endOrderID IN VARCHAR) IS

v_toyID Toy.ToyID%TYPE;
v_toyName Toy.ToyName%TYPE;
v_quantity OrderDetails.Quantity%TYPE;
v_total Orders.Total%TYPE;
v_orderDate Orders.OrderDate%TYPE;
v_paymentMethod Payment.PaymentMethod%TYPE;
v_paymentDate Payment.PaymentDate%TYPE;
v_paymentTime Payment.PaymentTime%TYPE;
v_totalAmount NUMBER(15,2);

CURSOR orderIDCursor IS
  SELECT O.OrderID, T.ToyID, T.ToyName, OD.Quantity, O.Total, O.OrderDate, P.PaymentMethod, P.PaymentDate, P.PaymentTime
  FROM Payment P, Orders O, Toy T, OrderDetails OD
  WHERE T.ToyID = OD.ToyID AND OD.OrderID = O.OrderID AND P.PaymentID = O.PaymentID AND O.OrderID BETWEEN v_startOrderID AND v_endOrderID;

orderIDCursorRec orderIDCursor%ROWTYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 150, '='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Deliveries by Start Order ID : ' || v_startOrderID);
  DBMS_OUTPUT.PUT_LINE('Deliveries by End Order ID : ' || v_endOrderID);
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Date Generated: ' || SYSDATE);
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 140, '='));
  DBMS_OUTPUT.PUT_LINE(RPAD('Toy ID', 8, ' ') || ' ' ||
                       RPAD('Toy Name', 45, ' ') || ' ' ||
                       RPAD('Quantity', 10, ' ') || ' ' ||
                       RPAD('Total', 17, ' ') || ' ' ||
                       RPAD('Order Date', 12, ' ') || ' ' ||
                       RPAD('Payment Method', 16, ' ') || ' ' ||
                       RPAD('Payment Date', 12, ' ') || ' ' ||
                       RPAD('Payment Time', 12, ' '));
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 140, '='));

v_totalAmount := 0;
OPEN orderIDCursor;
LOOP
FETCH orderIDCursor INTO orderIDCursorRec;
IF (orderIDCursor%ROWCOUNT = 0) THEN
 DBMS_OUTPUT.PUT_LINE('No such Order ID found or no Order in charge');
END IF;
EXIT WHEN orderIDCursor%NOTFOUND;

v_totalAmount := v_totalAmount + orderIDCursorRec.total;

  DBMS_OUTPUT.PUT_LINE(RPAD(orderIDCursorRec.ToyID, 8, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.toyName, 45, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.quantity, 10, ' ') || ' ' ||
                       RPAD('RM' || TO_CHAR(orderIDCursorRec.total, '9,999,999.99'), 17, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.orderDate, 12, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.paymentMethod, 16, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.paymentDate, 12, ' ') || ' ' ||
                       RPAD(orderIDCursorRec.paymentTime, 12, ' '));

END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 139, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of Order: ' || orderIDCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total Amount: ' || 'RM' || TO_CHAR(v_totalAmount, '999,999,999.99'));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 65, '=') || RPAD('End of File', 74, '='));

CLOSE orderIDCursor;
END;
/

EXEC prc_show_order_by_oID ('OR0202','OR0222')