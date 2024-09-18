-- Simulate Transaction
-- Begin Transaction

-- Sales Transaction
-- 1 --> Find Game available
SELECT * FROM MsGame

-- 2 --> Check Game Price with ID GA111
SELECT GameID, GameSales 
FROM MsGame mg
JOIN MsgamePrice mgp ON mg.GamePriceID = mgp.GamePriceID
WHERE GameID IN ('GA111')

-- 3 --> Choose the staff to do the transaction
SELECT * FROM MsStaff

-- 4 --> Find customer Data in the system or Add new customer
SELECT*FROM MsCustomer
-- OR --
INSERT INTO MsCustomer VALUES
('CU021', 'Keizia Teko', 'Female', '2004-01-01', 0877886522)

--5 -->  Substract Game Stock after purchased by customer
UPDATE MsGame
SET GameStock -=15
WHERE GameID = 'GA111'

-- Purchase Transaction
-- 1 --> FInd Supplier
SELECT*FROM MsSupplier

-- 2 --> Check Supplier with SupplierID (SU222)
SELECT*FROM MsSupplier
WHERE SupplierID = 'SU121'

-- 3 --> Find Supplier who made transaction on (2022-07-20) OR Add new suppplier
SELECT*FROM MsSupplier ms
JOIN PurchaseTr pt ON ms.SupplierID = pt.SupplierID
WHERE PurchaseDate = '2022-07-20'
-- OR --
INSERT INTO MsSupplier VALUES
('SU126','Johan Majun', 'Jl. Kemajuan Sinkat', 098877654202)

-- 4 --> Find Staff to handle purchase transaction
SELECT*FROM MsStaff


-- 5 --> Update Stock after buy game with GA233 GameID
UPDATE MsGame
SET GameStock += 455
WHERE GameID= 'GA233' 

-- 6 --> Update game sales price after buying the game
UPDATE MsGamePrice
SET GameSales = 1800000
WHERE GamePriceID = 'GA233'



