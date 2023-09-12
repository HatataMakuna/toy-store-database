SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_promotion_by_orders IS

CURSOR promotionCursor IS
 SELECT P.PromotionID, P.PromotionName, O.OrderID, O.OrderDate
 FROM Promotion P, Orders O
 WHERE O.OrderDate >= P.PromotionStartDate AND O.OrderDate <= P.PromotionEndDate AND P.PromotionID = O.PromotionID
 ORDER BY PromotionID;

promotionRec promotionCursor%ROWTYPE;

BEGIN
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('List of orders that involved with Promotion');
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE(RPAD('Promotion ID', 15, ' ') || ' ' ||
                      RPAD('Promotion Name', 50, ' ') || ' ' ||
                      RPAD('Order ID', 15, ' ') || ' ' ||
                      RPAD('Order Date', 10, ' '));
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));

 OPEN promotionCursor;
 LOOP
 FETCH promotionCursor INTO promotionRec;
 IF (promotionCursor%ROWCOUNT = 0) THEN
  RAISE_APPLICATION_ERROR(-20000, 'No orders found');
 END IF;
 EXIT WHEN promotionCursor%NOTFOUND;

 DBMS_OUTPUT.PUT_LINE(RPAD(promotionRec.PromotionID, 15, ' ') || ' ' ||
                      RPAD(promotionRec.PromotionName, 50, ' ') || ' ' ||
                      RPAD(promotionRec.OrderID, 15, ' ') || ' ' ||
                      RPAD(promotionRec.OrderDate, 10, ' '));
 END LOOP;

 DBMS_OUTPUT.PUT_LINE(LPAD('=', 100, '='));
 DBMS_OUTPUT.PUT_LINE('Total number of orders involved with promotion: ' || promotionCursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE(LPAD('=', 44, '=') || RPAD('End of File', 56, '='));

CLOSE promotionCursor;
END;
/

cl scr
EXEC prc_promotion_by_orders