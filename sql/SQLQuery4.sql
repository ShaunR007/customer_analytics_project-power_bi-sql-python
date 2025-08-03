select * from engagement_data;

-- Retrieve cleaned engagement data and split combined metrics (Views-Clicks)

SELECT
    EngagementID,  -- Unique ID for each engagement entry
    ContentID,     -- ID of the content piece
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,  
        -- Fixes casing and spelling in 'Socialmedia' values
    
    Likes,  -- Number of likes the content received

    FORMAT(CONVERT(DATE, EngagementDate), 'dd/MM/yyyy') AS EngagementDate,  
        -- Converts the datetime to a more readable format (DD/MM/YYYY)

    CampaignID,  -- Campaign identifier
    ProductID,   -- Product related to the engagement

    -- Splitting 'Views-Clicks' column into separate 'Views' and 'Clicks'
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks

FROM 
    engagement_data
WHERE 
    ContentType != 'NEWSLETTER';  -- Exclude newsletter records

