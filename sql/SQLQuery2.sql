select * from customers;
select * from geography;

SELECT
    c.CustomerID,       -- Unique ID for each customer
    c.CustomerName,     -- Name of the customer
    c.Age,              -- Age of the customer
    c.Email,            -- Email address
    c.Gender,           -- Gender of the customer
    g.City,             -- City (from the geography table)
    g.Country           -- Country (from the geography table)

FROM
    dbo.customers AS c              -- Source table containing customer details
LEFT JOIN
    dbo.geography AS g             -- Lookup table containing city and country info
    ON c.GeographyID = g.GeographyID;  -- Matching key for joining both tables
