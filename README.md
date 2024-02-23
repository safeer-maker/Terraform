# Terraform

## [1-Aws-Cli-and-Terraform-Install](/docs/1-aws-cli-and-terraform-install.md)

### Terraform CLI Installation

- Check Linux version with "cat /etc/os-release".
- Follow platform-specific instructions from Terraform website.

### Bash Script Creation for Dependency Installation

- Create bash script in "bin" folder to install dependencies.
- Make script executable with "chmod +x ./bin/terradorm-cli".

### Gitpod Dependency Installation

- Adjust task workflows to address Gitpod dependency installation issues.

### Handling Environment Variables

- Export environment variables in a bin file.
- Use `source ./env.sh` to set envars.

### AWS CLI Setup

- Use provided bash script to set up AWS CLI.
- Ensure appropriate permissions with "chmod".

### Automated Dependency Installation

- Utilize "install-script.sh" to automate dependency installation.

# [3-Terraform-Basic](/docs/3-terraform-basic.md)

- Covered all the basic realted to terraform

## Random Terraform Provider
- Using 32-bit random string generation for unique S3 bucket names, ensuring global uniqueness.

### Terraform init:
Terraform init is an initimizing command after you write your module. It will download required dependensises or binaries of prvider and create files new files that used in the project.

### Terraform plan:
Terraform plan create a chainset about the state of infrastructure we are willing to create.

### Terraform apply:
Terraform apply will generate the plan and then apply that plan to create resources.

### Terraform Destroy;
To destroy all the resources Terraform has created either locally or on Cloud Providers

### S3 Bucket

- To create an S3 bucket using the AWS provider in a .tf file, utilize a random_string for the bucket name to ensure global uniqueness, while configuring the AWS CLI globally or passing configuration keys explicitly within the Terraform module.

### Terraform Cloud

- Used Terraform cloud for Inferacture creation and delation

### Alies of tf for terraform

- Decleared Alies in Linux for terrafrom and ablove commands for easy and convenience. 

## [5-Creating-Modules](/docs/5-creating-modules.md)

### Restructuring the Workspace

- Declare variable structure in **variables.tf** and store variable data in **terraform.tfvars**.
  
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

