output "ebs_snapshot_id" {
  value = module.ebs.snapshot_id
}

output "kms_secondary_key_arn" {
  value = module.kms_secondary.kms_key_arn
}
