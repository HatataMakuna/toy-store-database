SET SERVEROUTPUT ON
SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE OR REPLACE PROCEDURE prc_create_promotion (v_promoName IN VARCHAR, v_discount IN NUMBER, v_memberOnly IN VARCHAR, v_startDate IN VARCHAR, v_endDate IN VARCHAR) IS
EMPTY_DATA EXCEPTION;
DISCOUNT_ERROR EXCEPTION;
INVALID_MEMBER_INPUT EXCEPTION;
INVALID_ENDDATE EXCEPTION;
v_promotionid Promotion.PromotionID%TYPE;

BEGIN
DBMS_OUTPUT.PUT_LINE('Please wait while we are validating your input...');
DBMS_OUTPUT.PUT_LINE(CHR(10));

IF (v_promoName IS NOT NULL) THEN
 DBMS_OUTPUT.PUT_LINE('Promotion Name: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

-- discount
IF (v_discount IS NOT NULL) THEN
 IF (v_discount >= 0.10 AND v_discount <= 0.90) THEN
  DBMS_OUTPUT.PUT_LINE('Discount: OK');
 ELSE
  RAISE DISCOUNT_ERROR;
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

-- is member only
IF (v_memberOnly IS NOT NULL) THEN
 IF (v_memberOnly = '1' OR v_memberOnly = '0') THEN
  DBMS_OUTPUT.PUT_LINE('Member Only?: OK');
 ELSE
  RAISE INVALID_MEMBER_INPUT;
 END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

-- start date
IF (v_startDate IS NOT NULL) THEN
  DBMS_OUTPUT.PUT_LINE('Start Date: OK');
ELSE
 RAISE EMPTY_DATA;
END IF;

-- end date
IF (v_endDate IS NOT NULL) THEN
  IF (TO_DATE(v_endDate, 'DD-MON-YYYY') >= TO_DATE(v_startDate, 'DD-MON-YYYY')) THEN
   DBMS_OUTPUT.PUT_LINE('End Date: OK');
  ELSE
   RAISE INVALID_ENDDATE;
  END IF;
ELSE
 RAISE EMPTY_DATA;
END IF;

v_promotionid := 'PR' || TO_CHAR(promotion_seq.nextval, 'FM0000');

IF (SQLCODE = 0) THEN
 INSERT INTO Promotion VALUES(v_promotionid, v_discount, v_promoName, v_memberOnly, v_startDate, v_endDate);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('Promotion ID        : ' || v_promotionid);
 DBMS_OUTPUT.PUT_LINE('Discount value      : ' || TO_CHAR(v_discount, '9.99'));
 DBMS_OUTPUT.PUT_LINE('Promotion name      : ' || v_promoName);
 DBMS_OUTPUT.PUT_LINE('Is Member Only?     : ' || v_memberOnly);
 DBMS_OUTPUT.PUT_LINE('Promotion start date: ' || v_startDate);
 DBMS_OUTPUT.PUT_LINE('Promotion end date  : ' || v_endDate);
 DBMS_OUTPUT.PUT_LINE(CHR(10));
 DBMS_OUTPUT.PUT_LINE('Record added successfully');
ELSE
  DBMS_OUTPUT.PUT_LINE('There is a problem with the database. Please try again later.');
END IF;

EXCEPTION
WHEN EMPTY_DATA THEN
 DBMS_OUTPUT.PUT_LINE('Some of your input is missing.');
WHEN DISCOUNT_ERROR THEN
 DBMS_OUTPUT.PUT_LINE('Invalid discount number. Your number must be between 0.10 and 0.90!');
WHEN INVALID_MEMBER_INPUT THEN
 DBMS_OUTPUT.PUT_LINE('The member only input must be either 0 or 1.');
WHEN INVALID_ENDDATE THEN
 DBMS_OUTPUT.PUT_LINE('The end date input must be at least start date.');
END;
/

cl scr
PROMPT 'Create promotion'
PROMPT
PROMPT

ACCEPT v_promoName CHAR FORMAT 'A50' PROMPT 'Enter promotion name: '
ACCEPT v_discount CHAR FORMAT 'A4' PROMPT 'Enter discount (0.10 ~ 0.90): '
ACCEPT v_memberOnly CHAR FORMAT 'A1' PROMPT 'Is your promotion open for members only? (1 ~ Yes; 0 ~ No): '
ACCEPT v_startDate CHAR FORMAT 'A11' PROMPT 'Enter promotion start date (dd-mon-yyyy): '
ACCEPT v_endDate CHAR FORMAT 'A11' PROMPT 'Enter promotion end date (dd-mon-yyyy): '

EXEC prc_create_promotion ('&v_promoName', '&v_discount', '&v_memberOnly', '&v_startDate', '&v_endDate');