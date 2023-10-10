locals {
  az = "us-east-2a"
}

resource "aws_ebs_volume" "default" {
  availability_zone = local.az
  size              = 40
  final_snapshot    = false

  encrypted  = true
  kms_key_id = var.kms_key_arn

  tags = {
    Name = "kms-encrypted-volume"
  }
}

resource "aws_ebs_snapshot" "snap1" {
  volume_id = aws_ebs_volume.default.id

  tags = {
    Name = "snap1"
  }
}
