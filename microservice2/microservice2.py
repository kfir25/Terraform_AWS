import boto3
import os
import time
import json
from datetime import datetime

# ENV variables
QUEUE_URL = os.environ.get("SQS_URL")
BUCKET_NAME = os.environ.get("S3_BUCKET")
REGION = os.environ.get("AWS_REGION", "us-east-1")
POLL_INTERVAL = int(os.environ.get("POLL_INTERVAL", 10))  # seconds

# AWS clients
sqs = boto3.client('sqs', region_name=REGION)
s3 = boto3.client('s3', region_name=REGION)

def poll_and_process():
    while True:
        response = sqs.receive_message(
            QueueUrl=QUEUE_URL,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=5
        )

        messages = response.get("Messages", [])

        for msg in messages:
            body = msg["Body"]

            # Create unique filename using timestamp
            filename = f"{datetime.utcnow().isoformat()}_{msg['MessageId']}.json"

            # Upload to S3
            s3.put_object(
                Bucket=BUCKET_NAME,
                Key=f"processed/{filename}",
                Body=body
            )

            # Delete from queue
            sqs.delete_message(
                QueueUrl=QUEUE_URL,
                ReceiptHandle=msg["ReceiptHandle"]
            )

            print(f"Processed and uploaded: {filename}")

        time.sleep(POLL_INTERVAL)

if __name__ == "__main__":
    print("Starting Microservice 2...")
    poll_and_process()
