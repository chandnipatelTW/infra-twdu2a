resource "aws_sns_topic" "alarm" {
  name = "2wheelers-alarms-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}

resource "aws_cloudwatch_metric_alarm" "delivery_file_check" {
  alarm_name                = "2wheelers-delivery-file-check"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "delivery_file"
  namespace                 = "TwoWheelers"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors for latest delivery file"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]

  dimensions {
    source = "airflow"
  }
}