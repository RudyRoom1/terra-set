import boto3
import json

rekognition = boto3.client("rekognition")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("ImageTableRecognition")

def update_item(response_db, key, labels=None, status=None):
    if response_db['Items']:
        item = response_db['Items'][0]
        item.update({'imageStatus': status})
        if labels:
            item.update({'labels': labels})
    else:
        # If item does not exist, create a new item
        item = {'ImageName': key, 'labels': labels or [], 'imageStatus': status}
    return item

def lambda_handler(event, context):
    for event_record in event["Records"]:
        body = json.loads(event_record["body"])

        for record in body["Records"]:
            bucket = record["s3"]["bucket"]["name"]
            key = record["s3"]["object"]["key"]

            id_field_name = 'ImageName'  # Replace 'id_field_name' with your field's name.

            # Query the DynamoDB table.
            response_db = table.query(
                KeyConditionExpression=boto3.dynamodb.conditions.Key('LabelValue').eq(key))

            try:
                response = rekognition.detect_labels(Image={"S3Object": {"Bucket": bucket, "Name": key}})
                labels = [label["Name"] for label in response["Labels"]]
                item = update_item(response_db, key, labels, 'RECOGNITION_COMPLETED')
                # Update the item in the DynamoDB table
                table.put_item(Item=item)

            except Exception as e:
                print(f"Error processing object {key} from bucket {bucket}: {e}")
                item = update_item(response_db, key, status='RECOGNITION_FAILED')
                # Update the item in the DynamoDB table
                table.put_item(Item=item)
                raise e from None