# Table of contents

- [1-Aws-Cli-and-Terraform-Install](#1-aws-cli-and-terraform-install)
  * [Install Terraform CLI](#-install-terraform-cli--https---developerhashicorpcom-terraform-tutorials-aws-get-started-install-cli-)
    + [Check linux version](#-check-linux-version--https---wwwcybercitibiz-faq-how-to-check-os-version-in-linux-command-line--)
    + [Creating Bash script and running commands](#-creating-bash-script-and-running-commands--https---developerhashicorpcom-terraform-tutorials-aws-get-started-install-cli-)
    + [Make script Executable](#-make-script-executable--https---wwwgeeksforgeeksorg-chmod-command-linux--)
    + [Install dependencies on very Gitpod Restart](#-install-dependencies-on-very-gitpod-restart--https---wwwgitpodio-docs-configure-workspaces-tasks-)
  * [Lets work with environment variable.](#initial-setup-of-dependensies-and-environment-variable)
  * [AWS CLI](#aws-cli)
    + [RUN AWS-CLI in install-script.sh](#run--aws-cli---bin-aws-cli--in--install-scriptsh---install-scriptsh-)


# 1-Aws-Cli-and-Terraform-Install

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

### [Make script Executable](https://www.geeksforgeeks.org/chmod-command-linux/)

Now to make this script executable I need to add permissions.
CHMOD is the command to make bash file executable in linux.

``` bash
chmod +x ./bin/terradorm-cli 
```

After making the script executable add it to .yml file for auto installation.

### [Install dependencies on very Gitpod Restart](https://www.gitpod.io/docs/configure/workspaces/tasks)

Gitpod is not installing the dependencies on every restart of the machine.

The cause was Gitpod's task workflow failing to install the dependencies. Please read the documentation to get a better idea of how restarting Gitpod can install dependencies.

I have to change the **init:** tasks to **before:** tasks. This recommendation will install Terraform dependencies with every restart.


## Lets work with environment variable.

In previous work I have learned that Enviranmnet variable (envar) cause lots of issue. 

> Sample envar variable are listed in .env.exapmle. Fetch those variables from required sources and add to /bin/environment-var

Lets create a bin file to export the envar in the program.

As we are using Linux Ubuntu Distro for over project. The envar can be set in terminal as

```bash
export ENVIRONMENT_VARIABLE = "sample-key"
```
> This method can set only termianl and sub terminal level envar variable.

[To select the envar at all bash terminals you can follow this link.](https://www.hostinger.com/tutorials/linux-environment-variables?ppc_campaign=google_search_generic_hosting_all&bidkw=defaultkeyword&lo=9076951&gad_source=1&gclid=EAIaIQobChMI7tO4kviPhAMVrWZBAh0QsQyyEAAYASAAEgKDdfD_BwE)

### Initial setup of Dependensies and Environment Variable

Visual studio code does not setup the envar on it own. If you want to setup you envar and dependonsies you have to edit Preferences in JSON to do it. but this method does not work on multiple development setups. So it better to create an ***install-script.sh*** to load all envar and install depondensies on host system.

```bash
# Run command to install dependensies
sudo ./install-script.sh
```

> Install-script.sh is not able to export envars. So I created a seperate bash script. env.sh will load all the envars but needed to be called seperately on the terminal 

```bash
source ./env.sh
```

## AWS CLI

[aws-cli](/bin/aws-cli) bash script is created to install the AWS CLI. [Reference link to install aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

The work flow I have used for bash script requires to add [AWS ENVARS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) first in env.sh script. Sample AWS variables are in [.env.example](env.example)

> Once you set the variables. Run the [aws-cli](/bin/aws-cli) to setup AWS CLI

```bash
source ./bin/aws-cli
```

> **OUTPUT must results**
```bash
{
    "UserId": "AIFFSSUHC*******",
    "Account": "12345678912",
    "Arn": "arn:aws:iam::12345678912:user/temp-user-terraform"
}
```

### RUN [AWS-CLI](/bin/aws-cli) in [install-script.sh](/install-script.sh)

[install-script.sh](/install-script.sh) is not working right now!!!!

**WELL IT WORKED**

The [aws-cli](/bin/aws-cli) and [terraform-cli](/bin/terradorm-cli) needs higher permission to run. You can grant those permission using chmod. use below commands to give these permission

```bash
chmod 774 /bin/aws-cli
chmod 774 /bin/erradorm-cli
```

> After permission the [install-scrip.sh](/install-script.sh) worked fine.


