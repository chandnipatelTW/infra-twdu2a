resource "aws_sns_topic" "alarm" {
  name = "2wheelers-alarms-topic-${var.cohort}"
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

resource "aws_cloudwatch_metric_alarm" "has_station_mart_updated" {
  alarm_name                = "2wheelers-delivery-file-check-${var.cohort}"
  comparison_operator       = "MoreThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "has_station_mart_updated"
  namespace                 = "TwoWheelers"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "5"
  alarm_description         = "This metric monitors for latest delivery file"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]

  dimensions {
    source = "airflow"
  }
}


resource "aws_cloudwatch_metric_alarm" "duplicate_station_id_count" {
  alarm_name                = "2wheelers-duplicate_station_id_count-${var.cohort}"
  comparison_operator       = "MoreThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "duplicate_station_id_count"
  namespace                 = "TwoWheelers"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "0"
  alarm_description         = "This metric monitors for duplicate station count"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]

  dimensions {
    source = "airflow"
  }
}


resource "aws_cloudwatch_metric_alarm" "null_latitude_longitude_count" {
  alarm_name                = "2wheelers-null_latitude_longitude_count-${var.cohort}"
  comparison_operator       = "MoreThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "null_latitude_longitude_count"
  namespace                 = "TwoWheelers"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "0"
  alarm_description         = "This metric monitors for duplicate station count"
  alarm_actions             = [ "${aws_sns_topic.alarm.arn}" ]

  dimensions {
    source = "airflow"
  }
}