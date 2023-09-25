SET SERVEROUTPUT ON
SET linesize 200
SET pagesize 150
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_last_toy_purchase (v_toyID IN VARCHAR) IS 
v_purchaseDate DATE;
v_duration NUMBER(4);
v_months NUMBER(4, 1);

--Declare custom exception;
    EMPTY_DATA EXCEPTION;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Today is: ' || SYSDATE);

    --Validate inputs
    DBMS_OUTPUT.PUT_LINE('Please wait a moment while we validate your input ... ');
	
    -- toy id
    IF (v_toyID IS NOT NULL) THEN
        SELECT MAX(PurchaseDate) INTO v_purchaseDate
        FROM StockPurchase
        WHERE ToyID = v_toyID;
         DBMS_OUTPUT.PUT_LINE('Toy ID: OK');
    ELSE
        RAISE EMPTY_DATA;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Toy: ' || v_toyID || ' last purchase on ' || v_purchaseDate);

    v_duration := ROUND(SYSDATE - v_purchaseDate, 0);

    IF (v_duration < 30) THEN
    DBMS_OUTPUT.PUT_LINE('That was ' || v_duration || ' days ago.');
    ELSE
    v_months := MONTHS_BETWEEN (SYSDATE, v_purchaseDate);
    DBMS_OUTPUT.PUT_LINE('That was ' || v_months || ' months ago.');
    END IF;

	EXCEPTION
    WHEN EMPTY_DATA THEN
     DBMS_OUTPUT.PUT_LINE('There are certain blanks in some of your responses!');
    
END;
/

--Prompt inputs
cl scr
PROMPT 'Check Last Date Of Toy Purchase'
PROMPT

ACCEPT v_toyID CHAR FORMAT 'A10' PROMPT 'Enter Toy ID: '

EXEC prc_last_toy_purchase('&v_toyID');