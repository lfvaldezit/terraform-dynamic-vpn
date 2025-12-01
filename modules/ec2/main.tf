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
  count = var.instance_count
  ami = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data = var.user_data
  tags = merge({Name = "${var.name}-${count.index + 1}"}, var.common_tags)

  primary_network_interface {
    network_interface_id = var.enable_public_eni ? aws_network_interface.public[count.index].id : aws_network_interface.private[count.index].id
  }

  lifecycle {
  ignore_changes = all
}

  depends_on = [ aws_network_interface.public, aws_network_interface.private]
}

resource "aws_network_interface" "public" {
  count = var.enable_public_eni ? var.instance_count : 0
  subnet_id = var.public_subnet_id[count.index % length(var.public_subnet_id)]
  security_groups = var.security_group_ids
  source_dest_check = var.source_dest_check
  tags = merge({Name = "${var.name}-eni-pub-${count.index + 1 }"}, var.common_tags)
}

resource "aws_network_interface" "private" {
  count = var.instance_count
  subnet_id = var.private_subnet_id[count.index % length(var.private_subnet_id)]
  security_groups = var.security_group_ids
  source_dest_check = var.source_dest_check
  tags = merge({Name = "${var.name}-eni-priv-${count.index + 1 }"}, var.common_tags)
}

resource "aws_network_interface_attachment" "this" {
  count = var.enable_public_eni ? var.instance_count : 0
  instance_id          = aws_instance.this[count.index].id
  network_interface_id = aws_network_interface.private[count.index].id
  device_index         = 1
}

resource "aws_eip" "this" {
  count = var.enable_public_eni ? var.instance_count : 0
  domain = "vpc"
  network_interface = aws_network_interface.public[count.index].id
  tags = merge({Name = "${var.name}-eip-${count.index + 1 }"}, var.common_tags)
  depends_on = [ aws_instance.this ]
}