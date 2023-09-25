SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_stkPurch_by_supplier (v_supplierID IN VARCHAR) IS
v_stockPurchaseID StockPurchase.StockPurchaseID%TYPE;
v_noOfToys StockPurchase.NoOfToys%TYPE;
v_purchaseDate StockPurchase.PurchaseDate%TYPE;
v_totalPurchToys NUMBER;

CURSOR stockPurchaseCursor IS
 SELECT StockPurchaseID, NoOfToys, PurchaseDate
 FROM StockPurchase
 WHERE SupplierID = v_supplierID;

BEGIN
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE('Stock Purchased by Supplier ID: ' || v_supplierID);
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(RPAD('StockPurchase ID', 20, ' ') || ' ' ||
                      RPAD('Purchase Date', 20, ' ') || ' ' ||
                      RPAD('Number Of Toys', 20, ' '));

 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));

v_totalPurchToys := 0;
OPEN stockPurchaseCursor;
LOOP
FETCH stockPurchaseCursor INTO v_stockPurchaseID, v_noOfToys, v_purchaseDate;
IF (stockPurchaseCursor%ROWCOUNT = 0) THEN
 DBMS_OUTPUT.PUT_LINE('No such supplier found or no such stock purchased!');
END IF;
EXIT WHEN stockPurchaseCursor%NOTFOUND;

v_totalPurchToys := v_totalPurchToys + v_noOfToys;

 DBMS_OUTPUT.PUT_LINE(RPAD(v_stockPurchaseID, 20, ' ') || ' ' ||
                      RPAD(v_purchaseDate, 20, ' ') || ' ' ||
                      RPAD(TO_CHAR(v_noOfToys, '999,999') || ' unit', 13, ' '));

END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of Stock Purchase : ' || stockPurchaseCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total unit of Stock Purchase : ' || v_totalPurchToys || ' units');
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 44, '=') || RPAD('End of File', 56, '='));

CLOSE stockPurchaseCursor;
END;
/

cl scr
EXEC prc_show_stkPurch_by_supplier ('S0088')