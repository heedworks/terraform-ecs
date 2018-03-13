import boto3
from utils import constants


def create_session(profile, assume_account_id, assume_role_name, assume_reason, mfa_token):
    try:
        boto3.setup_default_session(profile_name=profile)
        client = boto3.client(
            service_name='sts',
            region_name=constants.DEFAULT_REGION
        )
    except Exception as error:
        raise Exception(
            'Failed to create boto3 client: {}'.format(repr(error)))

    try:
        # Assume role
        # http://boto3.readthedocs.io/en/latest/reference/services/sts.html#STS.Client.assume_role
        role_arn = 'arn:aws:iam::{}:role/{}'.format(
            assume_account_id, assume_role_name)

        response = client.assume_role(
            RoleArn=role_arn,
            RoleSessionName='se_terraform_' + assume_reason,
            DurationSeconds=900,
            SerialNumber='arn:aws:iam::{}:mfa/terraform'.format(
                client.get_caller_identity()['Account']),
            TokenCode=mfa_token
        )
        credentials = response['Credentials']
    except Exception as error:
        raise Exception('Error assuming role "{}": {}'.format(
            role_arn, repr(error)))

    # Create session
    # http://boto3.readthedocs.io/en/latest/reference/core/session.html#boto3.session.Session
    return boto3.session.Session(
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )
