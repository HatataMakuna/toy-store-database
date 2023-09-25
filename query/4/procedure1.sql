/*
Purpose: The purpose of this procedure is to let the customer select the payment method to pay it. The system will auto-generate the PaymentID by the sequence, once the payment is successful. Users might need to manually key in the payment method (Debit Card, Credit Card, Cash, and E-wallet). If the user key in the correct payment method, the system will auto-generate the current date and time. The user might follow the example I show before, if not the procedure contains validation for all field, which include checking whether the input is empty or not, invalid discount range, etc. When any of the inputs are invalid, the procedure will raise an error message. Multiple error messages can be displayed when the validation encountered more than one error. Once the user did the payment successfully, the system will auto-generate the receipt to the user.

Procedure Statement:
*/

SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_create_payment (v_paymentMethod IN VARCHAR) IS
  EMPTY_DATA EXCEPTION;
  INVALID_METHOD EXCEPTION;
  ID_NOTFOUND EXCEPTION;
  order_isfound NUMBER;

  v_OrderID Orders.OrderID%TYPE;
  v_ToyID Toy.ToyID%TYPE;
  v_ToyName Toy.ToyName%TYPE;
  v_Quantity OrderDetails.Quantity%TYPE;
  v_ActualPrice OrderDetails.ActualPrice%TYPE;
  v_Subtotal OrderDetails.Subtotal%TYPE;
  v_OrderDate Orders.OrderDate%TYPE; 
  v_paymentID Payment.PaymentID%TYPE;
  
  CURSOR orderCursor IS
  SELECT O.OrderID, T.ToyID, T.ToyName, OD.Quantity, OD.ActualPrice, OD.Subtotal, O.OrderDate
  FROM Orders O, Toy T, OrderDetails OD
  WHERE T.ToyID = OD.ToyID AND OD.OrderID = O.OrderID AND O.OrderID = 'OR' || TO_CHAR(DBMS_RANDOM.VALUE(1, 300), 'FM0000');
  orderRec orderCursor%ROWTYPE;

BEGIN
--payment method
IF (v_paymentMethod IS NOT NULL) THEN
 IF (v_paymentMethod = 'Cash' OR v_paymentMethod = 'Debit Card' OR v_paymentMethod = 'Credit Card' OR v_paymentMethod = 'E-wallet') THEN
  DBMS_OUTPUT.PUT_LINE('Payment Method: OK');
 ELSE
  RAISE INVALID_METHOD;
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;


OPEN orderCursor;
FETCH orderCursor INTO orderRec;
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));
  DBMS_OUTPUT.PUT_LINE('Order Details');
  DBMS_OUTPUT.PUT_LINE('Order ID : ' || 'OR' || TO_CHAR(DBMS_RANDOM.VALUE(1, 300), 'FM0000'));
  DBMS_OUTPUT.PUT_LINE('Toy ID : ' || orderRec.ToyID);
  DBMS_OUTPUT.PUT_LINE('Toy Name : ' || orderRec.ToyName);
  DBMS_OUTPUT.PUT_LINE('Quantity : ' || orderRec.Quantity);
  DBMS_OUTPUT.PUT_LINE('Actual Price : ' || orderRec.ActualPrice);
  DBMS_OUTPUT.PUT_LINE('Subtotal : ' || orderRec.Subtotal);
  DBMS_OUTPUT.PUT_LINE('The last Order Date is on ' || TO_CHAR(orderRec.OrderDate,'DD/MON/YYYY') || '.');

  v_paymentID := 'PY' || TO_CHAR(payment_seq.nextval, 'FM0000');

  INSERT INTO Payment VALUES (v_paymentID, v_PaymentMethod, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'));
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'=')); 
  DBMS_OUTPUT.PUT_LINE('Record Updated.');
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));
  DBMS_OUTPUT.PUT_LINE('Latest Record Payment Details ');
  DBMS_OUTPUT.PUT_LINE('Payment ID : ' || v_paymentID);
  DBMS_OUTPUT.PUT_LINE('Payment Method : ' || v_PaymentMethod);
  DBMS_OUTPUT.PUT_LINE('Payment Date : ' || SYSDATE);
  DBMS_OUTPUT.PUT_LINE('Payment Time : ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
  DBMS_OUTPUT.PUT_LINE(LPAD('=',75,'='));

CLOSE orderCursor;
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
PROMPT 'Add Payment / Make Payment'
PROMPT
PROMPT
ACCEPT v_paymentMethod CHAR FORMAT 'A10' PROMPT 'Enter the Payment Method: '

EXEC prc_create_payment ('&v_paymentMethod');