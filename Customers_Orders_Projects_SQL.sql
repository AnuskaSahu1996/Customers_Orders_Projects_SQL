create database Customers_Orders_Products 

use Customers_Orders_Products

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');

  SELECT * FROM Customers

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);

SELECT * FROM Orders

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

SElECT * FROM Products


--Task 1 :-
--1.Write a query to retrieve all records from the Customers table..

SELECT * FROM Customers

--2.Write a query to retrieve the names and email addresses of customers whose names start with 'J'.

SELECT  Name,Email FROM Customers WHERE Name LIKE 'J%'

--3.Write a query to retrieve the order details (OrderID, ProductName, Quantity) for all orders..

SELECT OrderID, ProductName, Quantity FROM Orders

--4.Write a query to calculate the total quantity of products ordered.

SELECT SUM(Quantity) AS total_quantity  FROM Orders

--5.Write a query to retrieve the names of customers who have placed an order.

SELECT Name FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID

--6.Write a query to retrieve the products with a price greater than $10.00.

SELECT ProductName FROM Products
WHERE Price > 10

--7.Write a query to retrieve the customer name and order date for all orders placed on or after '2023-07-05'.

SELECT NAME,OrderDate FROM Customers
INNER JOIN Orders
ON  Customers.CustomerID = Orders.CustomerID
WHERE OrderDate >= '2023-07-05'

--8.Write a query to calculate the average price of all products.

SELECT AVG(Price) AS AVARAGEPRICE FROM Products

--9.Write a query to retrieve the customer names along with the total quantity of products they have ordered.

SELECT Name, SUM([Quantity]) AS TOTALQUANTITYPERPERSON FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Name


--10.Write a query to retrieve the products that have not been ordered.

SELECT * FROM Products
LEFT JOIN Orders
ON Products.ProductName = Orders.ProductName
WHERE Quantity IS NULL

SELECT ProductName FROM Products
WHERE ProductName NOT in (SELECT ProductName FROM Orders)

--Task 2 :-
--1.Write a query to retrieve the top 5 customers who have placed the highest total quantity of orders.

SELECT TOP 5(Name), SUM(Quantity) FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Name
ORDER BY SUM(Quantity) DESC

--2.Write a query to calculate the average price of products for each product category.

SELECT ProductName,AVG(Price) FROM Products
GROUP BY ProductName

--3.Write a query to retrieve the customers who have not placed any orders.

SELECT * FROM Products
LEFT JOIN Orders
ON Products.ProductName = Orders.ProductName
WHERE Quantity IS NULL

--4.Write a query to retrieve the order details (OrderID, ProductName, Quantity) for orders placed by customers whose names start with 'M'.

SELECT OrderID, ProductName, Quantity FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Name LIKE 'M%'

--5.Write a query to calculate the total revenue generated from all orders.

SELECT SUM([Quantity]*[Price]) AS TOTALREVENUE FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName


--6.Write a query to retrieve the customer names along with the total revenue generated from their orders.

SELECT Name,SUM([Quantity]*[Price]) AS TOTALREVENUE FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Products ON Orders.ProductName = Products.ProductName
GROUP BY Name

--7.Write a query to retrieve the customers who have placed at least one order for each product category.

SELECT Name,OrderID,ProductID FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Products ON Orders.ProductName = Products.ProductName
GROUP BY Name,ProductID,OrderID

--8.Write a query to retrieve the customers who have placed orders on consecutive days.

SELECT C.Name FROM Customers AS C
INNER JOIN Orders AS O1
ON C.CustomerID = O1.CustomerID
INNER JOIN Orders AS O2
ON C.CustomerID = O2.CustomerID
WHERE DATEDIFF(DAY , O1.OrderDate , O2.OrderDate) = 1

--9.Write a query to retrieve the top 3 products with the highest average quantity ordered.

SELECT TOP 3(ProductName),AVG(Quantity) AS AVGQUANTITY,Quantity FROM Orders
GROUP BY ProductName,Quantity
ORDER BY AVGQUANTITY DESC

