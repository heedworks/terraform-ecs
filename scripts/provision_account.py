import argparse
import boto3
from utils import constants
from utils.aws import create_session
import utils.aws.s3 as s3_utils
import utils.aws.dynamodb as dynamodb_utils
import utils.aws.iam as iam_utils
from pyfiglet import Figlet
from termcolor import colored, cprint


def main(account_key, account_id, mfa_token):
    cprint('\nAuthenticating...', 'cyan')
    session = create_session(
        profile='se-master-account-terraform',
        assume_account_id=account_id,
        assume_role_name='OrganizationAccountAccessRole',
        assume_reason='account_setup',
        mfa_token=mfa_token)

    cprint('  ✨✨ Session created using se-master-account-terraform IAM user', 'green')

    ##########################
    ##                      ##
    ##   S3 Configuration   ##
    ##                      ##
    ##########################
    # 1. Create S3 bucket for Terraform state
    cprint('\nProvisioning S3 Resources...', 'cyan')
    bucket_name = 'schedule-engine-terraform-{0}'.format(account_key)
    # Create S3 Bucket
    s3_utils.create_bucket(session, bucket_name)
    cprint('  ✨✨ S3 bucket created', 'green')
    print('    Bucket name: {0}'.format(bucket_name))

    #######################
    ##                   ##
    ##   DynamoDB Setup  ##
    ##                   ##
    #######################
    # 2. Create DynamoDB table for Terraform state
    cprint('\nProvisioning DynamoDB Resources...', 'cyan')
    # Create DynamoDB Terraform lock table
    dynamodb_utils.create_tf_backend_table(session, 'terraform_state_lock')
    cprint('  ✨✨ DynamoDB table created', 'green')
    print('    Table name: terraform_state_lock')

    # 3. Create IAM resources
    cprint('\nProvisioning IAM Resources...', 'cyan')

    # Account Password Policy
    iam_utils.update_account_password_policy(session)

    ###################
    ##               ##
    ## IAM Policies  ##
    ##               ##
    ###################
    cprint('\n  Provisioning IAM Policies...', 'cyan')

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

    # DeveloperPolicy
    developer_policy = iam_utils.create_developer_policy(session)

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        developer_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(developer_policy['Policy']['Arn']))

    # ObserverPolicy
    observer_policy = iam_utils.create_observer_policy(session)

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        observer_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(observer_policy['Policy']['Arn']))

    # OpsAdminPolicy
    ops_admin_policy = iam_utils.create_ops_admin_policy(session)

    cprint('    ✨✨ IAM policy created', 'green')
    print('      Policy Name: {}'.format(
        ops_admin_policy['Policy']['PolicyName']))
    print('      Policy ARN: {}'.format(ops_admin_policy['Policy']['Arn']))

    ##################
    ##              ##
    ##  IAM Roles   ##
    ##              ##
    ##################
    cprint('\n  Provisioning IAM Roles...', 'cyan')

    # TerraformRole
    terraform_role = iam_utils.create_terraform_role(session)
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(terraform_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(terraform_role['Role']['Arn']))

    # Attach TerraformPolicy to the TerraformRole
    iam_utils.attach_role_policy(
        session, terraform_role['Role']['RoleName'], terraform_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    # PipelinesRole
    pipelines_role = iam_utils.create_pipelines_role(session)
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(pipelines_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(pipelines_role['Role']['Arn']))

    iam_utils.attach_role_policy(
        session, pipelines_role['Role']['RoleName'], pipelines_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        pipelines_policy['Policy']['Arn']))

    # OpsAdminRole
    ops_admin_role = iam_utils.create_ops_mfa_role(
        session, 'OpsAdminRole', 'This role allows for full admin access from the se-ops-account.')
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(ops_admin_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(ops_admin_role['Role']['Arn']))

    iam_utils.attach_role_policy(
        session, ops_admin_role['Role']['RoleName'], ops_admin_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        ops_admin_policy['Policy']['Arn']))

    # DeveloperRole
    developer_role = iam_utils.create_ops_mfa_role(
        session, 'DeveloperRole', 'This role allows for developer access from the se-ops-account.')
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(developer_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(developer_role['Role']['Arn']))

    iam_utils.attach_role_policy(
        session, developer_role['Role']['RoleName'], developer_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        developer_policy['Policy']['Arn']))

    # ObserverRole
    observer_role = iam_utils.create_ops_mfa_role(
        session, 'ObserverRole', 'This role allows for observer access from the se-ops-account.')
    cprint('    ✨✨ IAM role created', 'green')
    print('      Role Name: {}'.format(observer_role['Role']['RoleName']))
    print('      Role ARN: {}'.format(observer_role['Role']['Arn']))

    iam_utils.attach_role_policy(
        session, observer_role['Role']['RoleName'], observer_policy['Policy']['Arn'])
    print('      Attached policy ARN: {}'.format(
        observer_policy['Policy']['Arn']))

    ##################
    ##              ##
    ##  IAM Groups  ##
    ##              ##
    ##################
    cprint('\n  Provisioning IAM Groups...', 'cyan')
    # Terraform group
    terraform_group = iam_utils.create_group(session, 'Terraform')

    cprint('    ✨✨ IAM group created', 'green')
    print('      Group Name: {}'.format(terraform_group['Group']['GroupName']))
    print('      Group ARN: {}'.format(terraform_group['Group']['Arn']))

    # Attach TerraformPolicy to the Terraform group
    iam_utils.attach_group_policy(
        session, terraform_group['Group']['GroupName'], terraform_policy['Policy']['Arn'])

    cprint('        ✨✨ IAM policy attached', 'green')
    print('          Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('          Policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    ##################
    ##              ##
    ##  IAM Users   ##
    ##              ##
    ##################
    cprint('\n  Provisioning IAM Users...', 'cyan')
    # terraform user (only used for terraform backend state)
    terraform_user = iam_utils.create_user(session, 'terraform')

    cprint('    ✨✨ IAM user created', 'green')
    print('      User Name: {}'.format(terraform_user['User']['UserName']))
    print('      User ARN: {}'.format(terraform_user['User']['Arn']))

    # Generate user access key
    terraform_user_access_key = iam_utils.create_access_key(
        session, terraform_user['User']['UserName'])

    if terraform_user_access_key is not None:
        cprint('     Make sure to save this access key; it is not possible to retreive this value again.',
               color='green', attrs=['bold'])
        print('      Access Key ID: {}'.format(
            terraform_user_access_key['AccessKey']['AccessKeyId']))
        print('      Secret Access Key: {}'.format(
            terraform_user_access_key['AccessKey']['SecretAccessKey']))

    # Attach terraform user to Terraform group
    iam_utils.add_user_to_group(
        session, terraform_group['Group']['GroupName'], terraform_user['User']['UserName'])

    cprint('      ✨✨ IAM policy attached', 'green')
    print('        Policy Name: {}'.format(
        terraform_policy['Policy']['PolicyName']))
    print('        Policy ARN: {}'.format(
        terraform_policy['Policy']['Arn']))

    if terraform_user_access_key is not None:
        credentials_entry = '''
    [se-{}-account-terraform]
    region = {}
    aws_access_key_id = {}
    aws_secret_access_key = {}
        '''.format(account_key, constants.DEFAULT_REGION, terraform_user_access_key['AccessKey']['AccessKeyId'], terraform_user_access_key['AccessKey']['SecretAccessKey'])
        print('')
        print('')
        cprint('Add the following entry to ~/.aws/credentials BEFORE running terraform on this account:',
               color='blue', attrs=['bold'])
        print(credentials_entry)


if __name__ == '__main__':
    f = Figlet(font='standard')
    cprint('\n{}'.format(f.renderText(
        'Schedule Engine')), color='cyan')
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
        print('\nGoodbye. 🙁')
        exit(0)

    mfa_token = None
    while(mfa_token is None):
        cprint('\nThe master/terraform IAM user account is secured using multi-factor authentication (MFA).',
               'blue', attrs=['bold'])
        mfa_token_input = input(
            '\nEnter One-Time Password: ').strip()
        if mfa_token_input:
            mfa_token = mfa_token_input

    # Provision account
    main(account_key, account_id, mfa_token)

    cprint('\n{}'.format(f.renderText('Done.')), color='green')
    exit(0)
