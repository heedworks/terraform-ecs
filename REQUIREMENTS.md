_NOTE:_ New member account will have the `OrganizationAccountAccessRole`, which can be assumed by IAM users in the master account (595075499860). `initialize_member_account.py` will assume the `OrganizationAccountAccessRole` role in the new member account by authenticating as the `terraform-initialization-admin`.



## Requirements for new organization member account

# Accounts

| Account name             | Account ID   | Environment (ENV) |
| ------------------------ | ------------ | ----------------- |
| Schedule Engine (master) | 595075499860 |                   |
| se-ops-account           | 528208453446 |                   |
| se-ecr-account           | 302058597523 |                   |
| se-integration-account   | 205210731340 | integration       |
| se-sandbox-account       | 616175625615 | sandbox           |
| se-dev-account           | 836163781281 | dev               |
| se-staging-account       | 577994762406 | staging           |
| se-prod-account          | 636307651596 | prod              |
| se-test-account          | 502057002395 | test              |
| se-demo-account          | 865240589816 | demo              |

# se-{ENV}-account
> NOTE: ENV is the name of the environment; e.g. `integration` for `se-integration-account`

## S3

| Bucket name                     | Properites          |
| ------------------------------- | ------------------- |
| schedule-engine-terraform-{ENV} | Versioning: enabled |

## Dynamo DB

| Table name           | Partition key     |
| -------------------- | ----------------- |
| terraform_state_lock | `LockID` (String) |

## IAM Groups

| Group name | Policies                 |
| ---------- | ------------------------ |
| Terraform  | TerraformPolicy (custom) |
| Pipelines  | PipelinesPolicy (custom) |

## IAM Users

| User name | Groups    |
| --------- | --------- |
| terraform | Terraform |
| pipelines | Pipelines |

## IAM Roles

| Role name     | Policies                 | Trusted entities      |
| ------------- | ------------------------ | --------------------- |
| TerraformRole | TerraformPolicy (custom) | Account: 528208453446 |
| PipelinesRole | PipelinesPolicy (custom) | Account: 528208453446 |

## IAM Policies

| Policy name     |
| --------------- |
| TerraformPolicy |
| PipelinesPolicy |

**TerraformPolicy**

```
{
    "Version": "2012-10-17",
    "Statement": []
}
```

**PipelinesPolicy**

```
{
    "Version": "2012-10-17",
    "Statement": []
}
```

# se-ecr-account

## S3

| Bucket name                   | Properites          |
| ----------------------------- | ------------------- |
| schedule-engine-terraform-ecr | Versioning: enabled |

## Dynamo DB

| Table name           | Partition key     |
| -------------------- | ----------------- |
| terraform_state_lock | `LockID` (String) |

## IAM Groups

| Group name | Policies                           |
| ---------- | ---------------------------------- |
| Terraform  | TerraformPolicy (custom)           |
| Pipelines  | AmazonEC2ContainerRegistryReadOnly |

## IAM Users

| User name | Groups    |
| --------- | --------- |
| terraform | Terraform |
| pipelines | Pipelines |

## IAM Roles

| Role name              | Policies                            | Trusted entities      |
| ---------------------- | ----------------------------------- | --------------------- |
| PipelinesPowerUserRole | AmazonEC2ContainerRegistryPowerUser | Account: 528208453446 |
| PipelinesReadOnlyRole  | AmazonEC2ContainerRegistryReadOnly  | Account: 528208453446 |
| TerraformRole          | TerraformPolicy (custom)            | Account: 528208453446 |

## IAM Policies

| Policy name     |
| --------------- |
| TerraformPolicy |

**TerraformPolicy**

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:CreateRepository",
                "ecr:DescribeRepositories"
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
                "arn:aws:s3:::schedule-engine-terraform-ecr",
                "arn:aws:s3:::schedule-engine-terraform-ecr/terraform.tfstate"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-east-1:302058597523:table/terraform_state_lock"
            ]
        }
    ]
}
```
