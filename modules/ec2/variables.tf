variable "ami_id" {
  description = "AMI ID for the instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for the instance"
  type = string
}

variable "security_group_ids" {
  description = "Security Group ID for the instance"
  type = set(string)
}

variable "name" {
  description = "Base name prefix used to label all created resources "
  type = string
}

variable "subnet_id" {
  description = "subnet IDs where EC2 instance will be deployed"
  type = string
}

variable "public_subnet_id" {
  description = "Public subnet ID (required when subnet_type is 'public')"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script for the instance"
  type = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "subnet_type" {
    description = "Subnet type for the instance"
    type = string
    validation {
        condition = contains(["public", "private"], var.subnet_type)
        error_message = "subnet_type must be either public or private"
    }
}