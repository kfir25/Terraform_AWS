FROM python:3.13-alpine

WORKDIR /app

COPY microservice2.py .

RUN pip install boto3

CMD ["python", "microservice2.py"]
