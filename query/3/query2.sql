SET linesize 120
SET pagesize 100

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

SELECT DISTINCT toyCategory
FROM toy
ORDER BY toyCategory;

ACCEPT v_toyCategory CHAR FORMAT 'A15' PROMPT 'Enter toy category: '

COLUMN SupplierID	      FORMAT A12			HEADING 'Supplier ID'
COLUMN SupplierName 	FORMAT A35			HEADING 'Supplier Name'
COLUMN ToyID	      FORMAT A10			HEADING 'Toy ID'
COLUMN ToyName 	      FORMAT A35			HEADING 'Toy Name'
COLUMN QuantityInStock	FORMAT 99999		HEADING 'Quantity In Stock'

TTITLE CENTER 'Quantity In Stock List for ' v_toyCategory -
RIGHT 'Page: ' FORMAT 999 SQL.PNO SKIP 2

BREAK ON ToyName SKIP 2
COMPUTE SUM LABEL 'Total: ' OF QuantityInStock ON ToyName

SELECT DISTINCT S.SupplierID, S.SupplierName, T.ToyID, T.ToyName, T.QuantityInStock
FROM Supplier S, Toy T, StockPurchase SP
WHERE S.SupplierID = SP.SupplierID AND T.ToyID = SP.ToyID AND ToyCategory = '&v_toyCategory'
ORDER BY QuantityInStock;

TTITLE OFF
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES