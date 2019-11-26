resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "aws_db_instance" "airflow_postgres" {
  identifier = "training-airflow-${var.deployment_identifier}"

  allocated-storage      = "30"
  engine                 = "postgres"
  username               = "airflow"
  password               = "${random_password.password.result}"
  instance_class         = "${var.rds_instance_class}"
  vpc_security_group_ids = ["${aws_security_group.airflow_rds.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.airflow_postgres.name}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "training-airflow-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_ssm_parameter" "secret" {
  name        = "airflow-rds-password"
  description = "RDS password for airflow user"
  type        = "SecureString"
  value       = "${random_password.password.result}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "training-airflow-${var.deployment_identifier}"
      )
    )}"
}

resource "aws_db_subnet_group" "airflow_postgres" {
  name       = "training-airflow-${var.deployment_identifier}"
  subnet_ids = ["${var.subnet_ids}"]

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "training-airflow-${var.deployment_identifier}"
    )
  )}"
}
