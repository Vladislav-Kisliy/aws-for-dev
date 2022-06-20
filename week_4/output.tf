output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "nat_ec2_ip" {
  value = ["${aws_instance.public_nat_instance.*.public_ip}"]
  description = "EC2 public ip address"
}

output "elb_dns" {
  value = ["${aws_elb.web_elb.dns_name}"]
  description = "DNS name of load balancer"
}