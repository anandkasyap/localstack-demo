import boto3

def lambda_handler(event, context):
    s3 = boto3.resource('s3',endpoint_url="http://localhost:4566")
    object = s3.Object('ls-s3-demo', 'test/from/python-lambda')
    object.put(Body="This is a sample published into localstack from a python script running in a lambda within localstack")
    return {'status_code': 200}
