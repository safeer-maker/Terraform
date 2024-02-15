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

