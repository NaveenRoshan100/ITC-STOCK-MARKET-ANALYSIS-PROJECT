# ITC-STOCK-MARKET-ANALYSIS-PROJECT

## Executive Summary

Stock market analysis is crucial for helping investors and businesses make informed decisions. However, collecting, storing, and analyzing stock data by hand can be time-consuming and error-prone. **This project addresses that challenge by developing an automated and scalable data pipeline for ITC stock market data using AWS (S3, Lambda, EventBridge) for data ingestion, Snowflake for data transformation, and Power BI for visualization**. The solution ensures smooth stock data extraction from the **Alpha Vantage API**, structured ETL workflows for preprocessing in Snowflake, and **real-time Power BI dashboards with scheduled refreshes**. This automation not only improves the timeliness and accuracy of stock insights, but it also provides decision-makers with up-to-date, interactive visual analytics.

## Business Problem

Companies and their investors faced obstacles from time to time because of the absence of trust in stock data and different systems regarding data ingestion, transformation, and visualization. Downloading stock data via manual methods, cleaning, and generating reports from that is in itself inefficient, laden with errors, and quite deficient in real-time insight. Decisions for organizations could be based on either obsolete or partial facts in the absence of automated workflows. This is particularly relevant for ITC stock analysis where knowing the accurate market trends on time becomes a need for investment strategies, risk assessment, and performance tracking. That is to say, the business problem is ill-defined as the provision of a fully automated data solution that can provide pure, real-time, and actionable insights on stocks.

## Solution

The solution was implemented by developing a fully automated data pipeline that ingests ITC stock data from the Alpha Vantage API into AWS S3 using Lambda functions triggered by EventBridge for scheduled execution. Once ingested, the raw data was processed through ETL workflows in Snowflake using SQL to clean, preprocess, and transform it into analytics-ready formats. Finally, the transformed datasets were connected to Power BI, where interactive dashboards were created with scheduled refresh capabilities to deliver real-time insights into ITC’s stock performance. This end-to-end solution ensured seamless automation, improved data accuracy, and enabled timely, data-driven decision-making.

## Methodology

### 1. Data Collection

Identified Alpha Vantage as the primary source for ITC stock market data. Created a Python script within AWS Lambda to call the Alpha Vantage API and fetch daily stock attributes such as open, close, high, low, and volume.

    symbol='ITC.BSE'
    API_KEY=os.environ['itc_api']
    url='https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={symbol}&apikey={API_KEY}&datatype=csv'
    data=p.read_csv(url)

The Lambda function was configured to automate this process, while Amazon EventBridge was used to schedule the function to run daily. This ensured continuous and reliable data acquisition without manual intervention.

### 2. Cloud Storage Setup

Two Amazon S3 buckets were used to organize the stock data. The history data bucket contained ITC stock data from 2005 to the present, serving as a consolidated historical record, while the daily data bucket stored the most recent stock data. The Lambda function merged each new daily dataset into the daily data bucket, keeping it updated automatically, while the historical data bucket remained as a stable reference for long-term analysis.

### 3. Data Ingestion and Transformation

Snowflake was connected to both S3 buckets using external stages. The COPY INTO command was used to ingest new daily data from S3 into Snowflake automatically. SQL-based ETL workflows were then developed to clean, preprocess, and transform both historical and daily stock data into structured, analytics-ready tables, ensuring accuracy and consistency for reporting and analysis.

### 4. Data Visualization

The transformed stock data from Snowflake was connected to Power BI for reporting and analysis. Interactive dashboards were created to visualize ITC’s stock performance, highlighting trends in daily prices, trading volume, and historical comparisons. A scheduled refresh was implemented in Power BI to ensure dashboards always displayed the most recent stock data flowing through the automated pipeline.

## Skills
+ Python
+ SQL
+ AWS Lambda
+ Amazon EventBridge
+ Amazon S3
+ Snowflake
+ Power BI

## Result
### DAILY RETURNS
![dashboard-1](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-1.png)


### CLOSE
![dashboard-2](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-2.png)


### TYPICAL PRICE
![dashboard-3](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-3.png)


### SMA FOR TYPICAL PRICE
![dashboard-4](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-4.png)

### RISK ANALYSIS
![dashboard-5](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-5.png)

### OVERVIEW OF DATA
![dashboard-6](https://raw.githubusercontent.com/NaveenRoshan100/ITC-STOCK-MARKET-ANALYSIS-PROJECT/refs/heads/main/dashboard/dashboard-6.png)
