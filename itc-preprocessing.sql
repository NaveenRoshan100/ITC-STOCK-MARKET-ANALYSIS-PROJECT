create or replace view  daily_data_updated as (
select distinct(daily_data.timestamp),daily_data.close,daily_data.high,daily_data.low,daily_data.open,
daily_data.volume from daily_data
);
select * from daily_data_updated;

create or replace view  history_updated as (
select distinct(history_data.timestamp),history_data.close,history_data.high,history_data.low,
history_data.open,history_data.volume from history_data
);


select * from history_updated;

create or replace view  full_table as (

select * from daily_data_updated
union all

select * from history_updated)
;
select * from full_table;

CREATE OR REPLACE  VIEW stock_metrics AS
WITH base AS (
    SELECT 
        timestamp,
        (high + low + close) / 3 AS typical_price,
        close,
        volume
    FROM full_table
)
SELECT 
    timestamp,
    typical_price,
    volume * typical_price AS total_value,

   
    (typical_price - LAG(typical_price,1,0.0) OVER (ORDER BY timestamp))
    / NULLIF(LAG(typical_price,1,0.0) OVER (ORDER BY timestamp), 0)
    AS daily_return,

    
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY timestamp) < 50
        THEN NULL
        ELSE 
    AVG(typical_price) OVER (
        ORDER BY timestamp 
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    ) END AS sma50,
   CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY timestamp) < 200
        THEN NULL
        ELSE 
    AVG(typical_price) OVER (
        ORDER BY timestamp 
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    ) END AS sma200,

    -- Volatility (Standard Deviation)
     CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY timestamp) < 50
        THEN NULL
        ELSE 
    STDDEV(typical_price) OVER (
        ORDER BY timestamp 
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    ) END AS sd50,
    
     CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY timestamp) < 200
        THEN NULL
        ELSE 

    STDDEV(typical_price) OVER (
        ORDER BY timestamp 
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    ) END AS sd200

FROM base;

select * from stock_metrics;

CREATE OR REPLACE VIEW final_itc_stock_table AS
SELECT 
    f.timestamp,
    f.high,
    f.low,
    f.close,
    f.volume,
    m.typical_price,
    m.total_value,
    m.daily_return,
    m.sma50,
    m.sma200,
    m.sd50,
    m.sd200
FROM full_table f
INNER JOIN stock_metrics m
    ON f.timestamp = m.timestamp
ORDER BY f.timestamp;

select * from final_itc_stock_table;

CREATE OR REPLACE TASK daily_update_task
WAREHOUSE = 'ITC_WH'
SCHEDULE = 'USING CRON 0 16 * * * UTC'  -- 4 PM Paris time in UTC
AS
COPY INTO daily_data
FROM @daily_stage
FILE_FORMAT = (TYPE=CSV  SKIP_HEADER=1);

ALTER TASK daily_update_task RESUME;
