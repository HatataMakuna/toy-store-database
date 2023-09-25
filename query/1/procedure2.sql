SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_create_member (v_memberID IN VARCHAR, v_memberBirthDate IN VARCHAR, v_memberExpiryDate IN VARCHAR, v_customerID IN VARCHAR) IS

--Declare custom exceptions
ID_NOTFOUND EXCEPTION;
EMPTY_DATA EXCEPTION;
DATE_BEFORE_TODAY EXCEPTION;
customer_isfound Number;

BEGIN
--Validate inputs
DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('Please wait while we are validating your input...');
DBMS_OUTPUT.PUT_LINE('');
--Member ID
IF (v_memberID IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Member ID: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

-- Customer id
IF (v_customerID IS NOT NULL) THEN
 SELECT COUNT(*) INTO customer_isfound FROM Customer WHERE CustomerID = v_customerID;

 IF (customer_isfound = 0) THEN
  RAISE ID_NOTFOUND;
 ELSE
  DBMS_OUTPUT.PUT_LINE('Customer ID: OK');
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

--  Birthdate
IF (v_memberBirthDate IS NOT NULL) THEN
  IF (v_memberBirthDate >= SYSDATE) THEN
   DBMS_OUTPUT.PUT_LINE('Member Birth Date: OK');
  ELSE
   RAISE DATE_BEFORE_TODAY;
  END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

--  expire
IF (v_memberExpiryDate IS NOT NULL) THEN
  IF (v_memberExpiryDate >= SYSDATE) THEN
   DBMS_OUTPUT.PUT_LINE('Expire  Date: OK');
  ELSE
   RAISE DATE_BEFORE_TODAY;
  END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;


IF (SQLCODE = 0) THEN
 INSERT INTO Member VALUES('M' || TO_CHAR(member_seq.nextval, 'FM0000'), 0 ,v_memberBirthDate, v_memberExpiryDate, v_customerID);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('Record added successfully');
ELSE
 DBMS_OUTPUT.PUT_LINE('There is a problem with the database. Please try again later.');
END IF;

EXCEPTION
WHEN EMPTY_DATA THEN
 DBMS_OUTPUT.PUT_LINE('Some of your input is missing.');
WHEN DATE_BEFORE_TODAY THEN
 DBMS_OUTPUT.PUT_LINE('Your date input must be at least today');
WHEN ID_NOTFOUND THEN
 DBMS_OUTPUT.PUT_LINE('Customer ID not found');
END;
/

--Prompt inputs
cl scr
PROMPT 'Create Member'
PROMPT
PROMPT

ACCEPT v_memberID CHAR FORMAT 'A10' PROMPT 'Enter Member ID: '
ACCEPT v_memberBirthDate CHAR FORMAT 'A11' PROMPT 'Enter Register date (dd-mon-yyyy): '
ACCEPT v_memberExpiryDate CHAR FORMAT 'A11' PROMPT 'Enter Member Expired date (dd-mon-yyyy): '
ACCEPT v_customerID CHAR FORMAT 'A10' PROMPT 'Enter Customer ID: '

EXEC prc_create_member ('&v_memberID', '&v_memberBirthDate', '&v_memberExpiryDate','&v_customerID');