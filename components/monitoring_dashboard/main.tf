terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.0"
}


module "monitoring" {
  source = "../../modules/monitoring"

  aws_region = "${var.aws_region}"
  cohort = "${var.cohort}"
  alarms_email = "twdu2-cia@thoughtworks.com"
}