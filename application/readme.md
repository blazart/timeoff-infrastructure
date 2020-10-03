# application module

Terraform module to deploy an application using the following resources

* ECS+Fargate
* ALB
* ECR
* Cloudfront


## Usage


```
module "application" {
  source = "./application"
  app_name = var.app
  env = var.env
  private_subnets = []
  public_subnets = []
  vpc_id = ""
}
```

In order to use this module you need to have previously created some network resources (VPC/SUBNETS) because module need it as inputs.

public subnets and private subnets have the following structure (A list of object). It could be an output from a terraform resource.
```
 list(object({
    id = string
    arn = string
  })) 
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
| private_subnets | List of objects with ID an ARN of private subnet resources | `list(object({id:string, arn:string}))` |    `[]`| yes |
| public_subnets | List of objects with ID an ARN of public subnet resources  | `list(object({id:string, arn:string}))` |    `[]`| yes |
| vpc_id | VPC where resources are going to be associated | `string` |    `""`| yes |
| app_cpu | CPU to assign to each fargate task | `string` |    `"256"`| no |
| app_memory | Memory to assign to each fargate task | `string` |    `"512"`| no |
| app_port | Port exposed by container | `number` |    `3000`| no |
| min_capacity | Min number of task running of the service | `number` |    `1`| no |
| max_capacity | Max number of task running of the service | `number` |    `4`| no |
| app_count | How many tasks of service are going to be deployed | `number` |    `2`| no |
| app_region | Region to create resources | `string` |    `"us-east-1"`| no |


## Outputs

This module doesn't produce any output

| Name | Description |
|------|-------------|
| cloudfront_url | Cloudfront url to load application from browser |
