module "db" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    description = "SG for mysql db instance"
    common_tags = var.common_tags
    sg_name = "db"
    vpc_id = data.aws_ssm_parameter.ssm_vpc_info.value

}

module "backend" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    description = "SG for backend instance"
    common_tags = var.common_tags
    sg_name = "backend"
    vpc_id = data.aws_ssm_parameter.ssm_vpc_info.value

}
module "frontend" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    description = "SG for frontend instance"
    common_tags = var.common_tags
    sg_name = "frontend"
    vpc_id = data.aws_ssm_parameter.ssm_vpc_info.value

}
module "bastion" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    description = "SG for bastion instance"
    common_tags = var.common_tags
    sg_name = "bastion"
    vpc_id = data.aws_ssm_parameter.ssm_vpc_info.value

}
module "ansible" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    description = "SG for ansible instance"
    common_tags = var.common_tags
    sg_name = "ansible"
    vpc_id = data.aws_ssm_parameter.ssm_vpc_info.value

}
#inbound security group rules allowing traffic to db from backend
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    security_group_id = module.db.sg_id
    source_security_group_id = module.backend.sg_id # source is from where we're getting traffic
}

#inbound security group rules allowing traffic to db from bastion
resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    security_group_id = module.db.sg_id
    source_security_group_id = module.bastion.sg_id # source is from where we're getting traffic
}

#inbound security group rules allowing traffic to backend from frontend
resource "aws_security_group_rule" "backend_frontend" {
    type = "ingress"
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    security_group_id = module.backend.sg_id
    source_security_group_id = module.frontend.sg_id # source is from where we're getting traffic
}

#inbound security group rules allowing traffic to backend from bastion
resource "aws_security_group_rule" "backend_bastion" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.backend.sg_id
    source_security_group_id = module.bastion.sg_id # source is from where we're getting traffic
}

#inbound security group rules allowing traffic to backend from ansible
resource "aws_security_group_rule" "backend_ansible" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.backend.sg_id
    source_security_group_id = module.ansible.sg_id # source is from where we're getting traffic
}

#inbound security group rules allowing traffic to frontend from public
resource "aws_security_group_rule" "frontend_public" {
    type = "ingress"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    security_group_id = module.frontend.sg_id
    cidr_blocks = ["0.0.0.0/0"] # it is from where we're getting traffic
}

#inbound security group rules allowing traffic to frontend from bastion
resource "aws_security_group_rule" "frontend_bastion" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.bastion.sg_id  # it is from where we're getting traffic
}

#inbound security group rules allowing traffic to frontend from ansible
resource "aws_security_group_rule" "frontend_ansible" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.ansible.sg_id  # it is from where we're getting traffic
}

#inbound security group rules allowing traffic to bastion from public
resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.bastion.sg_id
    cidr_blocks = ["0.0.0.0/0"]  # it is from where we're getting traffic
}
#inbound security group rules allowing traffic to ansible from public
resource "aws_security_group_rule" "ansible_public" {
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_group_id = module.ansible.sg_id
    cidr_blocks = ["0.0.0.0/0"]  # it is from where we're getting traffic
}

