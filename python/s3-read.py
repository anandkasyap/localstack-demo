import boto3

s3 = boto3.resource('s3',endpoint_url="http://localhost:4567")
object = s3.Object('ls-s3-demo', 'test/from/python')
data=object.get()['Body'].read().decode('utf-8')
print(data)
