/**
 * The dns module creates a local route53 zone that serves
 * as a service discovery utility. For example a service
 * resource with the name `auth` and a dns module
 * with the name `internal`, the service address will be `se-mobile-api.internal`.
 *
 * Usage:
 *
 *    module "dns" {
 *      source = "../dns"
 *      name   = "internal"
 *    }
 *
 */

resource "aws_route53_zone" "main" {
  name    = "${var.name}"
  vpc_id  = "${var.vpc_id}"
  comment = "${var.comment}"
}
