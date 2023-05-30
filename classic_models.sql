/*
Dataset source: https://www.mysqltutorial.org/mysql-sample-database.aspx
 
The objective of the exercise is to analyse the perform an analysis of the performance 
of the company through answering the following questions:

1. Which country has generated the most revenue?
2. Which period of the year receives the most revenue?
3. Which company has the most orders?
4. Who is the sales person that the most revenue ?
5. Which product line has the highest revenue?
									
*/


USE classicmodels;

#Data exploration

SELECT MAX(orderDate), MIN(orderDate)
FROM
orders;



# Which country has the most revenue?

SELECT 
country, (od.quantityOrdered * od.priceEach) AS totalPrice
FROM
customers c
JOIN
orders o ON c.customerNumber = o.customerNumber
JOIN
orderDetails od ON o.orderNumber = od.orderNumber
GROUP BY
country
ORDER BY 
totalPrice DESC;


# Which period of the year receives the most revenue?

SELECT MONTH(o.orderDate) AS dateMonth ,SUM(od.quantityOrdered * od.priceEach) AS totalPrice
FROM
orders o 
JOIN
orderDetails od ON o.orderNumber = od.orderNumber
GROUP BY
MONTH(o.orderDate)
ORDER BY
MONTH(o.orderDate) DESC;


# Which country has generated the most orders?

SELECT
c.country, od.quantityOrdered
FROM
customers c 
JOIN
orders o ON c.customerNumber = o.customerNumber
JOIN
orderDetails od ON o.orderNumber = od.orderNumber
GROUP BY
od.quantityOrdered
ORDER BY
od.quantityOrdered DESC;


# Who is the sales person that has generated the most revenue?

SELECT CONCAT(e.firstName,' ',e.lastName) AS salesPerson,
		(od.quantityOrdered * od.priceEach) AS totalPrice
FROM
		employees e 
RIGHT JOIN
		customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
		orders o ON c.customerNumber = o.customerNumber
JOIN
		orderDetails od ON o.orderNumber = od.orderNumber
GROUP BY 
		salesPerson
ORDER BY 
		totalPrice DESC;
        
# Which product line has the highest revenue?

SELECT
		p.productLine, od.quantityOrdered,(od.quantityOrdered * od.priceEach) AS totalPrice
FROM
		orderDetails od 
JOIN
		products p ON od.productCode = p.productCode
GROUP BY
		ProductLine
Order By
		totalPrice DESC;


# Preparing dataset for visualization in Looker Studio

SELECT 	c.customerName, c.city, c.country, o.orderDate, p.productLine,
		od.quantityOrdered, od.priceEach, (od.quantityOrdered * od.priceEach) AS revenue,
        CONCAT(e.firstName,' ',e.lastName) AS salesPerson
	
FROM 
employees e 
RIGHT JOIN
customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
orders o ON c.customerNumber = o.customerNumber
JOIN
orderDetails od ON o.orderNumber = od.orderNumber
JOIN
products p ON od.productCode = p.productCode;


SELECT
	c.contactFirstName,
	c.contactLastName,
    c.customerName as company,
    CONCAT(e.firstName,' ',e.lastName) AS salesPerson
FROM
	customers c 
JOIN
	employees e ON c.salesRepEmployeeNumber = e.employeeNumber;
    
    



