-- Question 1: Achieving 1NF (First Normal Form)

-- Create a new table to represent the ProductDetail in 1NF
CREATE TABLE OrderProducts1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert data into the 1NF table by splitting the Products column
INSERT INTO OrderProducts1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, SUBSTRING_INDEX(Products, ',', n) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 -- Add more numbers if you expect more than 5 products in a single order
) AS numbers
WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= n - 1;


-- Table for Orders (Order information)
CREATE TABLE Orders2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table for OrderItems (Details about products in each order)
CREATE TABLE OrderItems2NF (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product), -- Composite primary key
    FOREIGN KEY (OrderID) REFERENCES Orders2NF(OrderID)
);


-- Insert data into the Orders2NF table
INSERT INTO Orders2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert data into the OrderItems2NF table
INSERT INTO OrderItems2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

