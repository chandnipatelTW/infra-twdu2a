resource "aws_instance" "kafka" {
  ami                    = "ami-0ba7e6a2b438daa1c"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.kafka.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.kafka.name}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka-${var.deployment_identifier}"
    )
  )}"
}

resource "aws_instance" "kafka_cluster" {
  count = "${var.kafka_nodes_count}"
  ami                    = "${data.aws_ami.training_kafka.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.kafka.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.kafka.name}"
  user_data = "${element(data.template_cloudinit_config.kafka.*.rendered, count.index)}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 200
    delete_on_termination = false
  }

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "kafka-${count.index + 1}-${var.deployment_identifier}"
    )
  )}"
}

