import boto3

from utils import constants


def create_session(profile, account_id, role_name, reason):
    try:
        boto3.setup_default_session(profile_name=profile)
        client = boto3.client(
            service_name='sts',
            # aws_access_key_id=constants.OPS_ACCESS_KEY_ID,
            # aws_secret_access_key=constants.OPS_ACCESS_SECRET_KEY,
            region_name=constants.DEFAULT_REGION
        )
    except Exception as error:
        raise Exception('Failed to create boto3 client: ' + repr(error))

    try:
        # Assume role
        # http://boto3.readthedocs.io/en/latest/reference/services/sts.html#STS.Client.assume_role
        role_arn = 'arn:aws:iam::' + account_id + ':role/' + role_name
        response = client.assume_role(
            RoleArn=role_arn,
            RoleSessionName='se_terraform_' + reason,
            DurationSeconds=900,
        )
        credentials = response['Credentials']
    except Exception as error:
        raise Exception('Error assuming role "' +
                        account_id + ':/role/' + role_name + '": ' + repr(error))

    # Create session
    # http://boto3.readthedocs.io/en/latest/reference/core/session.html#boto3.session.Session
    return boto3.session.Session(
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )
