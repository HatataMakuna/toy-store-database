SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_show_tyCat_by_toy (v_toyCategory IN VARCHAR) IS
v_toyID Toy.ToyID%TYPE;
v_toyName Toy.ToyName%TYPE;
v_qtyInStock Toy.QuantityInStock%TYPE;
v_toyPrice Toy.ToyPrice%TYPE;
v_totalqtyInStock NUMBER;
v_totalAmount NUMBER(7,2);

CURSOR toyCursor IS
 SELECT ToyID, ToyName, QuantityInStock, ToyPrice
 FROM Toy
 WHERE ToyCategory = v_toyCategory;

BEGIN
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE('Toy Name that under the toy category: ' || v_toyCategory);
 DBMS_OUTPUT.PUT_LINE(CHR(6));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(RPAD('Toy ID', 15, ' ') || ' ' ||
                      RPAD('Toy Name', 25, ' ') || ' ' ||
				      RPAD('QuantityInStock (unit)', 29, ' ') || ' ' ||
                      RPAD('Toy Price (RM)', 17, ' '));

 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));

v_totalqtyInStock := 0;
v_totalAmount := 0;
OPEN toyCursor;
LOOP
FETCH toyCursor INTO v_toyID, v_toyName, v_qtyInStock, v_toyPrice;
IF (toyCursor%ROWCOUNT = 0) THEN
 DBMS_OUTPUT.PUT_LINE('No such toy category found!');
END IF;
EXIT WHEN toyCursor%NOTFOUND;

v_totalqtyInStock := v_totalqtyInStock + v_qtyInStock;
v_totalAmount := v_totalAmount + v_toyPrice;

 DBMS_OUTPUT.PUT_LINE(RPAD(v_toyID, 15, ' ') || ' ' ||
                      RPAD(v_toyName, 35, ' ') || ' ' ||
                      RPAD(v_qtyInStock, 20, ' ') || ' ' ||
                      RPAD('RM' || TO_CHAR(v_toyPrice, '99,999.99'), 17, ' '));

END LOOP;
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of Toy In Hand : ' || toyCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE('Total number of Quantity Stock In Hand : ' || v_totalqtyInStock || ' units');
 DBMS_OUTPUT.PUT_LINE('Total Amount Used under the toy category : ' || 'RM' || TO_CHAR(v_totalAmount, '999,999.99'));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 44, '=') || RPAD('End of File', 56, '='));

CLOSE toyCursor;
END;
/

cl scr
EXEC prc_show_tyCat_by_toy ('Robot')