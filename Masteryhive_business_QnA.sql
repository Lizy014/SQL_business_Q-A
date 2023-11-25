--SQL BUSINESS QUESTIONS AND ANSWERS

--1. List all suppliers in the UK
SELECT 
CompanyName as SuppliersName, City, Country
  FROM [Masteryhive].[dbo].[Supplier]
  WHERE Country = 'UK';


--2. List the first name, last name, and city for all customers. Concatenate the first and last name 
--separated by a space and a comma as a single column
SELECT 
  CONCAT(FirstName,',', ' ',LastName) as Customers_FullName,
  City
FROM Masteryhive.dbo.Customer;


--3. List all customers in Sweden
SELECT 
  CONCAT(FirstName,', ' ,LastName) as CustomerName,
  City, Country
FROM Masteryhive.dbo.Customer
WHERE Country  = 'Sweden';
--(No result will be returned in the rows as there is no customer in Sweden).


--4. List all suppliers in alphabetical order
SELECT *
  FROM Masteryhive.dbo.Supplier
  ORDER BY CompanyName ASC;


--5. List all suppliers with their products
SELECT
  CompanyName,
  ProductName,
  ContactName,
  Country,
  Phone
From Masteryhive.dbo.Supplier S
JOIN Masteryhive.dbo.Product P ON S.Id = P.Id;


--6. List all orders with customers information
SELECT 
  C.Id,
  O.OrderNumber,
  CONCAT(c.FirstName,',', ' ',c.LastName) as OrderedBy,
  City, 
  Country,
  Phone
From Masteryhive.dbo.Customer c
JOIN Masteryhive.dbo.[Order] o ON c.Id = o.Id;
/*NOTED; without inserting the 'Order' in a block bracket as seen in the above query, the query will fail. 
This is because order is a function in sql, the block bracket tells the server that it is a table in the query*/


--7. List all orders with product name, quantity, and price, sorted by order number
SELECT
       OrderNumber,
       ProductName,
	   Quantity,
	   p.UnitPrice,
	   (Quantity * p.UnitPrice) as TotalPrice
FROM dbo.Product p
JOIN dbo.OrderItem oi on p.Id = oi.Id
JOIN dbo.[Order] o on oi.Id = o.Id
ORDER BY OrderNumber ASC;

--8. Using a case statement, list all the availability of products. When 0 then not available, else 
--available
SELECT ProductName AS Product,
       CASE IsDiscontinued
         WHEN 0 THEN  'Not Available'
         ELSE 'Available' 
       END AS Availability
FROM dbo.Product


/*9. Using case statement, list all the suppliers and the language they speak. The language they 
speak should be their country E.g if UK, then English*/
SELECT CompanyName as Supplier,
       CASE Country
         WHEN 'Australia' THEN 'English'
         WHEN 'Brazil' THEN 'Portuguese'
		 WHEN 'Canada' THEN 'English'
		 WHEN 'Denmark' THEN 'Danish, English'
		 WHEN 'Finland' THEN  'Finnish, Swedish'
		 WHEN 'France' THEN 'French' 
		 WHEN 'Germany' THEN 'German'
		 WHEN 'Italy'  THEN 'Italian'
		 WHEN 'Japan' THEN 'Japanese'
		 WHEN 'Netherlands' THEN 'Dutch'
		 WHEN 'Norway' THEN 'Norwegain, Sami'
		 WHEN 'Singapore' THEN 'Malay, Mandarin, Tamil, English'
		 WHEN 'Spain' THEN 'Spanish'
		 WHEN 'Sweden' THEN 'Swedish'
		 WHEN 'UK' THEN 'English'
		 WHEN 'USA' THEN 'English'
     END AS Spoken_Language
FROM dbo.Supplier;


--10. List all products that are packaged in Jars
SELECT DISTINCT ProductName Product,
                package
FROM Masteryhive.dbo.Product
WHERE Package LIKE '%jars%'


--11. List procucts name, unitprice and packages for products that starts with Ca
SELECT ProductName,
	   Unitprice,
	   Package
FROM Masteryhive.dbo.Product
WHERE ProductName LIKE 'Ca%'
ORDER BY ProductName;


--12. List the number of products for each supplier, sorted high to low.
SELECT SupplierId,
	   COUNT(ProductName) AS Number_of_Product
FROM dbo.Product
GROUP BY SupplierId
ORDER BY Number_of_Product DESC;


--13. List the number of customers in each country.
SELECT
       Country,
	   COUNT(Country) AS Number_of_Customer
FROM dbo.Customer
GROUP BY Country
ORDER BY Number_of_Customer;

--14. List the number of customers in each country, sorted high to low.
SELECT
       Country,
	   COUNT(Country) AS Number_of_Customer
FROM dbo.Customer
GROUP BY Country
ORDER BY Number_of_Customer DESC;


--15. List the total order amount for each customer, sorted high to low.
SELECT CustomerId,
       Sum(TotalAmount) As Total_Order_Amount
FROM dbo.[Order]
GROUP BY CustomerId
ORDER BY Total_Order_Amount DESC;
       
--16. List all countries with more than 2 suppliers.
SELECT Id,
       CompanyName AS Supplier,
	   COUNT(CompanyName) AS Supplier_Count,
	   Country
FROM dbo.Supplier
GROUP BY Id,
         CompanyName,
		 COuntry
HAVING COUNT(CompanyName) > 2 /*This will return no result as there is no country with more than 2 suppliers*/
ORDER BY Supplier_Count;

/*17. List the number of customers in each country. Only include countries with more than 10
customers.*/
SELECT Id,
       Country,
	   COUNT(Country) AS Country_Count
FROM dbo.Customer
GROUP BY Id,
		 Country
HAVING COUNT(Country) > 10 
ORDER BY Country_Count;


/*18. List the number of customers in each country, except the USA, sorted high to low. Only
include countries with 9 or more customers.*/
SELECT Id,
       Country,
	   COUNT(Country) AS Country_Count
FROM dbo.Customer
WHERE Country != 'USA'
GROUP BY Id,
		 Country
HAVING COUNT(Country) >= 9 
ORDER BY Country_Count;


--19. List customer with average orders between $1000 and $1200.
SELECT CustomerId,
       AVG(TotalAmount) AVG_TotalAmount
FROM dbo.[Order]
GROUP BY CustomerId
HAVING AVG(TotalAmount) BETWEEN 1000 AND 1200;


--20. Get the number of orders and total amount sold between Jan 1, 2013 and Jan 31, 2013.
SELECT Id,
       OrderDate,
	   Count(OrderNumber) As Number_of_Order,
	   TotalAmount
FROM dbo.[Order]
WHERE OrderDate BETWEEN '2013-01-01' AND '2013-01-30'
GROUP BY Id,
         OrderDate,
		 TotalAmount