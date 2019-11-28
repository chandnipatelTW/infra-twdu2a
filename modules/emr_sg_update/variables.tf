variable "airflow_security_group_id" {
  description = "Airflow security group Id"
}

variable "emr_shared_security_group_id" {
  description = "Id of airflow security group to allow Web HDFS ingress"
}
