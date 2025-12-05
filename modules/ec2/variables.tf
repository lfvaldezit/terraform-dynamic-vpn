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

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = list(string)
  default     = []
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script for the instance"
  type = string
  default = null
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

# variable "subnet_type" {
#     description = "Subnet type for the instance"
#     type = string
#     validation {
#         condition = contains(["public", "private"], var.subnet_type)
#         error_message = "subnet_type must be either public or private"
#     }
# }

variable "source_dest_check" {
  description = "Blocks traffic if the instance isn't the source or destination"
  type = string
}

variable "instance_count" {
  description = "Number of EC2 instances to be created"
  type = string
}

variable "enable_public_eni" {
  description = "Create public ENI"
  type = bool
}