terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "confy"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "Nizuri"
    }
  }
}
# An example resource that does nothing.
resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing! - test trigger"
  }
}
data "aws_iam_role" "ecr" {
  name = "ecr"
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace              = "eg"
  stage                  = "test"
  name                   = "ecr"
  principals_full_access = [data.aws_iam_role.ecr.arn]
}
