terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84.0"
    }
  }
}

variable "yandex_token" {}
variable "yandex_cloud_id" {}
variable "yandex_folder_id" {}

variable "public_ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
  type    = string
}

provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "web1" {
  name        = "web1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ueg1g3ifoelgdaqhb" # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key_path)}"
  }
}

resource "yandex_compute_instance" "web2" {
  name        = "web2"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ueg1g3ifoelgdaqhb" # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key_path)}"
  }
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ueg1g3ifoelgdaqhb" # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "ubuntu:${file(var.public_ssh_key_path)}"
    serial-port-enable = 1
  }
}

resource "yandex_vpc_network" "main_network" {}

resource "yandex_vpc_subnet" "main_subnet" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main_network.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_lb_target_group" "main_target_group" {
  name      = "main-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    address   = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    address   = yandex_compute_instance.web2.network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "main_load_balancer" {
  name = "main-load-balancer"

  listener {
    name = "main-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.main_target_group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "webservers" {
  value = [
    yandex_compute_instance.web1,
    yandex_compute_instance.web2
  ]
}

output "bastion" {
  value = yandex_compute_instance.bastion
}
