----views
DROP VIEW QueryOneOrder;
CREATE OR REPLACE VIEW QueryOneOrder AS
SELECT P.*, O.OrderID, O.OrderDate, O.Total, OD.Quantity, OD.ActualPrice, OD.Subtotal, T.*
FROM Payment P, Orders O, OrderDetails OD, Toy T
WHERE P.PaymentID = O.PaymentiD AND O.OrderID = OD.OrderID AND OD.ToyID = T.ToyID;

DROP VIEW QueryTwoQuantity;
CREATE OR REPLACE VIEW QueryTwoQuantity AS
SELECT T.*, SP.StockPurchaseID, SP.NoOfToys, SP.PurchaseDate, S.*
FROM Toy T, StockPurchase SP, Supplier S
WHERE S.SupplierID = SP.SupplierID AND T.ToyID = SP.ToyID;

----sequence
DROP SEQUENCE toy_seq;
CREATE SEQUENCE toy_seq
MINVALUE 301
MAXVALUE 9999
START WITH 301
INCREMENT BY 1
NOCACHE;

DROP SEQUENCE payment_seq;
CREATE SEQUENCE payment_seq
MINVALUE 301
MAXVALUE 9999
START WITH 301
INCREMENT BY 1
NOCACHE;

DROP SEQUENCE order_seq;
CREATE SEQUENCE order_seq
MINVALUE 301
MAXVALUE 9999
START WITH 301
INCREMENT BY 1
NOCACHE;

----indexes
/*
Description: Create an index for Toy name from Toy table
*/
DROP INDEX item_name_idx;
CREATE INDEX item_name_idx ON Toy(ToyName, QuantityInStock);
SELECT ToyName, QuantityInStock, count(*) As Respond_Times
FROM Toy
WHERE ToyName is not null AND QuantityInStock is not null
group by ToyName, QuantityInStock;
CLEAR COLUMNS

/*
Description: Create an index for Payment Method from Payment table
*/
DROP INDEX payment_method_idx;
CREATE INDEX payment_method_idx ON Payment(PaymentID, PaymentMethod);
SELECT PaymentID, PaymentMethod, count(*) AS Payment_Made
FROM PAYMENT
WHERE PaymentID is not null AND PaymentMethod is not null
GROUP BY PaymentID, PaymentMethod;
CLEAR COLUMNS