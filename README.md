# Terraform Documentation

## [1-Aws-Cli-and-Terraform-Install](/docs/1-aws-cli-and-terraform-install.md)

### Terraform CLI Installation

- Verify Linux version with "cat /etc/os-release".
- Follow platform-specific instructions from the Terraform website.

### Bash Script Creation for Dependency Installation

- Create a bash script in the "bin" folder to install dependencies.
- Ensure the script is executable with "chmod +x ./bin/terradorm-cli".

### Gitpod Dependency Installation

- Adjust task workflows to address Gitpod dependency installation issues.

### Handling Environment Variables

- Export environment variables in a bin file.
- Utilize `source ./env.sh` to set environment variables.

### AWS CLI Setup

- Utilize the provided bash script to set up AWS CLI.
- Ensure appropriate permissions with "chmod".

### Automated Dependency Installation

- Utilize "install-script.sh" to automate dependency installation.

## [3-Terraform-Basic](/docs/3-terraform-basic.md)

### Random Terraform Provider

- Implement 32-bit random string generation for unique S3 bucket names, ensuring global uniqueness.

#### Terraform init:

- Initialize Terraform after writing the module to download required dependencies or binaries and create necessary files.

#### Terraform plan:

- Generate a chainset about the state of infrastructure to be created.

#### Terraform apply:

- Apply the generated plan to create resources.

#### Terraform Destroy:

- Destroy all resources created by Terraform, either locally or on cloud providers.

### S3 Bucket

- Create an S3 bucket using the AWS provider in a .tf file.
- Utilize a random_string for the bucket name to ensure global uniqueness.
- Configure the AWS CLI globally or pass configuration keys explicitly within the Terraform module.

### Terraform Cloud

- Use Terraform cloud for infrastructure creation and deletion.

### Alias of tf for Terraform

- Declare aliases in Linux for Terraform and related commands for easy and convenience.

## [5-Creating-Modules](/docs/5-creating-modules.md)

### Restructuring the Workspace

- Declare the variable structure in **variables.tf** and store variable data in **terraform.tfvars**.

#### Submodule

- The structure of a submodule is similar to the root module itself.

#### Static Website Hosting

- Utilize AWS S3 bucket with static website hosting enabled.

#### Upload index.html

- Upload the index.html file to the S3 bucket.

#### Creating CDN

##### Clicks OPS

- Perform ClickOPS to set up S3 static website hosting with CloudFront.

##### CloudFront using Terraform

- Use Terraform to create CloudFront distribution.

##### Terraform Data Lifecycle

- Implement Terraform data lifecycle to control resource updates.

##### CloudFront Cash Invalidation

- Use Terraform provisioners to perform CloudFront cache invalidation.


## GitOPS

Gitops is the method to implement/modefy your IAC when you either commit something.

More throught approch is to use main branch for Version control apply. As anyone merge pull request to your project. Your infrastructure get updated for those changes as well.


