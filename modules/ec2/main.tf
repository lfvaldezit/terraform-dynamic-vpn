resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ec2-inst-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-ec2-role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole",
        "Condition": {}
        }
    ]
    }
EOF    
}

resource "aws_iam_role_policy_attachment" "ec2-role-ssm-instance-core" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "this" {
    depends_on = [ aws_iam_instance_profile.this ]
    ami = var.ami_id
    instance_type = var.instance_type
    iam_instance_profile = aws_iam_instance_profile.this.name
    user_data = var.user_data

    primary_network_interface {
      network_interface_id = aws_network_interface.eni-0.id
    }

    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "optional"
    }
    
    lifecycle {
      ignore_changes = [source_dest_check]
    }
    
    tags = merge({Name = "${var.name}"}, var.common_tags)
}

resource "aws_network_interface_attachment" "this" {
  count                = var.subnet_type == "public" ? 1 : 0
  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.eni-1[0].id
  device_index         = 1
}

resource "aws_eip" "this" {
  count = var.subnet_type == "public" ? 1 : 0
  domain = "vpc"
  network_interface = aws_network_interface.eni-0.id
  depends_on = [aws_instance.this]
  tags = merge({Name = "${var.name}-eip"}, var.common_tags)
}

resource "aws_network_interface" "eni-0" {
  subnet_id   = var.public_subnet_id
  security_groups = var.security_group_ids
  source_dest_check = false
}

resource "aws_network_interface" "eni-1" {
  count = var.subnet_type == "public" ? 1 : 0
  subnet_id   = var.subnet_id
  security_groups = var.security_group_ids
  source_dest_check = false
}

# --------------- ec2 Instance Connect Endpoint ----------------- #

# resource "aws_ec2_instance_connect_endpoint" "this" {
#   subnet_id         = var.subnet_id
#   security_group_ids = var.security_group_ids
#   preserve_client_ip = false
#   tags = merge({Name = "${var.name}-eip-ec2-endpoint"}, var.common_tags)
# }