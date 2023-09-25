SET linesize 120
SET pagesize 100

CREATE OR REPLACE TRIGGER trg_NewToyCategory
BEFORE INSERT ON Toy
FOR EACH ROW

DECLARE
v_toyCount NUMBER;
v_ToyCategory Toy.ToyCategory%TYPE;

BEGIN
SELECT COUNT(*) INTO v_toyCount
FROM Toy
WHERE ToyCategory = :NEW.ToyCategory;

IF (v_toyCount > 0) THEN
    RAISE_APPLICATION_ERROR(-20000, 'The Toy Category is exist : ' || :NEW.ToyCategory);    
END IF;

END;
/

INSERT INTO Toy
VALUES('T0202', 'Groovy Skates', 'Mechanical', 820.1, NULL, NULL, 87);

--INSERT INTO Toy
--VALUES('T0302', 'Barbie Dreamhouse Adventure', 'Dolls & Accessories', 150.00, NULL, NULL, 50);