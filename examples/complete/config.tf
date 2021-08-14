#=============================#
# AWS Provider Settings       #
#=============================#
provider "aws" {
  region                  = var.region
  profile                 = var.profile
  shared_credentials_file = "~/.aws/${var.project}/config"
}

#=============================#
# Backend Config (partial)    #
#=============================#
terraform {
  required_version = ">= 0.14.11"

  required_providers {
    aws = "~> 3.0"
  }

}

#=============================#
# Data sources                #
#=============================#

#
# Inspection Network
#
data "terraform_remote_state" "inspection_vpc" {
  backend = "s3"

  config = {
    region  = var.region
    profile = "${var.project}-dev-deploymaster"
    #profile = "${var.project}-network-deploymaster"
    bucket = "${var.project}-network-terraform-backend"
    key    = "network/network-firewall/terraform.tfstate"
  }
}
