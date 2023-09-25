/*
Purpose: The purpose of this query is to view the payment history by the date that selected by the user. The system will auto-filter if the same date makes a payment will display together and calculate the total that day.

SQL statement:
*/

SET linesize 120
SET pagesize 120
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

cl scr
PROMPT 'Purchase History'
PROMPT
PROMPT

ACCEPT v_start_order_date            char   FORMAT 'A14'         PROMPT 'Enter Start Order Date       :      '
ACCEPT v_end_order_date            char   FORMAT 'A14'         PROMPT 'Enter End Order Date       :      '

COLUMN OrderID FORMAT A8 HEADING "ORDER ID";
COLUMN OrderDate FORMAT A11 HEADING "ORDER DATE";
COLUMN PaymentID FORMAT A10 HEADING "PAYMENT ID";
COLUMN ToyID FORMAT A6 HEADING "TOY ID";
COLUMN ToyName FORMAT A18 HEADING "TOY NAME";
COLUMN Quantity FORMAT 99 HEADING "QUANTITY";
COLUMN Total FORMAT $99,999.99 HEADING "TOTAL (RM)";
COLUMN PaymentMethod FORMAT A14 HEADING "PAYMENT METHOD";
COLUMN PaymentDate FORMAT A12 HEADING "PAYMENT DATE";
COLUMN PaymentTime FORMAT A12 HEADING "PAYMENT TIME";

TTITLE CENTER 'Purchase History for ' _DATE -
RIGHT 'Page NO: ' FORMAT 999 SQL.PNO SKIP 2
COMPUTE SUM OF TOTAL ON OrderDate 
BREAK ON OrderDate SKIP 2 ON ToyName

SELECT OrderID, OrderDate, PaymentID, ToyID, ToyName, Quantity, Total, PaymentMethod, PaymentDate, PaymentTime
FROM QueryOneOrder
WHERE OrderDate BETWEEN  '&v_start_order_date' AND '&v_end_order_date'
ORDER BY OrderDate;

CLEAR COLUMNS
CLEAR BREAKS 
TTITLE OFF