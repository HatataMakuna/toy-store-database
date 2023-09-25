----view
DROP VIEW OrderByCustomer;
CREATE OR REPLACE VIEW OrderByCustomer AS
SELECT c.CustomerName, c.CustomerAddress, c.CustomerEmail, c.CustomerPhone, o.CustomerID
FROM Customer c, Orders o
WHERE c.CustomerID = o.CustomerID;

DROP VIEW CustomerByMember;
CREATE OR REPLACE VIEW CustomerByMember AS
SELECT m.MemberID, m.MemberPoints, m.MemberBirthDate, m.MemberExpiryDate, c.CustomerID
FROM Customer c, Member m
WHERE m.CustomerID = c.CustomerID;

----sequence
--Customer
DROP SEQUENCE customer_seq;
CREATE SEQUENCE customer_seq
MINVALUE 101
MAXVALUE 9999
START WITH 101
INCREMENT BY 1
NOCACHE;

--Member
DROP SEQUENCE member_seq;
CREATE SEQUENCE member_seq
MINVALUE 101
MAXVALUE 9999
START WITH 101
INCREMENT BY 1
NOCACHE;