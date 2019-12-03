resource "aws_security_group" "kafka" {

  name        = "kafka-${var.deployment_identifier}"
  description = "Security group for Kafka"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  source_security_group_id = "${var.bastion_security_group_id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "SSH from Bastion to Kafka"
}

resource "aws_security_group_rule" "kafka_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.kafka.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Unrestricted egress for Kafka"
}

resource "aws_security_group_rule" "kafka_emr_ingress_broker" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  source_security_group_id = "${var.emr_security_group_id}"
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  description              = "Kafka broker ingress for EMR cluster"
}

resource "aws_security_group_rule" "kafka_emr_ingress_zookeeper" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  source_security_group_id = "${var.emr_security_group_id}"
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  description              = "Zookeeper ingress for EMR cluster"
}

resource "aws_security_group_rule" "kafka_cluster_ingress_zookeeper" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  self = true
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  description              = "Zookeeper ingress for communication within Kafka cluster"
}

resource "aws_security_group_rule" "kafka_cluster_ingress_kafka" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  self = true
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  description              = "Kafka ingress for communication within Kafka cluster"
}

resource "aws_security_group_rule" "kafka_cluster_ingress_zookeeper_internal" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  self = true
  from_port                = 2888
  to_port                  = 2888
  protocol                 = "tcp"
  description              = "Zookeeper internal ingress for zookeeper ensemble"
}

resource "aws_security_group_rule" "kafka_cluster_ingress_zookeeper_leader" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.kafka.id}"
  self = true
  from_port                = 3888
  to_port                  = 3888
  protocol                 = "tcp"
  description              = "Zookeeper internal ingress for leader election in zookeeper"
}
