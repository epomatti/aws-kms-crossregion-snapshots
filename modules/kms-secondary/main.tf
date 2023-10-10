provider "aws" {
  region = var.aws_secondary_region
  alias  = "secondary"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_account_id        = data.aws_caller_identity.current.account_id
  aws_region            = var.aws_secondary_region
  aws_account_principal = "arn:aws:iam::${local.aws_account_id}:root"
}

resource "aws_kms_key" "default" {
  description             = "Cross-region snapshots - Secondary"
  deletion_window_in_days = 7

  provider = aws.secondary
}

resource "aws_kms_alias" "default" {
  name          = "alias/region2key"
  target_key_id = aws_kms_key.default.key_id

  provider = aws.secondary
}

resource "aws_kms_key_policy" "default" {
  key_id   = aws_kms_key.default.id
  provider = aws.secondary

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EC2Project"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${local.aws_account_principal}"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}
