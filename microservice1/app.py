from flask import Flask, request, jsonify
import boto3
import os
from datetime import datetime

app = Flask(__name__)

# ENV vars
REGION = os.environ.get("AWS_REGION", "us-east-1")
SSM_PARAM = os.environ.get("SSM_PARAM", "/microservice/token")
SQS_URL = os.environ.get("SQS_URL")

# AWS clients
ssm = boto3.client('ssm', region_name=REGION)
sqs = boto3.client('sqs', region_name=REGION)

def get_token_from_ssm():
    response = ssm.get_parameter(Name=SSM_PARAM, WithDecryption=True)
    return response['Parameter']['Value']

def validate_token(incoming_token):
    stored_token = get_token_from_ssm()
    return incoming_token == stored_token

def validate_email_timestamp(data):
    try:
        email_ts = data.get("email_timestream")
        datetime.strptime(email_ts, "%Y-%m-%dT%H:%M:%SZ")
        return True
    except:
        return False

@app.route("/process", methods=["POST"])
def process():
    data = request.get_json()
    token = request.headers.get("Authorization")

    if not token or not validate_token(token):
        return jsonify({"error": "Invalid or missing token"}), 401

    if not validate_email_timestamp(data):
        return jsonify({"error": "Invalid or missing email_timestream"}), 400

    # Send to SQS
    sqs.send_message(
        QueueUrl=SQS_URL,
        MessageBody=str(data)
    )

    return jsonify({"message": "Processed and sent to queue"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
