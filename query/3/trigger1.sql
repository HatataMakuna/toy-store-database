SET linesize 220
SET pagesize 100

CREATE TABLE Toy_Audit(
    UserID      VARCHAR(30),
    TransDate   DATE,
    Time        CHAR(8),
    Action      VARCHAR(10)
);

CREATE OR REPLACE TRIGGER trg_track_toy
AFTER INSERT OR UPDATE ON Toy
FOR EACH ROW

DECLARE
timeString CHAR(8);

BEGIN
    CASE
        WHEN INSERTING THEN
            timeString := TO_CHAR(SYSDATE, 'HH24:MI:SS');
            INSERT INTO Toy_Audit
            VALUES(User, SYSDATE, timeString, 'INSERT');
        WHEN UPDATING THEN
            timeString := TO_CHAR(SYSDATE, 'HH24:MI:SS');
            INSERT INTO Toy_Audit
            VALUES(User, SYSDATE, timeString, 'UPDATE');
    END CASE;
END;
/

INSERT INTO Toy
VALUES('T0301', 'Ball Toss Puzzle', 'Mascot', 280.00, NULL, NULL, 20);

UPDATE Toy
SET ToyPrice = 300.00
WHERE ToyID = 'T0212';

select * from toy_audit;