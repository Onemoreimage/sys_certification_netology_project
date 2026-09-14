output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Public IP of bastion host"
}

output "zabbix_public_ip" {
  value       = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
  description = "Public IP of Zabbix"
}

output "kibana_public_ip" {
  value       = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
  description = "Public IP of Kibana"
}

output "alb_public_ip" {
  value       = yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Public IP of Application Load Balancer"
}

output "web_fqdn" {
  value = [
    yandex_compute_instance.web_01.fqdn,
    yandex_compute_instance.web_02.fqdn,
  ]
  description = "FQDN of web servers"
}

output "elasticsearch_fqdn" {
  value       = yandex_compute_instance.elasticsearch.fqdn
  description = "FQDN of Elasticsearch"
}