/*
TOYCATEGORY
--------------------------------------------------
Educational
Electronic
Mascot
Mechanical
Puzzle
Robot
Traditional
Transforming
Vehicle
Weapon
*/

SET SERVEROUTPUT ON
SET linesize 200
SET pagesize 150
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE OR REPLACE PROCEDURE prc_create_toy (v_toyName IN VARCHAR, v_toyCategory IN VARCHAR, v_toyPrice IN NUMBER, v_qtyInStock IN NUMBER) IS
	
--Declare custom exception;
    EMPTY_DATA EXCEPTION;
    INVALID_QUANTITY_INPUT EXCEPTION;
    INVALID_NUMBER_FORMAT_INPUT EXCEPTION;

BEGIN
    --Validate inputs
    DBMS_OUTPUT.PUT_LINE('Please wait a moment while we validate your input.  ... ');
	
    --toy name
    IF (v_toyName IS NOT NULL) THEN
     DBMS_OUTPUT.PUT_LINE('Toy Name entered: OK!');
    ELSE
     RAISE EMPTY_DATA;
    END IF;

    --toy category
    IF (v_toyCategory IS NOT NULL) THEN
      DBMS_OUTPUT.PUT_LINE('Toy Category entered: Existed!');
    ELSE
     RAISE EMPTY_DATA;
    END IF;

    --toy price
    IF (v_toyPrice IS NOT NULL) THEN
     IF (v_toyPrice > 0 AND v_toyPrice <= 9999999) THEN
      DBMS_OUTPUT.PUT_LINE('Toy Price entered: OK!');
     ELSE
      RAISE INVALID_NUMBER_FORMAT_INPUT;
     END IF;
    ELSE
     RAISE EMPTY_DATA;
    END IF;

    --qty in stock
    IF (v_qtyInStock IS NOT NULL) THEN
     IF (v_qtyInStock != 0) THEN
      DBMS_OUTPUT.PUT_LINE('Quantity In Stock: Available!');
     ELSE
      RAISE INVALID_QUANTITY_INPUT;
     END IF;
    ELSE
     RAISE EMPTY_DATA;
    END IF;

    --insert data (if no exception)
    IF (SQLCODE = 0) THEN
     INSERT INTO Toy VALUES('T' || TO_CHAR(toy_seq.nextval, 'FM0000'), v_toyName, v_toyCategory,
     v_toyPrice, NULL, NULL, v_qtyInStock);
     COMMIT;
     DBMS_OUTPUT.PUT_LINE('Record successfully added!');
    ELSE
     DBMS_OUTPUT.PUT_LINE('The database is having an issue. Try a further time later, please.');
    END IF;

	EXCEPTION
    WHEN EMPTY_DATA THEN
     DBMS_OUTPUT.PUT_LINE('There are certain blanks in some of your responses!');
    WHEN INVALID_QUANTITY_INPUT THEN
     DBMS_OUTPUT.PUT_LINE('There are invalid quantity entered!');
    WHEN INVALID_NUMBER_FORMAT_INPUT THEN
     DBMS_OUTPUT.PUT_LINE('There are incorrect number format entered!');
    
END;
/

--Prompt inputs
cl scr
PROMPT 'Add New Toy'
PROMPT

--ACCEPT v_toyID CHAR FORMAT 'A10' PROMPT 'Enter Toy ID: '
ACCEPT v_toyName CHAR FORMAT 'A40' PROMPT 'Enter Toy Name: '
ACCEPT v_toyCategory CHAR FORMAT 'A20' PROMPT 'Enter Toy Category: '
ACCEPT v_toyPrice NUMBER PROMPT 'Enter Toy Price: '
ACCEPT v_qtyInStock NUMBER PROMPT 'Enter Quantity: '

EXEC prc_create_toy('&v_toyName', '&v_toyCategory', '&v_toyPrice', '&v_qtyInStock');

--SELECT * from Toy
--where ToyID = 'T0301';