SET linesize 120
SET pagesize 100

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

ACCEPT v_supplier CHAR FORMAT 'A6' PROMPT 'Enter Supplier ID (S0001 ~ S0100): '

COLUMN SupplierID	      FORMAT A12			HEADING 'Supplier ID'
COLUMN SupplierName 	FORMAT A55			HEADING 'Supplier Name'
COLUMN PurchaseDate	FORMAT A15		      HEADING 'Purchase Date'
COLUMN StockPurchaseID	FORMAT A20			HEADING 'Stock Purchase ID'
COLUMN NoOfToys	      FORMAT 99999		HEADING 'Quantity'

TTITLE CENTER 'Stock Purchase List for ' v_supplier -
RIGHT 'Page: ' FORMAT 999 SQL.PNO SKIP 2

BREAK ON SupplierID SKIP 2
COMPUTE SUM LABEL 'Total: ' OF NoOfToys ON SupplierID

SELECT * FROM StockPurchaseBySupplier
WHERE SupplierID = '&v_supplier'
ORDER BY PurchaseDate DESC;

TTITLE OFF
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES