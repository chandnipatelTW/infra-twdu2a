resource "aws_route53_record" "kafka" {
  zone_id = "${var.dns_zone_id}"
  name    = "kafka"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.kafka.private_dns}"]
}

resource "aws_route53_record" "kafka_cluster" {
  count = "${var.kafka_nodes_count}"
  zone_id = "${var.dns_zone_id}"
  name    = "kafka-${count.index + 1}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_instance.kafka_cluster.*.private_dns[count.index]}"]
}
