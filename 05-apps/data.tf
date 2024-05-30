data "aws_ssm_parameter" "backend_sg_id" {
    name = "/${var.project_name}/${var.environment}/backend_sg_id"
}

data "aws_ssm_parameter" "frontend_sg_id" {
    name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "ansible_sg_id" {
    name = "/${var.project_name}/${var.environment}/ansible_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}
data "aws_ami" "ami_info" {
    most_recent = true
    owners = ["973714476881"]

    filter {
      name = "name" #asking to filter with its name here
      values =["RHEL-9-DevOps-Practice"] #mentioning with the name value of the ami queried
    }
    /* filter {
      name = "root-device-type"
      values = ["ebs"] #though the value is shown as EBS in aws, terraform accepts and caompares with 'ebs' while querying.
    } */
    
}