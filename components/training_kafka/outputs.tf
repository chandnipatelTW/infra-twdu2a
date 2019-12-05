output "kafka_address" {
  description = "The DNS address of the Kafka node."
  value       = "${module.training_kafka.kafka_address}"
}

output "kafka_security_group_id" {
  description = "Security group of Kafka instance."
  value       = "${module.training_kafka.kafka_security_group_id}"
}

output "kafka_instance_id" {
  description = "The instance id."
  value       = "${module.training_kafka.kafka_instance_id}"
}


output "kafka_cluster_instance_ids" {
  description = "The instance ids of nodes in the kafka cluster."
  value       = ["${module.training_kafka.kafka_cluster_instance_ids}"]
}