--10.Write a query to calculate the percentage of orders that have a quantity greater than the average quantity.

SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders) as percentages
FROM orders
WHERE quantity > (SELECT AVG(quantity) FROM orders);

SELECT COUNT(*) FROM orders
--OR

SELECT (COUNT(CASE WHEN Quantity > AVGQUANTITY THEN 1 END)*100.0)/COUNT(*) AS PERCENTAGES
FROM Orders
CROSS JOIN
(SELECT AVG(Quantity) AS AVGQUANTITY FROM Orders) AS AVGTABLE

--Task 3:-
--1.Write a query to retrieve the customers who have placed orders for all products.


SELECT C.CustomerID  , C.Name FROM Customers AS C
	WHERE NOT EXISTS( SELECT 1 FROM Products AS P 
		WHERE NOT EXISTS(SELECT 1 FROM Orders AS O
			WHERE  O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName));


--2.Write a query to retrieve the products that have been ordered by all customers.

SELECT P.ProductID  , P.ProductName FROM Products AS P
	WHERE NOT EXISTS( SELECT 1 FROM Customers AS C 
		WHERE NOT EXISTS(SELECT 1 FROM Orders AS O
			WHERE  O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName));

--3.Write a query to calculate the total revenue generated from orders placed in each month.

SELECT YEAR (OrderDate) as SalesYear, MONTH (OrderDate) as SalesMonth,SUM([Quantity]*[Price]) AS TOTALREVENUE FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY YEAR (OrderDate), MONTH (OrderDate)

--4.Write a query to retrieve the products that have been ordered by more than 50% of the customers.

SELECT ProductName, COUNT(*) AS order_count
FROM orders
GROUP BY ProductName
HAVING COUNT(*) = (SELECT COUNT(DISTINCT CustomerID) FROM orders) * 0.5


--6.Write a query to retrieve the top 5 customers who have spent the highest amount of money on orders.

SELECT TOP 5(Name),SUM(Price*Quantity)AS COUNTS FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products ON Products.ProductName = Orders.ProductName
GROUP BY Name
ORDER BY COUNTS DESC

--7.Write a query to calculate the running total of order quantities for each customer.

SELECT CustomerID, OrderID, SUM(Quantity) OVER (ORDER BY OrderID) AS running_total
FROM orders;

--8.Write a query to retrieve the top 3 most recent orders for each customer.

SELECT TOP 3* FROM Orders
ORDER BY OrderDate DESC

--9.Write a query to calculate the total revenue generated by each customer in the last 30 days.

SELECT CustomerID,SUM([Quantity]*[Price]) AS TOTALREVENUE FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
WHERE OrderDate >= DATEADD(day, -30, GETDATE())
GROUP BY customerID

--10.Write a query to retrieve the customers who have placed orders for at least two different product categories.

SELECT CustomerID
FROM Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT ProductName) >= 2
);

--11.Write a query to calculate the average revenue per order for each customer.

SELECT CustomerID,AVG(Quantity*Price) AS average_revenue
FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY CustomerID

--13.Write a query to retrieve the customers who have placed orders for every month of a specific year.

SELECT OrderID,YEAR (OrderDate) as SalesYear, MONTH (OrderDate) as SalesMontH FROM Orders
INNER JOIN Products
ON Orders.ProductName = Products.ProductName
GROUP BY YEAR (OrderDate), MONTH (OrderDate)

--14.Write a query to retrieve the customers who have placed orders for a specific product in consecutive months.

SELECT C.Name FROM Customers AS C
INNER JOIN Orders AS O1
ON C.CustomerID = O1.CustomerID
INNER JOIN Orders AS O2
ON C.CustomerID = O2.CustomerID
WHERE DATEDIFF(MONTH , O1.OrderDate , O2.OrderDate) = 1

--15.Write a query to retrieve the products that have been ordered by a specific customer at least twice.

SELECT ProductName,CustomerID,COUNT(*) AS order_count FROM Orders
GROUP BY ProductName,CustomerID
HAVING COUNT(*) >= 2;