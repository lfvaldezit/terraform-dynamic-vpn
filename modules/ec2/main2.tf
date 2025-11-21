# resource "aws_iam_instance_profile" "this" {
#   name = "${var.name}-ec2-inst-profile"
#   role = aws_iam_role.this.name
# }

# resource "aws_iam_role" "this" {
#   name               = "${var.name}-ec2-role"
#   assume_role_policy = <<EOF
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "ec2.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole",
#         "Condition": {}
#         }
#     ]
#     }
# EOF    
# }

# resource "aws_iam_role_policy_attachment" "ec2-role-ssm-instance-core" {
#   role       = aws_iam_role.this.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_instance" "server" {
#     depends_on = [ aws_iam_instance_profile.this ]
#     ami = var.ami_id
#     instance_type = var.instance_type
#     iam_instance_profile = aws_iam_instance_profile.this.name
#     user_data = var.user_data

#     primary_network_interface {
#       network_interface_id = aws_network_interface.eni-0.id
#     }

#     metadata_options {
#       http_endpoint = "enabled"
#       http_tokens = "optional"
#     }
    
#     lifecycle {
#       ignore_changes = [source_dest_check]
#     }
    
#     tags = merge({Name = "${var.name}"}, var.common_tags)
# }

# resource "aws_instance" "router" {
#     depends_on = [ aws_iam_instance_profile.this ]
#     ami = var.ami_id
#     instance_type = var.instance_type
#     iam_instance_profile = aws_iam_instance_profile.this.name
#     user_data = var.user_data

#     primary_network_interface {
#       network_interface_id = aws_network_interface.eni-0.id
#     }

#     metadata_options {
#       http_endpoint = "enabled"
#       http_tokens = "optional"
#     }
    
#     lifecycle {
#       ignore_changes = [source_dest_check]
#     }
    
#     tags = merge({Name = "${var.name}"}, var.common_tags)
# }