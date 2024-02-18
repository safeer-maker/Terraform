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
