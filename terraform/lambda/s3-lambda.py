import boto3, json

def lambda_handler(event, context):
    s3 = boto3.resource('s3',endpoint_url="http://localhost:4566")
    body_string = "This is a sample published into localstack from a python script running in a lambda within localstack"
    key = "test/from/python"
    if event:
        key = "test/from/python-lambda-api-gateway"
        body_string = "This is a sample published into localstack from a python script running in a lambda within localstack, triggered by API Gateway"
    object = s3.Object('ls-s3-demo', key)
    object.put(Body=body_string)
    return {
        "statusCode": 200,
        "body": json.dumps('Lambda Invoked Successfully!!')
    }
