# Table of Content

# Restructuring the worksapce

The statndard structure of module is provided in this [Terraform Documentation](https://developer.hashicorp.com/terraform/language/modules/develop/structure). So lets restructure this workspace according to Standard Module Structure.

The best structure I can found that include variables file as well is 
~~~ bash
Module
├── main.tf         # Working file
|── variables.tf    # Declare Variable Structure
├── terraform.tfvars# Store Variable data
├── LICENSE         # Licence file
├── outputs.tf      # Output return files
└── README.md       # documentation file
~~~

### Variable.tf and terraform.tfvars

You can declare the structure of your variables in **variables.tf**. It contain the variable structure and if neede the validation check as well. [Link](https://developer.hashicorp.com/terraform/language/values/variables)

After defining the variable we can pass those variable to `tf plan` or `tf apply` using `-var` flag

```bash
tf plan  -var="VARIABLE_NAME=VARIABLE_VALUE"

tf apply -var="VARIABLE_NAME=VARIABLE_VALUE"
```

To store the values in the file, Its best to store in `terraform.tfvars`. This store the value for auto reload in in *plan* and *apply* phases. [Link](https://developer.hashicorp.com/terraform/language/values/variables)

## Sub module

The structure of sub module is most like the root module it self. [link](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

```bash
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```

Root module can call multiple sub modules. The source of sub module can be local system or online storage. Check [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources#local-paths) to get more detials on that.

[Created a sub module of S3 bucket.](/modules/web_bucket/)

#### Output of sub Module

Getting output from a sub module is bit of a tricky part. In sub module if you have defiend your bucket 
``` go
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.web_bucket_name

  tags = {
    Name        = var.team
    Environment = var.environment
  }
}
```
The output of this submodule will be writen like
```go
output "bucket_name" {
  value = aws_s3_bucket.web_bucket.bucket
}
```
But at root module the output will modefied as
``` go
output "bucket_name" {
  value = module.web_bucket.bucket_name
}
```
### Static webesite Hosting

S3 supports static website hosting. To host your web site you need to use [`aws_s3_bucket_website_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) resource to create it.

``` go
resource "aws_s3_bucket_website_configuration" "s3_static_website" {
  bucket = var.web_bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```
### Uplaod index.html
It is not recomended to manage file using terraform. Derafrom is designe to manage your inferacture not for file management.

I despite that I have used `aws_s3_object` to uplad the file for personal reasons. 

``` go
resource "aws_s3_object" "s3_upload_index" {
  bucket = var.web_bucket_name
  key    = "index.html"
  source = "temp/index.html"
  content_type = "text/html"
  etag = filemd5("temp/index.html")
}
```
It worked but did not worked very well. 
> If your inferacture is teardown or destroyed. Then running `tf apply` will create the bucket but through an error of not able to upload the object. this is because of latency to create and s3 bucket. So the files are not been uploaded on first apply. If you run the `tf apply` the file will be uploaded with out a hitch. 
** Same goes for `tf destroy`**

You can use `aws s3` commands ot upload and delete the obects after applying or before destroying the bucked using tf.

``` bash
# copy object to bucket
aws s3 cp test.txt s3://mybucket/test2.txt

# delete object to bucket
aws s3 rm s3://mybucket/test2.txt
```

If you use below code where we are passing resource insted of variable, its work on the go

``` go
resource "aws_s3_object" "s3_upload_index" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "index.html"
  source = "temp/index.html"
  content_type = "text/html"
  etag = filemd5("temp/index.html")
}
```



https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

data sources (https://developer.hashicorp.com/terraform/language/data-sources)

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity


Creating CDN is a mess

### Creating CDN 

Terraform supports cloudfornt as well as cloudflare.

**Its worth mentioning [Coludfare](https://www.cloudflare.com). It is an extradonary CDN service provider with numerous edge location through out the glob.**

#### Clicks OPS
For the socpe of this porject we are using cloudfront. Its best to perform CLickOPS to get better idea how to host [S3 static website using CLoudFront](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/getting-started-cloudfront-overview.html).

The major operations includes.
 - Creating S3 bucket
 - Upload index.html (Can be any html file)
 - Enable static website hosting in S3 properties.
 - NOT MAKE BUCKET PUBLIC
 - Create a Cloudfront CDN form s3 bucket.
 - Copy S3 bucket policy form CloudFront and past into s3 bucket policies
 - Create ACL (CloudFront ==> Security ==> Origin access)

#### CloudFront using Terraform 

To create CDN using Tf [`aws_cloudfront_distribution`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) is used. 

Remember to remove all unnecessory arguments from the module as it will take minimum of five minutes to spin up or down the distribution. 

The very next thing we needed is a OAC using [`aws_cloudfront_origin_access_control`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control). OAC provide the access of s3 to CloudFront.

Last thing to do is to add [s3 bucket policy for cloudfront](https://docs.aws.amazon.com/whitepapers/latest/secure-content-delivery-amazon-cloudfront/s3-origin-with-cloudfront.html). While modefing ploicy try not to fetch arn directecly into policy as variable. In my case it does not work well.

##### Data Sources

Tf provides [Data Sources](https://developer.hashicorp.com/terraform/language/data-sources) to get data from aws cloud. In this particular project I have used `aws_caller_identity` to get aws user id.
```go
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
```

> Data sources can be used to fetch different type of data like arn and userid from providers. Is especialy helpfull to avoid hardcode the data and fetch it realtime.

##### Local variables

Local varaibles can be used as a file specific but global variables. So the you dont need to define the variables multiple times, while maintaing there scope at file specific.

```go
locals {
  s3_origin_id = "MyS3Origin"
}
```

#### Terraform data lifecycle

Terraform support [lifecycle Meta-Argument] (https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes)

The purpose and need for data lifecycle is to only update the contnens on cloud when we want to. Before that enevy times we update or modefy the files `file5md` checks for content change and uplaod that file to cloud. But If in case of porduction server its sutable to push tested data.

```go
resource "aws_s3_object" "s3_upload_index" {
  bucket        = aws_s3_bucket.web_bucket.bucket
  key           = "index.html"
  source        = "temp/index.html"
  content_type  = "text/html"
  etag            = filemd5("temp/index.html")

  # lifecycle Meta-Argument
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
```
##### Terraform data module

[terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data) implements the standard resource lifecycle, but does not directly take any other actions. You can use the terraform_data resource without requiring or configuring a provider. It is always available through a built-in provider with the source address terraform.io/builtin/terraform

```go
variable "revision" {
  default = 1
}

resource "terraform_data" "replacement" {
  input = var.revision
}

# This resource has no convenient attribute which forces replacement,
# but can now be replaced by any change to the revision variable value.
resource "example_database" "test" {
  lifecycle {
    replace_triggered_by = [terraform_data.replacement]
  }
}
```

