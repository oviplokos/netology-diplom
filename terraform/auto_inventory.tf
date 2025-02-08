resource "local_file" "hosts_cfg" {
  content = templatefile("inventory.tftpl",
    {
      k8s-master   = yandex_compute_instance.master
      k8s-worker-1 = yandex_compute_instance.worker-1
      k8s-worker-2 = yandex_compute_instance.worker-2
      bastion-nat  = yandex_compute_instance.bastion-nat
  })

  filename = "../ansible/hosts.yaml"
}
