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

resource "aws_ecr_repository" "nizuri" {
  name                 = "nizuri"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}