SET linesize 180
SET pagesize 120
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

cl scr
PROMPT 'Check the Quantity of Toy Category'
PROMPT
PROMPT

ACCEPT v_min_category_toy            char   FORMAT 'A15'         PROMPT 'Enter The Category of Toy Wanna To Check      :      '

COLUMN ToyID FORMAT A6 HEADING "TOY ID";
COLUMN ToyName FORMAT A22 HEADING "TOY NAME";
COLUMN ToyCategory FORMAT A12 HEADING "Category";
COLUMN QuantityInStock FORMAT 99 HEADING "QUANTITY IN STOCK";
COLUMN SellingPrice FORMAT $99,999.99 HEADING "SELLING PRICE (RM)";
COLUMN SupplierID FORMAT A14 HEADING "SUPPLIER ID";
COLUMN SupplierName FORMAT A23 HEADING "SUPPLIER NAME";
COLUMN SupplierEmail FORMAT A32 HEADING "SUPPLIER EMAIL";
COLUMN SupplierPhone FORMAT A15 HEADING "SUPPLIER PHONE";

TTITLE CENTER 'Toys That Are Running Out Of Stock For Category ' _DATE -
RIGHT 'Page NO: ' FORMAT 999 SQL.PNO SKIP 2
COMPUTE SUM OF TOTAL ON ToyID
BREAK ON ToyID SKIP 2 ON ToyCategory

SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0001' AND 'T0010' AND QuantityInStock <= 60 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
UNION
SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0011' AND 'T0030' AND QuantityInStock <= 50 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
UNION
SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0021' AND 'T0040' AND QuantityInStock <= 55 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
UNION
SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0041' AND 'T0060' AND QuantityInStock <= 70 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
UNION
SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0061' AND 'T0080' AND QuantityInStock <= 50 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
UNION
SELECT DISTINCT ToyID, ToyName, ToyCategory, QuantityInStock, SellingPrice, SupplierID, SupplierName, SupplierEmail, SupplierPhone
FROM QueryTwoQuantity
WHERE ToyID BETWEEN 'T0081' AND 'T0100' AND QuantityInStock <= 75 AND UPPER(ToyCategory) = UPPER('&v_min_category_toy')
ORDER BY ToyCategory;

CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF