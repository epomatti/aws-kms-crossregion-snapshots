resource "aws_ebs_volume" "default" {
  availability_zone = "us-east-2a"
  size              = 40
  final_snapshot    = false

  encrypted  = true
  kms_key_id = var.kms_key_arn

  tags = {
    Name = "kms-encrypted-volume"
  }
}
