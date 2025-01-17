###
# Container Execution Role
###
# Role that the Amazon ECS container agent and the Docker daemon can assume
###

resource "aws_iam_role" "csp_reports_container_execution_role" {
  name               = "csp_reports_container_execution_role"
  assume_role_policy = data.aws_iam_policy_document.csp_reports_container_execution_role.json

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
    Product               = "${var.product_name}-${var.tool_name}"
  }
}

resource "aws_iam_role_policy_attachment" "csp_reports_ce_cs" {
  role       = aws_iam_role.csp_reports_container_execution_role.name
  policy_arn = data.aws_iam_policy.csp_reports_ec2_container_service.arn
}

###
# Policy Documents
###

data "aws_iam_policy_document" "csp_reports_container_execution_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "csp_reports_ec2_container_service" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "csp_reports_ecr_container_registery_policies" {
  role       = aws_iam_role.csp_reports_container_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "csp_reports_container_policies" {
  role       = aws_iam_role.csp_reports_container_execution_role.name
  policy_arn = aws_iam_policy.csp_reports_policies.arn
}
