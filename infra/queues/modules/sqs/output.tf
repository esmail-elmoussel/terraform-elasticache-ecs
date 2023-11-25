output "sqs_url" {
  description = "The URL for the created SQS"
  value       = aws_sqs_queue.test_queue.id
}
