#================================#
# Terraform AWS Backend Settings #
#================================#
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS Profile"
  default     = "bb-dev-deploymaster" # ci aws-iam-profile
}

#=============================#
# Project Variables           #
#=============================#
variable "project" {
  type        = string
  description = "Project Name"
  default     = "bb"
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "network-test"
}
