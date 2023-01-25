resource "yandex_vpc_network" "main_network" {}

resource "yandex_vpc_subnet" "main_subnet" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main_network.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}
