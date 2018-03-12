import boto3

from utils import constants


def update_account_password_policy(session):
    iam_client = session.client('iam')

    # Account Password Policy
    iam_client.update_account_password_policy(
        MinimumPasswordLength=8,
        RequireSymbols=True,
        RequireNumbers=True,
        RequireUppercaseCharacters=True,
        RequireLowercaseCharacters=True,
        AllowUsersToChangePassword=True,
        HardExpiry=False
    )


def create_policy(session, policy_name, description, policy_document):
    iam_client = session.client('iam')
    policy = None
    try:
        policy = iam_client.create_policy(
            PolicyName=policy_name,
            Path='/',
            Description=description,
            PolicyDocument=policy_document
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        sts_client = session.client('sts').get_caller_identity()
        policy = iam_client.get_policy(
            PolicyArn='arn:aws:iam::{0}:policy/{1}'.format(sts_client['Account'], policy_name))
        pass

    return policy


def create_pipelines_policy(session):
    policy_document = '''{
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "ecs:*"
                        ],
                        "Resource": "*"
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:PutObject",
                            "s3:GetObject",
                            "s3:ListBucket"
                        ],
                        "Resource": [
                            "*"
                        ]
                    }
                ]
            }'''
    return create_policy(
        session, policy_name='PipelinesPolicy', description='This policy provides the required permissions to deploy builds through Pipelines.', policy_document=policy_document)


def create_terraform_policy(session, account_key, account_id):
    policy_document = '''{{
                "Version": "2012-10-17",
                "Statement": [
                    {{
                        "Effect": "Allow",
                        "Action": [
                            "ecs:*"
                        ],
                        "Resource": "*"
                    }},
                    {{
                        "Effect": "Allow",
                        "Action": [
                            "s3:PutObject",
                            "s3:GetObject",
                            "s3:ListBucket"
                        ],
                        "Resource": [
                            "arn:aws:s3:::schedule-engine-terraform-{account_key}",
                            "arn:aws:s3:::schedule-engine-terraform-{account_key}/terraform.tfstate"
                        ]
                    }},
                    {{
                        "Effect": "Allow",
                        "Action": [
                            "dynamodb:PutItem",
                            "dynamodb:DeleteItem",
                            "dynamodb:GetItem"
                        ],
                        "Resource": [
                            "arn:aws:dynamodb:us-east-1:{account_id}:table/terraform_state_lock"
                        ]
                    }}
                ]
            }}'''.format(account_key=account_key, account_id=account_id)

    return create_policy(
        session, policy_name='TerraformPolicy', description='This policy provides the required permissions to run Terraform.', policy_document=policy_document)


def create_role(session, role_name, description, assume_role_policy_document):
    iam_client = session.client('iam')
    role = None
    try:
        role = iam_client.create_role(
            Path='/',
            RoleName=role_name,
            Description=description,
            AssumeRolePolicyDocument=assume_role_policy_document
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        role = iam_client.get_role(RoleName=role_name)
        pass

    return role


def create_terraform_role(session):
    assume_role_policy_document = '''{{
                "Version": "2012-10-17",
                "Statement": [
                    {{
                        "Effect": "Allow",
                        "Principal": {{
                            "AWS": "arn:aws:iam::{account_id}:root"
                        }},
                        "Action": "sts:AssumeRole",
                        "Condition": {{}}
                    }}
                ]
            }}'''.format(account_id=constants.OPS_ACCOUNT_ID)

    return create_role(session, role_name='TerraformRole', description='This role is assumed by the terraform user in the se-ops-account.', assume_role_policy_document=assume_role_policy_document)


def create_pipelines_role(session):
    assume_role_policy_document = '''{{
                "Version": "2012-10-17",
                "Statement": [
                    {{
                        "Effect": "Allow",
                        "Principal": {{
                            "AWS": "arn:aws:iam::{account_id}:root"
                        }},
                        "Action": "sts:AssumeRole",
                        "Condition": {{}}
                    }}
                ]
            }}'''.format(account_id=constants.OPS_ACCOUNT_ID)

    return create_role(session, role_name='PipelinesRole', description='This role is assumed by the pipelines user in the se-ops-account.', assume_role_policy_document=assume_role_policy_document)


def attach_role_policy(session, role_name, policy_arn):
    iam_client = session.client('iam')
    iam_client.attach_role_policy(
        RoleName=role_name,
        PolicyArn=policy_arn
    )


def attach_group_policy(session, group_name, policy_arn):
    iam_client = session.client('iam')
    iam_client.attach_group_policy(
        GroupName=group_name,
        PolicyArn=policy_arn
    )


def create_group(session, group_name):
    iam_client = session.client('iam')
    group = None
    try:
        group = iam_client.create_group(
            Path='/',
            GroupName=group_name
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        group = iam_client.get_group(GroupName=group_name)
        pass

    return group


def create_user(session, user_name):
    iam_client = session.client('iam')
    user = None
    try:
        user = iam_client.create_user(
            Path='/',
            UserName=user_name
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        user = iam_client.get_user(UserName=user_name)
        pass

    return user


def add_user_to_group(session, group_name, user_name):
    iam_client = session.client('iam')
    iam_client.add_user_to_group(
        GroupName=group_name,
        UserName=user_name
    )
