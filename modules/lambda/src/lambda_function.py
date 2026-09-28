import json
import os
import boto3

# created outside the handler so warm lambda invocations reuse the connection
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])


def lambda_handler(event, context):
    # ADD is atomic: creates the item/attribute on the first call and
    # increments by 1 on every call after that, even with parallel visitors
    response = table.update_item(
        Key={"visitors": "count"},
        UpdateExpression="ADD ViewerCount :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )

    count = int(response["Attributes"]["ViewerCount"])

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"ViewerCount": count}),
    }
