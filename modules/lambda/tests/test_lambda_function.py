import importlib
import json
import sys
from pathlib import Path

import boto3
import pytest
from moto import mock_aws

# make "import lambda_function" find modules/lambda/src
SRC_DIR = Path(__file__).resolve().parent.parent / "src"
sys.path.insert(0, str(SRC_DIR))

TABLE_NAME = "test-WebsiteVisitors"


@pytest.fixture
def lambda_module(monkeypatch):
    # fake credentials so boto3 can never reach a real aws account
    monkeypatch.setenv("AWS_ACCESS_KEY_ID", "testing")
    monkeypatch.setenv("AWS_SECRET_ACCESS_KEY", "testing")
    monkeypatch.setenv("AWS_SESSION_TOKEN", "testing")
    monkeypatch.setenv("AWS_DEFAULT_REGION", "eu-central-1")
    monkeypatch.setenv("TABLE_NAME", TABLE_NAME)

    with mock_aws():
        # same key schema as modules/dynamodb/main.tf
        boto3.client("dynamodb").create_table(
            TableName=TABLE_NAME,
            KeySchema=[{"AttributeName": "visitors", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "visitors", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        # the lambda connects to dynamodb at import time,
        # so (re)import it only after the fake table exists
        import lambda_function
        yield importlib.reload(lambda_function)


def test_first_visit_returns_count_one(lambda_module):
    response = lambda_module.lambda_handler({}, None)

    assert response["statusCode"] == 200
    assert json.loads(response["body"]) == {"ViewerCount": 1}


def test_count_increases_on_every_visit(lambda_module):
    counts = [
        json.loads(lambda_module.lambda_handler({}, None)["body"])["ViewerCount"]
        for _ in range(3)
    ]

    assert counts == [1, 2, 3]


def test_response_is_json_for_the_browser(lambda_module):
    response = lambda_module.lambda_handler({}, None)

    assert response["headers"]["Content-Type"] == "application/json"


def test_count_is_stored_in_dynamodb(lambda_module):
    lambda_module.lambda_handler({}, None)
    lambda_module.lambda_handler({}, None)

    item = boto3.resource("dynamodb").Table(TABLE_NAME).get_item(
        Key={"visitors": "count"}
    )["Item"]
    assert item["ViewerCount"] == 2
