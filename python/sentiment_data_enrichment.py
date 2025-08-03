# Import necessary libraries
import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Download VADER lexicon for sentiment analysis
nltk.download('vader_lexicon')

#  Connect to SQL Server and fetch customer review data
def fetch_data_from_sql():
    # Define the SQL Server connection string
    conn_str = (
        "Driver={SQL Server};"
        "Server=DESKTOP-V2DA8G5\\SQLEXPRESS;"
        "Database=PortfolioProject_MarketingAnalytics;"
        "Trusted_Connection=yes;"
    )
    
    # Establish connection
    conn = pyodbc.connect(conn_str)
    
    # SQL query to fetch review data
    query = """
        SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText 
        FROM customer_reviews
    """
    
    # Load data into a pandas DataFrame
    df = pd.read_sql(query, conn)
    return df

#  Load customer reviews into DataFrame
Customer_Reviews_df = fetch_data_from_sql()

# Initialize VADER sentiment analyzer
sia = SentimentIntensityAnalyzer()

#  Function to calculate sentiment score (compound value) from review text
def Calculate_Sentiment(Review):
    sentiment = sia.polarity_scores(Review)
    return sentiment['compound']

# 🏷 Categorize sentiment based on score and customer rating
def Categorize_Sentiment(score, Rating):
    if score > 0.05:
        if Rating >= 4:
            return 'Positive'
        elif Rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed Negative'
    elif score < -0.05:
        if Rating <= 2:
            return 'Negative'
        elif Rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else:
        if Rating >= 4:
            return 'Positive'
        elif Rating <= 2:
            return 'Negative'
        else:
            return 'Neutral'

#  Group sentiment scores into defined buckets for visualization
def Sentiment_Bucket(score):
    if score > 0.5:
        return '0.5 to 1.0'
    elif 0.00 <= score < 0.5:
        return '0.00 to 0.49'
    elif -0.5 <= score < 0.00:
        return '-0.49 to 0.00'
    else:
        return '-1.00 to -0.5'

#  Apply sentiment analysis to each review
Customer_Reviews_df['Sentiment_Score'] = Customer_Reviews_df['ReviewText'].apply(Calculate_Sentiment)

# 🏷 Categorize each review into sentiment category
Customer_Reviews_df['Sentiment_Category'] = Customer_Reviews_df.apply(
    lambda row: Categorize_Sentiment(row['Sentiment_Score'], row['Rating']), axis=1)

#  Group reviews into sentiment score buckets
Customer_Reviews_df['Sentiment_Bucket'] = Customer_Reviews_df['Sentiment_Score'].apply(Sentiment_Bucket)

#  Export the processed DataFrame to CSV for further use (e.g., in Power BI)
Customer_Reviews_df.to_csv('Customer_Reviews_With_Sentiments.csv', index=False)
