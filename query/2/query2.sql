SET linesize 120
SET pagesize 100
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

cl scr

COLUMN EmployeeID FORMAT A11 HEADING "EMPLOYEE ID";
COLUMN EmployeeName FORMAT A50 HEADING "EMPLOYEE NAME";
COLUMN TotalSales FORMAT 99999 HEADING "TOTAL SALES";

TTITLE CENTER 'List of the employees with the most sales in the last quarter'

SELECT EmployeeID, EmployeeName, COUNT(*) AS TotalSales
FROM EmployeeDelivery
WHERE DeliveryDate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'Q'), -3) AND SYSDATE
GROUP BY EmployeeID, EmployeeName
ORDER BY TotalSales DESC;

CLEAR COLUMNS
TTITLE OFF