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

> `terraform apply` its alsways ask to write yes to run the task. To automate it pass the flag `--auto-approve'

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






