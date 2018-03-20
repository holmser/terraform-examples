# Terraform Examples

This repo is full of terraform template examples for different AWS services.  Some may be incomplete or broken.  Always run a `terraform plan`, and use at your own risk.  

## Getting Started
I highly recommend using [tfenv](https://github.com/kamatama41/tfenv).  It allows you to define a `.terraform-version` file in your repo, and the correct version of terraform will automatically be used to run the template.

### Mac 
```
# Install tfenv with homebrew
brew install tfenv

# Install latest version of Terraform
tfenv install latest

# Init repo (must be done per subfolder)
terraform init
```

## Terraform 101

Terraform allows you to declaratively define your infrastructure as code.  It is an excellent tool to ensure that your infrastructure can be built and removed in a repeatable manner.  It has a vibrant community and generally doesn't lag too far behind the AWS APIs. With great power comes great responsibility.  It is possible to create or destroy an entire infrastructure with 1 command.  Always run a `plan` before you `apply`.

Terraform will take all of the .tf files in a directory and smash them together into 1 single template, then attempt to apply it.  

```
# Planning run to view changes
terraform plan

# Apply will actually create the infrastructure
terraform apply

# Plan the destruction
terraform plan -destroy

# Kill it with fire
terraform destroy
```
