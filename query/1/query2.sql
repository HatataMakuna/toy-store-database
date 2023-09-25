SET linesize 100
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

--ACCEPT Letter char FORMAT 'A5' PROMPT 'Enter The Customer ID:'

COLUMN CustomerID FORMAT A20 HEADING "Customer ID";
COLUMN OrderID FORMAT A15 HEADING "Order ID";
COLUMN OrderDate FORMAT A10 HEADING "Order Date";
COLUMN PaymentID FORMAT A20 HEADING "Payment ID";
COLUMN DeliveryID FORMAT A10 HEADING "Delivery ID";
COLUMN Total FORMAT $999999999999.99 HEADING "TOTAL PRICE";

TTITLE LEFT 'Customer Order     ' _DATE -
RIGHT 'Page No: ' FORMAT 999 SQL.PNO SKIP 2
BREAK ON CustomerID SKIP 2 ON OrderID
COMPUTE SUM LABEL 'Total Price:' OF Total ON CustomerID

SELECT o.CustomerID, o.OrderID, o.OrderDate, o.PaymentID, o.DeliveryID, o.Total
FROM Orders o ,Customer c
WHERE o.CustomerID = c.CustomerID AND o.CustomerID = '&customer' 
ORDER BY orderID;

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF