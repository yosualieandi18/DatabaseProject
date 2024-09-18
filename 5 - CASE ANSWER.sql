--1 
SELECT REPLACE (c.StaffID, 'ST', 'Staff') AS StaffID, UPPER (StaffName) AS StaffName, COUNT(SalesID) TotalSales
	FROM MsStaff c JOIN SalesTr s ON c.StaffID = s.StaffID
	JOIN MsCustomer mc ON s.CustomerID = mc.CustomerID
	WHERE StaffGender = 'Male' AND CustomerGender = 'Female'
	GROUP BY c.StaffID, StaffName


--2 
SELECT mp.PurchaseID, CONVERT (VARCHAR, PurchaseDate, 103) as PurchaseDate, COUNT (mgt.GameTypeID) as 'Total Game Type'
FROM MsGameType mgt
JOIN MsGame mg ON mg.GameTypeID = mgt.GameTypeID
JOIN PurchaseTrDetail mp ON mp.GameID = mg.GameID
JOIN PurchaseTr pt ON pt.PurchaseID=mp.PurchaseID
WHERE YEAR(PurchaseDate) = 2019 
GROUP BY mp.PurchaseID, CONVERT (VARCHAR, PurchaseDate, 103) 
HAVING COUNT(mgt.GameTypeID) > 2


--3 
SELECT REVERSE(c.CustomerID) AS CustomerCode, UPPER (CustomerName) AS CustomerName, COUNT(DISTINCT st.SalesID) AS TotalTransaction, MIN(SalesQuantity) AS MinimumPurchase
FROM MsCustomer c 
JOIN SalesTr st ON c.CustomerID = st.CustomerID
JOIN SalesTrDetail t ON st.SalesID = t.SalesID
WHERE CustomerName LIKE 'M%' 
GROUP BY REVERSE(c.CustomerID), UPPER (CustomerName)
HAVING COUNT (st.SalesID) > 1


--4 
SELECT
msp.SupplierID, 
CONCAT(SupplierName, ' Inc.') AS [SupplierName], 
SUM(SalesQuantity) AS [TotalGamesSold], 
MAX(SalesQuantity) AS [MaximumGamesSold] 
FROM SalesTr ms
	JOIN MsStaff mst ON mst.StaffID = ms.StaffID
	JOIN PurchaseTr mp ON mst.StaffID = mp.StaffID
	JOIN MsSupplier msp ON mp.SupplierID = msp.SupplierID
	JOIN SalesTrDetail std ON ms.SalesID = std.SalesID
	WHERE SupplierAddress LIKE '%Drive%' AND RIGHT(msp.SupplierID,1) IN (1,3,5,7,9) 
GROUP BY msp.SupplierID, CONCAT(SupplierName, ' Inc.')

--5 
SELECT PurchaseID, p.SupplierID, SupplierName, LEFT(StaffName, CHARINDEX(' ', StaffName)) AS StaffFirstName, StaffDOB
FROM PurchaseTr p
JOIN MsStaff s ON p.StaffID = s.StaffID
JOIN MsSupplier mu ON p.SupplierID = mu.SupplierID, 
(SELECT AVG (StaffSalary) AS AVGSalary FROM MsStaff) AS X
WHERE s.StaffSalary > X.AVGSalary AND YEAR (StaffDOB) > 2000

--6  
SELECT ms.SalesID, SalesDate, LOWER(CustomerName) AS CustomerName
FROM SalesTr ms
JOIN MsCustomer mc ON ms.CustomerID = mc.CustomerID 
JOIN SalesTrDetail std ON ms.SalesID=std.SalesID, (
SELECT AVG(SalesQuantity) AS AVGQuantity
FROM SalesTrDetail) x 
WHERE YEAR(GETDATE()) - YEAR(CustomerDOB) < 24
AND SalesQuantity > x.AVGQuantity
GROUP BY ms.SalesID,SalesDate,LOWER(CustomerName)

--7 
SELECT DAY(PurchaseDate) AS PurchasedDay,  REPLACE (mg.GameID, 'GA', 'Game') AS GameID, YEAR(GameReleaseDate) AS GameReleasedYear, COUNT(PurchaseQuantity) AS TotalPurchased
FROM MsGame mg
JOIN PurchaseTrDetail ptd ON mg.GameID=ptd.GameID
JOIN PurchaseTr pt ON ptd.PurchaseID = pt.PurchaseID
JOIN MsGamePrice mgp ON mg.GamePriceID=mgp.GamePriceID, (
SELECT AVG (GamePurchase) AS AVGPurchase
FROM MsGamePrice) AS x  
WHERE GamePurchase > x.AVGPurchase and DATENAME(QUARTER, GameReleaseDate) = 2
GROUP BY DAY(PurchaseDate),  REPLACE (mg.GameID, 'GA', 'Game'), YEAR(GameReleaseDate)

--8 
SELECT LOWER(ms.SalesID) as SalesID, CONVERT(VARCHAR, SalesDate, 105) AS [SalesDate], CONCAT('Rp. ',SUM(SalesQuantity * GameSales)) AS 'TotalSalesCost'
FROM SalesTr ms
JOIN SalesTrDetail std ON ms.SalesID = std.SalesID
JOIN MsGame mg on std.GameID = mg.GameID
JOIN MsGamePrice mgp on mg.GamePriceID = mgp.GamePriceID
JOIN MsStaff s on ms.StaffID = s.StaffID,(
SELECT AVG(StaffSalary) AS AVGSalery
FROM MsStaff 
) AS X
WHERE StaffSalary > X.AVGSalery and MONTH(SalesDate) = 2
GROUP BY LOWER(ms.SalesID), CONVERT(VARCHAR, SalesDate, 105)

-- 9 
GO
CREATE VIEW Customer_Quarterly_Transaction_View AS
	SELECT mc.CustomerID,
	CustomerName, 
	COUNT(ptd.SalesID) AS TotalTransaction,
	CONCAT(MAX(SalesQuantity), 'Pc(s)') AS MaximumPurchaseQuantity
FROM SalesTr mp
JOIN SalesTrDetail ptd ON mp.SalesID = ptd.SalesID
JOIN MsStaff ms ON mp.StaffID = ms.StaffID
JOIN MsCustomer mc ON mp.CustomerID = mc.CustomerID
WHERE YEAR(SalesDate) = 2021 AND StaffGender = 'Female'
GROUP BY mc.CustomerID, CustomerName
GO

--10 
GO
CREATE VIEW Quarterly_Sales_Report AS 
SELECT CONCAT('Rp. ', SUM(SalesQuantity * GameSales)) AS [TotalSales], 
CONCAT('Rp. ', AVG(SalesQuantity * GameSales)) AS [AverageSales]
FROM SalesTrDetail std
JOIN SalesTr st ON std.SalesID = st.SalesID
JOIN MsGame mg ON std.GameID = mg.GameID
JOIN MsGamePrice mgp ON mg.GamePriceID = mgp.GamePriceID
WHERE DATENAME(QUARTER, SalesDate) IN (1) AND GameSales > 200000
GO




