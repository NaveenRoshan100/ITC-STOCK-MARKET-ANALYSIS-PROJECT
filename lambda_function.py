import pandas as pd
import boto3
import io
import os
import requests

def lambda_handler(event, context):
    API_KEY = os.environ['APLHA']
    symbol = "ITC.BSE"
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={symbol}&apikey={API_KEY}&datatype=csv&outputsize=compact"

    df = pd.read_csv(url)
    latest_row = df.iloc[0:1]

    s3 = boto3.client('s3')
    bucket_name = "itc-daily-update-date"
    key = "ITC-DAILY-UPDATE.csv"

    # Read existing CSV from S3
    try:
        obj = s3.get_object(Bucket=bucket_name, Key=key)
        existing_df = pd.read_csv(io.BytesIO(obj['Body'].read()))
        if latest_row['timestamp'].values[0] not in existing_df['timestamp'].values:
            updated_df = pd.concat([latest_row, existing_df], ignore_index=True)
        else:
            updated_df = existing_df
    except s3.exceptions.NoSuchKey:
        updated_df = latest_row

    # Write back to S3
    csv_buffer = io.StringIO()
    updated_df.to_csv(csv_buffer, index=False)
    s3.put_object(Bucket=bucket_name, Key=key, Body=csv_buffer.getvalue())

    return {
        "statusCode": 200,
        "body": f"Updated {key} in {bucket_name}"
    }
