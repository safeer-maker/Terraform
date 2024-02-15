# Table of Contents
- [3-Terraform-Basic](#3-terraform-basic)
  * [Random Terraform Provider](#-random-terraform-provider--https---registryterraformio-providers-hashicorp-random-latest-docs-)
    + [Terraform init:](#terraform-init-)
    + [Terraform plan:](#terraform-plan-)
    + [Terraform apply:](#terraform-apply-)
    + [Terraform Output:](#terraform-output-)
    + [Terraform Destroy;](#terraform-destroy-)
  * [S3 Bucket](#s3-bucket)
  * [Terraform Cloud](#terraform-cloud)
    + [Resolved tf Cloud Module Issue](#resolved-tf-cloud-module-issue)
  * [Alies of tf for terraform](#alies-of-tf-for-terraform)
      - [Terraform Not able to create resource](#terraform-not-able-to-create-resource)

# 3-Terraform-Basic

[**Terraform Registry**](https://registry.terraform.io)
 - [Providers](https://registry.terraform.io/browse/providers) contain the cloud providers like AWS, Azure and GCP etc. It provides api for IAC for specific cloud.
 - [Modules](https://registry.terraform.io/browse/modules) are the collection of IAC templats to comanly use actions. They are to make terraform code modular


## [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs) 

Using Random string genration to create a unique name of s3 bucket.
> [S3 bucket naming rules needed to follow for bucket creation.](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

We are using 32 bit random string so that s3 bucket will be globaly unique.

### Terraform init:
Terraform init is an initimizing command after you write your module. It will download required dependensises or binaries of prvider and create files new files that used in the project.
> terraform init

### Terraform plan:
Terraform plan create a chainset about the state of infrastructure we are willing to create.

### Terraform apply:
Terraform apply will generate the plan and then apply that plan to create resources.

> `terraform apply` its alsways ask to write yes to run the task. To automate it pass the flag `--auto-approve`

```bash 
# terraform command to apply
terraform apply

# to include auto approve
terraform apply --auto-approve
```

### Terraform Output:
Prompt the output of the resource created by terraform

```bash
# resource created my prvious command "random_bucket_name"
terraform output random_bucket_name
```

### Terraform Destroy;
To destroy all the resources Terraform has created either locally or on Cloud Providers

```bash
terraform destroy
```

> Can use flag `--auto-approve`

## S3 Bucket

We can create an s3 bucket using AWS provider in .tf file.

[AWS S3 bucket doc link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

Use random_string bucket_name to create bucket name as S3 required unique name at global level.

If you have configure your AWS CLI at global level that it can run from any shell. Else we can explecitely pass the configuration keys to use with in terraform module.

```bash
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
```

But ***NOT*** to pass them in the form of global envars as terraform will detect them automatically.

```bash
provider "aws" {
  # Configuration options
    region     = "$AWS_DEFAULT_REGION"
    access_key = "$AWS_ACCESS_KEY_ID"
    secret_key = "$AWS_SECRET_ACCESS_KEY"
}
```
> Terraform first use aws config in .tf to congigure aws. If not found then use envars to configure them.

## Terraform Cloud

To deploy your inferacture state on to the clould create a project folowed be worksapce and add example code to your .tf file.

when you login into Terraform via cli command `terraform login`. The token is stored in the plain text at `/home/$USER/.terraform.d/credentials.tfrc.json`

The Terraform login commands sucks. You can also store this file using usign ChatGPT on same area mentioned above.

More over the structuer of the *.tfrc.json is
```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR TERRAFORM TOKEN"
    }
  }
}
```

> Its best if you have a copy of this json file at `/root/.terraform.d/credentials.tfrc.json` as well.

### Resolved tf Cloud Module Issue

When I created the project and workspace in terraform cloud. I get `cloud` module to intigrade into terraform block.

``` json 
terraform {

  cloud {
      organization = "safeerahmad"
      workspaces {
        name = "safeer-tf"
      }
  }
}
```
 [This integration may produce issue.](#terraform-not-able-to-create-resource)

To resolve this its best to set the variables in workspace on terraform cloud website.
![](/assets/var-app.terraform.io.png)

Add AWS keys as `Environment variable` be clicking `Add variables`
![](/assets/var2-app.terraform.io.png)
> Keep these variables private for security purposes. Make sure to select `Environment variable` each time when adding variables.

## Alies of tf for terraform

Writing terraform on every command is a hectic way to do it. Lets make an **Alies** of `terraform` to `tf`

If you does not have `~/.bash_aliases` file then create one. If exist then add below code in it.

```bash
alias tf="terraform"
```

After modefing this file add below command in `~/.bashrc` file

```bash
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
Then run `source ~/.bashrc` to implement then alias.

#### Terraform Not able to create resource

when running `tf plan` or `tf apply`/ Terraform was not able to complete plan and promt error. 
``` bash
Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/safeerahmad/safeer-tf/runs/run-FCv9vnYL7DGekMxR

Waiting for the plan to start...

Terraform v1.7.2
on linux_amd64
Initializing plugins and modules...
╷
│ Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 27, in provider "aws":
│   27: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found,
│ operation error ec2imds: GetMetadata, request canceled, context deadline
│ exceeded
│ 
╵
Operation failed: failed running terraform plan (exit 1)
```

I am able to get-caller-identity and also sucessfull in creating s3 bucket using cli command `aws s3api create-bucket --bucket safeer-cli-aws-bucket-143  --region us-east-1`

** Lets Try somting **

> [Resolved issue In above heading](#resolved-tf-cloud-module-issue)

