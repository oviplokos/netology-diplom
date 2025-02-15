  provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.token
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "bucket-donets-2025"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  }
