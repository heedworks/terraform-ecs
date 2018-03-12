import boto3

from utils import constants


def create_tf_backend_table(session, table_name):
    dynamodb_client = session.client('dynamodb')
    try:
        dynamodb_client.create_table(
            TableName=table_name,
            KeySchema=[
                {
                    'AttributeName': 'LockID',
                    'KeyType': 'HASH'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'LockID',
                    'AttributeType': 'S'
                }

            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 1,
                'WriteCapacityUnits': 1
            }
        )
        # Wait until the table exists.
        dynamodb_client.get_waiter('table_exists').wait(
            TableName='terraform_state_lock')

        # terraform_table = dynamodb_client.describe_table(
        #     TableName='terraform_state_lock')
    except dynamodb_client.exceptions.ResourceInUseException:
        pass
