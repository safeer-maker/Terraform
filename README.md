# Terraform

## [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### [Check linux version](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Instruction to install terraform changes in each linux version.
```bash
cat /etc/os-release
```
> for Linux base system only

### [Creating Bash script and running commands](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

I need to create a bash script to install all dependensies including Terraform. The .gitpod.yml file may not work with all linux base systems.

The bash script is created under bin folder

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform
```

> Use Terraform website to fetch latest instruction for installing Terraform.



