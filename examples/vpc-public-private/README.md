# VPC - public / private subnets

This example shows the basic usages of the module.
- Public / Private subnets.
- VPC endpoint for S3.

## Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`

## Run the example

Just run the default terraform commands.


### Setup

```
terraform init
```

### Plan the changes and inspect

```
terraform plan
```

### Create the environment.

```
terraform apply
```

Once done you can test the service via the URL on the console. It can take a few minutes before the service is available


### Cleanup

```
terraform destroy
```

