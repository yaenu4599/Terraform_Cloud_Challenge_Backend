# Lambda execution role (created manually)

| File | Attach as | Purpose |
|---|---|---|
| `trust-policy.json` | Trust relationship | Lets the Lambda service assume the role |
| `permissions-policy.json` | Inline / customer managed policy | What the function may do once it has the role |

Replace `<ACCOUNT_ID>` locally before using the files. Don't commit the real value.

## Create with the AWS CLI

```bash
aws iam create-role \
  --role-name dev-visitor-counter-role \
  --assume-role-policy-document file://trust-policy.json

aws iam put-role-policy \
  --role-name dev-visitor-counter-role \
  --policy-name dev-visitor-counter-permissions \
  --policy-document file://permissions-policy.json

# copy the Arn into the GitHub secret LAMBDA_EXECUTION_ROLE_ARN
aws iam get-role --role-name dev-visitor-counter-role --query Role.Arn --output text
```

## GitHub OIDC role

Terraform attaches this role to the Lambda, so the deploy role needs `iam:PassRole` for it.
That permission is in [deploy-policy.json](deploy-policy.json), together with the permissions to manage the function itself.
