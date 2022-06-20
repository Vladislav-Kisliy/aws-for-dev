output "sqs_queue_arn" {
  value       = aws_sqs_queue.sqs_queue.arn
  description = "The ARN of the SQS queue."
}

output "sqs_queue_id" {
  value       = aws_sqs_queue.sqs_queue.id
  description = "The URL for the created Amazon SQS queue."
}

output "sns_topic_arn" {
  value       = aws_sns_topic.sns_topic.arn
  description = "The ARN of the SNS topic."
}

output "ec2_ip" {
  value = ["${aws_instance.web_instances.*.public_ip}"]
  description = "EC2 public ip address"
}