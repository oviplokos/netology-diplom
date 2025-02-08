variable "cloud_id" {
  description = "ID облака"
  type        = string
  default     = "b1g7ap6c3mqfb35ap85v"
}
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
  default     = "y0__wgBEM_W6psHGMHdEyC--ZuIEjOsfpwQGlDxBbLrDHhnyD7bBaif"
}
variable "folder_id" {
  description = "ID папки"
  type        = string
  default     = "b1g8rmgv6c5417m3479h"
}

# variable "service_account_key_file" {
#   description = "Путь к файлу ключа сервисного аккаунта"
#   type        = string
# }
variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH ключу"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vpc_name" {
  description = "Имя виртуальной сети"
  type        = string
  default     = "vpc"
}

variable "subnet_public_name" {
  description = "Имя публичной подсети"
  type        = string
  default     = "public"
}

variable "subnet_private_name" {
  description = "Имя приватной подсети"
  type        = string
  default     = "private"
}
variable "default_zone" {
  default = "ru-central1-a"
}
