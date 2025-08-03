select * from customer_journey;

-- Step 1: Identify duplicate customer journey records
WITH DuplicateRecords AS (
    SELECT
        JourneyID,        -- Unique identifier for each journey step
        CustomerID,       -- ID of the customer
        ProductID,        -- ID of the product involved
        VisitDate,        -- Date of the interaction
        Stage,            -- Customer journey stage (e.g., Awareness, Purchase)
        Action,           -- Action taken (e.g., Click, View)
        Duration,         -- Duration of the action or visit

        -- Assign row numbers to duplicates within grouped combinations
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
            ORDER BY JourneyID
        ) AS row_num
    FROM customer_journey
)

-- Step 2: Display all entries (can later filter duplicates using WHERE row_num > 1)
SELECT * 
FROM DuplicateRecords
ORDER BY JourneyID;


-- Step 3: Cleaned dataset — remove duplicates and fill missing durations

SELECT
    JourneyID,
    CustomerID,
    ProductID,
    VisitDate,
    Stage,
    Action,
    
    -- Fill missing Duration values using the average for that VisitDate
    COALESCE(Duration, Avg_Duration) AS Duration  

FROM (
    SELECT
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,
        UPPER(Stage) AS Stage,  -- Standardize Stage values to uppercase
        Action,
        Duration,

        -- Calculate average duration per day (used for imputation)
        AVG(Duration) OVER (PARTITION BY VisitDate) AS Avg_Duration,

        -- Again, assign row numbers for deduplication
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
            ORDER BY JourneyID
        ) AS row_num
    FROM customer_journey
) AS subquery

-- Keep only the first record from each duplicate group
WHERE row_num = 1;
