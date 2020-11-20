data "aws_caller_identity" "current" {}

resource "aws_security_group" "sg-elasticsearch" {
  name        = "sg_elasticsearch"
  description = "Allow access to elasticsearch service"
  vpc_id      = data.aws_vpc.main-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Elasticsearch"
    env   = var.env
    team  = var.team
  }
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "audit" {
  domain_name           = "audit"
  elasticsearch_version = "7.4"

  cluster_config {
    instance_type           = var.elasticsearch_instance_type
    instance_count          = length(data.aws_subnet.private)
    zone_awareness_enabled  = true
    zone_awareness_config {
      availability_zone_count = length(data.aws_subnet.private)
    }
  }

  vpc_options {
    subnet_ids = [for s in data.aws_subnet.private : s.id]
    security_group_ids = [aws_security_group.sg-elasticsearch.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  snapshot_options {
    automated_snapshot_start_hour = 00
  }

  tags = {
    Domain = "Audit"
  }

  depends_on = [
    aws_iam_service_linked_role.es,
  ]
}

resource "aws_elasticsearch_domain_policy" "elasticsearch-policy_audit" {
  domain_name = aws_elasticsearch_domain.audit.domain_name

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${aws_elasticsearch_domain.audit.domain_name}/*"
    }
  ]
}
POLICY
}