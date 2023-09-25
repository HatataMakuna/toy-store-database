SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_create_customer (v_customerID IN VARCHAR, v_customerName IN VARCHAR, v_customerAdd IN VARCHAR, v_customerEmail IN VARCHAR , v_customerPhone IN VARCHAR) IS

--Declare custom exceptions
EMPTY_DATA EXCEPTION;

BEGIN
--Validate inputs
DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('Please wait while we are validating your input...');
DBMS_OUTPUT.PUT_LINE('');
--Customer ID
IF (v_customerID IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Customer ID: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

--Customer name
IF (v_customerName IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Customer Name: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

--Customer address
IF (v_customerAdd IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Customer Address: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

--Customer email
IF (v_customerEmail IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Customer Email: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

--Customer phone
IF (v_customerPhone IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Customer Phone: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

IF (SQLCODE = 0) THEN
 INSERT INTO Customer VALUES('C' || TO_CHAR(customer_seq.nextval, 'FM0000'), v_customerName ,v_customerAdd, v_customerEmail, v_customerPhone);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('Record added successfully');
ELSE
 DBMS_OUTPUT.PUT_LINE('There is a problem with the database. Please try again later.');
END IF;

EXCEPTION
WHEN EMPTY_DATA THEN
 DBMS_OUTPUT.PUT_LINE('Some of your input is missing.');
END;
/

--Prompt inputs
cl scr
PROMPT 'Create Customer'
PROMPT
PROMPT

ACCEPT v_customerID CHAR FORMAT 'A10' PROMPT 'Enter Customer ID: '
ACCEPT v_customerName CHAR FORMAT 'A50' PROMPT 'Enter Customer Name: '
ACCEPT v_customerAdd CHAR FORMAT 'A100' PROMPT 'Enter Customer Address: '
ACCEPT v_customerEmail CHAR FORMAT 'A50' PROMPT 'Enter Customer Email: '
ACCEPT v_customerPhone CHAR FORMAT 'A50' PROMPT 'Enter Customer Phone: '


EXEC prc_create_customer ('&v_customerID', '&v_customerName', '&v_customerAdd','&v_customerEmail','&v_customerPhone');