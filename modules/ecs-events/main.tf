resource "aws_sns_topic" "ecs_events" {
  name = "ecs-events-${var.cluster}"
}

data "aws_caller_identity" "current" {}

data "template_file" "ecs_task_stopped" {
  template = <<EOF
{
  "source": ["aws.ecs"],
  "detail-type": ["ECS Task State Change"],
  "detail": {
    "clusterArn": ["arn:aws:ecs:$${aws_region}:$${account_id}:cluster/$${cluster}"],
    "lastStatus": ["STOPPED"],
    "stoppedReason": ["Essential container in task exited"]
  }
}
EOF

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
    cluster    = "${var.cluster}"
    aws_region = "${var.region}"
  }
}

resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
  name          = "${var.cluster}-task-stopped"
  description   = "${var.cluster} Essential container in task exited"
  event_pattern = "${data.template_file.ecs_task_stopped.rendered}"
}

resource "aws_cloudwatch_event_target" "event_fired" {
  rule  = "${aws_cloudwatch_event_rule.ecs_task_stopped.name}"
  arn   = "${aws_sns_topic.ecs_events.arn}"
  input = "{ \"message\": \"Essential container in task exited\", \"account_id\": \"${data.aws_caller_identity.current.account_id}\", \"cluster\": \"${var.cluster}\"}"
}
