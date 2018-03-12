import boto3

from utils import constants


def create_bucket(session, bucket_name):
    s3_client = session.client('s3')
    try:
        s3_client.create_bucket(
            ACL='private',
            Bucket=bucket_name)

        s3_client.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={
                'Status': 'Enabled'
            }
        )
    except s3_client.exceptions.EntityAlreadyExistsException:
        pass
