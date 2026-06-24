# basic-api

Beginner-friendly monorepo for a TypeScript AWS Lambda behind API Gateway, provisioned with Terraform.

## What This Project Does

- Builds a TypeScript Lambda at `apps/hello`
- Provisions infrastructure with Terraform under `infra/terraform`
- Creates:
  - 1 Lambda function (`basic-api-hello-dev`)
  - 1 HTTP API Gateway (`basic-api-dev`)
  - 1 route (`GET /hello`)

## Current Protection

- Strict API Gateway throttling is enabled.
- Lambda reserved concurrency is currently unreserved (`-1`) due account limits; you can set it when your account allows lower unreserved capacity.

## Project Structure

```text
apps/hello/                         # Lambda source + build output
infra/terraform/modules/            # Reusable Terraform modules
infra/terraform/envs/dev/           # Dev environment composition
package.json                        # Root scripts
```

## Prerequisites

- Node.js + npm
- AWS CLI v2
- Terraform >= 1.6
- AWS credentials configured (profile you want to deploy with)

## Quick Start (Current Account)

1. Clone and install:

```powershell
git clone <your-repo-url>
cd basic-api
npm install
```

2. Select AWS profile for this shell:

```powershell
$env:AWS_PROFILE="default"
```

3. Optional: set region default for your AWS profile:

```powershell
aws configure set region eu-central-1 --profile default
```

4. Build Lambda package:

```powershell
npm run build:hello
```

5. Initialize Terraform:

```powershell
npm run infra:init
```

6. Preview infrastructure changes:

```powershell
npm run infra:plan
```

7. Deploy:

```powershell
npm run infra:apply
```

8. Get endpoint URL:

```powershell
npm run infra:show:hello
```

9. Test endpoint:

```powershell
Invoke-RestMethod -Uri "$(terraform -chdir=infra/terraform/envs/dev output -raw hello_url)" -Method Get
```

## Deploy To Another AWS Account

Yes, you can clone this repo and deploy to another account.

1. Configure credentials for the other account:

```powershell
aws configure --profile other-account
$env:AWS_PROFILE="other-account"
```

2. Choose region:

Option A: Update `infra/terraform/envs/dev/terraform.tfvars`

```hcl
aws_deployment_region = "eu-central-1"
```

Option B: Override on command line (without editing files):

```powershell
terraform -chdir=infra/terraform/envs/dev plan -var="aws_deployment_region=eu-central-1"
terraform -chdir=infra/terraform/envs/dev apply -var="aws_deployment_region=eu-central-1"
```

3. Build and deploy:

```powershell
npm install
npm run build:hello
npm run infra:init
npm run infra:apply
```

## If You Need To Move Regions

If resources already exist in another region/account, destroy in the old region first, then apply in the new one.

Example:

```powershell
terraform -chdir=infra/terraform/envs/dev destroy -var="aws_deployment_region=eu-west-1"
terraform -chdir=infra/terraform/envs/dev apply -var="aws_deployment_region=eu-central-1"
```

## Helpful Scripts

- `npm run build:hello` - Build and zip Lambda
- `npm run infra:init` - Terraform init
- `npm run infra:plan` - Terraform dry-run
- `npm run infra:apply` - Create/update resources
- `npm run infra:destroy` - Delete resources
- `npm run infra:output:hello` - Raw hello URL
- `npm run infra:show:hello` - Labeled hello URL
- `npm run help:scripts` - Print script help

## Cleanup (Avoid Ongoing Cost)

When done, destroy resources:

```powershell
npm run infra:destroy
```

## Notes

- Terraform state is local in this starter (`infra/terraform/envs/dev/terraform.tfstate`).
- Local state files are git-ignored and should never be committed.
- For team usage, use a remote Terraform backend (S3 + DynamoDB lock).
