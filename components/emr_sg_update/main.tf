data "terraform_remote_state" "airflow" {
  backend = "s3"
  config {
    key    = "training_airflow.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "training_emr_cluster" {
  backend = "s3"
  config {
    key    = "training_emr_cluster.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

module "emr_sg_update" {
  source                       = "../../modules/emr_sg_update"
  airflow_security_group_id    = "${data.terraform_remote_state.airflow.airflow_security_group_id}"
  emr_shared_security_group_id = "${data.terraform_remote_state.training_emr_cluster.security_group_id}"
}