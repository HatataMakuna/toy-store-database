SET linesize 80
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

COLUMN MemberID FORMAT A20 HEADING "Member ID";
COLUMN CustomerID FORMAT A20 HEADING "Customer ID";
COLUMN MemberPoints FORMAT 9999 HEADING "Member Points";
COLUMN MemberBirthDate FORMAT A10 HEADING "Member Birth Date";
COLUMN MemberExpiryDate FORMAT A10 HEADING "Member Expiry Date";


TTITLE LEFT 'Member Details     ' _DATE -
RIGHT 'Page No: ' FORMAT 999 SQL.PNO SKIP 2
BREAK ON MemberID 

SELECT m.MemberID,c.CustomerID, m.MemberPoints, m.MemberBirthDate, m.MemberExpiryDate
FROM Member m,Customer c
WHERE m.CustomerID = c.CustomerID AND m.MemberID = '&member' 
ORDER BY MemberID;

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF