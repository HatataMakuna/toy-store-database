CREATE TABLE OrdTable(
OrderID varchar(6),
OrderDate date,
Total number(7,2),
CustomerID varchar(5),
EmployeeID varchar(5),
PaymentID varchar(6),
PromotionID varchar(6),
DeliveryID varchar(5)
);
CREATE OR REPLACE TRIGGER trg_track_Order
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW

BEGIN
 CASE
  WHEN INSERTING THEN
   INSERT INTO OrderTable
VALUES(:NEW.OrderID, :NEW.OrderDate, :NEW.Total, :NEW.CustomerID, :NEW.EmployeeID, :NEW.PaymentID, :NEW.PromotionID, :NEW.DeliveryID);

  WHEN UPDATING THEN
   INSERT INTO OrderTable
VALUES(:NEW.OrderID, :NEW.OrderDate, :NEW.Total, :NEW.CustomerID, :NEW.EmployeeID, :NEW.PaymentID, :NEW.PromotionID, :NEW.DeliveryID);

  WHEN DELETING THEN
   INSERT INTO OrderTable
VALUES(:NEW.OrderID, :NEW.OrderDate, :NEW.Total, :NEW.CustomerID, :NEW.EmployeeID, :NEW.PaymentID, :NEW.PromotionID, :NEW.DeliveryID);

 END CASE;
END;
/