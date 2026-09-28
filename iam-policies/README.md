# IAM policies (created manually)

There are two kinds of roles in this project:

| Role | Assumed by | Used for |
|---|---|---|
| **Deploy role** | GitHub Actions (OIDC) | Running `terraform plan/apply/destroy` |
| **Lambda execution role** | The Lambda service | What the visitor counter code may do at runtime |

S3, CloudFront, DynamoDB and API Gateway don't run code, so they don't need runtime roles.
- CloudFront reads S3 through the bucket policy (OAC).
- API Gateway may invoke the Lambda because of `aws_lambda_permission`.

Both of those are resource-based policies that Terraform creates.

## Folder layout

| File | Attach to |
|---|---|
| `github-actions/trust-policy.json` | Deploy role: trust relationship |
| `backend/state-policy.json` | Deploy role |
| `s3/deploy-policy.json` | Deploy role |
| `cloudfront/deploy-policy.json` (incl. ACM + Route 53) | Deploy role |
| `dynamodb/deploy-policy.json` | Deploy role |
| `api_gateway/deploy-policy.json` | Deploy role |
| `lambda/deploy-policy.json` (incl. `iam:PassRole`) | Deploy role |
| `lambda/trust-policy.json` | Lambda role: trust relationship |
| `lambda/permissions-policy.json` | Lambda role |

## Placeholders

Replace these locally and don't commit the real values:

| Placeholder | Where to find it |
|---|---|
| `<ACCOUNT_ID>` | `aws sts get-caller-identity --query Account --output text` |
| `<BACKEND_BUCKET_NAME>` | GitHub secret `BUCKET_BACKEND` |
| `<MAIN_BUCKET_NAME>` | GitHub variable `BUCKET_MAIN` |
| `<HOSTED_ZONE_ID>` | `aws route53 list-hosted-zones-by-name --dns-name resume-challange-yannik-hofer.com` |

## Create the deploy role

Requires the GitHub OIDC provider (`token.actions.githubusercontent.com`, audience `sts.amazonaws.com`) to already exist in IAM.

```bash
aws iam create-role \
  --role-name github-actions-resume-deploy \
  --assume-role-policy-document file://github-actions/trust-policy.json

for p in backend/state s3/deploy cloudfront/deploy dynamodb/deploy api_gateway/deploy lambda/deploy; do
  name="resume-$(echo "$p" | tr '/_' '--')"
  arn=$(aws iam create-policy --policy-name "$name" \
    --policy-document "file://$p-policy.json" --query Policy.Arn --output text)
  aws iam attach-role-policy --role-name github-actions-resume-deploy --policy-arn "$arn"
done
```

Then set the GitHub secret `AWS_OIDC_ROLE` to `github-actions-resume-deploy`.

For the Lambda role, see [lambda/README.md](lambda/README.md).
