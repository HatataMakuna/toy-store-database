----views
DROP VIEW OrderEmployee;
CREATE OR REPLACE VIEW OrderEmployee AS
SELECT E.*, O.OrderID, O.OrderDate, O.Total, O.CustomerID, O.PaymentID, O.PromotionID, O.DeliveryID
FROM Employee E, Orders O
WHERE E.EmployeeID = O.EmployeeID;

DROP VIEW EmployeeDelivery;
CREATE OR REPLACE VIEW EmployeeDelivery AS
SELECT E.*, D.DeliveryID, D.DeliveryDate, D.DeliveryAddress, D.DeliveryCharges
FROM Employee E, Delivery D
WHERE E.EmployeeID = D.EmployeeID;

----sequence
--promotion
DROP SEQUENCE promotion_seq;
CREATE SEQUENCE promotion_seq
MINVALUE 101
MAXVALUE 9999
START WITH 101
INCREMENT BY 1
NOCACHE;

--delivery
DROP SEQUENCE delivery_seq;
CREATE SEQUENCE delivery_seq
MINVALUE 101
MAXVALUE 9999
START WITH 101
INCREMENT BY 1
NOCACHE;

----indexes
DROP INDEX employee_name_idx;
CREATE INDEX employee_name_idx ON Employee(EmployeeName);