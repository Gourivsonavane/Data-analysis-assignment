# Assignment Day 3

create database classicmodels;
use classicmodels;

# First Question

select * from customers;

select customernumber, customername, state, creditlimit
from customers
where state is not null and creditlimit > 50000 and creditlimit <100000
order by creditlimit desc;

# Second Question

select * from products;

select distinct productline from products where productline like '%cars';

# Assignment Day 4

# First Question

select * from orders;

select ordernumber, status,  COALESCE(comments, '-') AS comments 
from orders
where status='shipped';

# Second Question

select * from employees;

select employeeNumber, FirstName, JobTitle ,
CASE
WHEN jobtitle = 'president' THEN 'P'
WHEN jobtitle LIKE '%Sale Manager%' THEN 'SM'
WHEN jobtitle LIKE '%Sales Manager%' THEN 'SM'
WHEN jobtitle = 'Sales Rep' THEN 'SR'
WHEN jobtitle LIKE '%VP%' THEN 'VP'
ELSE jobtitle -- Default to the original job title if none of the conditions match
END AS jobTitleAbbr
FROM employees;

# Assignment Day 5

# First Question

select * from payments;

SELECT YEAR(paymentdate) as Year,
	MIN(amount) as Min_Amount 
    FROM payments
    GROUP BY YEAR(paymentdate)
    ORDER BY Year;
    
# Second Question

select * from orders;

	SELECT 
		YEAR(orderdate) as Year,
		QUARTER(orderdate) as Quarter,
		COUNT(DISTINCT customernumber) as Unique_Customers,
		COUNT(*) AS Total_Orders
		FROM Orders
	GROUP BY
		YEAR(orderdate),
		QUARTER(orderdate)
	ORDER BY
		YEAR, Quarter;
        
 # Third Question  
 
 	SELECT MONTHNAME(paymentDate) as Month,
	CONCAT(FORMAT(SUM(amount) / 1000, '0'), 'K') AS Formatted_AMT
	FROM payments Group by Month
    having Formatted_AMT between 500 and 1000
	ORDER BY Formatted_AMT DESC;
 
 
 # Assignment Day 6
 ## A.product table
 
 CREATE TABLE product (
		product_id INT NOT NULL AUTO_INCREMENT,
		product_name VARCHAR(255) NOT NULL UNIQUE,
		description VARCHAR(255),
		supplier_id INT NOT NULL,
		PRIMARY KEY (product_id),
		FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
		);
        
SELECT * FROM product;
        
## B. suppliers table

CREATE TABLE suppliers (
		supplier_id INT NOT NULL AUTO_INCREMENT,
		supplier_name VARCHAR(255) NOT NULL,
		location VARCHAR(255) NOT NULL,
		PRIMARY KEY (supplier_id)
		);
        
SELECT * FROM suppliers;
        
## C. stock table

CREATE TABLE stock (
		id INT NOT NULL AUTO_INCREMENT,
		product_id INT NOT NULL,
		balance_stock INT NOT NULL,
		PRIMARY KEY (id),
		FOREIGN KEY (product_id) REFERENCES product(product_id)
		);
        
SELECT * FROM stock;

# Assignment Day 7

# First Question

	select * from employees;

	SELECT
		employeenumber,
		concat(firstname, ' ' , lastname) AS Sales_Person,
		count(DISTINCT customernumber) AS Unique_Customers
	FROM employees
	INNER JOIN customers ON employees.employeenumber = customers.salesrepemployeenumber
	GROUP BY employeenumber, sales_person
	ORDER BY unique_customers DESC;
    
# Second Question

select * from customers;
	select * from orders;
	select * from orderdetails;
	select * from products;

	SELECT	
		customers.customernumber,
		customers.customername,
		products.productcode,
		products.productname,
		SUM(orderdetails.quantityordered) AS Ordered_Qty,
		products.quantityInStock,
		SUM(orderdetails.quantityordered) - products.quantityInStock AS Left_Qty
	FROM customers
	INNER JOIN orders ON customers.customernumber = orders.customernumber
	INNER JOIN orderdetails ON orders.ordernumber = orderdetails.ordernumber
	INNER JOIN products ON orderdetails.productcode = products.productcode
	GROUP BY customers.customernumber, products.productname,products.quantityInStock,productcode
	ORDER BY customers.customernumber,productcode;
    
