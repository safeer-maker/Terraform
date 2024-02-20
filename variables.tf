
variable "team" {
    type = string
    description = "Name of the team"  
}

variable "environment" {
    type = string
    description = "OS type for development"
}

variable "web_bucket_name" {
    type = string
    description = "Name of the bucket"
}

variable "content_version" {
    type = number
    description = "Version of the content"
}
