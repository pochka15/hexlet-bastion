output "webservers" {
  value = [
    yandex_compute_instance.web1,
    yandex_compute_instance.web2
  ]
}

output "bastion" {
  value = yandex_compute_instance.bastion
}
