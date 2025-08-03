-- Retrieve all records from the 'products' table for reference
SELECT * 
FROM products;

-- Categorize products based on their price using CASE statements
SELECT
    ProductID,         -- Unique identifier for each product
    ProductName,       -- Name of the product
    Price,             -- Price of the product
    Category,          -- Category or type of product

    -- Create a new column 'PriceCategory' based on the product's price
    CASE
        WHEN Price < 50 THEN 'Low'                  -- Products priced below 50 are labeled as 'Low'
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium' -- Products priced between 50 and 200 are labeled as 'Medium'
        ELSE 'High'                                 -- Products priced above 200 are labeled as 'High'
    END AS PriceCategory

FROM products;
