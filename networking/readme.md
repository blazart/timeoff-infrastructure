# networking module

Terraform module to deploy network resources

* VPC
* SUBNETS (Public / Private)
* ROUTE TABLE (Public / Private)
* EIP
* Internet Gateway
* Nat Gateway


## Usage


```
module "networking" {
  source = "./networking"
  aws_account_id = ""
  env = ""
  app_name = ""
}
```

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.8.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name | Name of application you want to deploy (It is going to be used for name of resources and tags) | `string` | `""` | yes |
| env | Name of environment you are deploying (Ex: dev,qa,prod)  | `string` | `"` | yes |
| app_region | Region to create resources | `string` |    `"us-east-1"`| no |
| zones_number | How many availability zones you want to use | `number` |    `2`| no |
| aws_account_id | Account to create resources | `string` |    `""`| yes |



## Outputs

| Name | Description |
|------|-------------|
| vpc_id | created VPC id |
| private_subnets | Complete list of object of private subnets (It can be use as input of application module) |
| public_subnets | Complete list of object of public subnets (It can be use as input of application module) |
