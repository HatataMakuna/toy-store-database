--Basic formats
SET linesize 120;
SET pagesize 100;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

--Drop tables
DROP TABLE OrderDetails;
DROP TABLE Orders;
DROP TABLE StockPurchase;
DROP TABLE Delivery;
DROP TABLE Member;
DROP TABLE Promotion;
DROP TABLE Payment;
DROP TABLE Supplier;
DROP TABLE Toy;
DROP TABLE Employee;
DROP TABLE Customer;

--Create table
CREATE TABLE Customer(
CustomerID varchar(5) NOT NULL,
CustomerName varchar(50),
CustomerAddress varchar(100),
CustomerEmail varchar(50) UNIQUE,
CustomerPhone varchar(50),
PRIMARY KEY (CustomerID)
);
CREATE TABLE Employee(
EmployeeID varchar(5) NOT NULL,
EmployeeName varchar(50),
EmployeeEmail varchar(50) UNIQUE,
EmployeePhone varchar(25),
EmployeePosition varchar(30),
PRIMARY KEY (EmployeeID)
);
CREATE TABLE Toy(
ToyID varchar(5) NOT NULL,
ToyName varchar(50),
ToyCategory varchar(50),
ToyPrice number(7,2),
SST number(7,2) DEFAULT NULL,
SellingPrice number(7,2) DEFAULT NULL,
QuantityInStock int,
PRIMARY KEY (ToyID),
CONSTRAINT chk_qtyinstock CHECK (QuantityInStock >= 0)
);
CREATE TABLE Supplier(
SupplierID varchar(5) NOT NULL,
SupplierName varchar(50),
SupplierEmail varchar(50) UNIQUE,
SupplierPhone varchar(20) UNIQUE,
PRIMARY KEY (SupplierID)
);
CREATE TABLE Payment(
PaymentID varchar(6) NOT NULL,
PaymentMethod varchar(20),
PaymentDate date,
PaymentTime char(8),
PRIMARY KEY (PaymentID)
);
CREATE TABLE Promotion(
PromotionID varchar(6) NOT NULL,
Discount number(2),
PromotionName varchar(50),
IsMemberOnly char(1),
PromotionStartDate date,
PromotionEndDate date,
PRIMARY KEY (PromotionID),
CONSTRAINT chk_member CHECK (IsMemberOnly = 0 OR IsMemberOnly = 1)
);

