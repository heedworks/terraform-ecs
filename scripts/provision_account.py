import argparse
import boto3
from utils import constants
from utils.aws import create_session
import utils.aws.s3 as s3_utils
import utils.aws.dynamodb as dynamodb_utils
import utils.aws.iam as iam_utils
from termcolor import colored, cprint


def main(account_key, account_id):
    cprint('Authentication', 'blue')
    session = create_session('se-master-account-terraform', account_id,
                             'OrganizationAccountAccessRole', 'account_setup')
    cprint('  ✨✨ Session created using se-master-account-terraform IAM user', 'green')

    # 1. Create S3 bucket for Terraform state
    # NOTE: Exclude the LocationConstraint for us-east-1
    cprint('Provisioning S3 Resources...', 'blue')
    bucket_name = 'schedule-engine-terraform-{0}'.format(account_key)
    # Create S3 Bucket
    s3_utils.create_bucket(session, bucket_name)
    cprint('  ✨✨ S3 bucket created', 'green')
    print('    Bucket name: {0}'.format(bucket_name))

    # 2. Create DynamoDB table for Terraform state
    cprint('Provisioning DynamoDB Resources...', 'blue')
    # Create DynamoDB Terraform lock table
    dynamodb_utils.create_tf_backend_table(session, 'terraform_state_lock')
    cprint('  ✨✨ DynamoDB table created', 'green')
    print('    Table name: terraform_state_lock')

    # 3. Create IAM resources
    cprint('Provisioning IAM Resources...', 'blue')
    iam_client = session.client('iam')

    # Account Password Policy
    iam_utils.update_account_password_policy(session)

    # Policies
    cprint('  Provisioning IAM Policies...', 'blue')

    # TerraformPolicy
    terraform_policy = iam_utils.create_terraform_policy(
        session, account_key, account_id)

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(terraform_policy['Policy']['Arn']))

    # PipelinesPolicy
    pipelines_policy = iam_utils.create_pipelines_policy(session)

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        pipelines_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(pipelines_policy['Policy']['Arn']))

# Roles

# TerraformRole
    cprint('  Provisioning IAM Roles...', 'blue')
    # terraform_role = None
    # try:
    #     terraform_role = iam_client.create_role(
    #         Path='/',
    #         RoleName='TerraformRole',
    #         Description='This role is assumed by the terraform user in the se-ops-account.',
    #         AssumeRolePolicyDocument='''{{
    #             "Version": "2012-10-17",
    #             "Statement": [
    #                 {{
    #                     "Effect": "Allow",
    #                     "Principal": {{
    #                         "AWS": "arn:aws:iam::{account_id}:root"
    #                     }},
    #                     "Action": "sts:AssumeRole",
    #                     "Condition": {{}}
    #                 }}
    #             ]
    #         }}'''.format(account_id=constants.OPS_ACCOUNT_ID)
    #     )
    # except iam_client.exceptions.EntityAlreadyExistsException:
    #     terraform_role = iam_client.get_role(RoleName='TerraformRole')
    #     pass
    terraform_role = iam_utils.create_terraform_role(session)
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(terraform_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(terraform_role['Role']['Arn']))

    # Attach TerraformPolicy to the TerraformRole
    # iam_client.attach_role_policy(
    #     RoleName='TerraformRole',
    #     PolicyArn=terraform_policy['Policy']['Arn']
    # )
    iam_utils.attach_role_policy(
        session, terraform_role['Role']['RoleName'], terraform_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    # PipelinesRole
    pipelines_role = iam_utils.create_pipelines_role(session)
    # pipelines_role = None
    # try:
    #     pipelines_role = iam_client.create_role(
    #         Path='/',
    #         RoleName='PipelinesRole',
    #         Description='This role is assumed by the pipelines user in the se-ops-account.',
    #         AssumeRolePolicyDocument='''{{
    #             "Version": "2012-10-17",
    #             "Statement": [
    #                 {{
    #                     "Effect": "Allow",
    #                     "Principal": {{
    #                         "AWS": "arn:aws:iam::{account_id}:root"
    #                     }},
    #                     "Action": "sts:AssumeRole",
    #                     "Condition": {{}}
    #                 }}
    #             ]
    #         }}'''.format(account_id=constants.OPS_ACCOUNT_ID)
    #     )
    # except iam_client.exceptions.EntityAlreadyExistsException:
    #     pipelines_role = iam_client.get_role(RoleName='PipelinesRole')
    #     pass

    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(pipelines_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(pipelines_role['Role']['Arn']))

    # Attach PipelinesPolicy to the PipelinesRole
    # iam_client.attach_role_policy(
    #     RoleName='PipelinesRole',
    #     PolicyArn=pipelines_policy['Policy']['Arn']
    # )

    iam_utils.attach_role_policy(
        session, pipelines_role['Role']['RoleName'], pipelines_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        pipelines_policy['Policy']['Arn']))

    # Groups
    cprint('  Provisioning IAM Groups...', 'blue')
    # Terraform group
    terraform_group = iam_utils.create_group(session, 'Terraform')
    # terraform_group = None
    # try:
    #     terraform_group = iam_client.create_group(
    #         Path='/',
    #         GroupName='Terraform'
    #     )
    # except iam_client.exceptions.EntityAlreadyExistsException:
    #     terraform_group = iam_client.get_group(GroupName='Terraform')
    #     pass

    cprint('    ✨✨ IAM group created', 'green')
    print('      Group Name: {}'.format(terraform_group['Group']['GroupName']))
    print('      Group ARN: {}'.format(terraform_group['Group']['Arn']))

    # Attach TerraformPolicy to the Terraform group
    iam_utils.attach_group_policy(
        session, terraform_group['Group']['GroupName'], terraform_policy['Policy']['Arn'])
    # iam_client.attach_group_policy(
    #     GroupName='Terraform',
    #     PolicyArn=terraform_policy['Policy']['Arn']
    # )

    cprint('        ✨✨ IAM policy attached', 'green')
    print('          Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('          Policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    # Users
    cprint('  Provisioning IAM Users...', 'blue')
    # terraform user (only used for terraform backend state)
    terraform_user = iam_utils.create_user(session, 'terraform')
    # terraform_user = None
    # try:
    #     terraform_user = iam_client.create_user(
    #         Path='/',
    #         UserName='terraform'
    #     )
    # except iam_client.exceptions.EntityAlreadyExistsException:
    #     terraform_user = iam_client.get_user(UserName='terraform')
    #     pass

    cprint('    ✨✨ IAM user created', 'green')
    print('      User Name: {}'.format(terraform_user['User']['UserName']))
    print('      User ARN: {}'.format(terraform_user['User']['Arn']))

    # Attach terraform user to Terraform group
    iam_utils.add_user_to_group(
        session, terraform_group['Group']['GroupName'], terraform_user['User']['UserName'])
    # iam_client.add_user_to_group(
    #     GroupName='Terraform',
    #     UserName='terraform'
    # )

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
