/*
Purpose: The purpose of this report is to search the toy price maximum amount. If user select 10,000 , the system will display all the toy details below the target amount.
*/
SET SERVEROUTPUT ON
SET linesize 200
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_order_by_minSPrice (v_sellingPrice IN NUMBER) IS 
v_orderID Orders.OrderID%TYPE;
v_deliveryID Delivery.DeliveryID%TYPE;
v_toyID Toy.ToyID%TYPE;
v_toyName Toy.ToyName%TYPE;
v_quantity OrderDetails.Quantity%TYPE;
v_toyPrice Toy.ToyPrice%TYPE;
v_subtotal OrderDetails.Subtotal%TYPE;
v_sst Toy.SST%TYPE;
v_totalAmount NUMBER(15,2);

CURSOR minSellingPriceCursor IS
  SELECT O.OrderID, D.DeliveryID, T.ToyID, T.ToyName, OD.Quantity, T.ToyPrice, OD.Subtotal, T.SST
  FROM Orders O, Delivery D, Toy T, OrderDetails OD
  WHERE T.ToyID = OD.ToyID AND OD.OrderID = O.OrderID AND D.DeliveryID = O.DeliveryID AND O.Total <= v_sellingPrice;

BEGIN
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 119, '='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Deliveries by Minimum of the Selling Price : ' || v_sellingPrice);
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 136, '='));
  DBMS_OUTPUT.PUT_LINE(RPAD('Order ID', 10, ' ') || ' ' ||
                       RPAD('Delivery ID', 11, ' ') || ' ' ||
                       RPAD('Toy ID', 8, ' ') || ' ' ||
                       RPAD('Toy Name', 45, ' ') || ' ' ||
                       RPAD('Quantity', 10, ' ') || ' ' ||
                       RPAD('Toy Price (RM)', 17, ' ') || ' ' ||
                       RPAD('Subtotal (RM)', 17, ' ') || ' ' ||
                       RPAD('SST (6% RM)', 17, ' '));
  DBMS_OUTPUT.PUT_LINE(LPAD('=', 136, '='));

v_totalAmount := 0;
OPEN minSellingPriceCursor;
LOOP
FETCH minSellingPriceCursor INTO v_orderID, v_deliveryID, v_toyID, v_toyName, v_quantity, v_toyPrice, v_subtotal, v_sst;
IF (minSellingPriceCursor%ROWCOUNT = 0) THEN
 DBMS_OUTPUT.PUT_LINE('No such Total Amount found or no Order in charge');
END IF;
EXIT WHEN minSellingPriceCursor%NOTFOUND;
v_totalAmount := v_totalAmount + v_subtotal;

  DBMS_OUTPUT.PUT_LINE(RPAD(v_orderID, 10, ' ') || ' ' ||
                       RPAD(v_deliveryID, 11, ' ') || ' ' ||
                       RPAD(v_toyID, 8, ' ') || ' ' ||
                       RPAD(v_toyName, 45, ' ') || ' ' ||
                       RPAD(v_quantity, 10, ' ') || ' ' ||
                       RPAD('RM' || TO_CHAR(v_toyPrice, '9,999,999.99'), 17, ' ') || ' ' ||
                       RPAD('RM' || TO_CHAR(v_subtotal, '9,999,999.99'), 17, ' ') || ' ' ||
                       RPAD('RM' || TO_CHAR(v_sst, '999.99'), 17, ' '));
END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 136, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of Total Amount: ' || minSellingPriceCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total Amount: ' || 'RM' || TO_CHAR(v_totalAmount, '999,999,999.99'));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 63, '=') || RPAD('End of File', 73, '='));

CLOSE minSellingPriceCursor;
END;
/

EXEC prc_show_order_by_minSPrice ('1000.00')