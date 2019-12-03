data "template_file" "init" {
  template = "${file("${path.module}/userdata/configure_kafka.sh")}"
  count = "${var.kafka_nodes_count}"
  vars = {
    index = "${count.index + 1}"
    cohort = "${var.cohort}"
  }
}

data "template_cloudinit_config" "kafka" {
  count = "${var.kafka_nodes_count}"
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${element(data.template_file.init.*.rendered, count.index)}"
  }
}