# Third Question

CREATE TABLE Laptop(
		Laptop_Name varchar(255)
		);
    
	CREATE TABLE Colours(
		Colour_Name varchar(255)
		);
    
	INSERT INTO Laptop VALUES ('Dell XPS 13');
	INSERT INTO Laptop VALUES ('MacBook Air');
	INSERT INTO Laptop VALUES ('Microsoft Surface Laptop 4');

	SELECT * FROM laptop;

	INSERT INTO Colours VALUES ('Silver');
	INSERT INTO Colours VALUES ('Gold');
	INSERT INTO Colours VALUES ('Space Gray');

	SELECT * FROM colours;

	SELECT * FROM laptop CROSS JOIN Colours;

	SELECT COUNT(*) FROM 
		(SELECT * FROM laptop CROSS JOIN colours) 
		AS cross_join_table;
        
# Fourth Question

CREATE TABLE project (
		EmployeeID INT,
		FullName VARCHAR(255),
		Gender VARCHAR(10),
		ManagerID INT,
		PRIMARY KEY (EmployeeID)
		);

	INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
	INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
	INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
	INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
	INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
	INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
	INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

	SELECT * FROM project;

	SELECT e.fullname, f.fullname AS emp_name
	FROM project e
	INNER JOIN project as f 
	ON e.employeeID = f.ManagerID
	ORDER BY fullname;
    
    
# Assignment Day 8
   
   CREATE TABLE Facility(
		Facility_ID INT,
		Name VARCHAR(255),
		State VARCHAR(255),
		Country VARCHAR(255)
		);
        
SELECT * FROM Facility;

ALTER TABLE Facility
		MODIFY Facility_ID INT NOT NULL auto_increment PRIMARY KEY;
    
	ALTER TABLE Facility
		ADD COLUMN City INT NOT NULL after Name;
        
Select * from facility;

	desc facility;
    
    
# Assignment Day 9

CREATE TABLE University(
		ID INT,
		Name VARCHAR(50)
		);
        
        	INSERT INTO University
		VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
        
        SELECT * FROM UNIVERSITY;
 
   ## Removing Spaces from Column Names

	select ID, CONCAT(TRIM(LEFT(TRIM(Name),7))," ",RIGHT(TRIM(Name),10)) AS Name From University;
    
    
## ASSIGNMENT DAY 10


CREATE VIEW products_status AS
	SELECT
		YEAR(orderdate) AS year,
		concat(count(productcode)," ","(", round(count(productcode)*100/ (select count(productcode) from orderdetails),0),"%",")")
		AS Value from orders as o
		JOIN orderdetails as od
		ON o.ordernumber = od.ordernumber
		GROUP BY YEAR(orderdate)
		order by count(productcode) desc;
        
        SELECT * FROM PRODUCTS_STATUS;
        use classicmodels;
## Assignment Day 11
  
## Question First
## Procedure GetCustomerLevel

	##	CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(Cust_no int)
	##	BEGIN
	##	declare CustomerLevel varchar(20);
	##	Select creditlimit into CustomerLevel from customers where Customernumber = Cust_no;
	##	if CustomerLevel > 100000 then 
	##	set CustomerLevel = "Platinum" ;
	##	elseif CustomerLevel < 25000 then  
	##	set CustomerLevel = " Silver";
	##	else 
	##	set CustomerLevel = "Gold";
	##	end if;
	##	select cust_no as Customer_number, CustomerLevel;
	##	END
 
 call classicmodels.GetCustomerLevel(103); 
	call getcustomerlevel (124); 
	call getcustomerlevel (112);
    
 
 ## Question Second
