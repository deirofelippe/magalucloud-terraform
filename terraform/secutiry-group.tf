data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "mgc_network_security_groups" "this" {
  name        = "mgc-network-security-group"
  description = "MGC Network Security Group"
}

resource "mgc_network_security_groups_rules" "allow_ingress_ssh" {
  depends_on        = [mgc_network_security_groups.this]
  description       = "Permite tráfego SSH de entrada somente do meu IP"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "${trimspace(data.http.my_ip.response_body)}/32"
  security_group_id = mgc_network_security_groups.this.id
}

resource "mgc_network_security_groups_rules" "allow_ingress_http" {
  depends_on        = [mgc_network_security_groups.this]
  description       = "Permite tráfego HTTP de entrada para todos os IPs"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.this.id
}

resource "mgc_network_security_groups_rules" "allow_egress_http" {
  depends_on        = [mgc_network_security_groups.this]
  description       = "Permite tráfego HTTP de saída"
  direction         = "egress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.this.id
}

resource "mgc_network_security_groups_rules" "allow_ingress_app" {
  depends_on        = [mgc_network_security_groups.this]
  description       = "Permite tráfego do App de entrada"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 3000
  port_range_max    = 3000
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.this.id
}
