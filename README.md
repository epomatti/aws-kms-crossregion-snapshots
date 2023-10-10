# AWS KMS cross-region snapshots

Cross-region snapshots for RDS and EBS using KMS encryption.

```sh
terraform init
terraform apply -auto-approve
```

A snapshot of the volume will be already be created by Terraform and encrypted with the primary region KMS key.

To created a copy of the snapshot to the secondary region, run the copy command selecting the KMS key on the secondary region.

```sh
aws ec2 copy-snapshot \
	  --region sa-east-1 \
    --source-region us-east-2 \
    --source-snapshot-id snap-00000000000000000 \
    --encrypted \
    --kms-key-id '000000000000000000000000000000000000'
```
