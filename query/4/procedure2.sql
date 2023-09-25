/*
Purpose: The purpose of this procedure is to let the user or admin cancel/delete the Order. Users can input Order ID to let the system check whether validation for all fields, which includes checking whether the input is empty or not, invalid discount range, etc. When any of the inputs are invalid, the procedure will raise an error message. Multiple error messages can be displayed when the validation encountered more than one error. Once the user keyed in the correct Order Id, the user might see the delete Order details before deleting. The system will auto-proceed to delete the current Order.

Procedure Statement:
*/

SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_delete_orderDetails (v_orderID IN VARCHAR) IS
  EMPTY_DATA EXCEPTION;
  INVALID_METHOD EXCEPTION;
  ID_NOTFOUND EXCEPTION;
  order_isfound NUMBER;

  
  v_ToyID Toy.ToyID%TYPE;
  v_ToyName Toy.ToyName%TYPE;
  v_Quantity OrderDetails.Quantity%TYPE;
  v_ActualPrice OrderDetails.ActualPrice%TYPE;
  v_Subtotal OrderDetails.Subtotal%TYPE;
  v_OrderDate Orders.OrderDate%TYPE; 

   CURSOR deleteOrderCursor IS
  SELECT O.OrderID, T.ToyID, T.ToyName, OD.Quantity, OD.ActualPrice, OD.Subtotal, O.OrderDate
  FROM Orders O, Toy T, OrderDetails OD
  WHERE T.ToyID = OD.ToyID AND OD.OrderID = O.OrderID AND O.OrderID = v_orderID;

  deleteOrderRec deleteOrderCursor%ROWTYPE;

BEGIN

--Order Details method
IF (v_orderID IS NOT NULL) THEN
 SELECT COUNT(*) INTO order_isfound FROM OrderDetails 
 WHERE OrderID = v_orderID;

  IF (order_isfound = 0) THEN
  RAISE ID_NOTFOUND;
 ELSE
  DBMS_OUTPUT.PUT_LINE('Order ID: OK');
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

OPEN deleteOrderCursor;
FETCH deleteOrderCursor INTO deleteOrderRec;
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'=')); 
  DBMS_OUTPUT.PUT_LINE('Order Details');
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));
  DBMS_OUTPUT.PUT_LINE('Order ID : ' || deleteOrderRec.OrderID);
  DBMS_OUTPUT.PUT_LINE('Toy ID : ' || deleteOrderRec.ToyID);
  DBMS_OUTPUT.PUT_LINE('Toy Name : ' || deleteOrderRec.ToyName);
  DBMS_OUTPUT.PUT_LINE('Quantity : ' || deleteOrderRec.Quantity);
  DBMS_OUTPUT.PUT_LINE('Actual Price : ' || deleteOrderRec.ActualPrice);
  DBMS_OUTPUT.PUT_LINE('Subtotal : ' || deleteOrderRec.Subtotal);
  DBMS_OUTPUT.PUT_LINE('The last Order Date is on ' || TO_CHAR(deleteOrderRec.OrderDate,'DD/MON/YYYY') || '.');
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));

  
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));
  DBMS_OUTPUT.PUT_LINE('Deleting......'); 
  DBMS_OUTPUT.PUT_LINE('Record Deleted.');
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));
  DELETE FROM OrderDetails WHERE OrderID = v_OrderID;

CLOSE deleteOrderCursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Unable to add new Record');
    DBMS_OUTPUT.PUT_LINE('Order not found');
  WHEN EMPTY_DATA THEN
    DBMS_OUTPUT.PUT_LINE('Some of your input is missing.');
 WHEN INVALID_METHOD THEN
    DBMS_OUTPUT.PUT_LINE('Your Payment Method is invalid. It must be Cash OR Debit Card OR Credit Card OR E-wallet');
  WHEN ID_NOTFOUND THEN
 DBMS_OUTPUT.PUT_LINE('The Order ID is not found.');
END;
/

cl scr
PROMPT 'Delete the Order Details'
PROMPT
PROMPT
ACCEPT v_orderID CHAR FORMAT 'A10' PROMPT 'Enter the Order ID (OR0001 - OR0300): '

EXEC prc_delete_orderDetails ('&v_orderID');