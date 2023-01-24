variable "yandex_token" {}
variable "yandex_cloud_id" {}
variable "yandex_folder_id" {}

variable "public_ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
  type    = string
}
