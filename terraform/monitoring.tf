# =================
# --- SNS Topic ---
# =================
resource "aws_sns_topic" "devinfra_alerts" {
  name = "devinfra-alerts"
}

# ================================
# --- SNS Subscription (Gmail) ---
# ================================
# Subscribe a user’s email to the topic
resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.devinfra_alerts.arn
  protocol  = "email"
  endpoint  = var.alerts_email
}


# ==================================
# --- Alarm: Status Check Failed ---
# ==================================
# Alarm if EC2 instance fails status checks
resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  alarm_name          = "ec2-instance-status-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"

  dimensions = {
    InstanceId = aws_instance.devinfra_worker.id
  }

  alarm_actions = [aws_sns_topic.devinfra_alerts.arn]
  ok_actions    = [aws_sns_topic.devinfra_alerts.arn]
}

# =======================
# --- Alarm: High CPU ---
# =======================
# Alarm if CPU usage goes above 70%
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  alarm_description = "Alarm if CPU goes above 70%."
  dimensions = {
    InstanceId = aws_instance.devinfra_worker.id
  }

  alarm_actions = [aws_sns_topic.devinfra_alerts.arn]
  ok_actions    = [aws_sns_topic.devinfra_alerts.arn]
}