## Create a stored procedure Get_country_payments 

    select * from customers;
	select * from payments;
	## Below is the procedure Get_Country_Payments

	##	CREATE DEFINER=root@localhost PROCEDURE Get_country_payments(in  inputyear int, in  inputcountry varchar(50))
	##	BEGIN
	##	select year(p.paymentdate) as Year , c.country, concat(format(sum(amount)/1000,0),'K') as Total_Amount
	##	from payments p join customers c on p.customernumber=c.customernumber
	##	where year(p.paymentdate)= inputyear and (c.country)=inputcountry
	##	group by year(P.paymentdate),country;
	##	END

call classicmodels.Get_country_payments(2003, 'france');
 
 ## Assignment Day 12
 
 # First Question
 
 select * from orders;

	SELECT
		YEAR(orderdate) AS Year,
		MONTHNAME(orderdate) AS Month,
		COUNT(orderNumber) AS Total_orders,
		CONCAT(IFNULL(round((COUNT(*) - LAG(COUNT(*), 1)
		OVER (ORDER BY YEAR(orderdate), MONTHNAME(orderdate))) / LAG(COUNT(*), 1) 
		OVER (ORDER BY YEAR(orderdate), MONTHNAME(orderdate)) * 100), 100)," ",'%') AS YoY_percentage_change
		FROM orders group by year,month;
        
# Second Question
        use classicmodels;
## CREATE DEFINER=root@localhost FUNCTION Calculate_Age(dob date) RETURNS varchar(100) CHARSET utf8mb4
## BEGIN
## 	  declare years int;
##    declare months int;

##    set years =  year(now()) - year(dob) ;
##    set months =  month(now()) - month(dob);
    
##    if months < 0 then
##		set years = years - 1;
##        set months = months + 12;
##	end if;
    
## return concat(years, 'years', months, 'months');
## END


 ## Assignment Day 13
 
 # First Question
 
 SELECT customernumber, customername
		FROM customers
		WHERE customernumber NOT IN (
		SELECT customernumber
		FROM orders 
		);
        
# Second Question

select c.customernumber, c.customername, count(o.customernumber) as total_orders
	from customers c left join orders o on c.customerNumber = o.customerNumber group by c.customerNumber;
    
# Third Question

select * from orderdetails;

	select count(*) from orderdetails;
    
	select o.ordernumber, o.quantityordered from (
	select ordernumber, quantityordered, dense_rank() over (partition by ordernumber order by quantityordered desc) as abc
	from orderdetails) as o where abc = 2;

# Fourth Question 
SELECT max(product_count) AS max_count, min(product_count) AS min_count FROM 
	( SELECT count(distinct productCode) AS product_count FROM Orderdetails GROUP BY ordernumber ) AS order_counts;
    

# Fifth Question

select * from products;

	select productline, count(productcode) as total from products 
	where buyprice > (select avg(buyprice) from products)
	group by productline	 order by total desc;

    
## Assignment Day 14

## CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertIntoEmpEH`( in EmpID int,in EmpName varchar (20),  in EmailAddress varchar (50))
## BEGIN
## DECLARE EXIT HANDLER FOR SQLEXCEPTION
## SELECT 'Error occurred' AS Message;
## INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
## VALUES (EmpID, EmpName, EmailAddress);
##	END
    
# Assignment Day 15

CREATE TABLE Emp_BIT 
		(Name VARCHAR(255),
		Occupation VARCHAR(255),
		Working_date DATE,
		Working_hours INT);

	INSERT INTO Emp_BIT VALUES
		('Robin', 'Scientist', '2020-10-04', 12),
		('Warner', 'Engineer', '2020-10-04', 10),
		('Peter', 'Actor', '2020-10-04', 13),
		('Marco', 'Doctor', '2020-10-04', 14),
		('Brayden', 'Teacher', '2020-10-04', 12),
		('Antonio', 'Business', '2020-10-04', 11);

	select * from emp_bit;

	INSERT INTO Emp_BIT VALUES
	('Anna', 'Scientist', '2020-10-04', -14);

	##		CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
	##    IF NEW.Working_hours < 0 THEN
	##        SET NEW.Working_hours = -NEW.Working_hours;
	##    END IF;
	##	END












        



   
    
    





    
 
 
 
 
 



    





 











