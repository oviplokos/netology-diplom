token     = ""
cloud_id  = ""
folder_id = ""

vpc_name    = "VPC-k8s"
subnet_zone = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
cidr        = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.0.0.0/24"]

master = {
  cores             = 4,
  memory            = 4,
  core_fraction     = 20,
  platform_id       = "standard-v3",
  count             = 1,
  image_id          = "fd8slhpjt2754igimqu8",
  disk_sze          = 40,
  scheduling_policy = "true"
}

worker = {
  cores             = 4,
  memory            = 4,
  core_fraction     = 20,
  platform_id       = "standard-v3",
  count             = 2,
  image_id          = "fd8slhpjt2754igimqu8",
  disk_sze          = 40,
  scheduling_policy = "true"
}

bastion = {
  cores             = 2,
  memory            = 2,
  core_fraction     = 20,
  image_id          = "fd8m30o437b5c6b9en6r",
  disk_sze          = 20,
  scheduling_policy = "true"
}
listener_grafana = {
  name        = "grafana-listener"
  port        = 80
  target_port = 31300
}

listener_web_app = {
  name        = "web-listener-app"
  port        = 80
  target_port = 30051
}
