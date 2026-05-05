#variable for aws region 
variable "aws_region" {
  type        = string
  description = "aws region variable"
  default     = "us-east-1"
}

#variable for  a list of public subnet cidr's for rke servers
variable "public_subnet_cidr" {
  type        = list(string)
  description = "aws public subnet cidr block"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

#variable for the vpc ip address that will be used
variable "vpc_cidr" {
  type        = string
  description = "aws vpc address cidr block"
  default     = "10.0.0.0/16"
}

#variable for availability zones for the region used and to spread amongst servers
variable "availability_zones" {
  type        = list(string)
  description = "availability zones for network"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

#variable for the server count 
variable "server_count" {
  type    = number
  default = 3
}

#variable for the worker node count
variable "agent_count" {
  type    = number
  default = 3
}

#volume size for each server
variable "volume_size" {
  type    = number
  default = 80
}

#variable for a default prefix for each instance
variable "name_prefix" {
  type    = string
  default = "rke2-test"
}

#allowed cidrs for ingress blocks in security groups
variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
