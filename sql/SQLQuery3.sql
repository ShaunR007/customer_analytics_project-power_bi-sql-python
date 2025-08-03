select * from dbo.customer_reviews;
-- Retrieve customer reviews and clean up excessive whitespace in the text

SELECT
    ReviewID,                                  -- Unique identifier for each review
    CustomerID,                                -- ID of the customer who gave the review
    ProductID,                                 -- ID of the product being reviewed
    ReviewDate,                                -- Date when the review was posted
    Rating,                                    -- Star rating provided by the customer
    REPLACE(ReviewText, '  ', ' ') AS ReviewText  -- Remove double spaces from the review text
FROM 
    dbo.customer_reviews;
