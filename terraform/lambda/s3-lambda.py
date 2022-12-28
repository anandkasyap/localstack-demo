import boto3, json

def lambda_handler(event, context):
    s3 = boto3.resource('s3',endpoint_url="http://localhost:4566")
    object = s3.Object('ls-s3-demo', 'test/from/python-lambda')
    body_string = "This is a sample published into localstack from a python script running in a lambda within localstack"
    if event:
        body_string = "This is a sample published into localstack from a python script running in a lambda within localstack, triggered by API Gateway"
    object.put(Body=body_string)
    return {
        "statusCode": 200,
        "body": json.dumps('Lambda Invoked Successfully!!')
    }
