resource "aws_security_group_rule" "airflow_hdfs_namenode" {
  type                     = "ingress"
  security_group_id        = "${var.emr_shared_security_group_id}"
  source_security_group_id = "${var.airflow_security_group_id}"
  from_port                = 50070
  to_port                  = 50070
  protocol                 = "tcp"
  description              = "Hadoop HDFS NameNode: http://master-dns-name:50070/"
}
