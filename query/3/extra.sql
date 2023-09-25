----view
DROP VIEW StockPurchaseBySupplier;
CREATE OR REPLACE VIEW StockPurchaseBySupplier AS
SELECT S.SupplierID, S.SupplierName, SP.PurchaseDate, SP.StockPurchaseID, SP.NoOfToys
FROM Supplier S, StockPurchase SP
WHERE S.SupplierID = SP.SupplierID;

----sequence
DROP SEQUENCE toy_seq;
CREATE SEQUENCE toy_seq
MINVALUE 301
MAXVALUE 9999
START WITH 301
INCREMENT BY 1
NOCACHE;