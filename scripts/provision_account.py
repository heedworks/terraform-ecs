import argparse
import boto3
from utils import constants
from utils.aws import create_session, create_bucket
from termcolor import colored, cprint


def main(account_key, account_id):
    cprint('Authentication', 'blue')
    session = create_session('se-master-account-terraform', account_id,
                             'OrganizationAccountAccessRole', 'account_setup')
    cprint('  ✨✨ Session created using se-master-account-terraform IAM user', 'green')

    # 1. Create S3 bucket for Terraform state
    # NOTE: Exclude the LocationConstraint for us-east-1
    cprint('Provisioning S3 Resources...', 'blue')
    # s3_client = session.client('s3')
    bucket_name = 'schedule-engine-terraform-{0}'.format(account_key)
    create_bucket(session, bucket_name)
    # try:
    #     s3_client.create_bucket(
    #         ACL='private',
    #         Bucket=bucket_name)

    #     s3_client.put_bucket_versioning(
    #         Bucket=bucket_name,
    #         VersioningConfiguration={
    #             'Status': 'Enabled'
    #         }
    #     )
    # except s3_client.exceptions.EntityAlreadyExistsException:
    #     pass

    cprint('  ✨✨ S3 bucket created', 'green')
    print('    Bucket name: {0}'.format(bucket_name))

    # 2. Create DynamoDB table for Terraform state
    cprint('Provisioning DynamoDB Resources...', 'blue')
    dynamodb_client = session.client('dynamodb')
    try:
        dynamodb_client.create_table(
            TableName='terraform_state_lock',
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

        terraform_table = dynamodb_client.describe_table(
            TableName='terraform_state_lock')
    except dynamodb_client.exceptions.ResourceInUseException:
        pass

    cprint('  ✨✨ DynamoDB table created', 'green')
    print('    Table name: terraform_state_lock')

    # 3. Create IAM resources
    cprint('Provisioning IAM Resources...', 'blue')
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

    # Policies
    cprint('  Provisioning IAM Policies...', 'blue')
    # TerraformPolicy
    terraform_policy = None
    try:
        terraform_policy = iam_client.create_policy(
            PolicyName='TerraformPolicy',
            Path='/',
            Description='This policy provides the required permissions to run Terraform.',
            PolicyDocument='''{{
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
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        terraform_policy = iam_client.get_policy(
            PolicyArn='arn:aws:iam::{0}:policy/TerraformPolicy'.format(account_id))
        pass

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(terraform_policy['Policy']['Arn']))

    # PipelinesPolicy

    pipelines_policy = None
    try:
        pipelines_policy = iam_client.create_policy(
            PolicyName='PipelinesPolicy',
            Path='/',
            Description='This policy provides the required permissions to deploy builds through Pipelines.',
            PolicyDocument='''{
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
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        pipelines_policy = iam_client.get_policy(
            PolicyArn='arn:aws:iam::{0}:policy/PipelinesPolicy'.format(account_id))
        pass

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        pipelines_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(pipelines_policy['Policy']['Arn']))

# Roles

# TerraformRole
    cprint('  Provisioning IAM Roles...', 'blue')
    terraform_role = None
    try:
        terraform_role = iam_client.create_role(
            Path='/',
            RoleName='TerraformRole',
            Description='This role is assumed by the terraform user in the se-ops-account.',
            AssumeRolePolicyDocument='''{{
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
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        terraform_role = iam_client.get_role(RoleName='TerraformRole')
        pass

    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(terraform_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(terraform_role['Role']['Arn']))

    # Attach TerraformPolicy to the TerraformRole
    iam_client.attach_role_policy(
        RoleName='TerraformRole',
        PolicyArn=terraform_policy['Policy']['Arn']
    )
    print('      Attached policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    # PipelinesRole
    pipelines_role = None
    try:
        pipelines_role = iam_client.create_role(
            Path='/',
            RoleName='PipelinesRole',
            Description='This role is assumed by the pipelines user in the se-ops-account.',
            AssumeRolePolicyDocument='''{{
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
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        pipelines_role = iam_client.get_role(RoleName='PipelinesRole')
        pass

    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(pipelines_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(pipelines_role['Role']['Arn']))

    # Attach PipelinesPolicy to the PipelinesRole
    iam_client.attach_role_policy(
        RoleName='PipelinesRole',
        PolicyArn=pipelines_policy['Policy']['Arn']
    )
    print('      Attached policy ARN: {}'.format(
        pipelines_policy['Policy']['Arn']))

    # Groups
    cprint('  Provisioning IAM Groups...', 'blue')
    # Terraform group
    terraform_group = None
    try:
        terraform_group = iam_client.create_group(
            Path='/',
            GroupName='Terraform'
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        terraform_group = iam_client.get_group(GroupName='Terraform')
        pass

    cprint('    ✨✨ IAM group created', 'green')
    print('      Group Name: {}'.format(terraform_group['Group']['GroupName']))
    print('      Group ARN: {}'.format(terraform_group['Group']['Arn']))

    # Attach TerraformPolicy to the Terraform group
    iam_client.attach_group_policy(
        GroupName='Terraform',
        PolicyArn=terraform_policy['Policy']['Arn']
    )

    cprint('        ✨✨ IAM policy attached', 'green')
    print('          Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('          Policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    # Users
    cprint('  Provisioning IAM Users...', 'blue')
    # terraform user (only used for terraform backend state)
    terraform_user = None
    try:
        terraform_user = iam_client.create_user(
            Path='/',
            UserName='terraform'
        )
    except iam_client.exceptions.EntityAlreadyExistsException:
        terraform_user = iam_client.get_user(UserName='terraform')
        pass

    cprint('    ✨✨ IAM user created', 'green')
    print('      User Name: {}'.format(terraform_user['User']['UserName']))
    print('      User ARN: {}'.format(terraform_user['User']['Arn']))

    # Attach terraform user to Terraform group
    iam_client.add_user_to_group(
        GroupName='Terraform',
        UserName='terraform'
    )

    cprint('      ✨✨ IAM policy attached', 'green')
    print('        Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('        Policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-account_key", "--account_key", dest="account_key",
                        help="Account key of the account to provision (e.g. integration, prod, etc")
    parser.add_argument("-account_id", "--account_id", dest="account_id",
                        help="Account ID of the account to provision (e.g. 205210731340)")

    args = parser.parse_args()

    if args.account_key is None or args.account_id is None:
        print('Enter values for the member account you wish to provision')

    account_key = args.account_key
    while(account_key is None):
        account_key_input = input(
            'Account Key (e.g. integration, prod): ').strip()
        if account_key_input:
            account_key = account_key_input

    account_id = args.account_id
    while(account_id is None):
        account_id_input = input('Account ID (e.g. 205210731340): ').strip()
        if account_id_input:
            account_id = account_id_input

    print('')
    cprint('You are going to provision the following account for Terraform usage:', 'blue')
    print(colored('  Account Key: ', attrs=['bold']) + account_key)
    print(colored('  Account ID: ', attrs=['bold']) + account_id)

    continue_response = None
    while(continue_response is None):
        continue_response_input = input(
            colored('Are you sure you want to continue? (y/n) ',
                    'magenta', None, ['bold'])).strip().lower()
        if continue_response_input and continue_response_input in ['y', 'n']:
            continue_response = continue_response_input

    if continue_response == 'n':
        print('Goodbye. 🙁')
        exit(0)

    # Provision account
    main(account_key, account_id)

    print('Done.')
    exit(0)
