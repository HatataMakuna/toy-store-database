SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_register_delivery (v_deliveryaddress IN VARCHAR, v_deliverycharges IN NUMBER, v_employeeid IN VARCHAR) IS
EMPTY_DATA EXCEPTION;
INVALID_CHARGES EXCEPTION;
ID_NOTFOUND EXCEPTION;
employee_isfound NUMBER;
v_deliveryid Delivery.DeliveryID%TYPE;

BEGIN
DBMS_OUTPUT.PUT_LINE('Please wait while we are validating your input...');
DBMS_OUTPUT.PUT_LINE(CHR(10));

--delivery address
IF (v_deliveryaddress IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Delivery address: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

-- delivery charges: between 1 and 100
IF (v_deliverycharges IS NOT NULL) THEN
 IF (v_deliverycharges >= 1 AND v_deliverycharges <= 100) THEN
  DBMS_OUTPUT.PUT_LINE('Delivery Charges: OK');
 ELSE
  RAISE INVALID_CHARGES;
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

-- employee id
IF (v_employeeid IS NOT NULL) THEN
 SELECT COUNT(*) INTO employee_isfound FROM Employee WHERE EmployeeID = v_employeeid;

 IF (employee_isfound = 0) THEN
  RAISE ID_NOTFOUND;
 ELSE
  DBMS_OUTPUT.PUT_LINE('Employee ID: OK');
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

v_deliveryid := 'D' || TO_CHAR(delivery_seq.nextval, 'FM0000');

IF (SQLCODE = 0) THEN
 INSERT INTO Delivery VALUES(v_deliveryid, SYSDATE, v_deliveryaddress, v_deliverycharges, v_employeeid);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('Delivery ID     : ' || v_deliveryid);
 DBMS_OUTPUT.PUT_LINE('Delivery date   : ' || SYSDATE);
 DBMS_OUTPUT.PUT_LINE('Delivery address: ' || v_deliveryaddress);
 DBMS_OUTPUT.PUT_LINE('Delivery charges: ' || 'RM ' || TO_CHAR(v_deliverycharges, 99.99));
 DBMS_OUTPUT.PUT_LINE('Employee ID     : ' || v_employeeid);
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('Record added successfully');
ELSE
 DBMS_OUTPUT.PUT_LINE('There is a problem with the database. Please try again later.');
END IF;

EXCEPTION
WHEN EMPTY_DATA THEN
 DBMS_OUTPUT.PUT_LINE('Some of your input is missing.');
WHEN INVALID_CHARGES THEN
 DBMS_OUTPUT.PUT_LINE('Your delivery charges is invalid. It must be between 1.00 and 100.00.');
WHEN ID_NOTFOUND THEN
 DBMS_OUTPUT.PUT_LINE('The delivery ID cannot be found.');
END;
/

cl scr
PROMPT 'Register Delivery'
PROMPT
PROMPT
ACCEPT v_deliveryaddress CHAR FORMAT 'A50' PROMPT 'Enter delivery address: '
ACCEPT v_deliverycharges NUMBER PROMPT 'Enter delivery charges: '
ACCEPT v_deliveryid CHAR FORMAT 'A7' PROMPT 'Enter employee ID: '

EXEC prc_register_delivery ('&v_deliveryaddress', '&v_deliverycharges', '&v_deliveryid');