CREATE TABLE Member(
MemberID varchar(5) NOT NULL,
MemberPoints int DEFAULT 0,
MemberBirthDate date,
MemberExpiryDate date,
CustomerID varchar(5) NOT NULL,
PRIMARY KEY (MemberID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT chk_memberpts CHECK (MemberPoints >= 0)
);
CREATE TABLE Delivery(
DeliveryID varchar(5) NOT NULL,
DeliveryDate date,
DeliveryAddress varchar(50),
DeliveryCharges number(5,2),
EmployeeID varchar(5) NOT NULL,
PRIMARY KEY (DeliveryID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE StockPurchase(
StockPurchaseID varchar(6) NOT NULL,
NoOfToys int,
PurchaseDate date,
ToyID varchar(5) NOT NULL,
SupplierID varchar(5) NOT NULL,
PRIMARY KEY (StockPurchaseID, ToyID, SupplierID),
FOREIGN KEY (ToyID) REFERENCES Toy(ToyID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
CONSTRAINT chk_notoys CHECK (NoOfToys >= 0)
);
CREATE TABLE Orders(
OrderID varchar(6) NOT NULL,
OrderDate date,
Total number(7,2),
CustomerID varchar(5) NOT NULL,
EmployeeID varchar(5) NOT NULL,
PaymentID varchar(6) NOT NULL,
PromotionID varchar(6) NOT NULL,
DeliveryID varchar(5) NOT NULL,
PRIMARY KEY (OrderID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID),
FOREIGN KEY (DeliveryID) REFERENCES Delivery(DeliveryID)
);

CREATE TABLE OrderDetails(
OrderID varchar(6) NOT NULL,
ToyID varchar(5) NOT NULL,
Quantity int,
ActualPrice number(7,2),
Subtotal number(7,2),
PRIMARY KEY (OrderID, ToyID),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ToyID) REFERENCES Toy(ToyID)
);

SET linesize 120
SET pagesize 100

CREATE OR REPLACE TRIGGER trg_cal_sst_SellingPrice
BEFORE INSERT ON Toy
FOR EACH ROW

BEGIN
:NEW.SST := :NEW.ToyPrice * 0.06;
:NEW.SellingPrice:=:NEW.ToyPrice*1.06;
END;
/

--Customer
INSERT INTO Customer VALUES ('C0000', NULL, NULL, NULL, NULL);

INSERT INTO Customer VALUES ('C0001', 'Fanchon Jeanneau', '3835 Rutledge Terrace', 'fjeanneau0@nymag.com', '729-411-5410');
INSERT INTO Customer VALUES ('C0002', 'Harwilll Teresa', '10136 Springs Alley', 'hteresa1@naver.com', '792-648-5231');
INSERT INTO Customer VALUES ('C0003', 'Traver Skeggs', '6 Butterfield Drive', 'tskeggs2@google.com.br', '798-453-5033');
INSERT INTO Customer VALUES ('C0004', 'Britney Salzen', '26 Arapahoe Terrace', 'bsalzen3@merriam-webster.com', '180-455-8174');
INSERT INTO Customer VALUES ('C0005', 'Caralie Dunne', '47744 Larry Park', 'cdunne4@ebay.co.uk', '134-664-9032');
INSERT INTO Customer VALUES ('C0006', 'Jacquelin Antonacci', '32 Messerschmidt Parkway', 'jantonacci5@microsoft.com', '636-820-8394');
INSERT INTO Customer VALUES ('C0007', 'Lonna Pixton', '38 Linden Way', 'lpixton6@ft.com', '689-504-1317');
INSERT INTO Customer VALUES ('C0008', 'Falkner De Stoop', '3 Barnett Terrace', 'fde7@sun.com', '199-799-2230');
INSERT INTO Customer VALUES ('C0009', 'Lindsy Ord', '8240 Tomscot Way', 'lord8@alibaba.com', '422-616-6217');
INSERT INTO Customer VALUES ('C0010', 'Garner Sugge', '609 Fairview Terrace', 'gsugge9@taobao.com', '288-741-1373');

INSERT INTO Customer VALUES ('C0011', 'Vilhelmina Tarborn', '27 Maple Wood Circle', 'vtarborna@alexa.com', '382-774-6514');
INSERT INTO Customer VALUES ('C0012', 'Darci Lerego', '60 School Road', 'dleregob@dagondesign.com', '672-564-0520');
INSERT INTO Customer VALUES ('C0013', 'Melvyn Kenwright', '018 Saint Paul Point', 'mkenwrightc@google.ru', '645-665-5040');
INSERT INTO Customer VALUES ('C0014', 'Vonnie Speke', '0571 Calypso Terrace', 'vspeked@kickstarter.com', '380-843-7298');
INSERT INTO Customer VALUES ('C0015', 'Clem Robertot', '9090 Saint Paul Point', 'crobertote@posterous.com', '164-527-9230');
INSERT INTO Customer VALUES ('C0016', 'Rosaleen Bonnick', '1739 Esch Crossing', 'rbonnickf@dropbox.com', '350-521-0342');
INSERT INTO Customer VALUES ('C0017', 'Kathrine Ponceford', '9 Pierstorff Drive', 'kponcefordg@diigo.com', '839-346-6611');
INSERT INTO Customer VALUES ('C0018', 'Kissiah Skym', '8132 Iowa Terrace', 'kskymh@samsung.com', '806-576-8831');
INSERT INTO Customer VALUES ('C0019', 'Ansel Stoppe', '9 Dennis Drive', 'astoppei@lycos.com', '922-151-9139');
INSERT INTO Customer VALUES ('C0020', 'Ahmed Demkowicz', '30 Stone Corner Court', 'ademkowiczj@woothemes.com', '647-206-8045');

INSERT INTO Customer VALUES ('C0021', 'Nealson Prisk', '1551 Southridge Hill', 'npriskk@google.it', '581-949-5819');
INSERT INTO Customer VALUES ('C0022', 'Rudolf Bails', '38237 Mcbride Plaza', 'rbailsl@rakuten.co.jp', '628-737-0736');
INSERT INTO Customer VALUES ('C0023', 'Tommie Carlesi', '42419 Sutherland Road', 'tcarlesim@creativecommons.org', '675-526-8030');
INSERT INTO Customer VALUES ('C0024', 'Nannie Humphery', '38442 Melby Alley', 'nhumpheryn@engadget.com', '928-682-1318');
INSERT INTO Customer VALUES ('C0025', 'Bernadine Bradbeer', '74 Calypso Alley', 'bbradbeero@eventbrite.com', '892-927-2014');
INSERT INTO Customer VALUES ('C0026', 'Tilly Cruse', '3 Elka Parkway', 'tcrusep@ebay.co.uk', '357-393-9857');
INSERT INTO Customer VALUES ('C0027', 'Merrick Grioli', '0369 Lakewood Gardens Hill', 'mgrioliq@wordpress.org', '293-155-1602');
INSERT INTO Customer VALUES ('C0028', 'Ronna Menicomb', '63 Stoughton Circle', 'rmenicombr@slideshare.net', '309-518-8801');
INSERT INTO Customer VALUES ('C0029', 'Geralda Schrader', '57741 Johnson Way', 'gschraders@princeton.edu', '645-259-5718');
INSERT INTO Customer VALUES ('C0030', 'Celesta Wingfield', '4077 Westridge Avenue', 'cwingfieldt@foxnews.com', '698-406-2944');

INSERT INTO Customer VALUES ('C0031', 'Lebbie Platt', '1 Dexter Drive', 'lplattu@indiegogo.com', '220-432-6112');
INSERT INTO Customer VALUES ('C0032', 'Pierette Larrett', '9 Prairieview Crossing', 'plarrettv@digg.com', '367-470-0715');
INSERT INTO Customer VALUES ('C0033', 'Babbie Southworth', '9 Crest Line Park', 'bsouthworthw@live.com', '627-906-3961');
INSERT INTO Customer VALUES ('C0034', 'Hilario Wint', '73525 Mayfield Point', 'hwintx@sfgate.com', '472-264-7295');
INSERT INTO Customer VALUES ('C0035', 'Bernete Spracklin', '83314 Westerfield Court', 'bsprackliny@bloglovin.com', '609-858-8032');
INSERT INTO Customer VALUES ('C0036', 'Waring McEvoy', '31 Russell Lane', 'wmcevoyz@who.int', '720-159-3113');
INSERT INTO Customer VALUES ('C0037', 'Meredithe Corro', '7 Northridge Junction', 'mcorro10@gravatar.com', '327-990-1605');
INSERT INTO Customer VALUES ('C0038', 'Pammy Mathieson', '55089 Northfield Point', 'pmathieson11@army.mil', '267-344-2514');
INSERT INTO Customer VALUES ('C0039', 'Syd Caesar', '76 Jackson Pass', 'scaesar12@reference.com', '927-121-8636');
INSERT INTO Customer VALUES ('C0040', 'Bibby MacAllester', '130 Sage Hill', 'bmacallester13@photobucket.com', '562-105-9653');

INSERT INTO Customer VALUES ('C0041', 'Charil Ginnety', '3525 Kinsman Avenue', 'cginnety14@kickstarter.com', '487-692-7425');
INSERT INTO Customer VALUES ('C0042', 'Lorilyn Charge', '86 Carey Parkway', 'lcharge15@apple.com', '151-625-8787');
INSERT INTO Customer VALUES ('C0043', 'Georgeta Triggol', '81885 Pawling Alley', 'gtriggol16@mtv.com', '891-875-5158');
INSERT INTO Customer VALUES ('C0044', 'Nicolais Lambot', '7 Homewood Avenue', 'nlambot17@1und1.de', '407-681-5181');
INSERT INTO Customer VALUES ('C0045', 'Jennie Papes', '5235 Northview Hill', 'jpapes18@cbsnews.com', '818-651-0997');
INSERT INTO Customer VALUES ('C0046', 'Kearney Dymidowicz', '9 Graceland Road', 'kdymidowicz19@vk.com', '644-790-8642');
INSERT INTO Customer VALUES ('C0047', 'Trenton MacGraith', '55446 Fallview Lane', 'tmacgraith1a@godaddy.com', '754-555-3458');
INSERT INTO Customer VALUES ('C0048', 'Rani Halfhyde', '730 Longview Trail', 'rhalfhyde1b@abc.net.au', '612-756-3301');
INSERT INTO Customer VALUES ('C0049', 'Margery Waddup', '16 Lakewood Gardens Crossing', 'mwaddup1c@yale.edu', '658-905-8344');
INSERT INTO Customer VALUES ('C0050', 'Kevina Nosworthy', '43 Prentice Pass', 'knosworthy1d@etsy.com', '755-836-1099');

INSERT INTO Customer VALUES ('C0051', 'Sean Tuite', '5637 North Parkway', 'stuite1e@slashdot.org', '376-659-6948');
INSERT INTO Customer VALUES ('C0052', 'Imogen McGraith', '6902 Stephen Parkway', 'imcgraith1f@umich.edu', '681-994-7951');
INSERT INTO Customer VALUES ('C0053', 'Marie-ann Castellino', '43096 Miller Alley', 'mcastellino1g@msu.edu', '714-711-9314');
INSERT INTO Customer VALUES ('C0054', 'Florence Bembridge', '0425 Hallows Park', 'fbembridge1h@github.io', '711-549-7665');
INSERT INTO Customer VALUES ('C0055', 'Sallyanne Collerd', '6583 Little Fleur Drive', 'scollerd1i@4shared.com', '804-224-0756');
INSERT INTO Customer VALUES ('C0056', 'Jany Shaddock', '0502 Comanche Alley', 'jshaddock1j@sourceforge.net', '739-835-6817');
INSERT INTO Customer VALUES ('C0057', 'Sharl Sket', '39 Kim Crossing', 'ssket1k@amazon.co.jp', '445-983-6657');
INSERT INTO Customer VALUES ('C0058', 'Penelopa Lafont', '17952 Caliangt Terrace', 'plafont1l@engadget.com', '785-396-8491');
INSERT INTO Customer VALUES ('C0059', 'Justina Creasey', '6 Cottonwood Alley', 'jcreasey1m@parallels.com', '954-265-2517');
INSERT INTO Customer VALUES ('C0060', 'Dirk Moulson', '700 Cordelia Alley', 'dmoulson1n@craigslist.org', '387-697-7215');

INSERT INTO Customer VALUES ('C0061', 'Fanni Wardall', '9 Hayes Crossing', 'fwardall1o@delicious.com', '698-224-1895');
INSERT INTO Customer VALUES ('C0062', 'Piggy Plevin', '11906 Sunbrook Avenue', 'pplevin1p@google.com.au', '627-579-5826');
INSERT INTO Customer VALUES ('C0063', 'Kacie Cutajar', '20 Duke Lane', 'kcutajar1q@globo.com', '348-840-3868');
INSERT INTO Customer VALUES ('C0064', 'Clarita Kristufek', '2 Upham Hill', 'ckristufek1r@sciencedirect.com', '924-931-0198');
INSERT INTO Customer VALUES ('C0065', 'Doralin Hedin', '27490 Hayes Trail', 'dhedin1s@tmall.com', '225-690-1200');
INSERT INTO Customer VALUES ('C0066', 'Dannie Boness', '893 Granby Drive', 'dboness1t@foxnews.com', '756-440-0930');
INSERT INTO Customer VALUES ('C0067', 'Daffi Rosoni', '6 Corscot Place', 'drosoni1u@ovh.net', '649-581-5834');
INSERT INTO Customer VALUES ('C0068', 'Wendall Bending', '27977 Union Way', 'wbending1v@state.tx.us', '396-658-0783');
INSERT INTO Customer VALUES ('C0069', 'Marcie Brasse', '2 Macpherson Trail', 'mbrasse1w@google.ru', '383-897-8330');
INSERT INTO Customer VALUES ('C0070', 'Lothario Butson', '25 Florence Drive', 'lbutson1x@bloomberg.com', '916-648-9986');

INSERT INTO Customer VALUES ('C0071', 'Ilaire Amor', '6 Shasta Point', 'iamor1y@nsw.gov.au', '668-289-8217');
INSERT INTO Customer VALUES ('C0072', 'Stearn Powles', '587 Old Shore Terrace', 'spowles1z@google.com.br', '397-279-6570');
INSERT INTO Customer VALUES ('C0073', 'Hilary Tukesby', '8 Cambridge Road', 'htukesby20@lycos.com', '901-288-4977');
INSERT INTO Customer VALUES ('C0074', 'Charlena Georgius', '686 Kedzie Circle', 'cgeorgius21@indiegogo.com', '994-386-8697');
INSERT INTO Customer VALUES ('C0075', 'Mada Cotherill', '345 Farwell Way', 'mcotherill22@discovery.com', '887-355-5163');
INSERT INTO Customer VALUES ('C0076', 'Everard McGreal', '79178 Debs Circle', 'emcgreal23@wikipedia.org', '121-394-0952');
INSERT INTO Customer VALUES ('C0077', 'Hyacinthe Vuitton', '8652 North Lane', 'hvuitton24@hubpages.com', '107-916-7799');
INSERT INTO Customer VALUES ('C0078', 'Stacee Seeler', '26 School Circle', 'sseeler25@bbb.org', '378-366-0307');
INSERT INTO Customer VALUES ('C0079', 'Conn Albone', '1 High Crossing Trail', 'calbone26@aol.com', '545-440-4386');
INSERT INTO Customer VALUES ('C0080', 'Noellyn Kun', '90451 Westport Center', 'nkun27@bizjournals.com', '174-447-7363');

INSERT INTO Customer VALUES ('C0081', 'Babbie Deners', '722 Bay Avenue', 'bdeners28@lulu.com', '539-370-2999');
INSERT INTO Customer VALUES ('C0082', 'Atalanta Baldini', '8 Bayside Crossing', 'abaldini29@sbwire.com', '500-691-3648');
INSERT INTO Customer VALUES ('C0083', 'Farah Greed', '16 Hollow Ridge Alley', 'fgreed2a@xinhuanet.com', '170-472-8675');
INSERT INTO Customer VALUES ('C0084', 'Nicolais O''Reilly', '36480 Vera Street', 'noreilly2b@businessweek.com', '314-293-5832');
INSERT INTO Customer VALUES ('C0085', 'Farley Covotti', '8 Northridge Park', 'fcovotti2c@amazon.de', '651-402-4921');
INSERT INTO Customer VALUES ('C0086', 'Rutledge Whyley', '430 Melody Park', 'rwhyley2d@nih.gov', '969-567-2584');
INSERT INTO Customer VALUES ('C0087', 'Gladys Twigg', '02736 Golf Junction', 'gtwigg2e@netvibes.com', '168-589-5252');
INSERT INTO Customer VALUES ('C0088', 'Lacee Giannotti', '49366 Arizona Plaza', 'lgiannotti2f@indiegogo.com', '489-883-9644');
INSERT INTO Customer VALUES ('C0089', 'Pearla Rivelin', '625 International Alley', 'privelin2g@cbsnews.com', '214-983-0152');
INSERT INTO Customer VALUES ('C0090', 'Dela Ipsley', '47703 Vera Way', 'dipsley2h@pcworld.com', '530-118-3629');

INSERT INTO Customer VALUES ('C0091', 'Lana Edgell', '152 Eagle Crest Center', 'ledgell2i@t-online.de', '728-448-1253');
INSERT INTO Customer VALUES ('C0092', 'Gale Nodin', '35 Everett Hill', 'gnodin2j@ihg.com', '353-682-7220');
INSERT INTO Customer VALUES ('C0093', 'Clementina Southerns', '19526 Del Mar Center', 'csoutherns2k@domainmarket.com', '603-470-4172');
INSERT INTO Customer VALUES ('C0094', 'Amaleta MacRannell', '3 Longview Lane', 'amacrannell2l@behance.net', '965-398-2184');
INSERT INTO Customer VALUES ('C0095', 'Eva Adriaan', '64699 Jenna Lane', 'eadriaan2m@whitehouse.gov', '715-464-1892');
INSERT INTO Customer VALUES ('C0096', 'Reggie Golsthorp', '2776 Macpherson Park', 'rgolsthorp2n@mediafire.com', '490-865-7596');
INSERT INTO Customer VALUES ('C0097', 'Tiphani Dobbing', '4315 Artisan Point', 'tdobbing2o@google.com.br', '460-830-3612');
INSERT INTO Customer VALUES ('C0098', 'Joelle Giraudeau', '8 Harper Circle', 'jgiraudeau2p@merriam-webster.com', '230-704-8908');
INSERT INTO Customer VALUES ('C0099', 'Timmy Rue', '02 Pawling Avenue', 'true2q@answers.com', '752-575-5704');
INSERT INTO Customer VALUES ('C0100', 'Bibbie Segebrecht', '2 Judy Point', 'bsegebrecht2r@bbc.co.uk', '489-560-0467');

--Employee
INSERT INTO Employee VALUES ('E0000', NULL, NULL, NULL, NULL);

INSERT INTO Employee VALUES ('E0001', 'Tamara Haysar', 'thaysar0@techcrunch.com', 213-424-0140, 'Associate');
INSERT INTO Employee VALUES ('E0002', 'Irv Rickertsen', 'irickertsen1@lycos.com', 805-913-3923, 'Associate');
INSERT INTO Employee VALUES ('E0003', 'Orville Peinton', 'opeinton2@github.com', 340-714-7330, 'Associate');
INSERT INTO Employee VALUES ('E0004', 'Rip Wagen', 'rwagen3@mapy.cz', 714-164-8583, 'Vice-manager');
INSERT INTO Employee VALUES ('E0005', 'Elfreda Edeler', 'eedeler4@meetup.com', 705-703-7226, 'Associate');
INSERT INTO Employee VALUES ('E0006', 'Bebe Dowthwaite', 'bdowthwaite5@chron.com', 799-575-3767, 'Associate');
INSERT INTO Employee VALUES ('E0007', 'Calli Woodison', 'cwoodison6@infoseek.co.jp', 205-861-9413, 'Associate');
INSERT INTO Employee VALUES ('E0008', 'Letta Gillbard', 'lgillbard7@desdev.cn', 845-154-5680, 'Associate');
INSERT INTO Employee VALUES ('E0009', 'Lara Mathet', 'lmathet8@sphinn.com', 484-225-3997, 'Vice-manager');
INSERT INTO Employee VALUES ('E0010', 'Trefor Josephy', 'tjosephy9@godaddy.com', 597-937-5976, 'Associate');

INSERT INTO Employee VALUES ('E0011', 'Jere Norledge', 'jnorledgea@studiopress.com', 506-432-3296, 'Associate');
INSERT INTO Employee VALUES ('E0012', 'Riannon Delacroux', 'rdelacrouxb@amazon.co.jp', 975-263-3447, 'Associate');
INSERT INTO Employee VALUES ('E0013', 'Vere Woodrooffe', 'vwoodrooffec@craigslist.org', 292-944-5018, 'Associate');
INSERT INTO Employee VALUES ('E0014', 'Helaina Menichi', 'hmenichid@chron.com', 284-756-9995, 'Associate');
INSERT INTO Employee VALUES ('E0015', 'Bernie Spurnier', 'bspurniere@mozilla.org', 104-152-4699, 'Associate');
INSERT INTO Employee VALUES ('E0016', 'Rodney Patesel', 'rpateself@clickbank.net', 389-245-4065, 'Associate');
INSERT INTO Employee VALUES ('E0017', 'Mora Sebrens', 'msebrensg@goo.gl', 589-462-7427, 'Associate');
INSERT INTO Employee VALUES ('E0018', 'Priscilla Morrant', 'pmorranth@bloglines.com', 918-568-0353, 'Associate');
INSERT INTO Employee VALUES ('E0019', 'Reeba Ferentz', 'rferentzi@google.es', 797-554-8492, 'Vice-manager');
INSERT INTO Employee VALUES ('E0020', 'Marven Newing', 'mnewingj@ed.gov', 719-812-9862, 'Associate');

INSERT INTO Employee VALUES ('E0021', 'Alfie Kingsnode', 'akingsnodek@deliciousdays.com', 666-938-3394, 'Associate');
INSERT INTO Employee VALUES ('E0022', 'Kleon Summergill', 'ksummergilll@imgur.com', 215-315-0739, 'Associate');
INSERT INTO Employee VALUES ('E0023', 'Doloritas Lewens', 'dlewensm@nifty.com', 436-681-9605, 'Associate');
INSERT INTO Employee VALUES ('E0024', 'Brennen Rogger', 'broggern@nydailynews.com', 801-459-8103, 'Associate');
INSERT INTO Employee VALUES ('E0025', 'Glory Pepperrall', 'gpepperrallo@reference.com', 317-696-7161, 'Associate');
INSERT INTO Employee VALUES ('E0026', 'Amitie Brydone', 'abrydonep@cyberchimps.com', 248-274-8692, 'Vice-manager');
INSERT INTO Employee VALUES ('E0027', 'Keith Gaylard', 'kgaylardq@amazon.com', 555-658-1435, 'Associate');
INSERT INTO Employee VALUES ('E0028', 'Marius Orable', 'morabler@reuters.com', 248-307-8721, 'Associate');
INSERT INTO Employee VALUES ('E0029', 'Magnum Zanolli', 'mzanollis@mapquest.com', 765-382-2167, 'Associate');
INSERT INTO Employee VALUES ('E0030', 'Reggie Emmerson', 'remmersont@timesonline.co.uk', 772-996-3633, 'Associate');

INSERT INTO Employee VALUES ('E0031', 'Gerianne Sandwich', 'gsandwichu@google.pl', 663-186-0669, 'Vice-manager');
INSERT INTO Employee VALUES ('E0032', 'Nettle Flipsen', 'nflipsenv@quantcast.com', 552-293-7290, 'Associate');
INSERT INTO Employee VALUES ('E0033', 'Seline Hartell', 'shartellw@about.com', 649-636-2060, 'Associate');
INSERT INTO Employee VALUES ('E0034', 'Hilary Figgures', 'hfigguresx@state.tx.us', 472-118-9986, 'Associate');
INSERT INTO Employee VALUES ('E0035', 'Beryle Shenton', 'bshentony@ycombinator.com', 718-559-4744, 'Associate');
INSERT INTO Employee VALUES ('E0036', 'Enrica Nuzzi', 'enuzziz@merriam-webster.com', 107-785-5243, 'Associate');
INSERT INTO Employee VALUES ('E0037', 'Robb Vasovic', 'rvasovic10@reddit.com', 341-534-1208, 'Associate');
INSERT INTO Employee VALUES ('E0038', 'Bobbette Treece', 'btreece11@weebly.com', 914-275-4216, 'Associate');
INSERT INTO Employee VALUES ('E0039', 'Wilfred Barlee', 'wbarlee12@va.gov', 217-885-7183, 'Associate');
INSERT INTO Employee VALUES ('E0040', 'Eldon Nacey', 'enacey13@auda.org.au', 888-181-8095, 'Associate');

INSERT INTO Employee VALUES ('E0041', 'Joli Tiuit', 'jtiuit14@utexas.edu', 672-831-4877, 'Associate');
INSERT INTO Employee VALUES ('E0042', 'Hedda Hempshall', 'hhempshall15@trellian.com', 857-811-4109, 'Manager');
INSERT INTO Employee VALUES ('E0043', 'Andrew Doll', 'adoll16@discovery.com', 388-867-5046, 'Associate');
INSERT INTO Employee VALUES ('E0044', 'Merola Shavel', 'mshavel17@dedecms.com', 112-793-6208, 'Associate');
INSERT INTO Employee VALUES ('E0045', 'Aldwin Poutress', 'apoutress18@gov.uk', 281-120-1246, 'Associate');
INSERT INTO Employee VALUES ('E0046', 'Sidonnie Giacubo', 'sgiacubo19@behance.net', 148-172-6916, 'Associate');
INSERT INTO Employee VALUES ('E0047', 'Chelsy Sowersby', 'csowersby1a@ow.ly', 562-769-6010, 'Associate');
INSERT INTO Employee VALUES ('E0048', 'Hedi Bownde', 'hbownde1b@opera.com', 830-273-9610, 'Vice-manager');
INSERT INTO Employee VALUES ('E0049', 'Sallyann Vaudre', 'svaudre1c@wisc.edu', 647-261-4002, 'Associate');
INSERT INTO Employee VALUES ('E0050', 'Milt Chatelain', 'mchatelain1d@4shared.com', 913-318-2895, 'Associate');

INSERT INTO Employee VALUES ('E0051', 'Debra Bart', 'dbart1e@fastcompany.com', 457-667-1343, 'Associate');
INSERT INTO Employee VALUES ('E0052', 'Giorgio Verdon', 'gverdon1f@stanford.edu', 177-719-7424, 'Associate');
INSERT INTO Employee VALUES ('E0053', 'Tersina Simmonds', 'tsimmonds1g@dailymotion.com', 398-247-4332, 'Associate');
INSERT INTO Employee VALUES ('E0054', 'Hardy Kellaway', 'hkellaway1h@squidoo.com', 951-974-3874, 'Associate');
INSERT INTO Employee VALUES ('E0055', 'Dominica Ughini', 'dughini1i@goo.gl', 297-666-5219, 'Associate');
INSERT INTO Employee VALUES ('E0056', 'Nappy Benko', 'nbenko1j@plala.or.jp', 919-639-5132, 'Vice-manager');
INSERT INTO Employee VALUES ('E0057', 'Savina Rockall', 'srockall1k@yahoo.co.jp', 404-699-9599, 'Associate');
INSERT INTO Employee VALUES ('E0058', 'Susanetta Claessens', 'sclaessens1l@earthlink.net', 583-314-7504, 'Associate');
INSERT INTO Employee VALUES ('E0059', 'Ketty Drugan', 'kdrugan1m@reuters.com', 810-941-0032, 'Associate');
INSERT INTO Employee VALUES ('E0060', 'Waylon Carnell', 'wcarnell1n@oracle.com', 395-101-4184, 'Associate');

INSERT INTO Employee VALUES ('E0061', 'Janek Hatje', 'jhatje1o@opensource.org', 605-714-7008, 'Vice-manager');
INSERT INTO Employee VALUES ('E0062', 'Gary Leeb', 'gleeb1p@indiegogo.com', 854-140-5694, 'Associate');
INSERT INTO Employee VALUES ('E0063', 'Hildy Goodhay', 'hgoodhay1q@dot.gov', 756-570-3995, 'Associate');
INSERT INTO Employee VALUES ('E0064', 'Lynea Killingworth', 'lkillingworth1r@businesswire.com', 413-770-8346, 'Associate');
INSERT INTO Employee VALUES ('E0065', 'Wenonah Hyam', 'whyam1s@nyu.edu', 148-572-5024, 'Associate');
INSERT INTO Employee VALUES ('E0066', 'Zandra Capenor', 'zcapenor1t@printfriendly.com', 757-117-4930, 'Associate');
INSERT INTO Employee VALUES ('E0067', 'Arman Wooller', 'awooller1u@networksolutions.com', 547-660-8888, 'Associate');
INSERT INTO Employee VALUES ('E0068', 'Dinny Garstan', 'dgarstan1v@google.pl', 402-658-0651, 'Associate');
INSERT INTO Employee VALUES ('E0069', 'Roderich Milmore', 'rmilmore1w@g.co', 735-170-2041, 'Associate');
INSERT INTO Employee VALUES ('E0070', 'Mort Claige', 'mclaige1x@ucsd.edu', 593-667-5119, 'Associate');

INSERT INTO Employee VALUES ('E0071', 'Justinian Patshull', 'jpatshull1y@house.gov', 113-859-1974, 'Associate');
INSERT INTO Employee VALUES ('E0072', 'Abeu Debney', 'adebney1z@sfgate.com', 340-871-5853, 'Vice-manager');
INSERT INTO Employee VALUES ('E0073', 'Agnola Normant', 'anormant20@yellowbook.com', 595-142-8111, 'Associate');
INSERT INTO Employee VALUES ('E0074', 'Maryellen Sadler', 'msadler21@ihg.com', 927-398-0447, 'Associate');
INSERT INTO Employee VALUES ('E0075', 'Georgeta Elderkin', 'gelderkin22@va.gov', 389-503-9697, 'Associate');
INSERT INTO Employee VALUES ('E0076', 'Alberik Harvard', 'aharvard23@eepurl.com', 413-622-1181, 'Associate');
INSERT INTO Employee VALUES ('E0077', 'Otes Clausner', 'oclausner24@epa.gov', 607-454-9621, 'Associate');
INSERT INTO Employee VALUES ('E0078', 'Shoshana Eglin', 'seglin25@wunderground.com', 582-622-3691, 'Associate');
INSERT INTO Employee VALUES ('E0079', 'Toby Slite', 'tslite26@mozilla.org', 916-328-4775, 'Associate');
INSERT INTO Employee VALUES ('E0080', 'Jocelyne Hayller', 'jhayller27@dagondesign.com', 381-274-7566, 'Associate');

INSERT INTO Employee VALUES ('E0081', 'Neysa Garbutt', 'ngarbutt28@furl.net', 802-211-0153, 'Associate');
INSERT INTO Employee VALUES ('E0082', 'Clarance Kybbye', 'ckybbye29@state.tx.us', 683-695-4761, 'Associate');
INSERT INTO Employee VALUES ('E0083', 'Devland Bratcher', 'dbratcher2a@scribd.com', 866-736-4607, 'Associate');
INSERT INTO Employee VALUES ('E0084', 'Eda Netting', 'enetting2b@comcast.net', 973-563-2515, 'Associate');
INSERT INTO Employee VALUES ('E0085', 'Shaw McCahey', 'smccahey2c@eventbrite.com', 451-648-2731, 'Associate');
INSERT INTO Employee VALUES ('E0086', 'Elijah Deelay', 'edeelay2d@cnbc.com', 751-757-8810, 'Vice-manager');
INSERT INTO Employee VALUES ('E0087', 'Pattin Cassam', 'pcassam2e@simplemachines.org', 937-139-2705, 'Associate');
INSERT INTO Employee VALUES ('E0088', 'Annaliese Deaville', 'adeaville2f@chron.com', 754-905-7483, 'Associate');
INSERT INTO Employee VALUES ('E0089', 'Baily Tropman', 'btropman2g@homestead.com', 120-463-5855, 'Associate');
INSERT INTO Employee VALUES ('E0090', 'Jasmina Gianninotti', 'jgianninotti2h@webmd.com', 244-934-6227, 'Associate');

INSERT INTO Employee VALUES ('E0091', 'Alejandra Jorcke', 'ajorcke2i@sciencedaily.com', 499-563-1233, 'Associate');
INSERT INTO Employee VALUES ('E0092', 'Lesley Sturges', 'lsturges2j@earthlink.net', 278-202-9979, 'Associate');
INSERT INTO Employee VALUES ('E0093', 'Don Maulden', 'dmaulden2k@apache.org', 476-572-8604, 'Associate');
INSERT INTO Employee VALUES ('E0094', 'Daniela Waldren', 'dwaldren2l@homestead.com', 279-533-6058, 'Associate');
INSERT INTO Employee VALUES ('E0095', 'Barri Banane', 'bbanane2m@virginia.edu', 116-143-6099, 'Associate');
INSERT INTO Employee VALUES ('E0096', 'Leticia Lidyard', 'llidyard2n@is.gd', 470-406-5004, 'Associate');
INSERT INTO Employee VALUES ('E0097', 'Krissy Blaydon', 'kblaydon2o@sourceforge.net', 796-171-3192, 'Associate');
INSERT INTO Employee VALUES ('E0098', 'Gerry Veasey', 'gveasey2p@cbslocal.com', 683-945-4127, 'Associate');
INSERT INTO Employee VALUES ('E0099', 'Frazier Fibbens', 'ffibbens2q@seesaa.net', 743-564-1251, 'Vice-manager');
INSERT INTO Employee VALUES ('E0100', 'Gayel Matyja', 'gmatyja2r@deviantart.com', 559-304-2938, 'Associate');

--Toy
INSERT INTO Toy VALUES ('T0001', 'Never Teenage Mutant Ninja Popper', 'Electronic', 115.00, 6.90, 121.90, 72);
INSERT INTO Toy VALUES ('T0002', 'Gonna Beanie SuperBall', 'Mechanical', 430.10, 25.81, 455.91, 42);
INSERT INTO Toy VALUES ('T0003', 'Give Hoop', 'Electronic', 241.00, 14.46, 255.46, 83);
INSERT INTO Toy VALUES ('T0004', 'You Silly Baby', 'Weapon', 878.60, 52.72, 931.32, 63);
INSERT INTO Toy VALUES ('T0005', 'Up Frozen Buddy', 'Puzzle', 952.90, 57.17, 1010.07, 74);
INSERT INTO Toy VALUES ('T0006', 'Never Ant Shoes', 'Vehicle', 147.00, 8.82, 155.82, 56);
INSERT INTO Toy VALUES ('T0007', 'Gonna African Hoop', 'Traditional', 849.30, 50.96, 900.26, 28);
INSERT INTO Toy VALUES ('T0008', 'Let Chemistry Football', 'Vehicle', 104.60, 6.28, 110.88, 49);
INSERT INTO Toy VALUES ('T0009', 'You Rainbow Putty', 'Traditional', 378.20, 22.69, 400.89, 24);
INSERT INTO Toy VALUES ('T0010', 'Down Japanese Clubbing', 'Educational', 742.50, 44.55, 787.05, 73);

INSERT INTO Toy VALUES ('T0011', 'Candy Elmo', 'Traditional', 619.60, 37.17, 656.77, 80);
INSERT INTO Toy VALUES ('T0012', 'Stick Hoop', 'Educational', 611.20, 36.67, 647.87, 71);
INSERT INTO Toy VALUES ('T0013', 'Game Cube', 'Traditional', 633.90, 38.03, 671.93, 68);
INSERT INTO Toy VALUES ('T0014', 'Moon Elmo', 'Mechanical', 190.20, 11.41, 201.61, 79);
INSERT INTO Toy VALUES ('T0015', 'Little Kitty', 'Traditional', 584.70, 35.08, 619.78, 55);
INSERT INTO Toy VALUES ('T0016', 'Snoopy Doll', 'Puzzle', 985.90, 59.15, 1045.05, 6);
INSERT INTO Toy VALUES ('T0017', 'Magma in my pocket', 'Traditional', 220.50, 13.23, 233.73, 17);
INSERT INTO Toy VALUES ('T0018', 'Moon Dinks', 'Mechanical', 224.70, 13.48, 238.18, 94);
INSERT INTO Toy VALUES ('T0019', 'Slip n Wagon', 'Traditional', 47.90, 2.87, 50.77, 83);
INSERT INTO Toy VALUES ('T0020', 'Celebrity Doodle', 'Mascot', 728.00, 43.68, 771.68, 50);

INSERT INTO Toy VALUES ('T0021', 'Joy Cozy Coupe Car', 'Mascot', 782.10, 46.93, 829.03, 18);
INSERT INTO Toy VALUES ('T0022', 'Mouse Monkeys', 'Vehicle', 37.70, 2.26, 39.96, 35);
INSERT INTO Toy VALUES ('T0023', 'Joy Puppy', 'Weapon', 868.80, 52.12, 920.92, 93);
INSERT INTO Toy VALUES ('T0024', 'Ken Men', 'Transforming', 244.30, 14.66, 258.96, 73);
INSERT INTO Toy VALUES ('T0025', 'Barrel of Doodle', 'Vehicle', 927.20, 55.63, 982.83, 37);
INSERT INTO Toy VALUES ('T0026', 'Pogo Trap', 'Educational', 809.30, 48.56, 857.86, 14);
INSERT INTO Toy VALUES ('T0027', 'Groovy Puppy', 'Vehicle', 154.50, 9.27, 163.77, 53);
INSERT INTO Toy VALUES ('T0028', 'Ant Transformers', 'Transforming', 515.30, 30.92, 546.22, 12);
INSERT INTO Toy VALUES ('T0029', 'Creepy Set', 'Educational', 471.60, 28.30, 499.90, 65);
INSERT INTO Toy VALUES ('T0030', 'Voodoo Bear', 'Vehicle', 680.80, 40.85, 721.65, 90);

INSERT INTO Toy VALUES ('T0031', 'Army House', 'Robot', 714.60, 42.88, 757.48, 59);
INSERT INTO Toy VALUES ('T0032', 'Art House', 'Puzzle', 563.40, 33.80, 597.20, 96);
INSERT INTO Toy VALUES ('T0033', 'Build by itself Kitty', 'Educational', 909.30, 54.56, 963.86, 15);
INSERT INTO Toy VALUES ('T0034', 'Hula Bricks', 'Transforming', 224.70, 15.28, 239.98, 3);
INSERT INTO Toy VALUES ('T0035', 'Groovy Sno-Cone Machine', 'Mechanical', 799.50, 47.97, 847.47, 85);
INSERT INTO Toy VALUES ('T0036', 'My Little Jack', 'Mascot', 792.30, 47.54, 839.84, 83);
INSERT INTO Toy VALUES ('T0037', 'Tickle Me Elmo', 'Mascot', 548.00, 32.88, 580.88, 82);
INSERT INTO Toy VALUES ('T0038', 'Slot Set', 'Mechanical', 790.10, 47.41, 837.51, 29);
INSERT INTO Toy VALUES ('T0039', 'Chemistry Worm', 'Transforming', 909.00, 54.54, 963.54, 66);
INSERT INTO Toy VALUES ('T0040', 'Two-Handed Truck', 'Puzzle', 354.50, 21.27, 375.77, 45);

INSERT INTO Toy VALUES ('T0041', 'Rag Puppy', 'Traditional', 945.50, 56.73, 1000.23, 69);
INSERT INTO Toy VALUES ('T0042', 'Teenage Mutant Ninja Stick', 'Weapon', 672.40, 40.35, 712.75, 48);
INSERT INTO Toy VALUES ('T0043', 'Slap Pony', 'Weapon', 167.00, 10.02, 177.02, 13);
INSERT INTO Toy VALUES ('T0044', 'Creepy Skip-It', 'Educational', 802.70, 48.16, 850.86, 14);
INSERT INTO Toy VALUES ('T0045', 'Black Pony', 'Vehicle', 844.40, 50.66, 895.06, 85);
INSERT INTO Toy VALUES ('T0046', 'Cozy Monkeys', 'Puzzle', 762.80, 75.77, 808.57, 16);
INSERT INTO Toy VALUES ('T0047', 'Corn BB Gun', 'Vehicle', 478.30, 28.70, 507.00, 66);
INSERT INTO Toy VALUES ('T0048', 'Teenage Mutant Ninja Bear', 'Puzzle', 951.70, 57.10, 1008.80, 7);
INSERT INTO Toy VALUES ('T0049', 'Rag Set', 'Mascot', 375.70, 22.54, 398.24, 31);
INSERT INTO Toy VALUES ('T0050', 'Corn BB Gun', 'Robot', 295.00, 17.70, 312.70, 80);

INSERT INTO Toy VALUES ('T0051', 'Creepy Car', 'Vehicle', 368.80, 22.13, 390.93, 98);
INSERT INTO Toy VALUES ('T0052', 'Pet Monkeys', 'Mechanical', 555.60, 33.34, 588.94, 87);
INSERT INTO Toy VALUES ('T0053', 'Stuffed Lightyear', 'Transforming', 714.00, 42.84, 756.84, 73);
INSERT INTO Toy VALUES ('T0054', 'USB Crawlers', 'Traditional', 153.20, 9.19, 162.39, 47);
INSERT INTO Toy VALUES ('T0055', 'Beanie SuperBall', 'Electronic', 308.50, 18.51, 327.01, 9);
INSERT INTO Toy VALUES ('T0056', 'Wiffle Trap', 'Transforming', 828.90, 49.73, 878.63, 80);
INSERT INTO Toy VALUES ('T0057', 'Digital Action Figure', 'Traditional', 195.90, 11.75, 207.65, 53);
INSERT INTO Toy VALUES ('T0058', 'Joy Men', 'Transforming', 569.20, 34.15, 603.35, 46);
INSERT INTO Toy VALUES ('T0059', 'Sea Car', 'Traditional', 187.00, 11.22, 198.22, 75);
INSERT INTO Toy VALUES ('T0060', 'Paper Monkeys', 'Vehicle', 12.10, 0.73, 12.83, 5);

INSERT INTO Toy VALUES ('T0061', 'Creepy Truck', 'Vehicle', 695.60, 41.74, 737.34, 33);
INSERT INTO Toy VALUES ('T0062', 'Little Putty', 'Mechanical', 263.30, 15.80, 279.10, 43);
INSERT INTO Toy VALUES ('T0063', 'My Little Doll', 'Mascot', 930.30, 55.82, 986.12, 63);
INSERT INTO Toy VALUES ('T0064', 'Little Monkeys', 'Mechanical', 457.30, 27.44, 484.74, 77);
INSERT INTO Toy VALUES ('T0065', 'Juggling Lightyear', 'Traditional', 722.30, 43.34, 765.64, 61);
INSERT INTO Toy VALUES ('T0066', 'Bubble Doll', 'Mascot', 885.60, 53.14, 938.74, 53);
INSERT INTO Toy VALUES ('T0067', 'Japanese Girl Doll', 'Electronic', 988.00, 59.28, 1047.28, 79);
INSERT INTO Toy VALUES ('T0068', 'Mr. Bear', 'Robot', 940.30, 56.42, 996.72, 16);
INSERT INTO Toy VALUES ('T0069', 'Ant Set', 'Electronic', 419.90, 25.19, 445.09, 95);
INSERT INTO Toy VALUES ('T0070', 'Matchbox Slide', 'Puzzle', 405.60, 24.34, 429.94, 84);

INSERT INTO Toy VALUES ('T0071', 'Never Masters of the Universe Turtles', 'Electronic', 850.95, 51.06, 902.01, 71);
INSERT INTO Toy VALUES ('T0072', 'Gonna Mr. Doll', 'Vehicle', 185.83, 11.15, 196.98, 41);
INSERT INTO Toy VALUES ('T0073', 'Give Black Buzzer', 'Puzzle', 747.98, 44.88, 792.86, 29);
INSERT INTO Toy VALUES ('T0074', 'You Sock Slide', 'Transforming', 162.07, 9.72, 171.79, 90);
INSERT INTO Toy VALUES ('T0075', 'Up Dream Puppy', 'Traditional', 151.65, 9.10, 160.75, 16);
INSERT INTO Toy VALUES ('T0076', 'Never Erector Turtles', 'Weapon', 805.78, 48.35, 854.13, 81);
INSERT INTO Toy VALUES ('T0077', 'Gonna African Paint', 'Mascot', 857.07, 51.42, 908.49, 27);
INSERT INTO Toy VALUES ('T0078', 'Let Cozy People', 'Educational', 25.80, 1.55, 27.35, 8);
INSERT INTO Toy VALUES ('T0079', 'You Pet Alive', 'Mascot', 809.88, 48.59, 858.47, 85);
INSERT INTO Toy VALUES ('T0080', 'Down Mr. Buzzer', 'Transforming', 376.35, 22.58, 398.93, 72);

INSERT INTO Toy VALUES ('T0081', 'Juggling Action Figure', 'Vehicle', 754.89, 45.29, 800.18, 35);
INSERT INTO Toy VALUES ('T0082', 'Creepy Monkeys', 'Vehicle', 564.42, 33.87, 598.29, 42);
INSERT INTO Toy VALUES ('T0083', 'Barrel of Girls', 'Traditional', 691.84, 41.51, 733.35, 96);
INSERT INTO Toy VALUES ('T0084', 'Lite in my pocket', 'Educational', 194.87, 11.69, 206.56, 76);
INSERT INTO Toy VALUES ('T0085', 'Rocking Hoop', 'Robot', 771.42, 42.29, 817.71, 61);
INSERT INTO Toy VALUES ('T0086', 'Pet Monkeys', 'Mechanical', 13.40, 0.80, 14.20, 48);
INSERT INTO Toy VALUES ('T0087', 'Tickle Me Truck', 'Mechanical', 293.34, 17.60, 310.94, 16);
INSERT INTO Toy VALUES ('T0088', 'Shrinky Crawlers', 'Weapon', 985.6, 59.14, 1044.74, 97);
INSERT INTO Toy VALUES ('T0089', 'Candy Alive', 'Mechanical', 568.37, 34.11, 602.47, 20);
INSERT INTO Toy VALUES ('T0090', 'Radio-Controlled Puppy', 'Transforming', 869.24, 52.15, 912.39, 74);

INSERT INTO Toy VALUES ('T0091', 'Never Creepy Open', 'Traditional', 827.02, 49.62, 876.64, 69);
INSERT INTO Toy VALUES ('T0092', 'Gonna Celebrity Clubs', 'Robot', 949.56, 56.97, 1006.53, 65);
INSERT INTO Toy VALUES ('T0093', 'Give Silly Transformers', 'Transforming', 125.14, 7.51, 132.55, 44);
INSERT INTO Toy VALUES ('T0094', 'You Wrestling Stick', 'Vehicle', 20.45, 1.23, 21.68, 64);
INSERT INTO Toy VALUES ('T0095', 'Up Squeaky Bear', 'Puzzle', 368.68, 22.12, 390.80, 66);
INSERT INTO Toy VALUES ('T0096', 'Never Rainbow Shoes', 'Electronic', 133.09, 7.99, 141.08, 24);
INSERT INTO Toy VALUES ('T0097', 'Gonna Teenage Mutant Ninja Cube', 'Transforming', 867.72, 7.99, 141.08, 23);
INSERT INTO Toy VALUES ('T0098', 'Let Erector Cube', 'Mechanical', 525.57, 31.53, 557.10, 88);
INSERT INTO Toy VALUES ('T0099', 'You Masters of the Universe Pony', 'Electronic', 332.49, 19.95, 352.44, 46);
INSERT INTO Toy VALUES ('T0100', 'Down Candy Monkeys', 'Weapon', 462.25, 27.74, 489.99, 52);

INSERT INTO Toy VALUES ('T0101', 'Rainbow Log Cabin', 'Electronic', 422.00, NULL, NULL, 27);
INSERT INTO Toy VALUES ('T0102', 'Cozy Frisbee', 'Mechanical', 872.10, NULL, NULL, 17);
INSERT INTO Toy VALUES ('T0103', 'Sock Football', 'Electronic', 467.00, NULL, NULL, 21);
INSERT INTO Toy VALUES ('T0104', 'Silly Robots', 'Weapon', 266.60, NULL, NULL, 93);
INSERT INTO Toy VALUES ('T0105', 'Erector Boy', 'Puzzle', 772.90, NULL, NULL, 63);
INSERT INTO Toy VALUES ('T0106', 'Wiffle Stick', 'Vehicle', 92.00, NULL, NULL, 47);
INSERT INTO Toy VALUES ('T0107', 'Super Rocket Pistol', 'Traditional', 298.30, NULL, NULL, 74);
INSERT INTO Toy VALUES ('T0108', 'Model Doodle', 'Vehicle', 451.60, NULL, NULL, 100);
INSERT INTO Toy VALUES ('T0109', 'Boop Rocket Pistol', 'Traditional', 791.20, NULL, NULL, 92);
INSERT INTO Toy VALUES ('T0110', 'Digital Elmo', 'Educational', 610.50, NULL, NULL, 1);

INSERT INTO Toy VALUES ('T0111', 'Toss Man Doll', 'Traditional', 916.60, NULL, NULL, 12);
INSERT INTO Toy VALUES ('T0112', 'My Little Car', 'Educational', 298.20, NULL, NULL, 79);
INSERT INTO Toy VALUES ('T0113', 'Paper Furby', 'Traditional', 859.90, NULL, NULL, 35);
INSERT INTO Toy VALUES ('T0114', 'Pretty Girls', 'Mechanical', 810.20, NULL, NULL, 7);
INSERT INTO Toy VALUES ('T0115', 'Celebrity Boy', 'Traditional', 944.70, NULL, NULL, 66);
INSERT INTO Toy VALUES ('T0116', 'Silly Doll', 'Puzzle', 562.90, NULL, NULL, 36);
INSERT INTO Toy VALUES ('T0117', 'Wiffle Robots', 'Traditional', 326.50, NULL, NULL, 81);
INSERT INTO Toy VALUES ('T0118', 'Slap Men', 'Mechanical', 808.70, NULL, NULL, 65);
INSERT INTO Toy VALUES ('T0119', 'Game Dinks', 'Traditional', 690.90, NULL, NULL, 53);
INSERT INTO Toy VALUES ('T0120', 'Little Skip-It', 'Mascot', 562.00, NULL, NULL, 10);

INSERT INTO Toy VALUES ('T0121', 'Chemistry Horse', 'Mascot', 586.10, NULL, NULL, 27);
INSERT INTO Toy VALUES ('T0122', 'Barrel of Dinks', 'Vehicle', 175.70, NULL, NULL, 82);
INSERT INTO Toy VALUES ('T0123', 'Buzz Skates', 'Weapon', 866.80, NULL, NULL, 25);
INSERT INTO Toy VALUES ('T0124', 'Puppy Set', 'Transforming', 356.30, NULL, NULL, 96);
INSERT INTO Toy VALUES ('T0125', 'Erector Buzzer', 'Vehicle', 499.20, NULL, NULL, 18);
INSERT INTO Toy VALUES ('T0126', 'Pogo Land', 'Educational', 475.30, NULL, NULL, 46);
INSERT INTO Toy VALUES ('T0127', 'Troll Furby', 'Vehicle', 971.50, NULL, NULL, 72);
INSERT INTO Toy VALUES ('T0128', 'Easy-Bake Land', 'Transforming', 867.30, NULL, NULL, 53);
INSERT INTO Toy VALUES ('T0129', 'Silly Baby', 'Educational', 328.60, NULL, NULL, 5);
INSERT INTO Toy VALUES ('T0130', 'Moon Monkeys', 'Vehicle', 180.80, NULL, NULL, 85);

INSERT INTO Toy VALUES ('T0131', 'Pony', 'Robot', 800.60, NULL, NULL, 67);
INSERT INTO Toy VALUES ('T0132', 'Wiffle Set', 'Puzzle', 122.40, NULL, NULL, 77);
INSERT INTO Toy VALUES ('T0133', 'Wrestling Wheels', 'Educational', 531.30, NULL, NULL, 30);
INSERT INTO Toy VALUES ('T0134', 'G.I. Ball', 'Transforming', 664.70, NULL, NULL, 1);
INSERT INTO Toy VALUES ('T0135', 'American Boy', 'Mechanical', 224.50, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0136', 'Digital Pony', 'Mascot', 695.30, NULL, NULL, 26);
INSERT INTO Toy VALUES ('T0137', 'Erector Bricks', 'Mascot', 748.00, NULL, NULL, 97);
INSERT INTO Toy VALUES ('T0138', 'Beanie Glow Stick', 'Mechanical', 756.10, NULL, NULL, 10);
INSERT INTO Toy VALUES ('T0139', 'Slap Buzzer', 'Transforming', 763.00, NULL, NULL, 43);
INSERT INTO Toy VALUES ('T0140', 'Amish Clubs', 'Puzzle', 701.50, NULL, NULL, 42);

INSERT INTO Toy VALUES ('T0141', 'Mr. Buzzer', 'Traditional', 470.50, NULL, NULL, 83);
INSERT INTO Toy VALUES ('T0142', 'Hot Buzzer', 'Weapon', 213.40, NULL, NULL, 19);
INSERT INTO Toy VALUES ('T0143', 'Masters of the Universe Baby', 'Weapon', 364.00, NULL, NULL, 69);
INSERT INTO Toy VALUES ('T0144', 'Stick Monkeys', 'Educational', 566.70, NULL, NULL, 58);
INSERT INTO Toy VALUES ('T0145', 'Groovy Pony', 'Vehicle', 661.40, NULL, NULL, 82);
INSERT INTO Toy VALUES ('T0146', 'Amish Popper', 'Puzzle', 120.80, NULL, NULL, 6);
INSERT INTO Toy VALUES ('T0147', 'Voodoo Slide', 'Vehicle', 627.30, NULL, NULL, 29);
INSERT INTO Toy VALUES ('T0148', 'Shrinky Kitty', 'Puzzle', 682.70, NULL, NULL, 51);
INSERT INTO Toy VALUES ('T0149', 'Cozy Popper', 'Mascot', 224.70, NULL, NULL, 86);
INSERT INTO Toy VALUES ('T0150', 'Toy Doll', 'Robot', 729.00, NULL, NULL, 80);

INSERT INTO Toy VALUES ('T0151', 'Japanese Pony', 'Vehicle', 777.80, NULL, NULL, 15);
INSERT INTO Toy VALUES ('T0152', 'Lite Lightyear', 'Mechanical', 831.60, NULL, NULL, 87);
INSERT INTO Toy VALUES ('T0153', 'Apple Doll', 'Transforming', 174.00, NULL, NULL, 40);
INSERT INTO Toy VALUES ('T0154', 'Creepy Doll', 'Traditional', 754.20, NULL, NULL, 26);
INSERT INTO Toy VALUES ('T0155', 'Super Wheels', 'Electronic', 79.50, NULL, NULL, 10);
INSERT INTO Toy VALUES ('T0156', 'Frozen Crawlers', 'Transforming', 367.90, NULL, NULL, 61);
INSERT INTO Toy VALUES ('T0157', 'Barbie Clubs', 'Traditional', 874.90, NULL, NULL, 17);
INSERT INTO Toy VALUES ('T0158', 'Shrinky Shoes', 'Transforming', 1000.20, NULL, NULL, 12);
INSERT INTO Toy VALUES ('T0159', 'Sock Men', 'Traditional', 871.00, NULL, NULL, 88);
INSERT INTO Toy VALUES ('T0160', 'My Little Horse', 'Vehicle', 429.10, NULL, NULL, 33);

INSERT INTO Toy VALUES ('T0161', 'Roller Robots', 'Vehicle', 710.60, NULL, NULL, 14);
INSERT INTO Toy VALUES ('T0162', 'Slap Horse', 'Mechanical', 743.30, NULL, NULL, 82);
INSERT INTO Toy VALUES ('T0163', 'My Little Transformers', 'Mascot', 196.30, NULL, NULL, 96);
INSERT INTO Toy VALUES ('T0164', 'Space Puppy', 'Mechanical', 41.30, NULL, NULL, 95);
INSERT INTO Toy VALUES ('T0165', 'Radio-Controlled Wheels', 'Traditional', 657.30, NULL, NULL, 47);
INSERT INTO Toy VALUES ('T0166', 'Super Skip-It', 'Mascot', 702.60, NULL, NULL, 75);
INSERT INTO Toy VALUES ('T0167', 'Juggling Worm', 'Electronic', 431.00, NULL, NULL, 87);
INSERT INTO Toy VALUES ('T0168', 'Fashion Truck', 'Robot', 804.30, NULL, NULL, 59);
INSERT INTO Toy VALUES ('T0169', 'Snoopy Glow Stick', 'Electronic', 682.90, NULL, NULL, 86);
INSERT INTO Toy VALUES ('T0170', 'Moon Skip-It', 'Puzzle', 383.60, NULL, NULL, 9);

INSERT INTO Toy VALUES ('T0171', 'Koosh Dinks', 'Electronic', 413.95, NULL, NULL, 52);
INSERT INTO Toy VALUES ('T0172', 'Finger Bear', 'Vehicle', 284.83, NULL, NULL, 20);
INSERT INTO Toy VALUES ('T0173', 'Black Ball', 'Puzzle', 263.98, NULL, NULL, 24);
INSERT INTO Toy VALUES ('T0174', 'Art Wagon', 'Transforming', 52.07, NULL, NULL, 22);
INSERT INTO Toy VALUES ('T0175', 'Joy Hoop', 'Traditional', 908.65, NULL, NULL, 37);
INSERT INTO Toy VALUES ('T0176', 'Wiffle Truck', 'Weapon', 89.78, NULL, NULL, 66);
INSERT INTO Toy VALUES ('T0177', 'Mr. Lightyear', 'Mascot', 56.07, NULL, NULL, 90);
INSERT INTO Toy VALUES ('T0178', 'Slot Puzzle', 'Educational', 805.80, NULL, NULL, 30);
INSERT INTO Toy VALUES ('T0179', 'Game Log Cabin', 'Mascot', 411.88, NULL, NULL, 61);
INSERT INTO Toy VALUES ('T0180', 'Mouse Action Figure', 'Transforming', 404.35, NULL, NULL, 16);

INSERT INTO Toy VALUES ('T0181', 'Black Lightyear', 'Vehicle', 64.89, NULL, NULL, 36);
INSERT INTO Toy VALUES ('T0182', 'Fashion Monkeys', 'Vehicle', 923.42, NULL, NULL, 15);
INSERT INTO Toy VALUES ('T0183', 'Silly Pocket', 'Traditional', 317.84, NULL, NULL, 77);
INSERT INTO Toy VALUES ('T0184', 'Model Elmo', 'Educational', 475.87, NULL, NULL, 41);
INSERT INTO Toy VALUES ('T0185', 'Squeaky Puppy', 'Robot', 963.42, NULL, NULL, 93);
INSERT INTO Toy VALUES ('T0186', 'Easy-Bake Clubs', 'Mechanical', 46.40, NULL, NULL, 64);
INSERT INTO Toy VALUES ('T0187', 'Corn Elmo', 'Mechanical', 191.34, NULL, NULL, 85);
INSERT INTO Toy VALUES ('T0188', 'Easy-Bake Truck', 'Weapon', 603.60, NULL, NULL, 14);
INSERT INTO Toy VALUES ('T0189', 'Care Set', 'Mechanical', 70.37, NULL, NULL, 44);
INSERT INTO Toy VALUES ('T0190', 'Mr. Action Figure', 'Transforming', 559.24, NULL, NULL, 31);

INSERT INTO Toy VALUES ('T0191', 'Wrestling BB Gun', 'Traditional', 635.02, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0192', 'Jumping BB Gun', 'Robot', 274.56, NULL, NULL, 73);
INSERT INTO Toy VALUES ('T0193', 'Squeaky Doll', 'Transforming', 130.14, NULL, NULL, 62);
INSERT INTO Toy VALUES ('T0194', 'Glo Slide', 'Vehicle', 226.45, NULL, NULL, 4);
INSERT INTO Toy VALUES ('T0195', 'Snoopy Ball', 'Puzzle', 411.68, NULL, NULL, 77);
INSERT INTO Toy VALUES ('T0196', 'Easy-Bake Figure', 'Electronic', 730.09, NULL, NULL, 72);
INSERT INTO Toy VALUES ('T0197', 'Hot House', 'Transforming', 527.72, NULL, NULL, 1);
INSERT INTO Toy VALUES ('T0198', 'Boop Trap', 'Mechanical', 682.57, NULL, NULL, 46);
INSERT INTO Toy VALUES ('T0199', 'Army Doodle', 'Electronic', 523.59, NULL, NULL, 39);
INSERT INTO Toy VALUES ('T0200', 'Space Turtles', 'Weapon', 969.25, NULL, NULL, 63);

INSERT INTO Toy VALUES ('T0201', 'Space Elmo', 'Electronic', 603.00, NULL, NULL, 43);
INSERT INTO Toy VALUES ('T0202', 'Groovy Skates', 'Mechanical', 820.10, NULL, NULL, 87);
INSERT INTO Toy VALUES ('T0203', 'Magna Cozy Coupe Car', 'Electronic', 904.00, NULL, NULL, 64);
INSERT INTO Toy VALUES ('T0204', 'Squeaky Trap', 'Weapon', 472.60, NULL, NULL, 66);
INSERT INTO Toy VALUES ('T0205', 'Teenage Mutant Ninja Slide', 'Puzzle', 622.90, NULL, NULL, 86);
INSERT INTO Toy VALUES ('T0206', 'Digital Clubbing', 'Vehicle', 954.00, NULL, NULL, 63);
INSERT INTO Toy VALUES ('T0207', 'Easy-Bake Wagon', 'Traditional', 157.30, NULL, NULL, 92);
INSERT INTO Toy VALUES ('T0208', 'Magna Set', 'Vehicle', 112.60, NULL, NULL, 51);
INSERT INTO Toy VALUES ('T0209', 'G.I. Sno-Cone Machine', 'Traditional', 103.20, NULL, NULL, 20);
INSERT INTO Toy VALUES ('T0210', 'Moon Rocket Pistol', 'Educational', 578.50, NULL, NULL, 71);

INSERT INTO Toy VALUES ('T0211', 'Erector Football', 'Traditional', 975.60, NULL, NULL, 15);
INSERT INTO Toy VALUES ('T0212', 'Wiffle Putty', 'Educational', 280.20, NULL, NULL, 13);
INSERT INTO Toy VALUES ('T0213', 'Juggling Man Doll', 'Traditional', 113.90, NULL, NULL, 29);
INSERT INTO Toy VALUES ('T0214', 'Koosh Baby', 'Mechanical', 679.20, NULL, NULL, 91);
INSERT INTO Toy VALUES ('T0215', 'Slip n Glow Stick', 'Traditional', 99.70, NULL, NULL, 60);
INSERT INTO Toy VALUES ('T0216', 'Barbie Doll', 'Puzzle', 675.90, NULL, NULL, 87);
INSERT INTO Toy VALUES ('T0217', 'Super Truck', 'Traditional', 462.50, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0218', 'Pretty Pretty Turtles', 'Mechanical', 195.70, NULL, NULL, 75);
INSERT INTO Toy VALUES ('T0219', 'Apple Action Figure', 'Traditional', 948.90, NULL, NULL, 67);
INSERT INTO Toy VALUES ('T0220', 'Baby BB Gun', 'Mascot', 154.00, NULL, NULL, 62);

INSERT INTO Toy VALUES ('T0221', 'Joy Cozy Coupe Car', 'Mascot', 854.10, NULL, NULL, 33);
INSERT INTO Toy VALUES ('T0222', 'Mouse Monkeys', 'Vehicle', 337.70, NULL, NULL, 22);
INSERT INTO Toy VALUES ('T0223', 'Joy Puppy', 'Weapon', 141.80, NULL, NULL, 26);
INSERT INTO Toy VALUES ('T0224', 'Ken Men', 'Transforming', 189.30, NULL, NULL, 10);
INSERT INTO Toy VALUES ('T0225', 'Barrel of Doodle', 'Vehicle', 225.20, NULL, NULL, 1);
INSERT INTO Toy VALUES ('T0226', 'Pogo Trap', 'Educational', 800.30, NULL, NULL, 42);
INSERT INTO Toy VALUES ('T0227', 'Groovy Puppy', 'Vehicle', 121.50, NULL, NULL, 15);
INSERT INTO Toy VALUES ('T0228', 'Ant Transformers', 'Transforming', 667.30, NULL, NULL, 51);
INSERT INTO Toy VALUES ('T0229', 'Creepy Set', 'Educational', 349.60, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0230', 'Voodoo Bear', 'Vehicle', 471.80, NULL, NULL, 62);

INSERT INTO Toy VALUES ('T0231', 'Paper Monkey', 'Robot', 673.60, NULL, NULL, 57);
INSERT INTO Toy VALUES ('T0232', 'Water Shoes', 'Puzzle', 738.40, NULL, NULL, 39);
INSERT INTO Toy VALUES ('T0233', 'Jumping Car', 'Educational', 50.30, NULL, NULL, 46);
INSERT INTO Toy VALUES ('T0234', 'Shrinky Buddy', 'Transforming', 230.70, NULL, NULL, 3);
INSERT INTO Toy VALUES ('T0235', 'Joy BB Gun', 'Mechanical', 821.50, NULL, NULL, 26);
INSERT INTO Toy VALUES ('T0236', 'Build by itself Crawlers', 'Mascot', 217.30, NULL, NULL, 76);
INSERT INTO Toy VALUES ('T0237', 'Toss Puzzle', 'Mascot', 339.00, NULL, NULL, 21);
INSERT INTO Toy VALUES ('T0238', 'Puppy Frisbee', 'Mechanical', 308.10, NULL, NULL, 53);
INSERT INTO Toy VALUES ('T0239', 'Glo Paint', 'Transforming', 375.00, NULL, NULL, 59);
INSERT INTO Toy VALUES ('T0240', 'Beach Men', 'Puzzle', 823.50, NULL, NULL, 60);

INSERT INTO Toy VALUES ('T0241', 'Strawberry Wagon', 'Traditional', 580.50, NULL, NULL, 1);
INSERT INTO Toy VALUES ('T0242', 'Stick Clubbing', 'Weapon', 232.40, NULL, NULL, 67);
INSERT INTO Toy VALUES ('T0243', 'Creepy Popper', 'Weapon', 524.00, NULL, NULL, 76);
INSERT INTO Toy VALUES ('T0244', 'Apple Bricks', 'Educational', 415.70, NULL, NULL, 71);
INSERT INTO Toy VALUES ('T0245', 'Glo Set', 'Vehicle', 80.40, NULL, NULL, 53);
INSERT INTO Toy VALUES ('T0246', 'Slip n Sno-Cone Machine', 'Puzzle', 74.80, NULL, NULL, 49);
INSERT INTO Toy VALUES ('T0247', 'Model Clubbing', 'Vehicle', 332.30, NULL, NULL, 36);
INSERT INTO Toy VALUES ('T0248', 'Wiffle Puzzle', 'Puzzle', 201.70, NULL, NULL, 72);
INSERT INTO Toy VALUES ('T0249', 'Two-Handed Glow Stick', 'Mascot', 155.70, NULL, NULL, 9);
INSERT INTO Toy VALUES ('T0250', 'Fidget Glow Stick', 'Robot', 181.00, NULL, NULL, 11);

INSERT INTO Toy VALUES ('T0251', 'Model Oven', 'Vehicle', 427.80, NULL, NULL, 82);
INSERT INTO Toy VALUES ('T0252', 'Koosh Doodle', 'Mechanical', 494.60, NULL, NULL, 51);
INSERT INTO Toy VALUES ('T0253', 'Little Rocket Pistol', 'Transforming', 957.00, NULL, NULL, 75);
INSERT INTO Toy VALUES ('T0254', 'Tickle Me Monkey', 'Traditional', 309.20, NULL, NULL, 54);
INSERT INTO Toy VALUES ('T0255', 'Beach Doll', 'Electronic', 70.50, NULL, NULL, 48);
INSERT INTO Toy VALUES ('T0256', 'Glo Monkeys', 'Transforming', 877.90, NULL, NULL, 36);
INSERT INTO Toy VALUES ('T0257', 'Slap Kitty', 'Traditional', 158.90, NULL, NULL, 22);
INSERT INTO Toy VALUES ('T0258', 'Frisbee', 'Transforming', 663.20, NULL, NULL, 39);
INSERT INTO Toy VALUES ('T0259', 'My Little Train', 'Traditional', 927.00, NULL, NULL, 20);
INSERT INTO Toy VALUES ('T0260', 'Army Buzzer', 'Vehicle', 707.10, NULL, NULL, 92);

INSERT INTO Toy VALUES ('T0261', 'Wiffle Baby', 'Vehicle', 468.60, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0262', 'Moon Shoes', 'Mechanical', 352.30, NULL, NULL, 40);
INSERT INTO Toy VALUES ('T0263', 'Space Wagon', 'Mascot', 574.30, NULL, NULL, 55);
INSERT INTO Toy VALUES ('T0264', 'Teenage Mutant Ninja Trap', 'Mechanical', 222.30, NULL, NULL, 79);
INSERT INTO Toy VALUES ('T0265', 'Amish Ballon', 'Traditional', 154.30, NULL, NULL, 74);
INSERT INTO Toy VALUES ('T0266', 'Pocket Doodle', 'Mascot', 744.60, NULL, NULL, 68);
INSERT INTO Toy VALUES ('T0267', 'Candy Trap', 'Electronic', 235.00, NULL, NULL, 48);
INSERT INTO Toy VALUES ('T0268', 'Roller Stick', 'Robot', 988.30, NULL, NULL, 34);
INSERT INTO Toy VALUES ('T0269', 'Build by itself Doodle', 'Electronic', 114.90, NULL, NULL, 31);
INSERT INTO Toy VALUES ('T0270', 'Wrestling Stick', 'Puzzle', 608.60, NULL, NULL, 62);

INSERT INTO Toy VALUES ('T0271', 'Masters of the Universe Worm', 'Electronic', 558.95, NULL, NULL, 36);
INSERT INTO Toy VALUES ('T0272', 'Mouse Horse', 'Vehicle', 289.83, NULL, NULL, 34);
INSERT INTO Toy VALUES ('T0273', 'Radio-Controlled Action Figure', 'Puzzle', 674.98, NULL, NULL, 92);
INSERT INTO Toy VALUES ('T0274', 'Super Puppy', 'Transforming', 454.07, NULL, NULL, 10);
INSERT INTO Toy VALUES ('T0275', 'Japanese Soaker', 'Traditional', 519.65, NULL, NULL, 58);
INSERT INTO Toy VALUES ('T0276', 'Pogo Action Figure', 'Weapon', 74.78, NULL, NULL, 20);
INSERT INTO Toy VALUES ('T0277', 'Magna Slide', 'Mascot', 597.07, NULL, NULL, 27);
INSERT INTO Toy VALUES ('T0278', 'African Man Doll', 'Educational', 121.80, NULL, NULL, 7);
INSERT INTO Toy VALUES ('T0279', 'You Pet Alive', 'Mascot', 446.88, NULL, NULL, 40);
INSERT INTO Toy VALUES ('T0280', 'Slip n Girls', 'Transforming', 58.35, NULL, NULL, 61);

INSERT INTO Toy VALUES ('T0281', 'Slap Dinks', 'Vehicle', 348.89, NULL, NULL, 34);
INSERT INTO Toy VALUES ('T0282', 'Space Bear', 'Vehicle', 534.42, NULL, NULL, 45);
INSERT INTO Toy VALUES ('T0283', 'Sock Buzzer', 'Traditional', 165.84, NULL, NULL, 12);
INSERT INTO Toy VALUES ('T0284', 'Amish Transformers', 'Educational', 997.87, NULL, NULL, 59);
INSERT INTO Toy VALUES ('T0285', 'Barrel of Rocket Pistol', 'Robot', 43.42, NULL, NULL, 2);
INSERT INTO Toy VALUES ('T0286', 'Bop Furby', 'Mechanical', 273.40, NULL, NULL, 21);
INSERT INTO Toy VALUES ('T0287', 'Classic Bear', 'Mechanical', 367.34, NULL, NULL, 86);
INSERT INTO Toy VALUES ('T0288', 'Sock Set', 'Weapon', 721.60, NULL, NULL, 100);
INSERT INTO Toy VALUES ('T0289', 'Candy Rocket Pistol', 'Mechanical', 423.37, NULL, NULL, 33);
INSERT INTO Toy VALUES ('T0290', 'Water Football', 'Transforming', 377.24, NULL, NULL, 90);

INSERT INTO Toy VALUES ('T0291', 'Pop-up Hoop', 'Traditional', 432.02, NULL, NULL, 90);
INSERT INTO Toy VALUES ('T0292', 'Care in my pocket', 'Robot', 403.56, NULL, NULL, 6);
INSERT INTO Toy VALUES ('T0293', 'Groovy Toy', 'Transforming', 71.14, NULL, NULL, 63);
INSERT INTO Toy VALUES ('T0294', 'Voodoo Set', 'Vehicle', 744.45, NULL, NULL, 72);
INSERT INTO Toy VALUES ('T0295', 'Buzz Football', 'Puzzle', 25.68, NULL, NULL, 74);
INSERT INTO Toy VALUES ('T0296', 'Little BB Gun', 'Electronic', 876.09, NULL, NULL, 53);
INSERT INTO Toy VALUES ('T0297', 'Rage Buzzer', 'Transforming', 353.72, NULL, NULL, 5);
INSERT INTO Toy VALUES ('T0298', 'Tickle Me Cube', 'Mechanical', 309.57, NULL, NULL, 97);
INSERT INTO Toy VALUES ('T0299', 'Cozy Monkeys', 'Electronic', 654.49, NULL, NULL, 32);
INSERT INTO Toy VALUES ('T0300', 'Creepy Doll', 'Weapon', 70.25, NULL, NULL, 43);

--Supplier
INSERT INTO Supplier VALUES ('S0001', 'Kristina Castellani', 'kcastellani0@aol.com', '184-153-9186');
INSERT INTO Supplier VALUES ('S0002', 'Marcille Isacq', 'misacq1@salon.com', '155-352-2334');
INSERT INTO Supplier VALUES ('S0003', 'Bamby Westbury', 'bwestbury2@flickr.com', '483-283-8690');
INSERT INTO Supplier VALUES ('S0004', 'Barbabas Prene', 'bprene3@ustream.tv', '938-290-8890');
INSERT INTO Supplier VALUES ('S0005', 'Brunhilda Dunabie', 'bdunabie4@vimeo.com', '516-685-5264');
INSERT INTO Supplier VALUES ('S0006', 'Natalya Camlin', 'ncamlin5@jimdo.com', '842-185-5867');
INSERT INTO Supplier VALUES ('S0007', 'Waldo Caddick', 'wcaddick6@opensource.org', '485-709-3686');
INSERT INTO Supplier VALUES ('S0008', 'Austin MacNeilly', 'amacneilly7@printfriendly.com', '148-121-5909');
INSERT INTO Supplier VALUES ('S0009', 'Washington Yurov', 'wyurov8@stanford.edu', '464-636-2786');
INSERT INTO Supplier VALUES ('S0010', 'Allix Fallen', 'afallen9@ft.com', '880-196-9059');

INSERT INTO Supplier VALUES ('S0011', 'Blane Cawood', 'bcawooda@pagesperso-orange.fr', '745-541-9454');
INSERT INTO Supplier VALUES ('S0012', 'Erin Trimmell', 'etrimmellb@spiegel.de', '817-411-8287');
INSERT INTO Supplier VALUES ('S0013', 'Geneva Coldbathe', 'gcoldbathec@shinystat.com', '420-265-1318');
INSERT INTO Supplier VALUES ('S0014', 'Clive O''Nions', 'conionsd@craigslist.org', '495-162-3884');
INSERT INTO Supplier VALUES ('S0015', 'Cathryn Kitching', 'ckitchinge@elpais.com', '792-581-0956');
INSERT INTO Supplier VALUES ('S0016', 'Worthington Gabitis', 'wgabitisf@vinaora.com', '391-300-8092');
INSERT INTO Supplier VALUES ('S0017', 'Tiena Cocke', 'tcockeg@cyberchimps.com', '132-454-5038');
INSERT INTO Supplier VALUES ('S0018', 'Ivette Ottery', 'iotteryh@meetup.com', '528-894-5489');
INSERT INTO Supplier VALUES ('S0019', 'Valene Ethridge', 'vethridgei@flickr.com', '238-771-5102');
INSERT INTO Supplier VALUES ('S0020', 'Garrett Stredder', 'gstredderj@mlb.com', '493-940-6464');

INSERT INTO Supplier VALUES ('S0021', 'Aldric Panichelli', 'apanichellik@irs.gov', '683-330-8841');
INSERT INTO Supplier VALUES ('S0022', 'Lemar Canton', 'lcantonl@virginia.edu', '934-184-0942');
INSERT INTO Supplier VALUES ('S0023', 'Alice Benazet', 'abenazetm@hhs.gov', '620-147-2099');
INSERT INTO Supplier VALUES ('S0024', 'Robenia Ricci', 'rriccin@nps.gov', '134-497-4775');
INSERT INTO Supplier VALUES ('S0025', 'Bunni Shirley', 'bshirleyo@elpais.com', '206-337-8562');
INSERT INTO Supplier VALUES ('S0026', 'Sherye Ewens', 'sewensp@irs.gov', '185-936-6295');
INSERT INTO Supplier VALUES ('S0027', 'Diane O''Nion', 'donionq@google.it', '228-929-4952');
INSERT INTO Supplier VALUES ('S0028', 'Bianca Vodden', 'bvoddenr@senate.gov', '108-115-2670');
INSERT INTO Supplier VALUES ('S0029', 'Florri Scarffe', 'fscarffes@ca.gov', '529-742-9947');
INSERT INTO Supplier VALUES ('S0030', 'Anabella Panther', 'apanthert@netvibes.com', '207-185-5618');

INSERT INTO Supplier VALUES ('S0031', 'Geneva Hylden', 'ghyldenu@prnewswire.com', '583-353-7820');
INSERT INTO Supplier VALUES ('S0032', 'Britney MacRory', 'bmacroryv@tripod.com', '371-907-5831');
INSERT INTO Supplier VALUES ('S0033', 'Rivi Osgordby', 'rosgordbyw@google.es', '764-977-1694');
INSERT INTO Supplier VALUES ('S0034', 'Adelaida Browett', 'abrowettx@mozilla.com', '735-896-4718');
INSERT INTO Supplier VALUES ('S0035', 'Wileen Knightly', 'wknightlyy@acquirethisname.com', '183-267-9921');
INSERT INTO Supplier VALUES ('S0036', 'Brigham Rex', 'brexz@intel.com', '363-462-2338');
INSERT INTO Supplier VALUES ('S0037', 'Hollyanne Kleehuhler', 'hkleehuhler10@marriott.com', '713-761-6726');
INSERT INTO Supplier VALUES ('S0038', 'Maximilianus Loins', 'mloins11@wufoo.com', '790-127-7449');
INSERT INTO Supplier VALUES ('S0039', 'Jeno Shord', 'jshord12@wikispaces.com', '391-467-9083');
INSERT INTO Supplier VALUES ('S0040', 'Calla Clemmitt', 'cclemmitt13@ucoz.com', '315-549-7926');

INSERT INTO Supplier VALUES ('S0041', 'Freddie Humpherston', 'fhumpherston14@adobe.com', '662-592-3144');
INSERT INTO Supplier VALUES ('S0042', 'Robbi Davidsohn', 'rdavidsohn15@istockphoto.com', '863-194-2164');
INSERT INTO Supplier VALUES ('S0043', 'Jolene Aubert', 'jaubert16@harvard.edu', '284-568-2873');
INSERT INTO Supplier VALUES ('S0044', 'Mendie Bernhardt', 'mbernhardt17@netvibes.com', '710-996-8283');
INSERT INTO Supplier VALUES ('S0045', 'Hi Bohills', 'hbohills18@networksolutions.com', '977-473-3280');
INSERT INTO Supplier VALUES ('S0046', 'Henryetta Boow', 'hboow19@dell.com', '130-943-3902');
INSERT INTO Supplier VALUES ('S0047', 'Griselda Wormleighton', 'gwormleighton1a@angelfire.com', '860-809-1843');
INSERT INTO Supplier VALUES ('S0048', 'Zolly MacNeillie', 'zmacneillie1b@apple.com', '486-848-6453');
INSERT INTO Supplier VALUES ('S0049', 'Tabbie Ferrand', 'tferrand1c@dyndns.org', '642-473-1799');
INSERT INTO Supplier VALUES ('S0050', 'Valry Jozaitis', 'vjozaitis1d@senate.gov', '550-259-5151');

INSERT INTO Supplier VALUES ('S0051', 'Lanae Dranfield', 'ldranfield1e@earthlink.net', '133-551-5927');
INSERT INTO Supplier VALUES ('S0052', 'Cloe Godier', 'cgodier1f@java.com', '993-479-0107');
INSERT INTO Supplier VALUES ('S0053', 'Antone Sanham', 'asanham1g@adobe.com', '623-958-8367');
INSERT INTO Supplier VALUES ('S0054', 'Jude McFie', 'jmcfie1h@fotki.com', '279-311-1868');
INSERT INTO Supplier VALUES ('S0055', 'Raynell Gawthorpe', 'rgawthorpe1i@ow.ly', '249-891-6699');
INSERT INTO Supplier VALUES ('S0056', 'Morris Boolsen', 'mboolsen1j@purevolume.com', '312-940-8543');
INSERT INTO Supplier VALUES ('S0057', 'Dominique Ziemecki', 'dziemecki1k@instagram.com', '853-542-9525');
INSERT INTO Supplier VALUES ('S0058', 'Raynor Fairbard', 'rfairbard1l@narod.ru', '420-160-1331');
INSERT INTO Supplier VALUES ('S0059', 'Griff Vegas', 'gvegas1m@ibm.com', '644-796-3634');
INSERT INTO Supplier VALUES ('S0060', 'Nataline Trenbey', 'ntrenbey1n@ifeng.com', '877-246-3153');

INSERT INTO Supplier VALUES ('S0061', 'Vivie Dach', 'vdach1o@hexun.com', '111-248-3713');
INSERT INTO Supplier VALUES ('S0062', 'Elvina Grassin', 'egrassin1p@live.com', '110-998-7724');
INSERT INTO Supplier VALUES ('S0063', 'Puff Renzini', 'prenzini1q@cornell.edu', '708-162-3755');
INSERT INTO Supplier VALUES ('S0064', 'Llewellyn Blackmuir', 'lblackmuir1r@networkadvertising.org', '481-871-5952');
INSERT INTO Supplier VALUES ('S0065', 'Diana Paal', 'dpaal1s@hubpages.com', '339-213-7228');
INSERT INTO Supplier VALUES ('S0066', 'Annetta Jurisic', 'ajurisic1t@cbsnews.com', '602-465-9026');
INSERT INTO Supplier VALUES ('S0067', 'Lezlie Overstreet', 'loverstreet1u@weebly.com', '718-523-6669');
INSERT INTO Supplier VALUES ('S0068', 'Keven Lohmeyer', 'klohmeyer1v@ebay.co.uk', '402-193-6121');
INSERT INTO Supplier VALUES ('S0069', 'Teador Werndley', 'twerndley1w@about.com', '185-856-9692');
INSERT INTO Supplier VALUES ('S0070', 'Ollie Wratten', 'owratten1x@msn.com', '645-521-6789');

INSERT INTO Supplier VALUES ('S0071', 'Maryanne Dwerryhouse', 'mdwerryhouse1y@acquirethisname.com', '242-306-0543');
INSERT INTO Supplier VALUES ('S0072', 'Emerson May', 'emay1z@posterous.com', '710-980-6927');
INSERT INTO Supplier VALUES ('S0073', 'Karissa Lucia', 'klucia20@msu.edu', '185-122-2620');
INSERT INTO Supplier VALUES ('S0074', 'Dorise Dyerson', 'ddyerson21@hud.gov', '802-464-9574');
INSERT INTO Supplier VALUES ('S0075', 'Kalie Dallmann', 'kdallmann22@java.com', '466-396-8150');
INSERT INTO Supplier VALUES ('S0076', 'Lorrie McElhargy', 'lmcelhargy23@is.gd', '307-168-0239');
INSERT INTO Supplier VALUES ('S0077', 'Karin Showell', 'kshowell24@apple.com', '407-952-4278');
INSERT INTO Supplier VALUES ('S0078', 'Marwin Casazza', 'mcasazza25@dyndns.org', '806-438-2155');
INSERT INTO Supplier VALUES ('S0079', 'Puff Nunnerley', 'pnunnerley26@example.com', '140-127-0355');
INSERT INTO Supplier VALUES ('S0080', 'Garner Cursey', 'gcursey27@wix.com', '400-397-2929');

INSERT INTO Supplier VALUES ('S0081', 'Tarra Eye', 'teye28@etsy.com', '333-315-0830');
INSERT INTO Supplier VALUES ('S0082', 'Jerome Bugge', 'jbugge29@ameblo.jp', '137-596-3585');
INSERT INTO Supplier VALUES ('S0083', 'Elsa Rentelll', 'erentelll2a@yelp.com', '874-960-3386');
INSERT INTO Supplier VALUES ('S0084', 'Mala Brakewell', 'mbrakewell2b@hubpages.com', '683-886-5762');
INSERT INTO Supplier VALUES ('S0085', 'Georgy Fairley', 'gfairley2c@ihg.com', '996-376-9270');
INSERT INTO Supplier VALUES ('S0086', 'Torrence Brambley', 'tbrambley2d@amazon.co.uk', '782-879-2478');
INSERT INTO Supplier VALUES ('S0087', 'Isacco Plaster', 'iplaster2e@fema.gov', '217-696-8238');
INSERT INTO Supplier VALUES ('S0088', 'Oates McShane', 'omcshane2f@mtv.com', '797-842-8889');
INSERT INTO Supplier VALUES ('S0089', 'Ariel Elsmere', 'aelsmere2g@multiply.com', '257-724-4140');
INSERT INTO Supplier VALUES ('S0090', 'Nolie Starmont', 'nstarmont2h@newsvine.com', '109-626-6832');

INSERT INTO Supplier VALUES ('S0091', 'Carin Gormally', 'cgormally2i@ucsd.edu', '938-321-6686');
INSERT INTO Supplier VALUES ('S0092', 'Dael Asif', 'dasif2j@reddit.com', '513-874-4855');
INSERT INTO Supplier VALUES ('S0093', 'Cchaddie Jackes', 'cjackes2k@twitter.com', '318-536-7553');
INSERT INTO Supplier VALUES ('S0094', 'Brenden Morican', 'bmorican2l@hexun.com', '293-784-6371');
INSERT INTO Supplier VALUES ('S0095', 'Marya Penni', 'mpenni2m@constantcontact.com', '785-341-8933');
INSERT INTO Supplier VALUES ('S0096', 'Grove Yorke', 'gyorke2n@google.co.uk', '175-488-6430');
INSERT INTO Supplier VALUES ('S0097', 'Krystal Linacre', 'klinacre2o@creativecommons.org', '381-927-2565');
INSERT INTO Supplier VALUES ('S0098', 'Reta Castagnier', 'rcastagnier2p@shop-pro.jp', '478-121-4686');
INSERT INTO Supplier VALUES ('S0099', 'Verge Brockie', 'vbrockie2q@blogs.com', '415-883-9176');
INSERT INTO Supplier VALUES ('S0100', 'Rowan Logan', 'rlogan2r@imageshack.us', '227-734-1904');

--Payment
INSERT INTO Payment VALUES ('PY0000', null, null, null);
INSERT INTO Payment VALUES ('PY0001', 'Debit Card', '09-Aug-2022', '08:30:00');
INSERT INTO Payment VALUES ('PY0002', 'Credit Card', '29-Jun-2022', '08:00:00');
INSERT INTO Payment VALUES ('PY0003', 'Debit Card', '24-Jan-2023', '08:25:00');
INSERT INTO Payment VALUES ('PY0004', 'Cash', '28-Feb-2023', '08:15:00');
INSERT INTO Payment VALUES ('PY0005', 'Cash', '18-Jul-2022', '08:15:30');
INSERT INTO Payment VALUES ('PY0006', 'Cash', '15-Sep-2022', '09:15:00');
INSERT INTO Payment VALUES ('PY0007', 'Credit Card', '11-Oct-2022', '09:00:00');
INSERT INTO Payment VALUES ('PY0008', 'Cash', '13-Jan-2023', '09:30:00');
INSERT INTO Payment VALUES ('PY0009', 'Credit Card', '08-Mar-2023', '09:50:00');
INSERT INTO Payment VALUES ('PY0010', 'Debit Card', '22-Jul-2022', '09:05:00');

INSERT INTO Payment VALUES ('PY0011', 'Cash', '21-Jan-2023', '09:35:00');
INSERT INTO Payment VALUES ('PY0012', 'E-wallet', '16-Oct-2022', '09:45:00');
INSERT INTO Payment VALUES ('PY0013', 'Credit Card', '06-Nov-2022', '09:45:30');
INSERT INTO Payment VALUES ('PY0014', 'E-wallet', '19-Mar-2023', '10:45:30');
INSERT INTO Payment VALUES ('PY0015', 'Cash', '13-May-2022', '10:45:30');
INSERT INTO Payment VALUES ('PY0016', 'Debit Card', '13-Dec-2022', '10:45:30');
INSERT INTO Payment VALUES ('PY0017', 'Cash', '02-Nov-2022', '10:15:30');
INSERT INTO Payment VALUES ('PY0018', 'E-wallet', '22-Jun-2022', '10:30:30');
INSERT INTO Payment VALUES ('PY0019', 'Debit Card', '06-Feb-2023', '10:30:00');
INSERT INTO Payment VALUES ('PY0020', 'Cash', '21-Apr-2022', '10:10:00');

INSERT INTO Payment VALUES ('PY0021', 'Cash', '19-Oct-2022', '10:50:00');
INSERT INTO Payment VALUES ('PY0022', 'Cash', '13-Dec-2022', '10:40:00');
INSERT INTO Payment VALUES ('PY0023', 'Credit Card', '23-Aug-2022', '11:45:00');
INSERT INTO Payment VALUES ('PY0024', 'Cash', '05-Sep-2022', '11:45:30');
INSERT INTO Payment VALUES ('PY0025', 'Debit Card', '01-Aug-2022', '11:15:30');
INSERT INTO Payment VALUES ('PY0026', 'Debit Card', '24-Mar-2022', '11:35:30');
INSERT INTO Payment VALUES ('PY0027', 'Credit Card', '29-Aug-2022', '11:25:30');
INSERT INTO Payment VALUES ('PY0028', 'E-wallet', '03-May-2022', '11:25:00');
INSERT INTO Payment VALUES ('PY0029', 'Cash', '22-Feb-2023', '11:15:00');
INSERT INTO Payment VALUES ('PY0030', 'Cash', '01-Sep-2022', '11:45:00');

INSERT INTO Payment VALUES ('PY0031', 'E-wallet', '26-Feb-2023', '11:55:00');
INSERT INTO Payment VALUES ('PY0032', 'Cash', '26-Sep-2022', '12:55:00');
INSERT INTO Payment VALUES ('PY0033', 'Debit Card', '17-Jun-2022', '12:15:00');
INSERT INTO Payment VALUES ('PY0034', 'Debit Card', '18-Oct-2022', '12:35:00');
INSERT INTO Payment VALUES ('PY0035', 'Credit Card', '04-Nov-2022', '12:45:00');
INSERT INTO Payment VALUES ('PY0036', 'E-wallet', '18-Sep-2022', '12:25:00');
INSERT INTO Payment VALUES ('PY0037', 'E-wallet', '23-Aug-2022', '12:25:15');
INSERT INTO Payment VALUES ('PY0038', 'E-wallet', '21-Nov-2022', '12:55:15');
INSERT INTO Payment VALUES ('PY0039', 'E-wallet', '02-Jan-2023', '12:45:15');
INSERT INTO Payment VALUES ('PY0040', 'Credit Card', '24-Oct-2022', '12:35:15');

INSERT INTO Payment VALUES ('PY0041', 'Cash', '20-Oct-2022', '12:15:15');
INSERT INTO Payment VALUES ('PY0042', 'Credit Card', '04-Apr-2022', '12:15:30');
INSERT INTO Payment VALUES ('PY0043', 'Cash', '16-Jul-2022', '12:25:30');
INSERT INTO Payment VALUES ('PY0044', 'Credit Card', '05-Apr-2022', '12:55:30');
INSERT INTO Payment VALUES ('PY0045', 'Credit Card', '28-Jul-2022', '12:45:30');
INSERT INTO Payment VALUES ('PY0046', 'Cash', '12-Aug-2022', '12:05:30');
INSERT INTO Payment VALUES ('PY0047', 'E-wallet', '12-Dec-2022', '12:08:00');
INSERT INTO Payment VALUES ('PY0048', 'E-wallet', '16-Oct-2022', '13:15:00');
INSERT INTO Payment VALUES ('PY0049', 'E-wallet', '14-Apr-2022', '13:45:00');
INSERT INTO Payment VALUES ('PY0050', 'Credit Card', '24-Jun-2022', '13:25:00');

INSERT INTO Payment VALUES ('PY0051', 'Debit Card', '20-Apr-2022', '13:35:00');
INSERT INTO Payment VALUES ('PY0052', 'Cash', '23-Mar-2022', '13:20:30');
INSERT INTO Payment VALUES ('PY0053', 'E-wallet', '29-Oct-2022', '13:10:30');
INSERT INTO Payment VALUES ('PY0054', 'E-wallet', '11-Aug-2022', '13:40:30');
INSERT INTO Payment VALUES ('PY0055', 'Credit Card', '18-Jan-2023', '13:50:30');
INSERT INTO Payment VALUES ('PY0056', 'Credit Card', '20-Jul-2022', '13:55:30');
INSERT INTO Payment VALUES ('PY0057', 'Debit Card', '26-Aug-2022', '14:55:30');
INSERT INTO Payment VALUES ('PY0058', 'Credit Card', '03-May-2022', '14:45:30');
INSERT INTO Payment VALUES ('PY0059', 'Debit Card', '19-Nov-2022', '14:25:30');
INSERT INTO Payment VALUES ('PY0060', 'E-wallet', '13-Nov-2022', '14:35:30');

INSERT INTO Payment VALUES ('PY0061', 'Credit Card', '23-Feb-2023', '14:15:30');
INSERT INTO Payment VALUES ('PY0062', 'E-wallet', '23-Jul-2022', '14:15:15');
INSERT INTO Payment VALUES ('PY0063', 'Cash', '18-Apr-2022', '14:30:15');
INSERT INTO Payment VALUES ('PY0064', 'Debit Card', '14-Mar-2023', '14:35:15');
INSERT INTO Payment VALUES ('PY0065', 'Debit Card', '17-Jan-2023', '14:45:15');
INSERT INTO Payment VALUES ('PY0066', 'Cash', '15-Aug-2022', '14:55:15');
INSERT INTO Payment VALUES ('PY0067', 'Credit Card', '19-Apr-2022', '14:15:15');
INSERT INTO Payment VALUES ('PY0068', 'Credit Card', '22-Dec-2022', '14:25:15');
INSERT INTO Payment VALUES ('PY0069', 'Debit Card', '02-Oct-2022', '15:25:15');
INSERT INTO Payment VALUES ('PY0070', 'Debit Card', '18-Nov-2022', '15:35:15');

INSERT INTO Payment VALUES ('PY0071', 'Debit Card', '27-Nov-2022', '15:55:15');
INSERT INTO Payment VALUES ('PY0072', 'Debit Card', '13-Jan-2023', '15:25:15');
INSERT INTO Payment VALUES ('PY0073', 'Credit Card', '21-Nov-2022', '15:45:15');
INSERT INTO Payment VALUES ('PY0074', 'E-wallet', '10-Dec-2022', '15:45:30');
INSERT INTO Payment VALUES ('PY0075', 'Credit Card', '21-Jan-2023', '15:15:30');
INSERT INTO Payment VALUES ('PY0076', 'Debit Card', '09-Apr-2022', '15:45:30');
INSERT INTO Payment VALUES ('PY0077', 'Cash', '16-Jun-2022', '15:35:30');
INSERT INTO Payment VALUES ('PY0078', 'Credit Card', '25-Jan-2023', '15:25:30');
INSERT INTO Payment VALUES ('PY0079', 'Cash', '07-Sep-2022', '15:05:30');
INSERT INTO Payment VALUES ('PY0080', 'Credit Card', '29-Jun-2022', '15:55:30');

INSERT INTO Payment VALUES ('PY0081', 'Credit Card', '09-Jan-2023', '16:55:30');
INSERT INTO Payment VALUES ('PY0082', 'Cash', '07-May-2022', '16:25:30');
INSERT INTO Payment VALUES ('PY0083', 'E-wallet', '24-May-2022', '16:15:30');
INSERT INTO Payment VALUES ('PY0084', 'Cash', '28-Oct-2022', '16:15:00');
INSERT INTO Payment VALUES ('PY0085', 'Debit Card', '07-Mar-2023', '16:55:00');
INSERT INTO Payment VALUES ('PY0086', 'E-wallet', '27-Sep-2022', '16:25:00');
INSERT INTO Payment VALUES ('PY0087', 'Cash', '06-Feb-2023', '16:35:00');
INSERT INTO Payment VALUES ('PY0088', 'E-wallet', '21-Aug-2022', '16:05:00');
INSERT INTO Payment VALUES ('PY0089', 'Credit Card', '02-Aug-2022', '16:05:30');
INSERT INTO Payment VALUES ('PY0090', 'E-wallet', '13-Jul-2022', '16:25:30');

INSERT INTO Payment VALUES ('PY0091', 'E-wallet', '31-Oct-2022', '17:25:30');
INSERT INTO Payment VALUES ('PY0092', 'Cash', '09-Sep-2022', '17:45:30');
INSERT INTO Payment VALUES ('PY0093', 'E-wallet', '09-Dec-2022', '17:55:30');
INSERT INTO Payment VALUES ('PY0094', 'Credit Card', '17-Jun-2022', '18:55:30');
INSERT INTO Payment VALUES ('PY0095', 'Credit Card', '28-May-2022', '18:45:30');
INSERT INTO Payment VALUES ('PY0096', 'Cash', '11-Dec-2022', '18:35:30');
INSERT INTO Payment VALUES ('PY0097', 'Cash', '23-Jun-2022', '19:35:30');
INSERT INTO Payment VALUES ('PY0098', 'Credit Card', '21-Sep-2022', '19:45:00');
INSERT INTO Payment VALUES ('PY0099', 'Cash', '16-Jul-2022', '20:45:00');
INSERT INTO Payment VALUES ('PY0100', 'Credit Card', '01-Oct-2022', '20:35:00');

INSERT INTO Payment VALUES ('PY0101', 'Credit Card', '30-Apr-2022', '16:17:35');
INSERT INTO Payment VALUES ('PY0102', 'Credit Card', '02-Jun-2022', '11:40:15');
INSERT INTO Payment VALUES ('PY0103', 'Debit Card', '01-Sep-2022', '18:34:26');
INSERT INTO Payment VALUES ('PY0104', 'Cash', '12-Apr-2023', '09:48:34');
INSERT INTO Payment VALUES ('PY0105', 'Cash', '17-May-2022', '12:18:07');
INSERT INTO Payment VALUES ('PY0106', 'Cash', '23-Jan-2023', '08:08:14');
INSERT INTO Payment VALUES ('PY0107', 'Credit Card', '08-Sep-2022', '08:37:32');
INSERT INTO Payment VALUES ('PY0108', 'Cash', '24-Jun-2022', '15:29:56');
INSERT INTO Payment VALUES ('PY0109', 'Credit Card', '04-Feb-2023', '17:26:58');
INSERT INTO Payment VALUES ('PY0110', 'Debit Card', '17-Oct-2022', '10:33:59');

INSERT INTO Payment VALUES ('PY0111', 'Cash', '16-Nov-2022', '20:13:09');
INSERT INTO Payment VALUES ('PY0112', 'E-wallet', '15-Sep-2022', '11:45:06');
INSERT INTO Payment VALUES ('PY0113', 'Credit Card', '11-Jan-2023', '18:36:25');
INSERT INTO Payment VALUES ('PY0114', 'E-wallet', '13-Jun-2022', '19:15:07');
INSERT INTO Payment VALUES ('PY0115', 'Cash', '24-Feb-2023', '19:43:16');
INSERT INTO Payment VALUES ('PY0116', 'Debit Card', '03-Aug-2022', '19:25:31');
INSERT INTO Payment VALUES ('PY0117', 'Cash', '06-Sep-2022', '14:15:22');
INSERT INTO Payment VALUES ('PY0118', 'E-wallet', '12-Jun-2022', '15:11:39');
INSERT INTO Payment VALUES ('PY0119', 'Debit Card', '18-Sep-2022', '17:36:16');
INSERT INTO Payment VALUES ('PY0120', 'Cash', '20-Oct-2022', '20:52:28');

INSERT INTO Payment VALUES ('PY0121', 'Cash', '19-May-2022', '20:56:38');
INSERT INTO Payment VALUES ('PY0122', 'Cash', '04-May-2022', '14:59:07');
INSERT INTO Payment VALUES ('PY0123', 'Credit Card', '18-Sep-2022', '15:11:27');
INSERT INTO Payment VALUES ('PY0124', 'Cash', '04-Jun-2022', '09:37:08');
INSERT INTO Payment VALUES ('PY0125', 'Debit Card', '15-Dec-2022', '08:24:21');
INSERT INTO Payment VALUES ('PY0126', 'Debit Card', '19-Jan-2023', '10:54:53');
INSERT INTO Payment VALUES ('PY0127', 'Credit Card', '12-Dec-2022', '13:03:49');
INSERT INTO Payment VALUES ('PY0128', 'E-wallet', '21-Jan-2023', '08:15:45');
INSERT INTO Payment VALUES ('PY0129', 'Cash', '22-May-2022', '18:23:29');
INSERT INTO Payment VALUES ('PY0130', 'Cash', '16-Mar-2023', '08:15:45');

INSERT INTO Payment VALUES ('PY0131', 'E-wallet', '22-May-2022', '18:23:29');
INSERT INTO Payment VALUES ('PY0132', 'Cash', '16-Mar-2023', '15:55:19');
INSERT INTO Payment VALUES ('PY0133', 'Debit Card', '20-May-2022', '19:34:48');
INSERT INTO Payment VALUES ('PY0134', 'Debit Card', '18-Apr-2022', '09:57:06');
INSERT INTO Payment VALUES ('PY0135', 'Credit Card', '01-Jun-2022', '15:17:48');
INSERT INTO Payment VALUES ('PY0136', 'E-wallet', '30-Dec-2022', '11:31:15');
INSERT INTO Payment VALUES ('PY0137', 'E-wallet', '08-Mar-2023', '13:41:54');
INSERT INTO Payment VALUES ('PY0138', 'E-wallet', '27-Dec-2022', '17:59:19');
INSERT INTO Payment VALUES ('PY0139', 'E-wallet', '08-Apr-2023', '16:04:22');
INSERT INTO Payment VALUES ('PY0140', 'Credit Card', '27-Feb-2023', '18:08:04');

INSERT INTO Payment VALUES ('PY0141', 'Cash', '13-Nov-2022', '14:11:50');
INSERT INTO Payment VALUES ('PY0142', 'Credit Card', '17-Nov-2022', '14:26:32');
INSERT INTO Payment VALUES ('PY0143', 'Cash', '17-Feb-2023', '20:13:33');
INSERT INTO Payment VALUES ('PY0144', 'Credit Card', '27-Sep-2022', '15:33:24');
INSERT INTO Payment VALUES ('PY0145', 'Credit Card', '09-Jun-2022', '12:47:25');
INSERT INTO Payment VALUES ('PY0146', 'Cash', '21-Oct-2022', '16:32:52');
INSERT INTO Payment VALUES ('PY0147', 'E-wallet', '02-Jul-2022', '10:39:58');
INSERT INTO Payment VALUES ('PY0148', 'E-wallet', '31-Mar-2023', '19:00:15');
INSERT INTO Payment VALUES ('PY0149', 'E-wallet', '20-Mar-2023', '14:35:57');
INSERT INTO Payment VALUES ('PY0150', 'Credit Card', '19-Oct-2022', '19:21:58');

INSERT INTO Payment VALUES ('PY0151', 'Debit Card', '23-Nov-2022', '09:44:01');
INSERT INTO Payment VALUES ('PY0152', 'Cash', '02-Nov-2022', '09:44:01');
INSERT INTO Payment VALUES ('PY0153', 'E-wallet', '31-Jan-2023', '14:45:33');
INSERT INTO Payment VALUES ('PY0154', 'E-wallet', '15-Jan-2023', '10:51:08');
INSERT INTO Payment VALUES ('PY0155', 'Credit Card', '20-Oct-2022', '17:04:06');
INSERT INTO Payment VALUES ('PY0156', 'Credit Card', '17-Oct-2022', '10:55:12');
INSERT INTO Payment VALUES ('PY0157', 'Debit Card', '02-Jun-2022', '19:31:05');
INSERT INTO Payment VALUES ('PY0158', 'Credit Card', '24-Nov-2022', '10:42:15');
INSERT INTO Payment VALUES ('PY0159', 'Debit Card', '02-Jun-2022', '11:18:10');
INSERT INTO Payment VALUES ('PY0160', 'E-wallet', '19-Nov-2022', '14:38:15');

INSERT INTO Payment VALUES ('PY0161', 'Credit Card', '15-Jan-2023', '15:28:56');
INSERT INTO Payment VALUES ('PY0162', 'E-wallet', '31-Mar-2023', '12:48:05');
INSERT INTO Payment VALUES ('PY0163', 'Cash', '13-Jan-2023', '11:45:07');
INSERT INTO Payment VALUES ('PY0164', 'Debit Card', '27-Jul-2022', '10:55:25');
INSERT INTO Payment VALUES ('PY0165', 'Debit Card', '22-Jan-2023', '09:18:52');
INSERT INTO Payment VALUES ('PY0166', 'Cash', '31-Aug-2022', '18:30:23');
INSERT INTO Payment VALUES ('PY0167', 'Credit Card', '16-Oct-2022', '11:08:48');
INSERT INTO Payment VALUES ('PY0168', 'Credit Card', '19-Dec-2022', '11:24:40');
INSERT INTO Payment VALUES ('PY0169', 'Debit Card', '20-Aug-2022', '12:21:06');
INSERT INTO Payment VALUES ('PY0170', 'Debit Card', '23-Apr-2022', '20:12:07');

INSERT INTO Payment VALUES ('PY0171', 'Debit Card', '25-Jun-2022', '12:21:49');
INSERT INTO Payment VALUES ('PY0172', 'Debit Card', '15-Feb-2023', '19:40:54');
INSERT INTO Payment VALUES ('PY0173', 'Credit Card', '03-Mar-2023', '13:46:11');
INSERT INTO Payment VALUES ('PY0174', 'E-wallet', '22-Aug-2022', '19:06:04');
INSERT INTO Payment VALUES ('PY0175', 'Credit Card', '19-Jan-2023', '13:41:09');
INSERT INTO Payment VALUES ('PY0176', 'Debit Card', '10-Aug-2022', '12:31:14');
INSERT INTO Payment VALUES ('PY0177', 'Cash', '29-Nov-2022', '20:25:36');
INSERT INTO Payment VALUES ('PY0178', 'Credit Card', '08-Aug-2022', '08:15:39');
INSERT INTO Payment VALUES ('PY0179', 'Cash', '08-Nov-2022', '20:05:40');
INSERT INTO Payment VALUES ('PY0180', 'Credit Card', '22-Aug-2022', '16:55:27');

INSERT INTO Payment VALUES ('PY0181', 'Credit Card', '10-Jan-2023', '20:49:40');
INSERT INTO Payment VALUES ('PY0182', 'Cash', '06-Feb-2023', '19:46:48');
INSERT INTO Payment VALUES ('PY0183', 'E-wallet', '22-May-2022', '10:38:47');
INSERT INTO Payment VALUES ('PY0184', 'Cash', '31-Jan-2023', '15:19:33');
INSERT INTO Payment VALUES ('PY0185', 'Debit Card', '26-Oct-2022', '14:50:04');
INSERT INTO Payment VALUES ('PY0186', 'E-wallet', '04-Mar-2023', '12:18:06');
INSERT INTO Payment VALUES ('PY0187', 'Cash', '17-Dec-2022', '16:25:01');
INSERT INTO Payment VALUES ('PY0188', 'E-wallet', '28-Sep-2022', '12:47:42');
INSERT INTO Payment VALUES ('PY0189', 'Credit Card', '14-Aug-2022', '09:50:23');
INSERT INTO Payment VALUES ('PY0190', 'E-wallet', '17-Nov-2022', '12:36:24');

INSERT INTO Payment VALUES ('PY0191', 'E-wallet', '19-Feb-2023', '13:37:10');
INSERT INTO Payment VALUES ('PY0192', 'Cash', '13-Apr-2023', '11:57:00');
INSERT INTO Payment VALUES ('PY0193', 'E-wallet', '15-Oct-2022', '14:41:25');
INSERT INTO Payment VALUES ('PY0194', 'Credit Card', '18-Aug-2022', '10:17:38');
INSERT INTO Payment VALUES ('PY0195', 'Credit Card', '23-Jun-2022', '13:03:40');
INSERT INTO Payment VALUES ('PY0196', 'Cash', '22-Jan-2023', '10:39:36');
INSERT INTO Payment VALUES ('PY0197', 'Cash', '17-Aug-2022', '15:06:16');
INSERT INTO Payment VALUES ('PY0198', 'Credit Card', '01-May-2022', '20:08:44');
INSERT INTO Payment VALUES ('PY0199', 'Cash', '20-May-2022', '10:31:22');
INSERT INTO Payment VALUES ('PY0200', 'Credit Card', '23-Oct-2022', '15:34:46');

INSERT INTO Payment VALUES ('PY0201', 'Credit Card', '21-Jul-2022', '10:07:24');
INSERT INTO Payment VALUES ('PY0202', 'Credit Card', '26-Oct-2022', '20:24:51');
INSERT INTO Payment VALUES ('PY0203', 'Debit Card', '15-Oct-2022', '12:07:18');
INSERT INTO Payment VALUES ('PY0204', 'Cash', '02-Mar-2023', '13:25:30');
INSERT INTO Payment VALUES ('PY0205', 'Cash', '21-Mar-2022', '20:25:16');
INSERT INTO Payment VALUES ('PY0206', 'Cash', '27-Jul-2022', '14:14:13');
INSERT INTO Payment VALUES ('PY0207', 'Credit Card', '12-Dec-2022', '14:17:41');
INSERT INTO Payment VALUES ('PY0208', 'Cash', '07-Sep-2022', '12:57:51');
INSERT INTO Payment VALUES ('PY0209', 'Credit Card', '04-Oct-2022', '15:32:18');
INSERT INTO Payment VALUES ('PY0210', 'Debit Card', '03-Dec-2022', '20:24:55');

INSERT INTO Payment VALUES ('PY0211', 'Cash', '18-Jun-2022', '18:46:25');
INSERT INTO Payment VALUES ('PY0212', 'E-wallet', '26-Oct-2022', '09:02:57');
INSERT INTO Payment VALUES ('PY0213', 'Credit Card', '21-Oct-2022', '19:55:57');
INSERT INTO Payment VALUES ('PY0214', 'E-wallet', '14-Jan-2023', '09:42:55');
INSERT INTO Payment VALUES ('PY0215', 'Cash', '15-Sep-2022', '13:49:57');
INSERT INTO Payment VALUES ('PY0216', 'Debit Card', '06-Oct-2022', '20:30:27');
INSERT INTO Payment VALUES ('PY0217', 'Cash', '13-Nov-2022', '14:51:48');
INSERT INTO Payment VALUES ('PY0218', 'E-wallet', '07-Jul-2022', '12:03:03');
INSERT INTO Payment VALUES ('PY0219', 'Debit Card', '10-Feb-2023', '16:21:13');
INSERT INTO Payment VALUES ('PY0220', 'Cash', '10-Aug-2022', '14:10:41');

INSERT INTO Payment VALUES ('PY0221', 'Cash', '16-May-2022', '10:27:38');
INSERT INTO Payment VALUES ('PY0222', 'Cash', '08-Nov-2022', '19:35:39');
INSERT INTO Payment VALUES ('PY0223', 'Credit Card', '18-Jun-2022', '20:10:45');
INSERT INTO Payment VALUES ('PY0224', 'Cash', '26-Dec-2022', '09:58:34');
INSERT INTO Payment VALUES ('PY0225', 'Debit Card', '12-Sep-2022', '19:20:58');
INSERT INTO Payment VALUES ('PY0226', 'Debit Card', '01-Feb-2023', '11:45:09');
INSERT INTO Payment VALUES ('PY0227', 'Credit Card', '30-May-2022', '13:19:32');
INSERT INTO Payment VALUES ('PY0228', 'E-wallet', '02-Jan-2023', '17:40:51');
INSERT INTO Payment VALUES ('PY0229', 'Cash', '15-Aug-2022', '17:25:08');
INSERT INTO Payment VALUES ('PY0230', 'Cash', '02-Oct-2022', '09:32:09');

INSERT INTO Payment VALUES ('PY0231', 'E-wallet', '25-Jan-2023', '15:10:03');
INSERT INTO Payment VALUES ('PY0232', 'Cash', '20-Feb-2023', '20:30:16');
INSERT INTO Payment VALUES ('PY0233', 'Debit Card', '30-Nov-2022', '16:43:56');
INSERT INTO Payment VALUES ('PY0234', 'Debit Card', '13-Aug-2022', '20:10:52');
INSERT INTO Payment VALUES ('PY0235', 'Credit Card', '03-Jul-2022', '17:34:30');
INSERT INTO Payment VALUES ('PY0236', 'E-wallet', '07-Mar-2023', '08:49:19');
INSERT INTO Payment VALUES ('PY0237', 'E-wallet', '14-Jan-2023', '17:52:49');
INSERT INTO Payment VALUES ('PY0238', 'E-wallet', '08-Sep-2022', '20:35:36');
INSERT INTO Payment VALUES ('PY0239', 'E-wallet', '14-Feb-2023', '17:08:04');
INSERT INTO Payment VALUES ('PY0240', 'Credit Card', '12-Apr-2023', '16:57:26');

INSERT INTO Payment VALUES ('PY0241', 'Cash', '26-Apr-2022', '09:27:22');
INSERT INTO Payment VALUES ('PY0242', 'Credit Card', '09-Dec-2022', '12:35:18');
INSERT INTO Payment VALUES ('PY0243', 'Cash', '05-Jul-2022', '20:58:32');
INSERT INTO Payment VALUES ('PY0244', 'Credit Card', '08-Jun-2022', '13:43:05');
INSERT INTO Payment VALUES ('PY0245', 'Credit Card', '28-Oct-2022', '20:33:33');
INSERT INTO Payment VALUES ('PY0246', 'Cash', '23-Oct-2022', '16:01:29');
INSERT INTO Payment VALUES ('PY0247', 'E-wallet', '25-Jun-2022', '19:50:10');
INSERT INTO Payment VALUES ('PY0248', 'E-wallet', '20-Feb-2023', '13:19:09');
INSERT INTO Payment VALUES ('PY0249', 'E-wallet', '17-Jun-2022', '09:23:57');
INSERT INTO Payment VALUES ('PY0250', 'Credit Card', '14-Oct-2022', '12:01:41');

INSERT INTO Payment VALUES ('PY0251', 'Debit Card', '16-Jan-2023', '14:49:00');
INSERT INTO Payment VALUES ('PY0252', 'Cash', '14-Apr-2022', '14:29:10');
INSERT INTO Payment VALUES ('PY0253', 'E-wallet', '06-Feb-2023', '15:22:11');
INSERT INTO Payment VALUES ('PY0254', 'E-wallet', '28-Aug-2022', '20:49:10');
INSERT INTO Payment VALUES ('PY0255', 'Credit Card', '28-Mar-2023', '20:02:29');
INSERT INTO Payment VALUES ('PY0256', 'Credit Card', '20-Jun-2022', '11:11:35');
INSERT INTO Payment VALUES ('PY0257', 'Debit Card', '27-Aug-2022', '20:26:55');
INSERT INTO Payment VALUES ('PY0258', 'Credit Card', '08-Apr-2023', '20:52:52');
INSERT INTO Payment VALUES ('PY0259', 'Debit Card', '25-Dec-2022', '19:57:36');
INSERT INTO Payment VALUES ('PY0260', 'E-wallet', '06-Aug-2022', '17:19:50');

INSERT INTO Payment VALUES ('PY0261', 'Credit Card', '12-Apr-2023', '08:34:24');
INSERT INTO Payment VALUES ('PY0262', 'E-wallet', '28-Jul-2022', '10:58:12');
INSERT INTO Payment VALUES ('PY0263', 'Cash', '16-Mar-2023', '20:41:44');
INSERT INTO Payment VALUES ('PY0264', 'Debit Card', '04-Jun-2022', '13:56:11');
INSERT INTO Payment VALUES ('PY0265', 'Debit Card', '25-Jan-2023', '19:37:00');
INSERT INTO Payment VALUES ('PY0266', 'Cash', '23-Dec-2022', '18:37:14');
INSERT INTO Payment VALUES ('PY0267', 'Credit Card', '28-Sep-2022', '10:16:00');
INSERT INTO Payment VALUES ('PY0268', 'Credit Card', '09-May-2022', '08:34:35');
INSERT INTO Payment VALUES ('PY0269', 'Debit Card', '07-Jul-2022', '17:08:51');
INSERT INTO Payment VALUES ('PY0270', 'Debit Card', '22-Sep-2022', '08:01:38');

INSERT INTO Payment VALUES ('PY0271', 'Debit Card', '22-Oct-2022', '20:02:12');
INSERT INTO Payment VALUES ('PY0272', 'Debit Card', '14-Jan-2023', '08:32:09');
INSERT INTO Payment VALUES ('PY0273', 'Credit Card', '19-Jan-2023', '08:12:29');
INSERT INTO Payment VALUES ('PY0274', 'E-wallet', '14-Sep-2022', '08:18:51');
INSERT INTO Payment VALUES ('PY0275', 'Credit Card', '18-Aug-2022', '18:11:30');
INSERT INTO Payment VALUES ('PY0276', 'Debit Card', '17-Apr-2022', '12:54:32');
INSERT INTO Payment VALUES ('PY0277', 'Cash', '16-Apr-2022', '20:05:09');
INSERT INTO Payment VALUES ('PY0278', 'Credit Card', '04-Mar-2023', '14:59:38');
INSERT INTO Payment VALUES ('PY0279', 'Cash', '29-Jan-2023', '11:44:45');
INSERT INTO Payment VALUES ('PY0280', 'Credit Card', '30-Jul-2022', '10:52:57');

INSERT INTO Payment VALUES ('PY0281', 'Credit Card', '09-Aug-2022', '17:43:38');
INSERT INTO Payment VALUES ('PY0282', 'Cash', '27-Jan-2023', '10:54:12');
INSERT INTO Payment VALUES ('PY0283', 'E-wallet', '23-Oct-2022', '19:39:03');
INSERT INTO Payment VALUES ('PY0284', 'Cash', '14-Apr-2022', '09:14:31');
INSERT INTO Payment VALUES ('PY0285', 'Debit Card', '03-Oct-2022', '18:33:33');
INSERT INTO Payment VALUES ('PY0286', 'E-wallet', '20-Sep-2022', '12:36:03');
INSERT INTO Payment VALUES ('PY0287', 'Cash', '26-May-2022', '08:14:54');
INSERT INTO Payment VALUES ('PY0288', 'E-wallet', '06-Jul-2022', '12:35:45');
INSERT INTO Payment VALUES ('PY0289', 'Credit Card', '05-Feb-2023', '08:05:13');
INSERT INTO Payment VALUES ('PY0290', 'E-wallet', '14-Aug-2022', '14:51:13');

INSERT INTO Payment VALUES ('PY0291', 'E-wallet', '02-Sep-2022', '12:24:40');
INSERT INTO Payment VALUES ('PY0292', 'Cash', '28-Jan-2023', '11:08:19');
INSERT INTO Payment VALUES ('PY0293', 'E-wallet', '30-Sep-2022', '18:48:52');
INSERT INTO Payment VALUES ('PY0294', 'Credit Card', '13-Sep-2022', '15:05:35');
INSERT INTO Payment VALUES ('PY0295', 'Credit Card', '04-Jul-2022', '11:44:31');
INSERT INTO Payment VALUES ('PY0296', 'Cash', '13-Jul-2022', '09:16:29');
INSERT INTO Payment VALUES ('PY0297', 'Cash', '30-Dec-2022', '15:26:44');
INSERT INTO Payment VALUES ('PY0298', 'Credit Card', '13-Feb-2023', '18:54:35');
INSERT INTO Payment VALUES ('PY0299', 'Cash', '07-Sep-2022', '09:23:32');
INSERT INTO Payment VALUES ('PY0300', 'Credit Card', '18-Aug-2022', '10:47:22');

--Promotion
INSERT INTO Promotion VALUES('PR0000', NULL, 'None', 0, NULL, NULL);
INSERT INTO Promotion VALUES('PR0001', 0.15, 'Member Day', 1, '28-Jun-2022', '28-Jun-2022');
INSERT INTO Promotion VALUES('PR0002', 0.15, 'Member Day', 1, '28-Jul-2022', '28-Jul-2022');
INSERT INTO Promotion VALUES('PR0003', 0.15, 'Member Day', 1, '28-Aug-2022', '28-Aug-2022');
INSERT INTO Promotion VALUES('PR0004', 0.15, 'Member Day', 1, '28-Sep-2022', '28-Sep-2022');
INSERT INTO Promotion VALUES('PR0005', 0.15, 'Member Day', 1, '28-Oct-2022', '28-Oct-2022');
INSERT INTO Promotion VALUES('PR0006', 0.15, 'Member Day', 1, '28-Nov-2022', '28-Nov-2022');
INSERT INTO Promotion VALUES('PR0007', 0.15, 'Member Day', 1, '28-Dec-2022', '28-Dec-2022');
INSERT INTO Promotion VALUES('PR0008', 0.4, 'Year End Sale', 0, '01-Dec-2022', '31-Dec-2022');
INSERT INTO Promotion VALUES('PR0009', 0.2, 'Christmas Sale', 1, '25-Dec-2022', '25-Dec-2022');
INSERT INTO Promotion VALUES('PR0010', 0.3, 'New Year Sale', 0, '01-Jan-2023', '07-Jan-2023');

INSERT INTO Promotion VALUES('PR0011', 0.15, 'Member Day', 1, '28-Jan-2023', '28-Jan-2023');
INSERT INTO Promotion VALUES('PR0012', 0.15, 'Member Day', 1, '28-Feb-2023', '28-Feb-2023');
INSERT INTO Promotion VALUES('PR0013', 0.15, 'Member Day', 1, '28-Aug-2023', '28-Aug-2023');
INSERT INTO Promotion VALUES('PR0014', 0.15, 'Member Day', 1, '28-Sep-2023', '28-Sep-2023');
INSERT INTO Promotion VALUES('PR0015', 0.15, 'Member Day', 1, '28-Oct-2023', '28-Oct-2023');
INSERT INTO Promotion VALUES('PR0016', 0.15, 'Member Day', 1, '28-Nov-2023', '28-Nov-2023');
INSERT INTO Promotion VALUES('PR0017', 0.15, 'Member Day', 1, '28-Dec-2023', '28-Dec-2023');
INSERT INTO Promotion VALUES('PR0018', 0.4, 'Year End Sale', 0, '01-Dec-2023', '31-Dec-2023');
INSERT INTO Promotion VALUES('PR0019', 0.2, 'Christmas Sale', 1, '25-Dec-2023', '25-Dec-2023');
INSERT INTO Promotion VALUES('PR0020', 0.3, 'New Year Sale', 0, '01-Jan-2024', '07-Jan-2024');

INSERT INTO Promotion VALUES('PR0021', 0.15, 'Member Day', 1, '28-Jan-2024', '28-Jan-2024');
INSERT INTO Promotion VALUES('PR0022', 0.15, 'Member Day', 1, '28-Feb-2024', '28-Feb-2024');
INSERT INTO Promotion VALUES('PR0023', 0.15, 'Member Day', 1, '28-Aug-2024', '28-Aug-2024');
INSERT INTO Promotion VALUES('PR0024', 0.15, 'Member Day', 1, '28-Sep-2024', '28-Sep-2024');
INSERT INTO Promotion VALUES('PR0025', 0.15, 'Member Day', 1, '28-Oct-2024', '28-Oct-2024');
INSERT INTO Promotion VALUES('PR0026', 0.15, 'Member Day', 1, '28-Nov-2024', '28-Nov-2024');
INSERT INTO Promotion VALUES('PR0027', 0.15, 'Member Day', 1, '28-Dec-2024', '28-Dec-2024');
INSERT INTO Promotion VALUES('PR0028', 0.4, 'Year End Sale', 0, '01-Dec-2024', '31-Dec-2024');
INSERT INTO Promotion VALUES('PR0029', 0.2, 'Christmas Sale', 1, '25-Dec-2024', '25-Dec-2024');
INSERT INTO Promotion VALUES('PR0030', 0.3, 'New Year Sale', 0, '01-Jan-2023', '07-Jan-2025');

INSERT INTO Promotion VALUES('PR0031', 0.15, 'Member Day', 1, '28-Jan-2025', '28-Jan-2025');
INSERT INTO Promotion VALUES('PR0032', 0.15, 'Member Day', 1, '28-Feb-2025', '28-Feb-2025');
INSERT INTO Promotion VALUES('PR0033', 0.15, 'Member Day', 1, '28-Aug-2025', '28-Aug-2025');
INSERT INTO Promotion VALUES('PR0034', 0.15, 'Member Day', 1, '28-Sep-2025', '28-Sep-2025');
INSERT INTO Promotion VALUES('PR0035', 0.15, 'Member Day', 1, '28-Oct-2025', '28-Oct-2025');
INSERT INTO Promotion VALUES('PR0036', 0.15, 'Member Day', 1, '28-Nov-2025', '28-Nov-2025');
INSERT INTO Promotion VALUES('PR0037', 0.15, 'Member Day', 1, '28-Dec-2025', '28-Dec-2025');
INSERT INTO Promotion VALUES('PR0038', 0.4, 'Year End Sale', 0, '01-Dec-202', '31-Dec-2025');
INSERT INTO Promotion VALUES('PR0039', 0.2, 'Christmas Sale', 1, '25-Dec-2025', '25-Dec-2025');
INSERT INTO Promotion VALUES('PR0040', 0.3, 'New Year Sale', 0, '01-Jan-2026', '07-Jan-2026');

INSERT INTO Promotion VALUES('PR0041', 0.15, 'Member Day', 1, '28-Jan-2027', '28-Jan-2027');
INSERT INTO Promotion VALUES('PR0042', 0.15, 'Member Day', 1, '28-Feb-2027', '28-Feb-2027');
INSERT INTO Promotion VALUES('PR0043', 0.15, 'Member Day', 1, '28-Aug-2027', '28-Aug-2027');
INSERT INTO Promotion VALUES('PR0044', 0.15, 'Member Day', 1, '28-Sep-2027', '28-Sep-2027');
INSERT INTO Promotion VALUES('PR0045', 0.15, 'Member Day', 1, '28-Oct-2027', '28-Oct-2027');
INSERT INTO Promotion VALUES('PR0046', 0.15, 'Member Day', 1, '28-Nov-2027', '28-Nov-2027');
INSERT INTO Promotion VALUES('PR0047', 0.15, 'Member Day', 1, '28-Dec-2027', '28-Dec-2027');
INSERT INTO Promotion VALUES('PR0048', 0.4, 'Year End Sale', 0, '01-Dec-2027', '31-Dec-2027');
INSERT INTO Promotion VALUES('PR0049', 0.2, 'Christmas Sale', 1, '25-Dec-2027', '25-Dec-2027');
INSERT INTO Promotion VALUES('PR0050', 0.3, 'New Year Sale', 0, '01-Jan-2028', '07-Jan-2028');

INSERT INTO Promotion VALUES('PR0051', 0.15, 'Member Day', 1, '28-Jan-2029', '28-Jan-2029');
INSERT INTO Promotion VALUES('PR0052', 0.15, 'Member Day', 1, '28-Feb-2029', '28-Feb-2029');
INSERT INTO Promotion VALUES('PR0053', 0.15, 'Member Day', 1, '28-Aug-2029', '28-Aug-2029');
INSERT INTO Promotion VALUES('PR0054', 0.15, 'Member Day', 1, '28-Sep-2029', '28-Sep-2029');
INSERT INTO Promotion VALUES('PR0055', 0.15, 'Member Day', 1, '28-Oct-2029', '28-Oct-2029');
INSERT INTO Promotion VALUES('PR0056', 0.15, 'Member Day', 1, '28-Nov-2029', '28-Nov-2029');
INSERT INTO Promotion VALUES('PR0057', 0.15, 'Member Day', 1, '28-Dec-2029', '28-Dec-2029');
INSERT INTO Promotion VALUES('PR0058', 0.4, 'Year End Sale', 0, '01-Dec-2029', '31-Dec-2029');
INSERT INTO Promotion VALUES('PR0059', 0.2, 'Christmas Sale', 1, '25-Dec-2029', '25-Dec-2029');
INSERT INTO Promotion VALUES('PR0060', 0.3, 'New Year Sale', 0, '01-Jan-2030', '07-Jan-2030');

INSERT INTO Promotion VALUES('PR0061', 0.15, 'Member Day', 1, '28-Jan-2030', '28-Jan-2030');
INSERT INTO Promotion VALUES('PR0062', 0.15, 'Member Day', 1, '28-Feb-2030', '28-Feb-2030');
INSERT INTO Promotion VALUES('PR0063', 0.15, 'Member Day', 1, '28-Aug-2030', '28-Aug-2030');
INSERT INTO Promotion VALUES('PR0064', 0.15, 'Member Day', 1, '28-Sep-2030', '28-Sep-2030');
INSERT INTO Promotion VALUES('PR0065', 0.15, 'Member Day', 1, '28-Oct-2030', '28-Oct-2030');
INSERT INTO Promotion VALUES('PR0066', 0.15, 'Member Day', 1, '28-Nov-2030', '28-Nov-2030');
INSERT INTO Promotion VALUES('PR0067', 0.15, 'Member Day', 1, '28-Dec-2030', '28-Dec-2030');
INSERT INTO Promotion VALUES('PR0068', 0.4, 'Year End Sale', 0, '01-Dec-2030', '31-Dec-2030');
INSERT INTO Promotion VALUES('PR0069', 0.2, 'Christmas Sale', 1, '25-Dec-2030', '25-Dec-2030');
INSERT INTO Promotion VALUES('PR0070', 0.3, 'New Year Sale', 0, '01-Jan-2031', '07-Jan-2031');

INSERT INTO Promotion VALUES('PR0071', 0.15, 'Member Day', 1, '28-Jan-2031', '28-Jan-2031');
INSERT INTO Promotion VALUES('PR0072', 0.15, 'Member Day', 1, '28-Feb-2031', '28-Feb-2031');
INSERT INTO Promotion VALUES('PR0073', 0.15, 'Member Day', 1, '28-Aug-2031', '28-Aug-2031');
INSERT INTO Promotion VALUES('PR0074', 0.15, 'Member Day', 1, '28-Sep-2031', '28-Sep-2031');
INSERT INTO Promotion VALUES('PR0075', 0.15, 'Member Day', 1, '28-Oct-2031', '28-Oct-2031');
INSERT INTO Promotion VALUES('PR0076', 0.15, 'Member Day', 1, '28-Nov-2031', '28-Nov-2031');
INSERT INTO Promotion VALUES('PR0077', 0.15, 'Member Day', 1, '28-Dec-2031', '28-Dec-2031');
INSERT INTO Promotion VALUES('PR0078', 0.4, 'Year End Sale', 0, '01-Dec-2031', '31-Dec-2031');
INSERT INTO Promotion VALUES('PR0079', 0.2, 'Christmas Sale', 1, '25-Dec-2031', '25-Dec-2031');
INSERT INTO Promotion VALUES('PR0080', 0.3, 'New Year Sale', 0, '01-Jan-2032', '07-Jan-2032');

INSERT INTO Promotion VALUES('PR0081', 0.15, 'Member Day', 1, '28-Jan-2032', '28-Jan-2032');
INSERT INTO Promotion VALUES('PR0082', 0.15, 'Member Day', 1, '28-Feb-2032', '28-Feb-2032');
INSERT INTO Promotion VALUES('PR0083', 0.15, 'Member Day', 1, '28-Aug-2032', '28-Aug-2032');
INSERT INTO Promotion VALUES('PR0084', 0.15, 'Member Day', 1, '28-Sep-2032', '28-Sep-2032');
INSERT INTO Promotion VALUES('PR0085', 0.15, 'Member Day', 1, '28-Oct-2032', '28-Oct-2032');
INSERT INTO Promotion VALUES('PR0086', 0.15, 'Member Day', 1, '28-Nov-2032', '28-Nov-2032');
INSERT INTO Promotion VALUES('PR0087', 0.15, 'Member Day', 1, '28-Dec-2032', '28-Dec-2032');
INSERT INTO Promotion VALUES('PR0088', 0.4, 'Year End Sale', 0, '01-Dec-2032', '31-Dec-2032');
INSERT INTO Promotion VALUES('PR0089', 0.2, 'Christmas Sale', 1, '25-Dec-2032', '25-Dec-2032');
INSERT INTO Promotion VALUES('PR0090', 0.3, 'New Year Sale', 0, '01-Jan-2033', '07-Jan-2033');

INSERT INTO Promotion VALUES('PR0091', 0.15, 'Member Day', 1, '28-Jan-2033', '28-Jan-2033');
INSERT INTO Promotion VALUES('PR0092', 0.15, 'Member Day', 1, '28-Feb-2023', '28-Feb-2033');
INSERT INTO Promotion VALUES('PR0093', 0.15, 'Member Day', 1, '28-Aug-2033', '28-Aug-2033');
INSERT INTO Promotion VALUES('PR0094', 0.15, 'Member Day', 1, '28-Sep-2033', '28-Sep-2033');
INSERT INTO Promotion VALUES('PR0095', 0.15, 'Member Day', 1, '28-Oct-2033', '28-Oct-2033');
INSERT INTO Promotion VALUES('PR0096', 0.15, 'Member Day', 1, '28-Nov-2033', '28-Nov-2033');
INSERT INTO Promotion VALUES('PR0097', 0.15, 'Member Day', 1, '28-Dec-2033', '28-Dec-2033');
INSERT INTO Promotion VALUES('PR0098', 0.4, 'Year End Sale', 0, '01-Dec-2033', '31-Dec-2033');
INSERT INTO Promotion VALUES('PR0099', 0.2, 'Christmas Sale', 1, '25-Dec-2033', '25-Dec-2033');
INSERT INTO Promotion VALUES('PR0100', 0.3, 'New Year Sale', 0, '01-Jan-2034', '07-Jan-2034');

--Member
INSERT INTO Member VALUES ('M0000', NULL, NULL, NULL, 'C0000');
INSERT INTO Member VALUES ('M0001', 127, '29-Nov-2022', '29-Nov-2024', 'C0001');
INSERT INTO Member VALUES ('M0002', 211, '19-Dec-2022', '19-Dec-2024', 'C0002');
INSERT INTO Member VALUES ('M0003', 78, '03-Jun-2022', '03-Jun-2024', 'C0003');
INSERT INTO Member VALUES ('M0004', 104, '16-Dec-2022', '16-Dec-2024', 'C0004');
INSERT INTO Member VALUES ('M0005', 8, '05-Aug-2022', '05-Aug-2024', 'C0005');
INSERT INTO Member VALUES ('M0006', 108, '12-Apr-2022', '12-Apr-2024', 'C0006');
INSERT INTO Member VALUES ('M0007', 56, '30-Sep-2022', '30-Sep-2024', 'C0007');
INSERT INTO Member VALUES ('M0008', 7, '30-Nov-2022', '30-Nov-2024', 'C0008');
INSERT INTO Member VALUES ('M0009', 52, '26-Sep-2022', '26-Sep-2024', 'C0009');
INSERT INTO Member VALUES ('M0010', 201, '08-Aug-2022', '08-Aug-2024', 'C0010');

INSERT INTO Member VALUES ('M0011', 136, '11-Mar-2023', '11-Mar-2025', 'C0011');
INSERT INTO Member VALUES ('M0012', 162, '15-Jun-2022', '15-Jun-2024', 'C0012');
INSERT INTO Member VALUES ('M0013', 145, '13-Apr-2022', '13-Apr-2024', 'C0013');
INSERT INTO Member VALUES ('M0014', 102, '09-Apr-2023', '09-Apr-2025', 'C0014');
INSERT INTO Member VALUES ('M0015', 149, '20-Nov-2022', '20-Nov-2024', 'C0015');
INSERT INTO Member VALUES ('M0016', 55, '13-May-2022', '13-May-2024', 'C0016');
INSERT INTO Member VALUES ('M0017', 47, '04-Nov-2022', '04-Nov-2024', 'C0017');
INSERT INTO Member VALUES ('M0018', 157, '01-Feb-2023', '01-Feb-2025', 'C0018');
INSERT INTO Member VALUES ('M0019', 127, '01-Dec-2022', '01-Dec-2024', 'C0019');
INSERT INTO Member VALUES ('M0020', 183, '07-Apr-2023', '07-Apr-2025', 'C0020');

INSERT INTO Member VALUES ('M0021', 198, '20-Jul-2022', '20-Jul-2024', 'C0021');
INSERT INTO Member VALUES ('M0022', 109, '21-Apr-2022', '21-Apr-2024', 'C0022');
INSERT INTO Member VALUES ('M0023', 214, '14-Jan-2023', '14-Jan-2025', 'C0023');
INSERT INTO Member VALUES ('M0024', 127, '02-Sep-2022', '02-Sep-2024', 'C0024');
INSERT INTO Member VALUES ('M0025', 228, '10-Feb-2023', '10-Feb-2025', 'C0025');
INSERT INTO Member VALUES ('M0026', 89, '02-Oct-2022', '02-Oct-2024', 'C0026');
INSERT INTO Member VALUES ('M0027', 12, '27-Jul-2022', '27-Jul-2024', 'C0027');
INSERT INTO Member VALUES ('M0028', 35, '07-Mar-2023', '07-Mar-2025', 'C0028');
INSERT INTO Member VALUES ('M0029', 172, '06-Feb-2023', '06-Feb-2025', 'C0029');
INSERT INTO Member VALUES ('M0030', 16, '10-May-2022', '10-May-2024', 'C0030');

INSERT INTO Member VALUES ('M0031', 193, '25-Aug-2022', '25-Aug-2024', 'C0031');
INSERT INTO Member VALUES ('M0032', 156, '04-Jun-2022', '04-Jun-2024', 'C0032');
INSERT INTO Member VALUES ('M0033', 248, '27-Jan-2023', '27-Jan-2025', 'C0033');
INSERT INTO Member VALUES ('M0034', 167, '10-Sep-2022', '10-Sep-2024', 'C0034');
INSERT INTO Member VALUES ('M0035', 102, '18-May-2022', '18-May-2024', 'C0035');
INSERT INTO Member VALUES ('M0036', 113, '13-Jun-2022', '13-Jun-2024', 'C0036');
INSERT INTO Member VALUES ('M0037', 168, '13-Oct-2022', '13-Oct-2024', 'C0037');
INSERT INTO Member VALUES ('M0038', 148, '17-Jul-2022', '17-Jul-2024', 'C0038');
INSERT INTO Member VALUES ('M0039', 23, '31-Jan-2023', '31-Jan-2025', 'C0039');
INSERT INTO Member VALUES ('M0040', 15, '07-Nov-2022', '07-Nov-2024', 'C0040');

INSERT INTO Member VALUES ('M0041', 220, '30-Jul-2022', '30-Jul-2024', 'C0041');
INSERT INTO Member VALUES ('M0042', 161, '11-Feb-2023', '11-Feb-2025', 'C0042');
INSERT INTO Member VALUES ('M0043', 211, '31-Jan-2023', '31-Jan-2025', 'C0043');
INSERT INTO Member VALUES ('M0044', 182, '08-Oct-2022', '08-Oct-2024', 'C0044');
INSERT INTO Member VALUES ('M0045', 212, '25-Feb-2023', '25-Feb-2025', 'C0045');
INSERT INTO Member VALUES ('M0046', 244, '17-May-2022', '17-May-2024', 'C0046');
INSERT INTO Member VALUES ('M0047', 30, '15-Sep-2022', '15-Sep-2024', 'C0047');
INSERT INTO Member VALUES ('M0048', 41, '24-Feb-2023', '24-Feb-2025', 'C0048');
INSERT INTO Member VALUES ('M0049', 206, '19-Nov-2022', '19-Nov-2024', 'C0049');
INSERT INTO Member VALUES ('M0050', 43, '13-Jul-2022', '13-Jul-2024', 'C0050');

INSERT INTO Member VALUES ('M0051', 234, '22-Feb-2023', '22-Feb-2025', 'C0051');
INSERT INTO Member VALUES ('M0052', 116, '12-Jul-2022', '12-Jul-2024', 'C0052');
INSERT INTO Member VALUES ('M0053', 153, '09-Apr-2023', '09-Apr-2025', 'C0053');
INSERT INTO Member VALUES ('M0054', 97, '26-Oct-2022', '26-Oct-2024', 'C0054');
INSERT INTO Member VALUES ('M0055', 98, '27-Jan-2023', '27-Jan-2025', 'C0055');
INSERT INTO Member VALUES ('M0056', 136, '28-Apr-2022', '28-Apr-2024', 'C0056');
INSERT INTO Member VALUES ('M0057', 99, '07-Oct-2022', '07-Oct-2024', 'C0057');
INSERT INTO Member VALUES ('M0058', 40, '14-Sep-2022', '14-Sep-2024', 'C0058');
INSERT INTO Member VALUES ('M0059', 111, '24-Aug-2022', '24-Aug-2024', 'C0059');
INSERT INTO Member VALUES ('M0060', 155, '24-Mar-2023', '24-Mar-2025', 'C0060');

INSERT INTO Member VALUES ('M0061', 232, '26-Nov-2022', '26-Nov-2024', 'C0061');
INSERT INTO Member VALUES ('M0062', 170, '22-Oct-2022', '22-Oct-2024', 'C0062');
INSERT INTO Member VALUES ('M0063', 110, '30-Mar-2023', '30-Mar-2025', 'C0063');
INSERT INTO Member VALUES ('M0064', 220, '06-Oct-2022', '06-Oct-2024', 'C0064');
INSERT INTO Member VALUES ('M0065', 148, '13-Oct-2022', '13-Oct-2024', 'C0065');
INSERT INTO Member VALUES ('M0066', 30, '08-Dec-2022', '08-Dec-2024', 'C0066');
INSERT INTO Member VALUES ('M0067', 144, '03-Jun-2022', '03-Jun-2024', 'C0067');
INSERT INTO Member VALUES ('M0068', 26, '08-Jul-2022', '08-Jul-2024', 'C0068');
INSERT INTO Member VALUES ('M0069', 228, '10-Apr-2023', '10-Apr-2025', 'C0069');
INSERT INTO Member VALUES ('M0070', 177, '06-Feb-2023', '06-Feb-2025', 'C0070');

INSERT INTO Member VALUES ('M0071', 38, '04-Dec-2022', '04-Dec-2024', 'C0071');
INSERT INTO Member VALUES ('M0072', 232, '21-Mar-2023', '21-Mar-2025', 'C0072');
INSERT INTO Member VALUES ('M0073', 67, '24-Jan-2023', '24-Jan-2025', 'C0073');
INSERT INTO Member VALUES ('M0074', 64, '06-Sep-2022', '06-Sep-2024', 'C0074');
INSERT INTO Member VALUES ('M0075', 104, '30-Oct-2022', '30-Oct-2024', 'C0075');
INSERT INTO Member VALUES ('M0076', 125, '20-Jun-2022', '20-Jun-2024', 'C0076');
INSERT INTO Member VALUES ('M0077', 160, '23-Sep-2022', '23-Sep-2024', 'C0077');
INSERT INTO Member VALUES ('M0078', 223, '11-Apr-2023', '11-Apr-2025', 'C0078');
INSERT INTO Member VALUES ('M0079', 51, '17-Jun-2022', '17-Jun-2024', 'C0079');
INSERT INTO Member VALUES ('M0080', 225, '25-Oct-2022', '25-Oct-2024', 'C0080');

INSERT INTO Member VALUES ('M0081', 52, '17-Nov-2022', '17-Nov-2024', 'C0081');
INSERT INTO Member VALUES ('M0082', 225, '27-Apr-2022', '27-Apr-2024', 'C0082');
INSERT INTO Member VALUES ('M0083', 197, '18-Apr-2022', '18-Apr-2024', 'C0083');
INSERT INTO Member VALUES ('M0084', 209, '14-Mar-2023', '14-Mar-2025', 'C0084');
INSERT INTO Member VALUES ('M0085', 208, '01-Feb-2023', '01-Feb-2025', 'C0085');
INSERT INTO Member VALUES ('M0086', 70, '05-Jan-2023', '05-Jan-2025', 'C0086');
INSERT INTO Member VALUES ('M0087', 239, '26-Jan-2023', '26-Jan-2025', 'C0087');
INSERT INTO Member VALUES ('M0088', 242, '16-Jun-2022', '16-Jun-2024', 'C0088');
INSERT INTO Member VALUES ('M0089', 133, '17-Jan-2023', '17-Jan-2025', 'C0089');
INSERT INTO Member VALUES ('M0090', 231, '19-Oct-2022', '19-Oct-2024', 'C0090');

INSERT INTO Member VALUES ('M0091', 78, '03-Jan-2023', '03-Jan-2025', 'C0091');
INSERT INTO Member VALUES ('M0092', 33, '08-May-2022', '08-May-2024', 'C0092');
INSERT INTO Member VALUES ('M0093', 235, '05-Jul-2022', '05-Jul-2024', 'C0093');
INSERT INTO Member VALUES ('M0094', 190, '13-Dec-2022', '13-Dec-2024', 'C0094');
INSERT INTO Member VALUES ('M0095', 77, '06-Aug-2022', '06-Aug-2024', 'C0095');
INSERT INTO Member VALUES ('M0096', 228, '17-Sep-2022', '17-Sep-2024', 'C0096');
INSERT INTO Member VALUES ('M0097', 230, '05-Jan-2023', '05-Jan-2025', 'C0097');
INSERT INTO Member VALUES ('M0098', 111, '13-Jul-2022', '13-Jul-2024', 'C0098');
INSERT INTO Member VALUES ('M0099', 31, '06-Oct-2022', '06-Oct-2024', 'C0099');
INSERT INTO Member VALUES ('M0100', 160, '15-Jun-2022', '15-Jun-2024', 'C0100');

--Delivery
INSERT INTO Delivery VALUES ('D0000', NULL, NULL, NULL, 'E0000');

INSERT INTO Delivery VALUES ('D0001', '24-Dec-2022', 'Room 385', 32.15, 'E0001');
INSERT INTO Delivery VALUES ('D0002', '21-Jan-2023', 'Room 1276', 16.43, 'E0002');
INSERT INTO Delivery VALUES ('D0003', '19-Oct-2022', 'Room 124', 15.94, 'E0003');
INSERT INTO Delivery VALUES ('D0004', '15-May-2022', 'Room 462', 76.79, 'E0004');
INSERT INTO Delivery VALUES ('D0005', '11-May-2022', 'Suite 35', 58.9, 'E0005');
INSERT INTO Delivery VALUES ('D0006', '28-Dec-2022', '3rd Floor', 93.4, 'E0006');
INSERT INTO Delivery VALUES ('D0007', '10-Nov-2022', 'Room 531', 6.58, 'E0007');
INSERT INTO Delivery VALUES ('D0008', '03-Oct-2022', 'Suite 84', 52.63, 'E0008');
INSERT INTO Delivery VALUES ('D0009', '06-Mar-2023', 'Suite 15', 18.0, 'E0009');
INSERT INTO Delivery VALUES ('D0010', '03-Aug-2022', 'Room 589', 13.19, 'E0010');

INSERT INTO Delivery VALUES ('D0011', '18-Aug-2022', 'Apt 1615', 19.54, 'E0011');
INSERT INTO Delivery VALUES ('D0012', '18-Dec-2022', 'Room 1045', 81.41, 'E0012');
INSERT INTO Delivery VALUES ('D0013', '03-Jul-2022', 'Apt 1856', 70.82, 'E0013');
INSERT INTO Delivery VALUES ('D0014', '08-Oct-2022', 'Room 328', 76.2, 'E0014');
INSERT INTO Delivery VALUES ('D0015', '15-May-2022', '8th Floor', 81.27, 'E0015');
INSERT INTO Delivery VALUES ('D0016', '18-Mar-2023', '12th Floor', 52.31, 'E0016');
INSERT INTO Delivery VALUES ('D0017', '26-Mar-2022', 'Room 887', 48.01, 'E0017');
INSERT INTO Delivery VALUES ('D0018', '04-Dec-2022', 'Suite 2', 21.91, 'E0018');
INSERT INTO Delivery VALUES ('D0019', '26-May-2022', 'Suite 79', 24.21, 'E0019');
INSERT INTO Delivery VALUES ('D0020', '27-May-2022', 'PO Box 33868', 45.29, 'E0020');

INSERT INTO Delivery VALUES ('D0021', '23-May-2022', 'PO Box 95000', 11.69, 'E0021');
INSERT INTO Delivery VALUES ('D0022', '16-Jul-2022', 'PO Box 14058', 46.62, 'E0022');
INSERT INTO Delivery VALUES ('D0023', '30-Mar-2022', '16th Floor', 22.71, 'E0023');
INSERT INTO Delivery VALUES ('D0024', '07-Feb-2023', 'PO Box 3819', 76.9, 'E0024');
INSERT INTO Delivery VALUES ('D0025', '08-Aug-2022', 'Suite 34', 5.31, 'E0025');
INSERT INTO Delivery VALUES ('D0026', '25-Nov-2022', '19th Floor', 42.93, 'E0026');
INSERT INTO Delivery VALUES ('D0027', '14-May-2022', '20th Floor', 81.47, 'E0027');
INSERT INTO Delivery VALUES ('D0028', '20-Jul-2022', 'Apt 1180', 61.78, 'E0028');
INSERT INTO Delivery VALUES ('D0029', '30-Apr-2022', '8th Floor', 61.91, 'E0029');
INSERT INTO Delivery VALUES ('D0030', '29-May-2022', '14th Floor', 42.32, 'E0030');

INSERT INTO Delivery VALUES ('D0031', '23-Feb-2023', 'PO Box 11731', 58.46, 'E0031');
INSERT INTO Delivery VALUES ('D0032', '13-Mar-2023', 'Suite 13', 44.87, 'E0032');
INSERT INTO Delivery VALUES ('D0033', '14-Dec-2022', 'Room 1475', 47.46, 'E0033');
INSERT INTO Delivery VALUES ('D0034', '02-Jul-2022', '1st Floor', 43.37, 'E0034');
INSERT INTO Delivery VALUES ('D0035', '06-Aug-2022', '15th Floor', 12.35, 'E0035');
INSERT INTO Delivery VALUES ('D0036', '21-Jun-2022', 'Apt 1297', 31.18, 'E0036');
INSERT INTO Delivery VALUES ('D0037', '11-Jun-2022', 'Apt 1976', 10.87, 'E0037');
INSERT INTO Delivery VALUES ('D0038', '04-Feb-2023', 'PO Box 80721', 61.3, 'E0038');
INSERT INTO Delivery VALUES ('D0039', '11-Aug-2022', 'PO Box 46751', 56.26, 'E0039');
INSERT INTO Delivery VALUES ('D0040', '10-Feb-2023', '20th Floor', 54.83, 'E0040');

INSERT INTO Delivery VALUES ('D0041', '29-Dec-2022', '8th Floor', 33.14, 'E0041');
INSERT INTO Delivery VALUES ('D0042', '18-Mar-2023', 'Suite 81', 3.31, 'E0042');
INSERT INTO Delivery VALUES ('D0043', '18-Nov-2022', 'Apt 770', 37.26, 'E0043');
INSERT INTO Delivery VALUES ('D0044', '08-Oct-2022', 'Room 236', 95.48, 'E0044');
INSERT INTO Delivery VALUES ('D0045', '27-Apr-2022', 'Apt 1651', 55.28, 'E0045');
INSERT INTO Delivery VALUES ('D0046', '03-Jun-2022', 'Room 750', 63.38, 'E0046');
INSERT INTO Delivery VALUES ('D0047', '09-Dec-2022', 'PO Box 17689', 48.88, 'E0047');
INSERT INTO Delivery VALUES ('D0048', '16-Dec-2022', '18th Floor', 99.01, 'E0048');
INSERT INTO Delivery VALUES ('D0049', '04-Sep-2022', 'Suite 10', 81.08, 'E0049');
INSERT INTO Delivery VALUES ('D0050', '16-Mar-2023', 'Room 60', 48.23, 'E0050');

INSERT INTO Delivery VALUES ('D0051', '28-Sep-2022', 'Suite 13', 91.67, 'E0051');
INSERT INTO Delivery VALUES ('D0052', '08-Sep-2022', 'Suite 9', 96.3, 'E0052');
INSERT INTO Delivery VALUES ('D0053', '12-Dec-2022', 'Apt 220', 40.84, 'E0053');
INSERT INTO Delivery VALUES ('D0054', '23-Apr-2022', '19th Floor', 55.32, 'E0054');
INSERT INTO Delivery VALUES ('D0055', '05-Dec-2022', 'Room 308', 11.25, 'E0055');
INSERT INTO Delivery VALUES ('D0056', '21-Mar-2022', 'Apt 341', 40.71, 'E0056');
INSERT INTO Delivery VALUES ('D0057', '24-Oct-2022', 'Apt 448', 41.39, 'E0057');
INSERT INTO Delivery VALUES ('D0058', '15-Sep-2022', 'Apt 949', 72.17, 'E0058');
INSERT INTO Delivery VALUES ('D0059', '24-Jun-2022', '9th Floor', 54.47, 'E0059');
INSERT INTO Delivery VALUES ('D0060', '17-Nov-2022', 'PO Box 62815', 65.33, 'E0060');

INSERT INTO Delivery VALUES ('D0061', '01-Jul-2022', 'Room 1722', 8.18, 'E0061');
INSERT INTO Delivery VALUES ('D0062', '11-Aug-2022', 'PO Box 72811', 29.22, 'E0062');
INSERT INTO Delivery VALUES ('D0063', '15-Sep-2022', '18th Floor', 89.41, 'E0063');
INSERT INTO Delivery VALUES ('D0064', '10-Apr-2022', 'PO Box 69089', 6.65, 'E0064');
INSERT INTO Delivery VALUES ('D0065', '26-Apr-2022', '8th Floor', 58.0, 'E0065');
INSERT INTO Delivery VALUES ('D0066', '04-Aug-2022', 'Room 1036', 45.56, 'E0066');
INSERT INTO Delivery VALUES ('D0067', '01-Aug-2022', '8th Floor', 14.9, 'E0067');
INSERT INTO Delivery VALUES ('D0068', '17-Nov-2022', 'Room 553', 10.07, 'E0068');
INSERT INTO Delivery VALUES ('D0069', '10-Dec-2022', 'Apt 253', 15.12, 'E0069');
INSERT INTO Delivery VALUES ('D0070', '26-May-2022', 'PO Box 54190', 71.88, 'E0070');

INSERT INTO Delivery VALUES ('D0071', '10-Mar-2023', 'Room 610', 66.95, 'E0071');
INSERT INTO Delivery VALUES ('D0072', '24-Jan-2023', 'PO Box 52256', 14.13, 'E0072');
INSERT INTO Delivery VALUES ('D0073', '12-Mar-2023', 'PO Box 15268', 52.64, 'E0073');
INSERT INTO Delivery VALUES ('D0074', '30-Nov-2022', 'Suite 2', 88.31, 'E0074');
INSERT INTO Delivery VALUES ('D0075', '03-Apr-2022', 'PO Box 48338', 15.06, 'E0075');
INSERT INTO Delivery VALUES ('D0076', '14-Jun-2022', '10th Floor', 57.49, 'E0076');
INSERT INTO Delivery VALUES ('D0077', '21-Sep-2022', 'Room 1319', 7.53, 'E0077');
INSERT INTO Delivery VALUES ('D0078', '30-Dec-2022', '18th Floor', 26.1, 'E0078');
INSERT INTO Delivery VALUES ('D0079', '06-Nov-2022', 'Suite 36', 3.11, 'E0079');
INSERT INTO Delivery VALUES ('D0080', '29-Jun-2022', 'Suite 90', 76.64, 'E0080');

INSERT INTO Delivery VALUES ('D0081', '20-Sep-2022', '2nd Floor', 44.4, 'E0081');
INSERT INTO Delivery VALUES ('D0082', '08-Jul-2022', 'Room 121', 86.73, 'E0082');
INSERT INTO Delivery VALUES ('D0083', '09-Apr-2022', 'Apt 895', 12.58, 'E0083');
INSERT INTO Delivery VALUES ('D0084', '03-May-2022', 'Apt 197', 35.92, 'E0084');
INSERT INTO Delivery VALUES ('D0085', '26-Oct-2022', '1st Floor', 32.56, 'E0085');
INSERT INTO Delivery VALUES ('D0086', '07-May-2022', 'Room 699', 40.55, 'E0086');
INSERT INTO Delivery VALUES ('D0087', '13-Feb-2023', 'Apt 648', 14.5, 'E0087');
INSERT INTO Delivery VALUES ('D0088', '28-Oct-2022', 'PO Box 55002', 47.97, 'E0088');
INSERT INTO Delivery VALUES ('D0089', '22-May-2022', 'Suite 41', 64.3, 'E0089');
INSERT INTO Delivery VALUES ('D0090', '04-Dec-2022', '13th Floor', 79.54, 'E0090');

INSERT INTO Delivery VALUES ('D0091', '12-Aug-2022', 'Suite 30', 59.19, 'E0091');
INSERT INTO Delivery VALUES ('D0092', '14-Jun-2022', 'Room 291', 29.09, 'E0092');
INSERT INTO Delivery VALUES ('D0093', '30-Aug-2022', 'Room 1418', 39.8, 'E0093');
INSERT INTO Delivery VALUES ('D0094', '23-Mar-2022', '3rd Floor', 50.22, 'E0094');
INSERT INTO Delivery VALUES ('D0095', '15-Mar-2023', 'Room 1053', 4.76, 'E0095');
INSERT INTO Delivery VALUES ('D0096', '13-Aug-2022', 'Suite 14', 95.49, 'E0096');
INSERT INTO Delivery VALUES ('D0097', '08-Jan-2023', '14th Floor', 90.31, 'E0097');
INSERT INTO Delivery VALUES ('D0098', '20-Nov-2022', 'Room 1675', 32.22, 'E0098');
INSERT INTO Delivery VALUES ('D0099', '14-Jun-2022', '15th Floor', 34.54, 'E0099');
INSERT INTO Delivery VALUES ('D0100', '30-Mar-2022', 'Room 1598', 83.32, 'E0100');

INSERT INTO Delivery VALUES ('D0101', '30-Mar-2023', '16th Floor', 11.14, 'E0050');
INSERT INTO Delivery VALUES ('D0102', '01-Apr-2023', 'PO Box 55000', 12.28, 'E0087');
INSERT INTO Delivery VALUES ('D0103', '05-Mar-2023', '9th Floor', 09.55, 'E0087');
INSERT INTO Delivery VALUES ('D0104', '17-Apr-2023', 'PO Box 54500', 9.28, 'E0087');
INSERT INTO Delivery VALUES ('D0105', '20-Mar-2023', 'PO Box 54500', 9.28, 'E0042');

--StockPurchase
INSERT INTO StockPurchase VALUES ('SP0001', 18, '19-Apr-2022', 'T0020', 'S0040');
INSERT INTO StockPurchase VALUES ('SP0002', 66, '26-Oct-2022', 'T0001', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0003', 33, '09-Jun-2022', 'T0058', 'S0035');
INSERT INTO StockPurchase VALUES ('SP0004', 88, '09-Aug-2022', 'T0010', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0005', 21, '21-Aug-2022', 'T0004', 'S0005');
INSERT INTO StockPurchase VALUES ('SP0006', 69, '10-Dec-2022', 'T0049', 'S0065');
INSERT INTO StockPurchase VALUES ('SP0007', 23, '15-Jan-2023', 'T0011', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0008', 30, '16-Jan-2023', 'T0012', 'S0080');
INSERT INTO StockPurchase VALUES ('SP0009', 55, '09-Mar-2023', 'T0039', 'S0068');
INSERT INTO StockPurchase VALUES ('SP0010', 47, '21-Mar-2023', 'T0018', 'S0028');

INSERT INTO StockPurchase VALUES ('SP0011', 90, '27-Dec-2022', 'T0041', 'S0047');
INSERT INTO StockPurchase VALUES ('SP0012', 82, '21-Aug-2022', 'T0034', 'S0033');
INSERT INTO StockPurchase VALUES ('SP0013', 71, '15-Apr-2022', 'T0099', 'S0014');
INSERT INTO StockPurchase VALUES ('SP0014', 62, '14-Aug-2022', 'T0004', 'S0054');
INSERT INTO StockPurchase VALUES ('SP0015', 15, '07-Jan-2023', 'T0082', 'S0055');
INSERT INTO StockPurchase VALUES ('SP0016', 17, '16-Aug-2022', 'T0093', 'S0069');
INSERT INTO StockPurchase VALUES ('SP0017', 100, '28-Mar-2023', 'T0015', 'S0062');
INSERT INTO StockPurchase VALUES ('SP0018', 48, '19-Sep-2022', 'T0044', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0019', 40, '21-Aug-2022', 'T0078', 'S0002');
INSERT INTO StockPurchase VALUES ('SP0020', 38, '22-Jul-2022', 'T0090', 'S0030');

INSERT INTO StockPurchase VALUES ('SP0021', 48, '23-Feb-2023', 'T0003', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0022', 27, '09-Dec-2022', 'T0093', 'S0090');
INSERT INTO StockPurchase VALUES ('SP0023', 20, '13-Sep-2022', 'T0009', 'S0091');
INSERT INTO StockPurchase VALUES ('SP0024', 21, '05-Feb-2023', 'T0054', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0025', 15, '28-Jul-2022', 'T0071', 'S0095');
INSERT INTO StockPurchase VALUES ('SP0026', 69, '26-Jul-2022', 'T0004', 'S0098');
INSERT INTO StockPurchase VALUES ('SP0027', 25, '02-Feb-2023', 'T0086', 'S0073');
INSERT INTO StockPurchase VALUES ('SP0028', 10, '03-Oct-2022', 'T0016', 'S0099');
INSERT INTO StockPurchase VALUES ('SP0029', 28, '17-Jun-2022', 'T0011', 'S0035');
INSERT INTO StockPurchase VALUES ('SP0030', 29, '15-Jul-2022', 'T0007', 'S0022');

INSERT INTO StockPurchase VALUES ('SP0031', 99, '14-Apr-2022', 'T0060', 'S0029');
INSERT INTO StockPurchase VALUES ('SP0032', 41, '01-May-2022', 'T0081', 'S0053');
INSERT INTO StockPurchase VALUES ('SP0033', 61, '09-Mar-2023', 'T0047', 'S0039');
INSERT INTO StockPurchase VALUES ('SP0034', 30, '19-Nov-2022', 'T0088', 'S0004');
INSERT INTO StockPurchase VALUES ('SP0035', 74, '09-Apr-2023', 'T0087', 'S0056');
INSERT INTO StockPurchase VALUES ('SP0036', 75, '13-Apr-2022', 'T0013', 'S0044');
INSERT INTO StockPurchase VALUES ('SP0037', 98, '03-May-2022', 'T0036', 'S0061');
INSERT INTO StockPurchase VALUES ('SP0038', 11, '11-Mar-2023', 'T0035', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0039', 52, '09-Dec-2022', 'T0071', 'S0072');
INSERT INTO StockPurchase VALUES ('SP0040', 64, '16-Jul-2022', 'T0089', 'S0013');

INSERT INTO StockPurchase VALUES ('SP0041', 76, '19-Jan-2023', 'T0059', 'S0069');
INSERT INTO StockPurchase VALUES ('SP0042', 57, '20-May-2022', 'T0065', 'S0025');
INSERT INTO StockPurchase VALUES ('SP0043', 23, '22-Dec-2022', 'T0084', 'S0009');
INSERT INTO StockPurchase VALUES ('SP0044', 24, '30-Jul-2022', 'T0076', 'S0005');
INSERT INTO StockPurchase VALUES ('SP0045', 23, '08-May-2022', 'T0094', 'S0011');
INSERT INTO StockPurchase VALUES ('SP0046', 60, '28-May-2022', 'T0079', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0047', 74, '11-Apr-2023', 'T0089', 'S0007');
INSERT INTO StockPurchase VALUES ('SP0048', 37, '02-Jan-2023', 'T0020', 'S0060');
INSERT INTO StockPurchase VALUES ('SP0049', 64, '14-Mar-2023', 'T0028', 'S0001');
INSERT INTO StockPurchase VALUES ('SP0050', 57, '26-Sep-2022', 'T0069', 'S0063');

INSERT INTO StockPurchase VALUES ('SP0051', 100, '13-Aug-2022', 'T0024', 'S0040');
INSERT INTO StockPurchase VALUES ('SP0052', 13, '16-Aug-2022', 'T0027', 'S0090');
INSERT INTO StockPurchase VALUES ('SP0053', 96, '19-May-2022', 'T0057', 'S0031');
INSERT INTO StockPurchase VALUES ('SP0054', 60, '23-Dec-2022', 'T0061', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0055', 23, '04-Feb-2023', 'T0006', 'S0088');
INSERT INTO StockPurchase VALUES ('SP0056', 99, '27-Nov-2022', 'T0014', 'S0030');
INSERT INTO StockPurchase VALUES ('SP0057', 85, '03-Dec-2023', 'T0095', 'S0072');
INSERT INTO StockPurchase VALUES ('SP0058', 73, '11-Jul-2023', 'T0072', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0059', 50, '06-Apr-2023', 'T0080', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0060', 72, '13-Jun-2022', 'T0030', 'S0019');

INSERT INTO StockPurchase VALUES ('SP0061', 52, '20-Sep-2022', 'T0035', 'S0098');
INSERT INTO StockPurchase VALUES ('SP0062', 14, '30-Dec-2022', 'T0043', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0063', 95, '28-Jan-2023', 'T0053', 'S0066');
INSERT INTO StockPurchase VALUES ('SP0064', 54, '16-Jul-2022', 'T0068', 'S0010');
INSERT INTO StockPurchase VALUES ('SP0065', 11, '19-Oct-2022', 'T0066', 'S0091');
INSERT INTO StockPurchase VALUES ('SP0066', 81, '26-Mar-2023', 'T0006', 'S0098');
INSERT INTO StockPurchase VALUES ('SP0067', 34, '24-Sep-2022', 'T0041', 'S0093');
INSERT INTO StockPurchase VALUES ('SP0068', 28, '02-Feb-2023', 'T0078', 'S0096');
INSERT INTO StockPurchase VALUES ('SP0069', 87, '08-Aug-2022', 'T0099', 'S0079');
INSERT INTO StockPurchase VALUES ('SP0070', 58, '27-Jan-2023', 'T0029', 'S0045');

INSERT INTO StockPurchase VALUES ('SP0071', 43, '28-Jun-2022', 'T0084', 'S0086');
INSERT INTO StockPurchase VALUES ('SP0072', 100, '26-Nov-2022', 'T0004', 'S0087');
INSERT INTO StockPurchase VALUES ('SP0073', 97, '10-Sep-2022', 'T0039', 'S0031');
INSERT INTO StockPurchase VALUES ('SP0074', 85, '07-Jun-2022', 'T0006', 'S0082');
INSERT INTO StockPurchase VALUES ('SP0075', 38, '14-May-2022', 'T0099', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0076', 62, '07-Sep-2022', 'T0085', 'S0060');
INSERT INTO StockPurchase VALUES ('SP0077', 84, '04-Jan-2023', 'T0002', 'S0094');
INSERT INTO StockPurchase VALUES ('SP0078', 30, '02-May-2022', 'T0096', 'S0080');
INSERT INTO StockPurchase VALUES ('SP0079', 26, '31-Dec-2022', 'T0053', 'S0069');
INSERT INTO StockPurchase VALUES ('SP0080', 45, '30-Mar-2023', 'T0035', 'S0097');

INSERT INTO StockPurchase VALUES ('SP0081', 18, '18-Jun-2022', 'T0014', 'S0018');
INSERT INTO StockPurchase VALUES ('SP0082', 23, '02-Nov-2022', 'T0099', 'S0053');
INSERT INTO StockPurchase VALUES ('SP0083', 11, '02-Oct-2022', 'T0037', 'S0083');
INSERT INTO StockPurchase VALUES ('SP0084', 56, '28-Aug-2022', 'T0003', 'S0026');
INSERT INTO StockPurchase VALUES ('SP0085', 95, '11-Jul-2022', 'T0007', 'S0089');
INSERT INTO StockPurchase VALUES ('SP0086', 54, '10-Aug-2022', 'T0035', 'S0044');
INSERT INTO StockPurchase VALUES ('SP0087', 72, '23-Jul-2022', 'T0003', 'S0091');
INSERT INTO StockPurchase VALUES ('SP0088', 78, '20-Sep-2022', 'T0056', 'S0008');
INSERT INTO StockPurchase VALUES ('SP0089', 26, '02-Apr-2023', 'T0096', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0090', 66, '25-Apr-2022', 'T0022', 'S0028');

INSERT INTO StockPurchase VALUES ('SP0091', 55, '19-Dec-2022', 'T0037', 'S0079');
INSERT INTO StockPurchase VALUES ('SP0092', 18, '31-Jan-2023', 'T0045', 'S0023');
INSERT INTO StockPurchase VALUES ('SP0093', 30, '11-May-2022', 'T0060', 'S0058');
INSERT INTO StockPurchase VALUES ('SP0094', 53, '11-Apr-2023', 'T0082', 'S0063');
INSERT INTO StockPurchase VALUES ('SP0095', 12, '20-Oct-2022', 'T0040', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0096', 70, '29-Sep-2022', 'T0019', 'S0088');
INSERT INTO StockPurchase VALUES ('SP0097', 81, '21-Jun-2022', 'T0056', 'S0053');
INSERT INTO StockPurchase VALUES ('SP0098', 47, '03-Oct-2022', 'T0021', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0099', 77, '12-Jun-2022', 'T0099', 'S0027');
INSERT INTO StockPurchase VALUES ('SP0100', 83, '07-Feb-2023', 'T0089', 'S0076');

INSERT INTO StockPurchase VALUES ('SP0101', 43, '05-Jul-2022', 'T0072', 'S0063');
INSERT INTO StockPurchase VALUES ('SP0102', 78, '03-Oct-2022', 'T0009', 'S0045');
INSERT INTO StockPurchase VALUES ('SP0103', 34, '05-Oct-2022', 'T0021', 'S0068');
INSERT INTO StockPurchase VALUES ('SP0104', 65, '30-Mar-2023', 'T0007', 'S0004');
INSERT INTO StockPurchase VALUES ('SP0105', 26, '19-Aug-2022', 'T0099', 'S0014');
INSERT INTO StockPurchase VALUES ('SP0106', 51, '20-Oct-2022', 'T0047', 'S0064');
INSERT INTO StockPurchase VALUES ('SP0107', 83, '11-Feb-2023', 'T0084', 'S0004');
INSERT INTO StockPurchase VALUES ('SP0108', 29, '23-Jun-2022', 'T0054', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0109', 16, '03-Nov-2022', 'T0030', 'S0015');
INSERT INTO StockPurchase VALUES ('SP0110', 68, '31-Dec-2022', 'T0002', 'S0018');

INSERT INTO StockPurchase VALUES ('SP0111', 67, '19-Mar-2023', 'T0071', 'S0099');
INSERT INTO StockPurchase VALUES ('SP0112', 68, '10-Jun-2022', 'T0072', 'S0073');
INSERT INTO StockPurchase VALUES ('SP0113', 59, '29-Jun-2022', 'T0037', 'S0088');
INSERT INTO StockPurchase VALUES ('SP0114', 71, '07-Jan-2023', 'T0065', 'S0082');
INSERT INTO StockPurchase VALUES ('SP0115', 49, '16-Oct-2022', 'T0070', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0116', 51, '27-Dec-2022', 'T0075', 'S0089');
INSERT INTO StockPurchase VALUES ('SP0117', 91, '11-Aug-2023', 'T0063', 'S0002');
INSERT INTO StockPurchase VALUES ('SP0118', 13, '27-Jan-2023', 'T0049', 'S0068');
INSERT INTO StockPurchase VALUES ('SP0119', 89, '04-Apr-2023', 'T0083', 'S0003');
INSERT INTO StockPurchase VALUES ('SP0120', 62, '08-Mar-2023', 'T0034', 'S0012');

INSERT INTO StockPurchase VALUES ('SP0121', 47, '11-Aug-2022', 'T0093', 'S0075');
INSERT INTO StockPurchase VALUES ('SP0122', 15, '29-Oct-2022', 'T0042', 'S0078');
INSERT INTO StockPurchase VALUES ('SP0123', 40, '04-Apr-2023', 'T0017', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0124', 62, '22-May-2022', 'T0049', 'S0067');
INSERT INTO StockPurchase VALUES ('SP0125', 33, '20-Dec-2022', 'T0067', 'S0013');
INSERT INTO StockPurchase VALUES ('SP0126', 84, '19-Oct-2022', 'T0014', 'S0037');
INSERT INTO StockPurchase VALUES ('SP0127', 73, '01-Jun-2022', 'T0020', 'S0043');
INSERT INTO StockPurchase VALUES ('SP0128', 80, '05-Jul-2022', 'T0047', 'S0066');
INSERT INTO StockPurchase VALUES ('SP0129', 91, '16-May-2022', 'T0013', 'S0040');
INSERT INTO StockPurchase VALUES ('SP0130', 60, '13-Mar-2023', 'T0095', 'S0047');

INSERT INTO StockPurchase VALUES ('SP0131', 83, '24-Jan-2023', 'T0077', 'S0005');
INSERT INTO StockPurchase VALUES ('SP0132', 95, '19-May-2022', 'T0034', 'S0018');
INSERT INTO StockPurchase VALUES ('SP0133', 37, '28-Dec-2022', 'T0093', 'S0098');
INSERT INTO StockPurchase VALUES ('SP0134', 18, '20-Apr-2022', 'T0085', 'S0040');
INSERT INTO StockPurchase VALUES ('SP0135', 96, '21-Jul-2022', 'T0097', 'S0038');
INSERT INTO StockPurchase VALUES ('SP0136', 72, '23-Oct-2022', 'T0074', 'S0069');
INSERT INTO StockPurchase VALUES ('SP0137', 93, '19-Jan-2023', 'T0079', 'S0053');
INSERT INTO StockPurchase VALUES ('SP0138', 22, '24-Oct-2022', 'T0041', 'S0078');
INSERT INTO StockPurchase VALUES ('SP0139', 98, '26-Sep-2022', 'T0039', 'S0059');
INSERT INTO StockPurchase VALUES ('SP0140', 58, '17-May-2022', 'T0053', 'S0041');

INSERT INTO StockPurchase VALUES ('SP0141', 94, '27-Dec-2022', 'T0079', 'S0035');
INSERT INTO StockPurchase VALUES ('SP0142', 77, '16-Apr-2022', 'T0096', 'S0037');
INSERT INTO StockPurchase VALUES ('SP0143', 44, '25-Dec-2022', 'T0038', 'S0090');
INSERT INTO StockPurchase VALUES ('SP0144', 72, '29-Aug-2022', 'T0019', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0145', 90, '12-Jun-2022', 'T0099', 'S0073');
INSERT INTO StockPurchase VALUES ('SP0146', 37, '30-Jun-2022', 'T0035', 'S0017');
INSERT INTO StockPurchase VALUES ('SP0147', 42, '08-Nov-2022', 'T0036', 'S0046');
INSERT INTO StockPurchase VALUES ('SP0148', 34, '01-Apr-2023', 'T0037', 'S0017');
INSERT INTO StockPurchase VALUES ('SP0149', 83, '17-Jun-2022', 'T0081', 'S0008');
INSERT INTO StockPurchase VALUES ('SP0150', 29, '09-Jan-2023', 'T0055', 'S0063');

INSERT INTO StockPurchase VALUES ('SP0151', 51, '03-Mar-2023', 'T0091', 'S0003');
INSERT INTO StockPurchase VALUES ('SP0152', 28, '26-Aug-2022', 'T0081', 'S0023');
INSERT INTO StockPurchase VALUES ('SP0153', 61, '14-Dec-2022', 'T0036', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0154', 38, '25-Feb-2023', 'T0005', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0155', 89, '06-Mar-2023', 'T0094', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0156', 25, '11-Jun-2022', 'T0050', 'S0063');
INSERT INTO StockPurchase VALUES ('SP0157', 67, '28-Jul-2023', 'T0024', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0158', 64, '03-Aug-2022', 'T0097', 'S0054');
INSERT INTO StockPurchase VALUES ('SP0159', 27, '31-Aug-2022', 'T0086', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0160', 48, '11-Feb-2023', 'T0093', 'S0074');

INSERT INTO StockPurchase VALUES ('SP0161', 89, '17-Aug-2022', 'T0090', 'S0018');
INSERT INTO StockPurchase VALUES ('SP0162', 29, '27-Feb-2023', 'T0018', 'S0093');
INSERT INTO StockPurchase VALUES ('SP0163', 73, '24-May-2022', 'T0086', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0164', 17, '11-Jul-2022', 'T0052', 'S0066');
INSERT INTO StockPurchase VALUES ('SP0165', 56, '03-Nov-2022', 'T0008', 'S0016');
INSERT INTO StockPurchase VALUES ('SP0166', 57, '20-Jan-2023', 'T0063', 'S0040');
INSERT INTO StockPurchase VALUES ('SP0167', 26, '07-Jan-2023', 'T0045', 'S0044');
INSERT INTO StockPurchase VALUES ('SP0168', 30, '03-Dec-2022', 'T0087', 'S0035');
INSERT INTO StockPurchase VALUES ('SP0169', 63, '30-May-2022', 'T0023', 'S0022');
INSERT INTO StockPurchase VALUES ('SP0170', 92, '21-May-2022', 'T0045', 'S0002');

INSERT INTO StockPurchase VALUES ('SP0171', 36, '10-Jun-2022', 'T0071', 'S0033');
INSERT INTO StockPurchase VALUES ('SP0172', 28, '09-Nov-2022', 'T0018', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0173', 79, '10-Jul-2022', 'T0044', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0174', 39, '12-Apr-2022', 'T0017', 'S0052');
INSERT INTO StockPurchase VALUES ('SP0175', 91, '28-Jul-2022', 'T0036', 'S0007');
INSERT INTO StockPurchase VALUES ('SP0176', 97, '10-Oct-2022', 'T0092', 'S0050');
INSERT INTO StockPurchase VALUES ('SP0177', 59, '06-Nov-2022', 'T0036', 'S0045');
INSERT INTO StockPurchase VALUES ('SP0178', 41, '10-Nov-2022', 'T0026', 'S0009');
INSERT INTO StockPurchase VALUES ('SP0179', 56, '24-Nov-2022', 'T0064', 'S0083');
INSERT INTO StockPurchase VALUES ('SP0180', 17, '17-Jul-2022', 'T0022', 'S0022');

INSERT INTO StockPurchase VALUES ('SP0181', 98, '30-Sep-2022', 'T0050', 'S0095');
INSERT INTO StockPurchase VALUES ('SP0182', 86, '30-May-2022', 'T0088', 'S0015');
INSERT INTO StockPurchase VALUES ('SP0183', 50, '18-Aug-2022', 'T0016', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0184', 73, '23-Apr-2022', 'T0043', 'S0095');
INSERT INTO StockPurchase VALUES ('SP0185', 59, '12-Aug-2022', 'T0067', 'S0082');
INSERT INTO StockPurchase VALUES ('SP0186', 72, '03-Jun-2022', 'T0069', 'S0063');
INSERT INTO StockPurchase VALUES ('SP0187', 48, '21-Aug-2022', 'T0030', 'S0038');
INSERT INTO StockPurchase VALUES ('SP0188', 54, '13-Jun-2022', 'T0097', 'S0072');
INSERT INTO StockPurchase VALUES ('SP0189', 13, '19-Nov-2022', 'T0023', 'S0008');
INSERT INTO StockPurchase VALUES ('SP0190', 90, '11-Nov-2022', 'T0064', 'S0014');

INSERT INTO StockPurchase VALUES ('SP0191', 69, '17-Sep-2022', 'T0037', 'S0029');
INSERT INTO StockPurchase VALUES ('SP0192', 82, '30-Sep-2022', 'T0080', 'S0020');
INSERT INTO StockPurchase VALUES ('SP0193', 47, '25-Dec-2022', 'T0002', 'S0008');
INSERT INTO StockPurchase VALUES ('SP0194', 91, '20-Sep-2022', 'T0018', 'S0081');
INSERT INTO StockPurchase VALUES ('SP0195', 48, '02-Dec-2022', 'T0012', 'S0039');
INSERT INTO StockPurchase VALUES ('SP0196', 65, '07-May-2022', 'T0100', 'S0058');
INSERT INTO StockPurchase VALUES ('SP0197', 67, '25-Jun-2022', 'T0034', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0198', 93, '02-Oct-2022', 'T0085', 'S0049');
INSERT INTO StockPurchase VALUES ('SP0199', 44, '27-Aug-2022', 'T0053', 'S0058');
INSERT INTO StockPurchase VALUES ('SP0200', 76, '28-Aug-2022', 'T0027', 'S0064');

INSERT INTO StockPurchase VALUES ('SP0201', 58, '02-Oct-2022', 'T0012', 'S0008');
INSERT INTO StockPurchase VALUES ('SP0202', 35, '04-Apr-2023', 'T0051', 'S0097');
INSERT INTO StockPurchase VALUES ('SP0203', 23, '09-Apr-2023', 'T0040', 'S0039');
INSERT INTO StockPurchase VALUES ('SP0204', 25, '15-Feb-2023', 'T0065', 'S0034');
INSERT INTO StockPurchase VALUES ('SP0205', 55, '08-Feb-2023', 'T0047', 'S0022');
INSERT INTO StockPurchase VALUES ('SP0206', 48, '17-Mar-2023', 'T0073', 'S0077');
INSERT INTO StockPurchase VALUES ('SP0207', 62, '07-Jul-2022', 'T0034', 'S0025');
INSERT INTO StockPurchase VALUES ('SP0208', 82, '24-Mar-2023', 'T0069', 'S0003');
INSERT INTO StockPurchase VALUES ('SP0209', 75, '28-Sep-2022', 'T0084', 'S0015');
INSERT INTO StockPurchase VALUES ('SP0210', 24, '01-Jun-2022', 'T0035', 'S0022');

INSERT INTO StockPurchase VALUES ('SP0211', 43, '08-Jun-2022', 'T0095', 'S0010');
INSERT INTO StockPurchase VALUES ('SP0212', 84, '30-Nov-2022', 'T0096', 'S0054');
INSERT INTO StockPurchase VALUES ('SP0213', 66, '02-May-2022', 'T0086', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0214', 97, '23-Feb-2023', 'T0013', 'S0075');
INSERT INTO StockPurchase VALUES ('SP0215', 20, '29-May-2022', 'T0007', 'S0002');
INSERT INTO StockPurchase VALUES ('SP0216', 62, '24-May-2022', 'T0025', 'S0096');
INSERT INTO StockPurchase VALUES ('SP0217', 80, '18-Mar-2023', 'T0016', 'S0034');
INSERT INTO StockPurchase VALUES ('SP0218', 70, '03-Oct-2022', 'T0039', 'S0059');
INSERT INTO StockPurchase VALUES ('SP0219', 52, '05-May-2022', 'T0046', 'S0015');
INSERT INTO StockPurchase VALUES ('SP0220', 61, '19-Oct-2022', 'T0048', 'S0026');

INSERT INTO StockPurchase VALUES ('SP0221', 88, '27-Jun-2022', 'T0090', 'S0022');
INSERT INTO StockPurchase VALUES ('SP0222', 23, '06-Mar-2023', 'T0039', 'S0094');
INSERT INTO StockPurchase VALUES ('SP0223', 69, '29-Jul-2022', 'T0031', 'S0046');
INSERT INTO StockPurchase VALUES ('SP0224', 75, '14-Feb-2023', 'T0014', 'S0007');
INSERT INTO StockPurchase VALUES ('SP0225', 35, '22-Oct-2022', 'T0070', 'S0060');
INSERT INTO StockPurchase VALUES ('SP0226', 58, '08-Jan-2023', 'T0099', 'S0029');
INSERT INTO StockPurchase VALUES ('SP0227', 18, '20-Sep-2022', 'T0087', 'S0057');
INSERT INTO StockPurchase VALUES ('SP0228', 78, '05-Nov-2022', 'T0035', 'S0062');
INSERT INTO StockPurchase VALUES ('SP0229', 57, '17-Jun-2022', 'T0079', 'S0072');
INSERT INTO StockPurchase VALUES ('SP0230', 81, '29-Jun-2022', 'T0096', 'S0053');

INSERT INTO StockPurchase VALUES ('SP0231', 60, '22-Feb-2023', 'T0070', 'S0070');
INSERT INTO StockPurchase VALUES ('SP0232', 86, '07-Apr-2023', 'T0030', 'S0028');
INSERT INTO StockPurchase VALUES ('SP0233', 46, '09-Apr-2023', 'T0072', 'S0002');
INSERT INTO StockPurchase VALUES ('SP0234', 16, '23-Jun-2022', 'T0001', 'S0007');
INSERT INTO StockPurchase VALUES ('SP0235', 82, '10-Mar-2023', 'T0039', 'S0086');
INSERT INTO StockPurchase VALUES ('SP0236', 45, '14-Dec-2022', 'T0089', 'S0021');
INSERT INTO StockPurchase VALUES ('SP0237', 37, '28-May-2022', 'T0029', 'S0073');
INSERT INTO StockPurchase VALUES ('SP0238', 49, '21-Feb-2023', 'T0053', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0239', 23, '26-Sep-2022', 'T0046', 'S0056');
INSERT INTO StockPurchase VALUES ('SP0240', 26, '21-Mar-2023', 'T0014', 'S0024');

INSERT INTO StockPurchase VALUES ('SP0241', 22, '26-Sep-2022', 'T0021', 'S0071');
INSERT INTO StockPurchase VALUES ('SP0242', 17, '21-Mar-2023', 'T0051', 'S0080');
INSERT INTO StockPurchase VALUES ('SP0243', 70, '13-Jun-2022', 'T0029', 'S0006');
INSERT INTO StockPurchase VALUES ('SP0244', 12, '15-Apr-2022', 'T0013', 'S0025');
INSERT INTO StockPurchase VALUES ('SP0245', 36, '25-Mar-2023', 'T0053', 'S0051');
INSERT INTO StockPurchase VALUES ('SP0246', 42, '27-Dec-2022', 'T0097', 'S0016');
INSERT INTO StockPurchase VALUES ('SP0247', 16, '25-Sep-2022', 'T0076', 'S0024');
INSERT INTO StockPurchase VALUES ('SP0248', 86, '11-Nov-2022', 'T0093', 'S0094');
INSERT INTO StockPurchase VALUES ('SP0249', 58, '10-Feb-2023', 'T0030', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0250', 15, '10-Dec-2022', 'T0021', 'S0049');

INSERT INTO StockPurchase VALUES ('SP0251', 43, '09-Mar-2023', 'T0092', 'S0018');
INSERT INTO StockPurchase VALUES ('SP0252', 56, '29-Dec-2022', 'T0098', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0253', 11, '26-Mar-2023', 'T0002', 'S0031');
INSERT INTO StockPurchase VALUES ('SP0254', 72, '25-Sep-2022', 'T0065', 'S0077');
INSERT INTO StockPurchase VALUES ('SP0255', 38, '18-Aug-2022', 'T0073', 'S0036');
INSERT INTO StockPurchase VALUES ('SP0256', 33, '04-May-2022', 'T0020', 'S0017');
INSERT INTO StockPurchase VALUES ('SP0257', 70, '28-Jan-2023', 'T0028', 'S0002');
INSERT INTO StockPurchase VALUES ('SP0258', 20, '22-Mar-2023', 'T0011', 'S0010');
INSERT INTO StockPurchase VALUES ('SP0259', 100, '16-Oct-2022', 'T0090', 'S0052');
INSERT INTO StockPurchase VALUES ('SP0260', 21, '27-May-2022', 'T0030', 'S0050');

INSERT INTO StockPurchase VALUES ('SP0261', 67, '03-Mar-2023', 'T0078', 'S0096');
INSERT INTO StockPurchase VALUES ('SP0262', 56, '19-Oct-2022', 'T0004', 'S0047');
INSERT INTO StockPurchase VALUES ('SP0263', 34, '20-Oct-2022', 'T0073', 'S0063');
INSERT INTO StockPurchase VALUES ('SP0264', 82, '21-Dec-2022', 'T0094', 'S0031');
INSERT INTO StockPurchase VALUES ('SP0265', 40, '20-Oct-2022', 'T0097', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0266', 49, '24-Dec-2022', 'T0083', 'S0032');
INSERT INTO StockPurchase VALUES ('SP0267', 59, '01-Oct-2022', 'T0041', 'S0100');
INSERT INTO StockPurchase VALUES ('SP0268', 27, '01-Jun-2022', 'T0014', 'S0042');
INSERT INTO StockPurchase VALUES ('SP0269', 30, '21-May-2022', 'T0097', 'S0033');
INSERT INTO StockPurchase VALUES ('SP0270', 55, '02-Jan-2023', 'T0098', 'S0016');

INSERT INTO StockPurchase VALUES ('SP0271', 62, '21-Aug-2022', 'T0097', 'S0039');
INSERT INTO StockPurchase VALUES ('SP0272', 30, '08-Nov-2022', 'T0004', 'S0030');
INSERT INTO StockPurchase VALUES ('SP0273', 26, '26-May-2022', 'T0049', 'S0052');
INSERT INTO StockPurchase VALUES ('SP0274', 48, '10-Feb-2023', 'T0008', 'S0061');
INSERT INTO StockPurchase VALUES ('SP0275', 64, '19-Jun-2022', 'T0027', 'S0005');
INSERT INTO StockPurchase VALUES ('SP0276', 53, '28-Feb-2023', 'T0054', 'S0018');
INSERT INTO StockPurchase VALUES ('SP0277', 72, '08-Dec-2022', 'T0041', 'S0092');
INSERT INTO StockPurchase VALUES ('SP0278', 56, '09-Mar-2023', 'T0032', 'S0014');
INSERT INTO StockPurchase VALUES ('SP0279', 80, '13-Oct-2022', 'T0022', 'S0081');
INSERT INTO StockPurchase VALUES ('SP0280', 60, '25-Oct-2022', 'T0057', 'S0048');

INSERT INTO StockPurchase VALUES ('SP0281', 27, '25-Jul-2022', 'T0015', 'S0013');
INSERT INTO StockPurchase VALUES ('SP0282', 82, '27-Aug-2022', 'T0062', 'S0001');
INSERT INTO StockPurchase VALUES ('SP0283', 25, '27-Oct-2022', 'T0028', 'S0075');
INSERT INTO StockPurchase VALUES ('SP0284', 46, '19-Aug-2022', 'T0047', 'S0014');
INSERT INTO StockPurchase VALUES ('SP0285', 77, '19-Mar-2023', 'T0060', 'S0061');
INSERT INTO StockPurchase VALUES ('SP0286', 23, '27-Jun-2022', 'T0074', 'S0048');
INSERT INTO StockPurchase VALUES ('SP0287', 63, '07-Jun-2022', 'T0062', 'S0090');
INSERT INTO StockPurchase VALUES ('SP0288', 17, '15-Sep-2022', 'T0033', 'S0045');
INSERT INTO StockPurchase VALUES ('SP0289', 88, '20-Sep-2022', 'T0034', 'S0019');
INSERT INTO StockPurchase VALUES ('SP0290', 84, '13-Jul-2022', 'T0089', 'S0066');

INSERT INTO StockPurchase VALUES ('SP0291', 41, '15-Sep-2022', 'T0017', 'S0075');
INSERT INTO StockPurchase VALUES ('SP0292', 47, '20-Sep-2022', 'T0048', 'S0014');
INSERT INTO StockPurchase VALUES ('SP0293', 69, '13-Jul-2022', 'T0040', 'S0035');
INSERT INTO StockPurchase VALUES ('SP0294', 63, '21-Jun-2022', 'T0091', 'S0085');
INSERT INTO StockPurchase VALUES ('SP0295', 93, '16-Jun-2022', 'T0046', 'S0034');
INSERT INTO StockPurchase VALUES ('SP0296', 55, '20-Dec-2022', 'T0059', 'S0054');
INSERT INTO StockPurchase VALUES ('SP0297', 35, '18-Sep-2022', 'T0019', 'S0051');
INSERT INTO StockPurchase VALUES ('SP0298', 23, '14-Oct-2022', 'T0043', 'S0011');
INSERT INTO StockPurchase VALUES ('SP0299', 50, '25-Nov-2022', 'T0020', 'S0088');
INSERT INTO StockPurchase VALUES ('SP0300', 100, '19-May-2022', 'T0045', 'S0070');

--Orders
INSERT INTO Orders VALUES ('OR0001', '10-Dec-2022', 7792.89, 'C0001', 'E0005', 'PY0001', 'PR0008', 'D0001');
INSERT INTO Orders VALUES ('OR0002', '05-Sep-2022', 3531.83, 'C0002', 'E0010', 'PY0002', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0003', '14-Aug-2022', 12949.52, 'C0003', 'E0009', 'PY0003', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0004', '28-Apr-2022', 1113.54, 'C0004', 'E0006', 'PY0004', 'PR0000', 'D0002');
INSERT INTO Orders VALUES ('OR0005', '19-Sep-2022', 4783.64, 'C0005', 'E0022', 'PY0005', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0006', '03-Nov-2022', 18951.04, 'C0006', 'E0036', 'PY0006', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0007', '08-Mar-2023', 1671.78, 'C0007', 'E0020', 'PY0007', 'PR0000', 'D0003');
INSERT INTO Orders VALUES ('OR0008', '06-Feb-2023', 502.63, 'C0008', 'E0029', 'PY0008', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0009', '20-Feb-2023', 13906.75, 'C0009', 'E0040', 'PY0009', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0010', '27-Apr-2022', 3708.98, 'C0010', 'E0037', 'PY0010', 'PR0000', 'D0004');

INSERT INTO Orders VALUES ('OR0011', '26-Nov-2022', 9876.58, 'C0030', 'E0089', 'PY0011', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0012', '04-Feb-2023', 8987.92, 'C0097', 'E0012', 'PY0012', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0013', '21-Mar-2023', 10579.78, 'C0079', 'E0060', 'PY0013', 'PR0000', 'D0005');
INSERT INTO Orders VALUES ('OR0014', '05-Jun-2022', 10883.45, 'C0094', 'E0015', 'PY0014', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0015', '17-Jul-2022', 12501.82, 'C0001', 'E0021', 'PY0015', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0016', '19-Feb-2023', 14446.69, 'C0054', 'E0005', 'PY0016', 'PR0000', 'D0006');
INSERT INTO Orders VALUES ('OR0017', '01-Apr-2023', 650.68, 'C0046', 'E0020', 'PY0017', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0018', '09-Jun-2022', 15711.45, 'C0054', 'E0052', 'PY0018', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0019', '05-Oct-2022', 5351.40, 'C0033', 'E0043', 'PY0019', 'PR0000', 'D0007');
INSERT INTO Orders VALUES ('OR0020', '18-Jun-2022', 15342.35, 'C0038', 'E0094', 'PY0020', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0021', '23-Feb-2023', 4695.22, 'C0025', 'E0019', 'PY0021', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0022', '28-Oct-2022', 9762.04, 'C0059', 'E0085', 'PY0022', 'PR0005', 'D0008');
INSERT INTO Orders VALUES ('OR0023', '29-Aug-2022', 19474.84, 'C0037', 'E0013', 'PY0023', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0024', '14-Sep-2022', 13653.12, 'C0071', 'E0050', 'PY0024', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0025', '01-Oct-2022', 3965.78, 'C0093', 'E0033', 'PY0025', 'PR0000', 'D0009');
INSERT INTO Orders VALUES ('OR0026', '06-Feb-2023', 13868.28, 'C0081', 'E0032', 'PY0026', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0027', '30-Jun-2022', 14955.22, 'C0076', 'E0045', 'PY0027', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0028', '20-Mar-2023', 12611.56, 'C0075', 'E0047', 'PY0028', 'PR0000', 'D0010');
INSERT INTO Orders VALUES ('OR0029', '25-Jul-2022', 18923.46, 'C0071', 'E0084', 'PY0029', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0030', '04-Jan-2023', 17245.43, 'C0006', 'E0020', 'PY0030', 'PR0010', 'D0000');

INSERT INTO Orders VALUES ('OR0031', '12-Apr-2023', 14095.76, 'C0076', 'E0098', 'PY0031', 'PR0000', 'D0011');
INSERT INTO Orders VALUES ('OR0032', '28-Nov-2022', 5473.76, 'C0080', 'E0025', 'PY0032', 'PR0006', 'D0000');
INSERT INTO Orders VALUES ('OR0033', '02-May-2022', 6550.55, 'C0049', 'E0052', 'PY0033', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0034', '27-Aug-2022', 19821.01, 'C0075', 'E0002', 'PY0034', 'PR0000', 'D0012');
INSERT INTO Orders VALUES ('OR0035', '21-Mar-2023', 17240.72, 'C0004', 'E0013', 'PY0035', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0036', '15-Jan-2023', 8857.61, 'C0099', 'E0084', 'PY0036', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0037', '14-Sep-2022', 10604.92, 'C0006', 'E0081', 'PY0037', 'PR0000', 'D0013');
INSERT INTO Orders VALUES ('OR0038', '27-Feb-2023', 3965.78, 'C0064', 'E0042', 'PY0038', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0039', '25-Jan-2023', 13868.28, 'C0069', 'E0079', 'PY0039', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0040', '07-Nov-2022', 14955.22, 'C0021', 'E0038', 'PY0040', 'PR0000', 'D0014');

INSERT INTO Orders VALUES ('OR0041', '08-Oct-2022', 12611.56, 'C0006', 'E0004', 'PY0041', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0042', '17-Mar-2023', 18923.46, 'C0012', 'E0084', 'PY0042', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0043', '13-Feb-2023', 17245.43, 'C0086', 'E0045', 'PY0043', 'PR0000', 'D0015');
INSERT INTO Orders VALUES ('OR0044', '10-Jun-2022', 14095.76, 'C0008', 'E0002', 'PY0044', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0045', '15-Nov-2022', 5473.76, 'C0068', 'E0057', 'PY0045', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0046', '20-Nov-2022', 6550.55, 'C0080', 'E0050', 'PY0046', 'PR0000', 'D0016');
INSERT INTO Orders VALUES ('OR0047', '16-Feb-2023', 19821.01, 'C0051', 'E0061', 'PY0047', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0048', '15-Jun-2022', 17240.72, 'C0002', 'E0009', 'PY0048', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0049', '01-Aug-2022', 8857.61, 'C0015', 'E0065', 'PY0049', 'PR0000', 'D0017');
INSERT INTO Orders VALUES ('OR0050', '04-Feb-2023', 10604.92, 'C0052', 'E0024', 'PY0050', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0051', '18-Mar-2023', 1116.88, 'C0065', 'E0062', 'PY0051', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0052', '16-Oct-2022', 3104.86, 'C0030', 'E0025', 'PY0052', 'PR0000', 'D0018');
INSERT INTO Orders VALUES ('OR0053', '20-Jun-2022', 1949.60, 'C0076', 'E0015', 'PY0053', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0054', '19-Apr-2022', 18197.12, 'C0066', 'E0052', 'PY0054', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0055', '02-Aug-2022', 10282.64, 'C0048', 'E0041', 'PY0055', 'PR0000', 'D0019');
INSERT INTO Orders VALUES ('OR0056', '30-Nov-2022', 16163.31, 'C0020', 'E0073', 'PY0056', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0057', '16-Sep-2022', 1242.65, 'C0034', 'E0070', 'PY0057', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0058', '09-Apr-2023', 18465.15, 'C0068', 'E0034', 'PY0058', 'PR0000', 'D0020');
INSERT INTO Orders VALUES ('OR0059', '25-Sep-2022', 11324.77, 'C0043', 'E0060', 'PY0059', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0060', '01-Mar-2023', 6797.94, 'C0071', 'E0012', 'PY0060', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0061', '23-Sep-2022', 17771.72, 'C0062', 'E0053', 'PY0061', 'PR0000', 'D0021');
INSERT INTO Orders VALUES ('OR0062', '05-Mar-2023', 6553.52, 'C0006', 'E0022', 'PY0062', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0063', '18-Jul-2022', 14166.01, 'C0052', 'E0019', 'PY0063', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0064', '22-Apr-2022', 19708.74, 'C0046', 'E0008', 'PY0064', 'PR0000', 'D0022');
INSERT INTO Orders VALUES ('OR0065', '28-Oct-2022', 8272.28, 'C0067', 'E0005', 'PY0065', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0066', '02-Jun-2022', 17400.96, 'C0005', 'E0092', 'PY0066', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0067', '28-Aug-2022', 8273.32, 'C0056', 'E0040', 'PY0067', 'PR0003', 'D0023');
INSERT INTO Orders VALUES ('OR0068', '07-May-2022', 15519.88, 'C0025', 'E0094', 'PY0068', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0069', '18-Jul-2022', 8312.79, 'C0007', 'E0074', 'PY0069', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0070', '28-Dec-2022', 15664.94, 'C0096', 'E0099', 'PY0070', 'PR0008', 'D0024');

INSERT INTO Orders VALUES ('OR0071', '04-Jan-2023', 17404.68, 'C0068', 'E0079', 'PY0071', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0072', '27-Mar-2023', 12789.97, 'C0083', 'E0019', 'PY0072', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0073', '19-Feb-2022', 18411.15, 'C0084', 'E0091', 'PY0073', 'PR0000', 'D0025');
INSERT INTO Orders VALUES ('OR0074', '08-Jun-2022', 2049.61, 'C0016', 'E0015', 'PY0074', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0075', '19-Nov-2022', 9732.63, 'C0011', 'E0057', 'PY0075', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0076', '05-Feb-2023', 4918.73, 'C0041', 'E0020', 'PY0076', 'PR0000', 'D0026');
INSERT INTO Orders VALUES ('OR0077', '08-Nov-2022', 10928.20, 'C0010', 'E0039', 'PY0077', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0078', '07-Jun-2022', 11752.92, 'C0064', 'E0099', 'PY0078', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0079', '07-Jul-2022', 1459.09, 'C0069', 'E0018', 'PY0079', 'PR0000', 'D0027');
INSERT INTO Orders VALUES ('OR0080', '18-Feb-2023', 6360.58, 'C0077', 'E0084', 'PY0080', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0081', '09-Nov-2022', 6344.51, 'C0093', 'E0025', 'PY0081', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0082', '12-Jul-2022', 8788.44, 'C0038', 'E0100', 'PY0082', 'PR0000', 'D0028');
INSERT INTO Orders VALUES ('OR0083', '13-Dec-2022', 8483.34, 'C0020', 'E0048', 'PY0083', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0084', '27-May-2022', 2244.66, 'C0003', 'E0095', 'PY0084', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0085', '12-Sep-2022', 1355.06, 'C0050', 'E0010', 'PY0085', 'PR0000', 'D0029');
INSERT INTO Orders VALUES ('OR0086', '05-Jun-2022', 9041.62, 'C0015', 'E0033', 'PY0086', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0087', '01-Jan-2023', 19482.85, 'C0083', 'E0089', 'PY0087', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0088', '09-Sep-2022', 9548.43, 'C0041', 'E0054', 'PY0088', 'PR0000', 'D0030');
INSERT INTO Orders VALUES ('OR0089', '24-Feb-2023', 18689.41, 'C0071', 'E0090', 'PY0089', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0090', '11-Oct-2022', 942.52, 'C0099', 'E0058', 'PY0090', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0091', '07-Aug-2022', 17655.52, 'C0061', 'E0067', 'PY0091', 'PR0000', 'D0031');
INSERT INTO Orders VALUES ('OR0092', '28-Jul-2022', 8954.68, 'C0095', 'E0010', 'PY0092', 'PR0002', 'D0000');
INSERT INTO Orders VALUES ('OR0093', '05-Sep-2022', 14366.14, 'C0029', 'E0081', 'PY0093', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0094', '09-Nov-2022', 5124.34, 'C0055', 'E0087', 'PY0094', 'PR0000', 'D0032');
INSERT INTO Orders VALUES ('OR0095', '03-Apr-2023', 3192.68, 'C0031', 'E0094', 'PY0095', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0096', '08-Aug-2022', 19118.47, 'C0077', 'E0070', 'PY0096', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0097', '01-Aug-2022', 12919.34, 'C0041', 'E0021', 'PY0097', 'PR0000', 'D0033');
INSERT INTO Orders VALUES ('OR0098', '14-Oct-2022', 11623.94, 'C0088', 'E0066', 'PY0098', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0099', '21-May-2022', 18505.23, 'C0053', 'E0060', 'PY0099', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0100', '23-Nov-2022', 13337.98, 'C0015', 'E0057', 'PY0100', 'PR0000', 'D0034');

INSERT INTO Orders VALUES ('OR0101', '26-Dec-2022', 7826.32, 'C0071', 'E0010', 'PY0101', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0102', '28-Apr-2022', 18055.81, 'C0015', 'E0031', 'PY0102', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0103', '23-Mar-2023', 17193.32, 'C0036', 'E0089', 'PY0103', 'PR0000', 'D0035');
INSERT INTO Orders VALUES ('OR0104', '20-Oct-2022', 18704.08, 'C0011', 'E0067', 'PY0104', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0105', '27-May-2022', 7241.57, 'C0010', 'E0045', 'PY0105', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0106', '20-Jul-2022', 6550.91, 'C0022', 'E0060', 'PY0106', 'PR0000', 'D0036');
INSERT INTO Orders VALUES ('OR0107', '14-Jul-2022', 14729.78, 'C0088', 'E0077', 'PY0107', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0108', '15-Dec-2022', 4852.20, 'C0090', 'E0036', 'PY0108', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0109', '28-Sep-2022', 11862.38, 'C0028', 'E0066', 'PY0109', 'PR0000', 'D0037');
INSERT INTO Orders VALUES ('OR0110', '02-Mar-2023', 8408.86, 'C0098', 'E0070', 'PY0110', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0111', '29-Nov-2022', 2344.30, 'C0037', 'E0074', 'PY0111', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0112', '08-Feb-2023', 3228.64, 'C0081', 'E0011', 'PY0112', 'PR0000', 'D0038');
INSERT INTO Orders VALUES ('OR0113', '15-Jun-2022', 17324.12, 'C0064', 'E0008', 'PY0113', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0114', '24-Jul-2022', 14906.73, 'C0065', 'E0036', 'PY0114', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0115', '24-Nov-2022', 16716.94, 'C0031', 'E0055', 'PY0115', 'PR0000', 'D0039');
INSERT INTO Orders VALUES ('OR0116', '11-Sep-2022', 8495.78, 'C0038', 'E0097', 'PY0116', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0117', '01-Jan-2023', 8225.60, 'C0085', 'E0056', 'PY0117', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0118', '14-Jan-2023', 18255.98, 'C0006', 'E0063', 'PY0118', 'PR0010', 'D0040');
INSERT INTO Orders VALUES ('OR0119', '02-Jan-2023', 4894.69, 'C0055', 'E0003', 'PY0119', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0120', '09-Mar-2023', 7024.28, 'C0028', 'E0092', 'PY0120', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0121', '20-Jun-2022', 9183.27, 'C0028', 'E0079', 'PY0121', 'PR0000', 'D0041');
INSERT INTO Orders VALUES ('OR0122', '25-Oct-2022', 11533.79, 'C0071', 'E0086', 'PY0122', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0123', '27-Jul-2022', 18042.56, 'C0009', 'E0035', 'PY0123', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0124', '14-May-2022', 5809.59, 'C0052', 'E0096', 'PY0124', 'PR0000', 'D0042');
INSERT INTO Orders VALUES ('OR0125', '18-May-2022', 235.76, 'C0086', 'E0031', 'PY0125', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0126', '19-Nov-2022', 1008.71, 'C0083', 'E0070', 'PY0126', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0127', '01-Apr-2023', 12275.98, 'C0096', 'E0003', 'PY0127', 'PR0000', 'D0043');
INSERT INTO Orders VALUES ('OR0128', '24-Jul-2022', 9272.39, 'C0060', 'E0065', 'PY0128', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0129', '09-Nov-2022', 19752.64, 'C0076', 'E0074', 'PY0129', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0130', '26-Dec-2022', 8800.07, 'C0073', 'E0043', 'PY0130', 'PR0008', 'D0044');

INSERT INTO Orders VALUES ('OR0131', '25-Jul-2022', 9941.44, 'C0023', 'E0042', 'PY0131', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0132', '09-May-2022', 15099.54, 'C0008', 'E0068', 'PY0132', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0133', '01-Sep-2022', 19215.16, 'C0079', 'E0001', 'PY0133', 'PR0000', 'D0045');
INSERT INTO Orders VALUES ('OR0134', '16-Apr-2022', 3764.93, 'C0002', 'E0048', 'PY0134', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0135', '14-Oct-2022', 886.34, 'C0007', 'E0032', 'PY0135', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0136', '28-Mar-2023', 12447.12, 'C0031', 'E0087', 'PY0136', 'PR0000', 'D0046');
INSERT INTO Orders VALUES ('OR0137', '24-Mar-2023', 2957.19, 'C0032', 'E0044', 'PY0137', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0138', '20-Feb-2023', 5847.65, 'C0005', 'E0024', 'PY0138', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0139', '30-Nov-2022', 5230.25, 'C0086', 'E0070', 'PY0139', 'PR0000', 'D0047');
INSERT INTO Orders VALUES ('OR0140', '25-May-2022', 870.46, 'C0092', 'E0062', 'PY0140', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0141', '21-Oct-2022', 6203.08, 'C0057', 'E0071', 'PY0141', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0142', '11-Aug-2022', 14548.57, 'C0008', 'E0008', 'PY0142', 'PR0000', 'D0048');
INSERT INTO Orders VALUES ('OR0143', '24-Apr-2022', 16929.41, 'C0075', 'E0094', 'PY0143', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0144', '28-Jul-2022', 17056.76, 'C0083', 'E0088', 'PY0144', 'PR0002', 'D0000');
INSERT INTO Orders VALUES ('OR0145', '08-Dec-2022', 13470.55, 'C0091', 'E0014', 'PY0145', 'PR0008', 'D0049');
INSERT INTO Orders VALUES ('OR0146', '04-Oct-2022', 6358.09, 'C0081', 'E0017', 'PY0146', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0147', '25-Mar-2023', 19465.15, 'C0058', 'E0098', 'PY0147', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0148', '04-Oct-2022', 10942.72, 'C0080', 'E0037', 'PY0148', 'PR0000', 'D0050');
INSERT INTO Orders VALUES ('OR0149', '25-Mar-2023', 2960.79, 'C0045', 'E0016', 'PY0149', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0150', '01-Oct-2022', 9802.13, 'C0012', 'E0076', 'PY0150', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0151', '11-Sep-2022', 6074.86, 'C0091', 'E0034', 'PY0151', 'PR0000', 'D0051');
INSERT INTO Orders VALUES ('OR0152', '06-Nov-2022', 17146.31, 'C0053', 'E0002', 'PY0152', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0153', '28-Dec-2022', 3702.36, 'C0019', 'E0004', 'PY0153', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0154', '30-Sep-2022', 3370.94, 'C0090', 'E0052', 'PY0154', 'PR0000', 'D0052');
INSERT INTO Orders VALUES ('OR0155', '22-Mar-2023', 2053.36, 'C0087', 'E0023', 'PY0155', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0156', '28-Jan-2023', 13833.63, 'C0100', 'E0001', 'PY0156', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0157', '10-Feb-2023', 15367.92, 'C0098', 'E0011', 'PY0157', 'PR0000', 'D0053');
INSERT INTO Orders VALUES ('OR0158', '12-Sep-2022', 408.68, 'C0025', 'E0057', 'PY0158', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0159', '29-Oct-2022', 9680.50, 'C0034', 'E0035', 'PY0159', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0160', '30-Apr-2022', 6977.38, 'C0078', 'E0066', 'PY0160', 'PR0000', 'D0054');

INSERT INTO Orders VALUES ('OR0161', '31-Jul-2022', 6259.81, 'C0095', 'E0056', 'PY0161', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0162', '22-Sep-2022', 1074.43, 'C0028', 'E0048', 'PY0162', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0163', '29-May-2022', 11995.36, 'C0056', 'E0095', 'PY0163', 'PR0000', 'D0055');
INSERT INTO Orders VALUES ('OR0164', '25-Nov-2022', 5780.20, 'C0042', 'E0096', 'PY0164', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0165', '24-Feb-2023', 8667.32, 'C0007', 'E0029', 'PY0165', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0166', '27-Sep-2022', 2109.90, 'C0088', 'E0066', 'PY0166', 'PR0000', 'D0056');
INSERT INTO Orders VALUES ('OR0167', '09-Nov-2022', 2648.96, 'C0021', 'E0019', 'PY0167', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0168', '05-Aug-2022', 19513.65, 'C0080', 'E0045', 'PY0168', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0169', '22-Oct-2022', 15668.34, 'C0038', 'E0004', 'PY0169', 'PR0000', 'D0057');
INSERT INTO Orders VALUES ('OR0170', '22-Dec-2022', 9034.96, 'C0034', 'E0092', 'PY0170', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0171', '26-Jul-2022', 13911.39, 'C0071', 'E0089', 'PY0171', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0172', '30-May-2022', 8065.53, 'C0094', 'E0054', 'PY0172', 'PR0000', 'D0058');
INSERT INTO Orders VALUES ('OR0173', '11-Aug-2022', 6927.15, 'C0035', 'E0092', 'PY0173', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0174', '20-Dec-2022', 15766.87, 'C0016', 'E0046', 'PY0174', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0175', '24-Jul-2022', 10352.24, 'C0049', 'E0004', 'PY0175', 'PR0000', 'D0059');
INSERT INTO Orders VALUES ('OR0176', '24-Dec-2022', 16230.59, 'C0069', 'E0090', 'PY0176', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0177', '05-Aug-2022', 17900.03, 'C0079', 'E0038', 'PY0177', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0178', '28-Dec-2022', 1614.33, 'C0085', 'E0020', 'PY0178', 'PR0008', 'D0060');
INSERT INTO Orders VALUES ('OR0179', '15-Jul-2022', 17680.82, 'C0100', 'E0065', 'PY0179', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0180', '09-Feb-2023', 11205.03, 'C0073', 'E0081', 'PY0180', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0181', '02-May-2022', 11060.03, 'C0042', 'E0066', 'PY0181', 'PR0000', 'D0061');
INSERT INTO Orders VALUES ('OR0182', '02-Nov-2022', 16242.62, 'C0070', 'E0049', 'PY0182', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0183', '27-Sep-2022', 3506.54, 'C0022', 'E0019', 'PY0183', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0184', '14-Sep-2022', 2109.62, 'C0049', 'E0011', 'PY0184', 'PR0000', 'D0062');
INSERT INTO Orders VALUES ('OR0185', '25-Mar-2023', 13676.61, 'C0039', 'E0030', 'PY0185', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0186', '23-Apr-2022', 4221.02, 'C0001', 'E0050', 'PY0186', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0187', '05-Jul-2022', 7356.23, 'C0077', 'E0095', 'PY0187', 'PR0000', 'D0063');
INSERT INTO Orders VALUES ('OR0188', '03-Apr-2023', 12068.58, 'C0075', 'E0015', 'PY0188', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0189', '14-Mar-2023', 2581.57, 'C0053', 'E0097', 'PY0189', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0190', '21-Aug-2022', 19872.66, 'C0088', 'E0035', 'PY0190', 'PR0000', 'D0064');

INSERT INTO Orders VALUES ('OR0191', '25-Apr-2022', 3061.52, 'C0088', 'E0080', 'PY0191', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0192', '14-May-2022', 19518.70, 'C0050', 'E0031', 'PY0192', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0193', '26-Apr-2022', 15726.71, 'C0084', 'E0020', 'PY0193', 'PR0000', 'D0065');
INSERT INTO Orders VALUES ('OR0194', '21-May-2022', 17788.91, 'C0099', 'E0024', 'PY0194', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0195', '27-Nov-2022', 5577.07, 'C0089', 'E0052', 'PY0195', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0196', '10-Jan-2023', 7085.20, 'C0062', 'E0023', 'PY0196', 'PR0010', 'D0066');
INSERT INTO Orders VALUES ('OR0197', '05-Apr-2023', 14402.80, 'C0017', 'E0045', 'PY0197', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0198', '27-Jun-2022', 9062.51, 'C0075', 'E0047', 'PY0198', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0199', '18-May-2022', 2502.20, 'C0012', 'E0055', 'PY0199', 'PR0000', 'D0067');
INSERT INTO Orders VALUES ('OR0200', '21-Oct-2022', 3932.70, 'C0011', 'E0032', 'PY0200', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0201', '01-May-2022', 12671.97, 'C0069', 'E0090', 'PY0201', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0202', '06-Aug-2022', 9666.77, 'C0042', 'E0086', 'PY0202', 'PR0000', 'D0068');
INSERT INTO Orders VALUES ('OR0203', '07-Jul-2022', 16975.78, 'C0092', 'E0025', 'PY0203', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0204', '18-May-2022', 15559.11, 'C0098', 'E0058', 'PY0204', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0205', '25-Feb-2023', 14358.47, 'C0100', 'E0082', 'PY0205', 'PR0000', 'D0069');
INSERT INTO Orders VALUES ('OR0206', '13-Oct-2022', 3779.36, 'C0067', 'E0097', 'PY0206', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0207', '07-Feb-2023', 11831.75, 'C0051', 'E0004', 'PY0207', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0208', '10-Mar-2023', 2494.35, 'C0061', 'E0072', 'PY0208', 'PR0000', 'D0070');
INSERT INTO Orders VALUES ('OR0209', '14-May-2023', 6768.10, 'C0060', 'E0095', 'PY0209', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0210', '27-Jan-2023', 13641.73, 'C0090', 'E0098', 'PY0210', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0211', '09-Jul-2022', 19339.53, 'C0093', 'E0036', 'PY0211', 'PR0000', 'D0071');
INSERT INTO Orders VALUES ('OR0212', '11-Nov-2022', 14769.10, 'C0051', 'E0049', 'PY0212', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0213', '10-Jun-2022', 2635.08, 'C0084', 'E0024', 'PY0213', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0214', '20-Feb-2023', 13412.36, 'C0032', 'E0040', 'PY0214', 'PR0000', 'D0072');
INSERT INTO Orders VALUES ('OR0215', '10-Sep-2022', 17142.97, 'C0067', 'E0047', 'PY0215', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0216', '09-Jun-2022', 14763.94, 'C0028', 'E0053', 'PY0216', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0217', '15-Mar-2023', 18902.95, 'C0059', 'E0044', 'PY0217', 'PR0000', 'D0073');
INSERT INTO Orders VALUES ('OR0218', '26-Apr-2022', 14019.75, 'C0003', 'E0071', 'PY0218', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0219', '06-Dec-2022', 2784.49, 'C0023', 'E0081', 'PY0219', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0220', '27-Mar-2023', 4836.02, 'C0054', 'E0008', 'PY0220', 'PR0000', 'D0074');

INSERT INTO Orders VALUES ('OR0221', '24-Mar-2023', 16386.39, 'C0052', 'E0040', 'PY0221', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0222', '03-Dec-2022', 11611.03, 'C0028', 'E0013', 'PY0222', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0223', '14-Jun-2022', 3833.05, 'C0058', 'E0017', 'PY0223', 'PR0000', 'D0075');
INSERT INTO Orders VALUES ('OR0224', '16-May-2022', 8624.18, 'C0033', 'E0029', 'PY0224', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0225', '13-Jul-2022', 1197.70, 'C0017', 'E0074', 'PY0225', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0226', '07-Jul-2022', 2845.28, 'C0045', 'E0028', 'PY0226', 'PR0000', 'D0076');
INSERT INTO Orders VALUES ('OR0227', '13-Jun-2022', 2649.42, 'C0003', 'E0065', 'PY0227', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0228', '06-Oct-2022', 19579.28, 'C0076', 'E0049', 'PY0228', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0229', '23-Dec-2022', 19618.56, 'C0041', 'E0031', 'PY0229', 'PR0008', 'D0077');
INSERT INTO Orders VALUES ('OR0230', '25-May-2022', 5981.86, 'C0081', 'E0099', 'PY0230', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0231', '22-Mar-2023', 12511.51, 'C0098', 'E0042', 'PY0231', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0232', '16-Apr-2022', 9383.95, 'C0085', 'E0083', 'PY0232', 'PR0000', 'D0078');
INSERT INTO Orders VALUES ('OR0233', '15-Aug-2022', 10281.25, 'C0043', 'E0090', 'PY0233', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0234', '25-Jun-2022', 16581.01, 'C0047', 'E0067', 'PY0234', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0235', '01-Feb-2023', 9917.52, 'C0097', 'E0013', 'PY0235', 'PR0000', 'D0079');
INSERT INTO Orders VALUES ('OR0236', '12-Apr-2023', 16673.84, 'C0013', 'E0040', 'PY0236', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0237', '04-Jul-2022', 10409.11, 'C0037', 'E0050', 'PY0237', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0238', '15-Mar-2023', 4256.31, 'C0050', 'E0053', 'PY0238', 'PR0000', 'D0080');
INSERT INTO Orders VALUES ('OR0239', '16-Aug-2022', 4911.03, 'C0090', 'E0060', 'PY0239', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0240', '12-Dec-2022', 6491.78, 'C0099', 'E0072', 'PY0240', 'PR0008', 'D0000');

INSERT INTO Orders VALUES ('OR0241', '02-Dec-2022', 2541.88, 'C0057', 'E0050', 'PY0241', 'PR0008', 'D0081');
INSERT INTO Orders VALUES ('OR0242', '12-Jul-2022', 19261.88, 'C0041', 'E0015', 'PY0242', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0243', '06-Sep-2022', 2402.72, 'C0023', 'E0008', 'PY0243', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0244', '11-Jul-2022', 10144.67, 'C0025', 'E0053', 'PY0244', 'PR0000', 'D0082');
INSERT INTO Orders VALUES ('OR0245', '06-Aug-2022', 9991.09, 'C0072', 'E0027', 'PY0245', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0246', '04-Jun-2022', 2043.16, 'C0082', 'E0072', 'PY0246', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0247', '27-May-2022', 6128.86, 'C0016', 'E0041', 'PY0247', 'PR0000', 'D0083');
INSERT INTO Orders VALUES ('OR0248', '21-Oct-2022', 382.78, 'C0011', 'E0098', 'PY0248', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0249', '25-Jan-2023', 2838.54, 'C0085', 'E0096', 'PY0249', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0250', '03-Feb-2023', 1770.76, 'C0056', 'E0037', 'PY0250', 'PR0000', 'D0084');

INSERT INTO Orders VALUES ('OR0251', '06-Mar-2023', 2728.91, 'C0036', 'E0048', 'PY0251', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0252', '31-May-2022', 14813.05, 'C0022', 'E0084', 'PY0252', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0253', '16-Oct-2022', 9480.38, 'C0020', 'E0024', 'PY0253', 'PR0000', 'D0085');
INSERT INTO Orders VALUES ('OR0254', '18-Aug-2022', 2440.14, 'C0081', 'E0069', 'PY0254', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0255', '20-Aug-2022', 1243.46, 'C0100', 'E0003', 'PY0255', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0256', '27-May-2022', 19391.89, 'C0069', 'E0075', 'PY0256', 'PR0000', 'D0086');
INSERT INTO Orders VALUES ('OR0257', '24-Jul-2022', 8517.35, 'C0005', 'E0029', 'PY0257', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0258', '26-Nov-2022', 11562.30, 'C0043', 'E0028', 'PY0258', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0259', '28-Dec-2022', 14257.13, 'C0011', 'E0095', 'PY0259', 'PR0008', 'D0087');
INSERT INTO Orders VALUES ('OR0260', '07-Dec-2022', 16403.86, 'C0084', 'E0044', 'PY0260', 'PR0008', 'D0000');

INSERT INTO Orders VALUES ('OR0261', '08-Jan-2023', 4008.73, 'C0017', 'E0074', 'PY0261', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0262', '03-Nov-2022', 3590.88, 'C0015', 'E0015', 'PY0262', 'PR0000', 'D0088');
INSERT INTO Orders VALUES ('OR0263', '26-Aug-2022', 6772.33, 'C0086', 'E0060', 'PY0263', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0264', '14-Oct-2022', 6232.65, 'C0010', 'E0081', 'PY0264', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0265', '19-Jan-2023', 8573.30, 'C0007', 'E0079', 'PY0265', 'PR0010', 'D0089');
INSERT INTO Orders VALUES ('OR0266', '28-Aug-2022', 6999.98, 'C0052', 'E0039', 'PY0266', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0267', '21-Sep-2022', 15996.78, 'C0058', 'E0047', 'PY0267', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0268', '16-May-2022', 696.88, 'C0099', 'E0019', 'PY0268', 'PR0000', 'D0090');
INSERT INTO Orders VALUES ('OR0269', '24-Jul-2022', 11536.12, 'C0063', 'E0084', 'PY0269', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0270', '16-Sep-2022', 1138.79, 'C0003', 'E0013', 'PY0270', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0271', '16-Aug-2022', 17469.10, 'C0024', 'E0047', 'PY0271', 'PR0000', 'D0091');
INSERT INTO Orders VALUES ('OR0272', '13-Mar-2023', 3930.42, 'C0025', 'E0044', 'PY0272', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0273', '13-Mar-2023', 16466.43, 'C0018', 'E0080', 'PY0273', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0274', '27-Jan-2023', 3235.12, 'C0028', 'E0061', 'PY0274', 'PR0010', 'D0092');
INSERT INTO Orders VALUES ('OR0275', '06-Dec-2022', 1007.50, 'C0051', 'E0089', 'PY0275', 'PR0008', 'D0000');
INSERT INTO Orders VALUES ('OR0276', '21-Mar-2023', 1729.28, 'C0034', 'E0023', 'PY0276', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0277', '12-Dec-2022', 16404.52, 'C0022', 'E0006', 'PY0277', 'PR0008', 'D0093');
INSERT INTO Orders VALUES ('OR0278', '29-Nov-2022', 12956.02, 'C0040', 'E0026', 'PY0278', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0279', '15-Jul-2022', 15286.60, 'C0057', 'E0078', 'PY0279', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0280', '17-Apr-2022', 15413.66, 'C0062', 'E0084', 'PY0280', 'PR0000', 'D0094');

INSERT INTO Orders VALUES ('OR0281', '15-Sep-2022', 10662.69, 'C0020', 'E0064', 'PY0281', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0282', '08-Mar-2023', 5956.88, 'C0025', 'E0004', 'PY0282', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0283', '10-Oct-2022', 6801.54, 'C0043', 'E0043', 'PY0283', 'PR0000', 'D0095');
INSERT INTO Orders VALUES ('OR0284', '04-Apr-2023', 15305.38, 'C0055', 'E0041', 'PY0284', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0285', '27-May-2022', 11523.31, 'C0095', 'E0016', 'PY0285', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0286', '23-Jul-2022', 18900.88, 'C0013', 'E0040', 'PY0286', 'PR0000', 'D0096');
INSERT INTO Orders VALUES ('OR0287', '15-Feb-2023', 18589.68, 'C0038', 'E0073', 'PY0287', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0288', '05-Jun-2022', 17075.88, 'C0015', 'E0069', 'PY0288', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0289', '02-Nov-2022', 16417.01, 'C0100', 'E0083', 'PY0289', 'PR0000', 'D0097');
INSERT INTO Orders VALUES ('OR0290', '15-Apr-2022', 1537.48, 'C0054', 'E0036', 'PY0290', 'PR0000', 'D0000');

INSERT INTO Orders VALUES ('OR0291', '08-Oct-2022', 16052.42, 'C0098', 'E0047', 'PY0291', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0292', '08-Feb-2023', 7620.09, 'C0021', 'E0050', 'PY0292', 'PR0000', 'D0098');
INSERT INTO Orders VALUES ('OR0293', '09-Jan-2023', 2492.20, 'C0043', 'E0043', 'PY0293', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0294', '05-Sep-2022', 13051.84, 'C0065', 'E0033', 'PY0294', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0295', '25-Sep-2022', 1665.15, 'C0058', 'E0070', 'PY0295', 'PR0000', 'D0099');
INSERT INTO Orders VALUES ('OR0296', '22-Jul-2022', 13923.74, 'C0033', 'E0069', 'PY0296', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0297', '04-Nov-2022', 7095.72, 'C0057', 'E0060', 'PY0297', 'PR0000', 'D0000');
INSERT INTO Orders VALUES ('OR0298', '11-Jul-2022', 8013.57, 'C0040', 'E0094', 'PY0298', 'PR0000', 'D0100');
INSERT INTO Orders VALUES ('OR0299', '30-Jan-2023', 2310.91, 'C0047', 'E0074', 'PY0299', 'PR0010', 'D0000');
INSERT INTO Orders VALUES ('OR0300', '25-Jan-2022', 4882.57, 'C0059', 'E0057', 'PY0300', 'PR0010', 'D0000');

--OrderDetails
INSERT INTO OrderDetails VALUES ('OR0001', 'T0071', 14, 200.00, 7592.89);
INSERT INTO OrderDetails VALUES ('OR0002', 'T0026', 4, 100.00, 3431.43);
INSERT INTO OrderDetails VALUES ('OR0003', 'T0090', 14, 50.00, 12899.52);
INSERT INTO OrderDetails VALUES ('OR0004', 'T0039', 1, 150.00, 963.54);
INSERT INTO OrderDetails VALUES ('OR0005', 'T0034', 20, 20.00, 4763.64);
INSERT INTO OrderDetails VALUES ('OR0006', 'T0067', 18, 100.00, 18851.04);
INSERT INTO OrderDetails VALUES ('OR0007', 'T0093', 12, 80.00, 1591.78);
INSERT INTO OrderDetails VALUES ('OR0008', 'T0008', 3, 180.00, 332.63);
INSERT INTO OrderDetails VALUES ('OR0009', 'T0097', 15, 110.00, 13796.75);
INSERT INTO OrderDetails VALUES ('OR0010', 'T0080', 9, 60.00, 3648.98);

INSERT INTO OrderDetails VALUES ('OR0011', 'T0097', 9, 200.00, 9676.58);
INSERT INTO OrderDetails VALUES ('OR0012', 'T0024', 15, 100.00, 8887.92);
INSERT INTO OrderDetails VALUES ('OR0013', 'T0001', 14, 50.00, 10529.78);
INSERT INTO OrderDetails VALUES ('OR0014', 'T0084', 10, 150.00, 10733.45);
INSERT INTO OrderDetails VALUES ('OR0015', 'T0036', 5, 20.00, 12481.82);
INSERT INTO OrderDetails VALUES ('OR0016', 'T0027', 12, 100.00, 14346.69);
INSERT INTO OrderDetails VALUES ('OR0017', 'T0116', 7, 80.00, 570.68);
INSERT INTO OrderDetails VALUES ('OR0018', 'T0028', 18, 180.00, 15531.45);
INSERT INTO OrderDetails VALUES ('OR0019', 'T0017', 16, 110.00, 5241.40);
INSERT INTO OrderDetails VALUES ('OR0020', 'T0081', 1, 60.00, 15282.35);

INSERT INTO OrderDetails VALUES ('OR0021', 'T0026', 4, 200.00, 4495.22);
INSERT INTO OrderDetails VALUES ('OR0022', 'T0081', 16, 100.00, 9662.04);
INSERT INTO OrderDetails VALUES ('OR0023', 'T0106', 2, 50.00, 19424.84);
INSERT INTO OrderDetails VALUES ('OR0024', 'T0090', 13, 150.00, 13500.12);
INSERT INTO OrderDetails VALUES ('OR0025', 'T0150', 14, 20.00, 3945.78);
INSERT INTO OrderDetails VALUES ('OR0026', 'T0087', 5, 100.00, 13768.28);
INSERT INTO OrderDetails VALUES ('OR0027', 'T0154', 1, 80.00, 14870.22);
INSERT INTO OrderDetails VALUES ('OR0028', 'T0012', 11, 180.00, 12431.56);
INSERT INTO OrderDetails VALUES ('OR0029', 'T0016', 6, 110.00, 18813.46);
INSERT INTO OrderDetails VALUES ('OR0030', 'T0062', 3, 60.00, 17185.43);

INSERT INTO OrderDetails VALUES ('OR0031', 'T0011', 4, 200.00, 13895.76);
INSERT INTO OrderDetails VALUES ('OR0032', 'T0047', 20, 100.00, 5373.76);
INSERT INTO OrderDetails VALUES ('OR0033', 'T0034', 13, 50.00, 6500.55);
INSERT INTO OrderDetails VALUES ('OR0034', 'T0149', 3, 150.00, 19671.01);
INSERT INTO OrderDetails VALUES ('OR0035', 'T0092', 17, 20.00, 17220.72);
INSERT INTO OrderDetails VALUES ('OR0036', 'T0055', 16, 100.00, 8757.61);
INSERT INTO OrderDetails VALUES ('OR0037', 'T0113', 11, 80.00, 10524.92);
INSERT INTO OrderDetails VALUES ('OR0038', 'T0052', 2, 180.00, 3785.78);
INSERT INTO OrderDetails VALUES ('OR0039', 'T0007', 12, 110.00, 13758.28);
INSERT INTO OrderDetails VALUES ('OR0040', 'T0071', 6, 60.00, 14895.22);

INSERT INTO OrderDetails VALUES ('OR0041', 'T0008', 4, 200.00, 12411.56);
INSERT INTO OrderDetails VALUES ('OR0042', 'T0031', 14, 100.00, 18823.46);
INSERT INTO OrderDetails VALUES ('OR0043', 'T0043', 12, 50.00, 17195.43);
INSERT INTO OrderDetails VALUES ('OR0044', 'T0087', 8, 150.00, 13945.76);
INSERT INTO OrderDetails VALUES ('OR0045', 'T0058', 10, 20.00, 5453.76);
INSERT INTO OrderDetails VALUES ('OR0046', 'T0083', 5, 100.00, 6450.55);
INSERT INTO OrderDetails VALUES ('OR0047', 'T0045', 7, 80.00, 19781.01);
INSERT INTO OrderDetails VALUES ('OR0048', 'T0048', 17, 180.00, 17060.72);
INSERT INTO OrderDetails VALUES ('OR0049', 'T0066', 11, 110.00, 8747.61);
INSERT INTO OrderDetails VALUES ('OR0050', 'T0052', 2, 60.00, 10544.92);

INSERT INTO OrderDetails VALUES ('OR0051', 'T0060', 20, 200.00, 916.88);
INSERT INTO OrderDetails VALUES ('OR0052', 'T0036', 1, 100.00, 3004.86);
INSERT INTO OrderDetails VALUES ('OR0053', 'T0090', 2, 50.00, 1899.60);
INSERT INTO OrderDetails VALUES ('OR0054', 'T0027', 15, 150.00, 18047.12);
INSERT INTO OrderDetails VALUES ('OR0055', 'T0059', 14, 20.00, 10262.64);
INSERT INTO OrderDetails VALUES ('OR0056', 'T0037', 9, 100.00, 16063.31);
INSERT INTO OrderDetails VALUES ('OR0057', 'T0014', 8, 80.00, 1162.65);
INSERT INTO OrderDetails VALUES ('OR0058', 'T0019', 12, 180.00, 18285.15);
INSERT INTO OrderDetails VALUES ('OR0059', 'T0033', 3, 110.00, 11214.77);
INSERT INTO OrderDetails VALUES ('OR0060', 'T0046', 6, 60.00, 6737.94);

INSERT INTO OrderDetails VALUES ('OR0061', 'T0004', 2, 200.00, 17571.72);
INSERT INTO OrderDetails VALUES ('OR0062', 'T0047', 4, 100.00, 6453.52);
INSERT INTO OrderDetails VALUES ('OR0063', 'T0084', 15, 50.00, 14116.01);
INSERT INTO OrderDetails VALUES ('OR0064', 'T0049', 16, 150.00, 19558.74);
INSERT INTO OrderDetails VALUES ('OR0065', 'T0085', 17, 20.00, 8252.28);
INSERT INTO OrderDetails VALUES ('OR0066', 'T0089', 12, 100.00, 17300.96);
INSERT INTO OrderDetails VALUES ('OR0067', 'T0002', 8, 80.00, 8193.32);
INSERT INTO OrderDetails VALUES ('OR0068', 'T0059', 19, 180.00, 15339.88);
INSERT INTO OrderDetails VALUES ('OR0069', 'T0064', 20, 110.00, 8202.79);
INSERT INTO OrderDetails VALUES ('OR0070', 'T0096', 6, 60.00, 15604.94);

INSERT INTO OrderDetails VALUES ('OR0071', 'T0004', 1, 200.00, 17204.68);
INSERT INTO OrderDetails VALUES ('OR0072', 'T0008', 19, 100.00, 12689.97);
INSERT INTO OrderDetails VALUES ('OR0073', 'T0059', 5, 50.00, 18361.15);
INSERT INTO OrderDetails VALUES ('OR0074', 'T0078', 15, 150.00, 1899.61);
INSERT INTO OrderDetails VALUES ('OR0075', 'T0045', 10, 20.00, 9712.63);
INSERT INTO OrderDetails VALUES ('OR0076', 'T0030', 7, 100.00, 4818.73);
INSERT INTO OrderDetails VALUES ('OR0077', 'T0081', 6, 80.00, 10868.20);
INSERT INTO OrderDetails VALUES ('OR0078', 'T0015', 18, 180.00, 11572.92);
INSERT INTO OrderDetails VALUES ('OR0079', 'T0037', 8, 110.00, 1349.09);
INSERT INTO OrderDetails VALUES ('OR0080', 'T0065', 14, 60.00, 6300.58);

INSERT INTO OrderDetails VALUES ('OR0081', 'T0003', 20, 200.00, 6144.51);
INSERT INTO OrderDetails VALUES ('OR0082', 'T0055', 2, 100.00, 8688.44);
INSERT INTO OrderDetails VALUES ('OR0083', 'T0060', 11, 50.00, 8433.34);
INSERT INTO OrderDetails VALUES ('OR0084', 'T0037', 5, 150.00, 2094.66);
INSERT INTO OrderDetails VALUES ('OR0085', 'T0264', 19, 20.00, 1335.06);
INSERT INTO OrderDetails VALUES ('OR0086', 'T0052', 8, 100.00, 8941.62);
INSERT INTO OrderDetails VALUES ('OR0087', 'T0242', 3, 80.00, 19402.85);
INSERT INTO OrderDetails VALUES ('OR0088', 'T0062', 16, 180.00, 9368.43);
INSERT INTO OrderDetails VALUES ('OR0089', 'T0215', 13, 110.00, 18579.41);
INSERT INTO OrderDetails VALUES ('OR0090', 'T0028', 15, 60.00, 882.52);

INSERT INTO OrderDetails VALUES ('OR0091', 'T0052', 3, 200.00, 17455.52);
INSERT INTO OrderDetails VALUES ('OR0092', 'T0266', 9, 100.00, 8854.68);
INSERT INTO OrderDetails VALUES ('OR0093', 'T0027', 5, 50.00, 14316.14);
INSERT INTO OrderDetails VALUES ('OR0094', 'T0025', 10, 150.00, 4974.04);
INSERT INTO OrderDetails VALUES ('OR0095', 'T0030', 2, 20.00, 3172.68);
INSERT INTO OrderDetails VALUES ('OR0096', 'T0092', 12, 100.00, 19018.47);
INSERT INTO OrderDetails VALUES ('OR0097', 'T0094', 16, 80.00, 12839.34);
INSERT INTO OrderDetails VALUES ('OR0098', 'T0004', 18, 180.00, 11443.94);
INSERT INTO OrderDetails VALUES ('OR0099', 'T0047', 6, 110.00, 18395.23);
INSERT INTO OrderDetails VALUES ('OR0100', 'T0053', 19, 60.00, 13277.98);

INSERT INTO OrderDetails VALUES ('OR0101', 'T0017', 17, 200.00, 7626.32);
INSERT INTO OrderDetails VALUES ('OR0102', 'T0040', 9, 100.00, 17955.81);
INSERT INTO OrderDetails VALUES ('OR0103', 'T0083', 18, 50.00, 17143.32);
INSERT INTO OrderDetails VALUES ('OR0104', 'T0022', 5, 150.00, 18554.08);
INSERT INTO OrderDetails VALUES ('OR0105', 'T0071', 8, 20.00, 7221.57);
INSERT INTO OrderDetails VALUES ('OR0106', 'T0097', 16, 100.00, 6450.91);
INSERT INTO OrderDetails VALUES ('OR0107', 'T0056', 10, 80.00, 14649.78);
INSERT INTO OrderDetails VALUES ('OR0108', 'T0002', 1, 180.00, 4672.20);
INSERT INTO OrderDetails VALUES ('OR0109', 'T0050', 2, 110.00, 11752.38);
INSERT INTO OrderDetails VALUES ('OR0110', 'T0052', 6, 60.00, 8348.86);

INSERT INTO OrderDetails VALUES ('OR0111', 'T0063', 19, 200.00, 2144.30);
INSERT INTO OrderDetails VALUES ('OR0112', 'T0043', 18, 100.00, 3128.64);
INSERT INTO OrderDetails VALUES ('OR0113', 'T0080', 4, 50.00, 17274.12);
INSERT INTO OrderDetails VALUES ('OR0114', 'T0084', 2, 150.00, 14756.73);
INSERT INTO OrderDetails VALUES ('OR0115', 'T0017', 8, 20.00, 16696.94);
INSERT INTO OrderDetails VALUES ('OR0116', 'T0041', 9, 100.00, 8395.78);
INSERT INTO OrderDetails VALUES ('OR0117', 'T0062', 3, 80.00, 8145.60);
INSERT INTO OrderDetails VALUES ('OR0118', 'T0075', 16, 180.00, 18035.98);
INSERT INTO OrderDetails VALUES ('OR0119', 'T0032', 15, 110.00, 4784.69);
INSERT INTO OrderDetails VALUES ('OR0120', 'T0049', 7, 60.00, 6964.28);

INSERT INTO OrderDetails VALUES ('OR0121', 'T0032', 15, 200.00, 8983.27);
INSERT INTO OrderDetails VALUES ('OR0122', 'T0072', 17, 100.00, 11433.79);
INSERT INTO OrderDetails VALUES ('OR0123', 'T0048', 20, 50.00, 17992.56);
INSERT INTO OrderDetails VALUES ('OR0124', 'T0038', 8, 150.00, 5659.59);
INSERT INTO OrderDetails VALUES ('OR0125', 'T0160', 6, 20.00, 215.76);
INSERT INTO OrderDetails VALUES ('OR0126', 'T0067', 2, 100.00, 908.71);
INSERT INTO OrderDetails VALUES ('OR0127', 'T0076', 12, 80.00, 12195.98);
INSERT INTO OrderDetails VALUES ('OR0128', 'T0064', 5, 180.00, 9092.39);
INSERT INTO OrderDetails VALUES ('OR0129', 'T0136', 19, 110.00, 19642.64);
INSERT INTO OrderDetails VALUES ('OR0130', 'T0091', 1, 60.00, 8740.07);

INSERT INTO OrderDetails VALUES ('OR0131', 'T0060', 7, 200.00, 9741.44);
INSERT INTO OrderDetails VALUES ('OR0132', 'T0023', 9, 100.00, 14999.54);
INSERT INTO OrderDetails VALUES ('OR0133', 'T0290', 13, 50.00, 19165.16);
INSERT INTO OrderDetails VALUES ('OR0134', 'T0026', 16, 150.00, 3614.93);
INSERT INTO OrderDetails VALUES ('OR0135', 'T0040', 18, 20.00, 866.34);
INSERT INTO OrderDetails VALUES ('OR0136', 'T0206', 12, 100.00, 12347.12);
INSERT INTO OrderDetails VALUES ('OR0137', 'T0027', 4, 80.00, 2877.19);
INSERT INTO OrderDetails VALUES ('OR0138', 'T0072', 14, 180.00, 5667.65);
INSERT INTO OrderDetails VALUES ('OR0139', 'T0038', 17, 110.00, 5120.25);
INSERT INTO OrderDetails VALUES ('OR0140', 'T0002', 2, 60.00, 810.46);

INSERT INTO OrderDetails VALUES ('OR0141', 'T0051', 15, 200.00, 6003.08);
INSERT INTO OrderDetails VALUES ('OR0142', 'T0017', 17, 100.00, 14448.57);
INSERT INTO OrderDetails VALUES ('OR0143', 'T0034', 16, 50.00, 16879.41);
INSERT INTO OrderDetails VALUES ('OR0144', 'T0099', 20, 150.00, 16906.76);
INSERT INTO OrderDetails VALUES ('OR0145', 'T0077', 10, 20.00, 13450.55);
INSERT INTO OrderDetails VALUES ('OR0146', 'T0086', 5, 100.00, 6258.09);
INSERT INTO OrderDetails VALUES ('OR0147', 'T0066', 1, 80.00, 19385.15);
INSERT INTO OrderDetails VALUES ('OR0148', 'T0008', 12, 180.00, 10842.72);
INSERT INTO OrderDetails VALUES ('OR0149', 'T0002', 14, 110.00, 2850.79);
INSERT INTO OrderDetails VALUES ('OR0150', 'T0019', 11, 60.00, 9742.13);

INSERT INTO OrderDetails VALUES ('OR0151', 'T0004', 8, 200.00, 5874.86);
INSERT INTO OrderDetails VALUES ('OR0152', 'T0042', 12, 100.00, 17046.31);
INSERT INTO OrderDetails VALUES ('OR0153', 'T0043', 16, 50.00, 3652.36);
INSERT INTO OrderDetails VALUES ('OR0154', 'T0019', 11, 150.00, 3220.94);
INSERT INTO OrderDetails VALUES ('OR0155', 'T0063', 5, 20.00, 2033.36);
INSERT INTO OrderDetails VALUES ('OR0156', 'T0003', 17, 100.00, 13733.63);
INSERT INTO OrderDetails VALUES ('OR0157', 'T0028', 13, 80.00, 15287.92);
INSERT INTO OrderDetails VALUES ('OR0158', 'T0024', 19, 180.00, 228.68);
INSERT INTO OrderDetails VALUES ('OR0159', 'T0085', 15, 110.00, 9570.50);
INSERT INTO OrderDetails VALUES ('OR0160', 'T0060', 18, 60.00, 6917.38);

INSERT INTO OrderDetails VALUES ('OR0161', 'T0063', 2, 200.00, 6059.81);
INSERT INTO OrderDetails VALUES ('OR0162', 'T0035', 15, 100.00, 974.43);
INSERT INTO OrderDetails VALUES ('OR0163', 'T0077', 6, 50.00, 11945.36);
INSERT INTO OrderDetails VALUES ('OR0164', 'T0010', 14, 150.00, 5630.20);
INSERT INTO OrderDetails VALUES ('OR0165', 'T0044', 8, 20.00, 8647.32);
INSERT INTO OrderDetails VALUES ('OR0166', 'T0001', 7, 100.00, 2009.90);
INSERT INTO OrderDetails VALUES ('OR0167', 'T0037', 12, 80.00, 2568.96);
INSERT INTO OrderDetails VALUES ('OR0168', 'T0064', 11, 180.00, 19333.65);
INSERT INTO OrderDetails VALUES ('OR0169', 'T0021', 17, 110.00, 15558.34);
INSERT INTO OrderDetails VALUES ('OR0170', 'T0083', 1, 60.00, 8974.96);

INSERT INTO OrderDetails VALUES ('OR0171', 'T0071', 13, 200.00, 13711.39);
INSERT INTO OrderDetails VALUES ('OR0172', 'T0077', 5, 100.00, 7965.53);
INSERT INTO OrderDetails VALUES ('OR0173', 'T0069', 8, 50.00, 6877.15);
INSERT INTO OrderDetails VALUES ('OR0174', 'T0096', 20, 150.00, 15616.87);
INSERT INTO OrderDetails VALUES ('OR0175', 'T0044', 10, 20.00, 10332.24);
INSERT INTO OrderDetails VALUES ('OR0176', 'T0001', 15, 100.00, 16130.59);
INSERT INTO OrderDetails VALUES ('OR0177', 'T0028', 2, 80.00, 17820.03);
INSERT INTO OrderDetails VALUES ('OR0178', 'T0010', 17, 180.00, 1434.33);
INSERT INTO OrderDetails VALUES ('OR0179', 'T0099', 1, 110.00, 17570.82);
INSERT INTO OrderDetails VALUES ('OR0180', 'T0064', 12, 60.00, 11145.03);

INSERT INTO OrderDetails VALUES ('OR0181', 'T0064', 20, 200.00, 10860.03);
INSERT INTO OrderDetails VALUES ('OR0182', 'T0029', 17, 100.00, 16142.62);
INSERT INTO OrderDetails VALUES ('OR0183', 'T0014', 6, 50.00, 3456.54);
INSERT INTO OrderDetails VALUES ('OR0184', 'T0098', 11, 150.00, 1959.62);
INSERT INTO OrderDetails VALUES ('OR0185', 'T0094', 18, 20.00, 13656.61);
INSERT INTO OrderDetails VALUES ('OR0186', 'T0024', 12, 100.00, 4121.02);
INSERT INTO OrderDetails VALUES ('OR0187', 'T0099', 19, 80.00, 7276.23);
INSERT INTO OrderDetails VALUES ('OR0188', 'T0045', 14, 180.00, 11888.58);
INSERT INTO OrderDetails VALUES ('OR0189', 'T0057', 16, 110.00, 2471.57);
INSERT INTO OrderDetails VALUES ('OR0190', 'T0084', 10, 60.00, 19812.66);

INSERT INTO OrderDetails VALUES ('OR0191', 'T0024', 14, 200.00, 2861.52);
INSERT INTO OrderDetails VALUES ('OR0192', 'T0042', 17, 100.00, 19418.70);
INSERT INTO OrderDetails VALUES ('OR0193', 'T0085', 11, 50.00, 15676.71);
INSERT INTO OrderDetails VALUES ('OR0194', 'T0034', 7, 150.00, 17638.91);
INSERT INTO OrderDetails VALUES ('OR0195', 'T0065', 3, 20.00, 5557.07);
INSERT INTO OrderDetails VALUES ('OR0196', 'T0003', 13, 100.00, 6985.20);
INSERT INTO OrderDetails VALUES ('OR0197', 'T0069', 20, 80.00, 14322.80);
INSERT INTO OrderDetails VALUES ('OR0198', 'T0007', 6, 180.00, 8882.51);
INSERT INTO OrderDetails VALUES ('OR0199', 'T0062', 19, 110.00, 2392.20);
INSERT INTO OrderDetails VALUES ('OR0200', 'T0060', 15, 60.00, 3872.70);

INSERT INTO OrderDetails VALUES ('OR0201', 'T0029', 18, 200.00, 12471.97);
INSERT INTO OrderDetails VALUES ('OR0202', 'T0049', 15, 100.00, 9566.77);
INSERT INTO OrderDetails VALUES ('OR0203', 'T0042', 11, 50.00, 16925.78);
INSERT INTO OrderDetails VALUES ('OR0204', 'T0091', 3, 150.00, 15409.11);
INSERT INTO OrderDetails VALUES ('OR0205', 'T0021', 20, 20.00, 14338.47);
INSERT INTO OrderDetails VALUES ('OR0206', 'T0014', 17, 100.00, 3679.36);
INSERT INTO OrderDetails VALUES ('OR0207', 'T0073', 5, 80.00, 11751.75);
INSERT INTO OrderDetails VALUES ('OR0208', 'T0087', 10, 180.00, 2314.35);
INSERT INTO OrderDetails VALUES ('OR0209', 'T0026', 7, 110.00, 6658.10);
INSERT INTO OrderDetails VALUES ('OR0210', 'T0018', 6, 60.00, 13581.73);

INSERT INTO OrderDetails VALUES ('OR0211', 'T0064', 14, 200.00, 19139.53);
INSERT INTO OrderDetails VALUES ('OR0212', 'T0090', 11, 100.00, 14669.10);
INSERT INTO OrderDetails VALUES ('OR0213', 'T0059', 1, 50.00, 2585.08);
INSERT INTO OrderDetails VALUES ('OR0214', 'T0029', 20, 150.00, 13262.36);
INSERT INTO OrderDetails VALUES ('OR0215', 'T0099', 18, 20.00, 17122.97);
INSERT INTO OrderDetails VALUES ('OR0216', 'T0001', 2, 100.00, 14663.94);
INSERT INTO OrderDetails VALUES ('OR0217', 'T0031', 15, 80.00, 18822.95);
INSERT INTO OrderDetails VALUES ('OR0218', 'T0055', 3, 180.00, 13839.75);
INSERT INTO OrderDetails VALUES ('OR0219', 'T0008', 16, 110.00, 2674.49);
INSERT INTO OrderDetails VALUES ('OR0220', 'T0024', 12, 60.00, 4776.02);

INSERT INTO OrderDetails VALUES ('OR0221', 'T0011', 13, 200.00, 16186.39);
INSERT INTO OrderDetails VALUES ('OR0222', 'T0087', 16, 100.00, 11511.03);
INSERT INTO OrderDetails VALUES ('OR0223', 'T0025', 4, 50.00, 3783.05);
INSERT INTO OrderDetails VALUES ('OR0224', 'T0088', 14, 150.00, 8474.18);
INSERT INTO OrderDetails VALUES ('OR0225', 'T0024', 17, 20.00, 1177.70);
INSERT INTO OrderDetails VALUES ('OR0226', 'T0058', 8, 100.00, 2745.28);
INSERT INTO OrderDetails VALUES ('OR0227', 'T0084', 1, 80.00, 2569.42);
INSERT INTO OrderDetails VALUES ('OR0228', 'T0015', 11, 180.00, 19399.28);
INSERT INTO OrderDetails VALUES ('OR0229', 'T0065', 3, 110.00, 19508.56);
INSERT INTO OrderDetails VALUES ('OR0230', 'T0062', 18, 60.00, 5921.86);

INSERT INTO OrderDetails VALUES ('OR0231', 'T0014', 15, 200.00, 12311.51);
INSERT INTO OrderDetails VALUES ('OR0232', 'T0021', 8, 100.00, 9283.95);
INSERT INTO OrderDetails VALUES ('OR0233', 'T0034', 10, 50.00, 10231.25);
INSERT INTO OrderDetails VALUES ('OR0234', 'T0089', 2, 150.00, 16431.01);
INSERT INTO OrderDetails VALUES ('OR0235', 'T0029', 13, 20.00, 9897.52);
INSERT INTO OrderDetails VALUES ('OR0236', 'T0086', 16, 100.00, 16573.84);
INSERT INTO OrderDetails VALUES ('OR0237', 'T0042', 6, 80.00, 10329.11);
INSERT INTO OrderDetails VALUES ('OR0238', 'T0076', 5, 180.00, 4076.31);
INSERT INTO OrderDetails VALUES ('OR0239', 'T0059', 19, 110.00, 4801.03);
INSERT INTO OrderDetails VALUES ('OR0240', 'T0074', 1, 60.00, 6431.78);

INSERT INTO OrderDetails VALUES ('OR0241', 'T0027', 12, 200.00, 2341.88);
INSERT INTO OrderDetails VALUES ('OR0242', 'T0037', 19, 100.00, 19161.88);
INSERT INTO OrderDetails VALUES ('OR0243', 'T0056', 15, 50.00, 2352.72);
INSERT INTO OrderDetails VALUES ('OR0244', 'T0018', 10, 150.00, 9994.67);
INSERT INTO OrderDetails VALUES ('OR0245', 'T0022', 11, 20.00, 9971.09);
INSERT INTO OrderDetails VALUES ('OR0246', 'T0073', 17, 100.00, 1943.16);
INSERT INTO OrderDetails VALUES ('OR0247', 'T0028', 4, 80.00, 6048.86);
INSERT INTO OrderDetails VALUES ('OR0248', 'T0093', 2, 180.00, 202.78);
INSERT INTO OrderDetails VALUES ('OR0249', 'T0054', 7, 110.00, 2728.54);
INSERT INTO OrderDetails VALUES ('OR0250', 'T0081', 8, 60.00, 1710.76);

INSERT INTO OrderDetails VALUES ('OR0251', 'T0071', 6, 200.00, 2528.91);
INSERT INTO OrderDetails VALUES ('OR0252', 'T0024', 10, 100.00, 14713.05);
INSERT INTO OrderDetails VALUES ('OR0253', 'T0005', 12, 50.00, 9430.38);
INSERT INTO OrderDetails VALUES ('OR0254', 'T0060', 3, 150.00, 2290.14);
INSERT INTO OrderDetails VALUES ('OR0255', 'T0043', 7, 20.00, 1223.46);
INSERT INTO OrderDetails VALUES ('OR0256', 'T0048', 4, 100.00, 19291.89);
INSERT INTO OrderDetails VALUES ('OR0257', 'T0002', 18, 80.00, 8437.35);
INSERT INTO OrderDetails VALUES ('OR0258', 'T0013', 11, 180.00, 11382.30);
INSERT INTO OrderDetails VALUES ('OR0259', 'T0020', 15, 110.00, 14147.13);
INSERT INTO OrderDetails VALUES ('OR0260', 'T0061', 19, 60.00, 16343.86);

INSERT INTO OrderDetails VALUES ('OR0261', 'T0059', 9, 200.00, 3808.73);
INSERT INTO OrderDetails VALUES ('OR0262', 'T0010', 20, 100.00, 3490.88);
INSERT INTO OrderDetails VALUES ('OR0263', 'T0019', 7, 50.00, 6722.33);
INSERT INTO OrderDetails VALUES ('OR0264', 'T0023', 13, 150.00, 6082.65);
INSERT INTO OrderDetails VALUES ('OR0265', 'T0034', 17, 20.00, 8553.30);
INSERT INTO OrderDetails VALUES ('OR0266', 'T0037', 3, 100.00, 6899.98);
INSERT INTO OrderDetails VALUES ('OR0267', 'T0083', 11, 80.00, 15916.78);
INSERT INTO OrderDetails VALUES ('OR0268', 'T0060', 6, 180.00, 516.88);
INSERT INTO OrderDetails VALUES ('OR0269', 'T0092', 2, 110.00, 11426.12);
INSERT INTO OrderDetails VALUES ('OR0270', 'T0070', 1, 60.00, 1078.79);

INSERT INTO OrderDetails VALUES ('OR0271', 'T0069', 10, 200.00, 17269.10);
INSERT INTO OrderDetails VALUES ('OR0272', 'T0093', 12, 100.00, 3830.42);
INSERT INTO OrderDetails VALUES ('OR0273', 'T0073', 11, 50.00, 16416.43);
INSERT INTO OrderDetails VALUES ('OR0274', 'T0057', 8, 150.00, 3085.12);
INSERT INTO OrderDetails VALUES ('OR0275', 'T0072', 20, 20.00, 987.50);
INSERT INTO OrderDetails VALUES ('OR0276', 'T0020', 15, 100.00, 1629.28);
INSERT INTO OrderDetails VALUES ('OR0277', 'T0013', 18, 80.00, 16324.52);
INSERT INTO OrderDetails VALUES ('OR0278', 'T0033', 9, 180.00, 12776.02);
INSERT INTO OrderDetails VALUES ('OR0279', 'T0043', 5, 110.00, 15176.60);
INSERT INTO OrderDetails VALUES ('OR0280', 'T0095', 13, 60.00, 15363.66);

INSERT INTO OrderDetails VALUES ('OR0281', 'T0061', 8, 200.00, 10462.69);
INSERT INTO OrderDetails VALUES ('OR0282', 'T0030', 10, 100.00, 5856.88);
INSERT INTO OrderDetails VALUES ('OR0283', 'T0047', 6, 50.00, 6751.54);
INSERT INTO OrderDetails VALUES ('OR0284', 'T0087', 13, 150.00, 15155.38);
INSERT INTO OrderDetails VALUES ('OR0285', 'T0052', 16, 20.00, 11503.31);
INSERT INTO OrderDetails VALUES ('OR0286', 'T0050', 9, 100.00, 18800.88);
INSERT INTO OrderDetails VALUES ('OR0287', 'T0079', 14, 80.00, 18509.68);
INSERT INTO OrderDetails VALUES ('OR0288', 'T0088', 1, 180.00, 16895.88);
INSERT INTO OrderDetails VALUES ('OR0289', 'T0081', 4, 110.00, 16307.01);
INSERT INTO OrderDetails VALUES ('OR0290', 'T0004', 15, 60.00, 1477.48);

INSERT INTO OrderDetails VALUES ('OR0291', 'T0003', 14, 200.00, 15852.42);
INSERT INTO OrderDetails VALUES ('OR0292', 'T0036', 19, 100.00, 7520.09);
INSERT INTO OrderDetails VALUES ('OR0293', 'T0051', 4, 50.00, 2442.20);
INSERT INTO OrderDetails VALUES ('OR0294', 'T0059', 20, 150.00, 12900.84);
INSERT INTO OrderDetails VALUES ('OR0295', 'T0004', 18, 20.00, 1645.15);
INSERT INTO OrderDetails VALUES ('OR0296', 'T0022', 7, 100.00, 13823.74);
INSERT INTO OrderDetails VALUES ('OR0297', 'T0013', 6, 80.00, 7015.72);
INSERT INTO OrderDetails VALUES ('OR0298', 'T0075', 8, 180.00, 7833.57);
INSERT INTO OrderDetails VALUES ('OR0299', 'T0084', 16, 110.00, 2200.91);
INSERT INTO OrderDetails VALUES ('OR0300', 'T0005', 11, 60.00, 4822.57);

COMMIT;

-- select counts
SELECT COUNT(*) AS NoOfCustomer
FROM Customer;
SELECT COUNT(*) AS NoOfDelivery
FROM Delivery;
SELECT COUNT(*) AS NoOfEmployee
FROM Employee;
SELECT COUNT(*) AS NoOfToy
FROM Toy;
SELECT COUNT(*) AS NoOfSupplier
FROM Supplier;
SELECT COUNT(*) AS NoOfPayment
FROM Payment;
SELECT COUNT(*) AS NoOfPromotion
FROM Promotion;
SELECT COUNT(*) AS NoOfMember
FROM Member;
SELECT COUNT(*) AS NoOfStockPurchase
FROM StockPurchase;
SELECT COUNT(*) AS NoOfOrder
FROM Orders;
SELECT COUNT(*) AS NoOfOrderDetails
FROM OrderDetails;