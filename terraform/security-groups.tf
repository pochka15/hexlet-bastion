resource "yandex_vpc_security_group" "sg_webservers" {
  name       = "sg-webservers"
  network_id = yandex_vpc_network.main_network

  ingress {
    protocol       = "TCP"
    description    = "allow ssh for bastion"
    v4_cidr_blocks = [yandex_compute_instance.bastion.network_interface.0.ip_address]
    port           = 22
  }

  # ingress {
  #   protocol       = "TCP"
  #   description    = "allow http for loadbalancer"
  #   v4_cidr_blocks = ["todo how to allow load balancer"]
  #   port           = 80
  # }

  ingress {
    protocol       = "ICMP"
    description    = "allow all ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "TCP"
    description    = "egress DNS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 53
  }

  egress {
    protocol       = "UDP"
    description    = "egress DNS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 53
  }

  egress {
    protocol       = "TCP"
    description    = "egress http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    protocol       = "TCP"
    description    = "egress https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}
