resource "aws_rds_cluster" "default" {
  cluster_identifier     = "aurora-cluster-${var.workload}"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.04.0"
  database_name          = var.workload
  master_username        = "aurora"
  master_password        = "p4ssw0rd"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier          = "aurora-cluster-demo-1"
  publicly_accessible = true
  cluster_identifier  = aws_rds_cluster.default.id
  instance_class      = "db.t4g.medium"
  engine              = aws_rds_cluster.default.engine
  engine_version      = aws_rds_cluster.default.engine_version
}

resource "aws_db_subnet_group" "default" {
  name       = var.workload
  subnet_ids = var.subnets
}

resource "aws_security_group" "default" {
  name        = "rds-${var.workload}"
  description = "Allow TLS inbound traffic to RDS Aurora"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-rds-${var.workload}"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
