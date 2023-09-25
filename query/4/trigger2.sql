/*
Purpose: The purpose is to add or update the order details in all time. The order make by the Toy quantity and Total price. If user key-in more quantity than quantity In Stock, it might showing error message.
*/
CREATE OR REPLACE TRIGGER trg_order_details
BEFORE INSERT OR UPDATE ON OrderDetails
FOR EACH ROW
DECLARE
  v_actualPrice number(7,2);
  v_QtyInStock number(7,2);
BEGIN

  SELECT SellingPrice INTO v_actualPrice FROM Toy WHERE ToyID = :NEW.ToyID;
  
    :NEW.ActualPrice := v_actualPrice;
 
SELECT QuantityInStock INTO v_QtyInStock
FROM Toy
WHERE ToyID = :NEW.ToyID;

IF (:NEW.Quantity > v_QtyInStock) THEN
  RAISE_APPLICATION_ERROR(-20002, 'Toy (' || :NEW.Quantity || ') is out of stock');
ELSE
  :NEW.Subtotal := :NEW.Quantity * :NEW.ActualPrice;
END IF;
END;
/

INSERT INTO OrderDetails VALUES('OR0151', 'T0101', 14, null, null);

update orderdetails
set quantity = 10
where toyid = 'T0101' and orderid = 'OR0151';