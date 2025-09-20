create database itc;

CREATE SCHEMA itc_analysis;

use itc.itc_analysis;

CREATE OR REPLACE STORAGE INTEGRATION itc_integ
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'my-id'
  STORAGE_ALLOWED_LOCATIONS = ('s3://itc-history-stock-data/', 's3://itc-daily-update-date/')
  comment ='continue';
  
desc integration itc_integ;

create table history_data(
   timestamp varchar(1000),
  open float,
  high	float,
  low	float,
  close float,
  volume int 
  
);

create table daily_data(
   timestamp varchar(1000),
  open float,
  high	float,
  low	float,
  close float,
  volume int 
  
);



CREATE OR REPLACE STAGE history_stage
  STORAGE_INTEGRATION = itc_integ
  URL = 's3://itc-history-stock-data/';

CREATE OR REPLACE STAGE daily_stage
  STORAGE_INTEGRATION = itc_integ
  URL = 's3://itc-daily-update-date/';


COPY INTO history_data
FROM @history_stage
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);

COPY INTO daily_data
FROM @daily_stage
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);


