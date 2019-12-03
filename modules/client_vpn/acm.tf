data "aws_acm_certificate" "root" {
  domain      = "twdu-2a.training"
  types       = ["IMPORTED"]
  most_recent = true
}

data "aws_acm_certificate" "server" {
  domain      = "openvpn.twdu-2a.training"
  types       = ["IMPORTED"]
  most_recent = true
}
