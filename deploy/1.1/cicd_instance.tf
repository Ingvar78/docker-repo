# Создаём master-ы - для cicd (отдельные инстансы)
resource "yandex_compute_instance" "cicd_master" {
  count       = local.cicd[local.workspace].master.count
  name        = "master-${local.workspace}-${count.index+1}"
  platform_id = local.cicd.platform_id
  hostname    = "master-${local.workspace}-${count.index+1}"
  zone        = local.networks[count.index - floor(count.index / length(local.networks)) * length(local.networks)].zone_name

  resources {
    cores         = local.cicd[local.workspace].master.cpu
    memory        = local.cicd[local.workspace].master.memory
    core_fraction = local.cicd[local.workspace].master.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = local.cicd.image_id
      type     = local.cicd.disk_type
      size     = local.cicd[local.workspace].master.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public[count.index - floor(count.index / length(local.networks)) * length(local.networks)].id
    nat       = true
  }

  scheduling_policy {
    preemptible = local.cicd.preemptible
  }

  metadata = {
    user-data = "${file(var.meta_file)}"
  }

}


# Создаём агенты для сборки

resource "yandex_compute_instance" "cicd_agent" {
  count       = local.cicd[local.workspace].agent.count
  name        = "agent-${local.workspace}-${count.index+1}"
  platform_id = local.cicd.platform_id
  hostname    = "agent-${local.workspace}-${count.index+1}"
  zone        = local.networks[count.index - floor(count.index / length(local.networks)) * length(local.networks)].zone_name

  resources {
    cores         = local.cicd[local.workspace].agent.cpu
    memory        = local.cicd[local.workspace].agent.memory
    core_fraction = local.cicd[local.workspace].agent.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = local.cicd.image_id
      type     = local.cicd.disk_type
      size     = local.cicd[local.workspace].agent.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public[count.index - floor(count.index / length(local.networks)) * length(local.networks)].id
    nat       = true
  }

  scheduling_policy {
    preemptible = local.k8s.preemptible
  }

  metadata = {
    user-data = "${file(var.meta_file)}"
#    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

}


output "cicd_master_nat_IP" {
  value = yandex_compute_instance.cicd_master.*.network_interface.0.nat_ip_address
}

output "cicd_master_IP" {
  value = yandex_compute_instance.cicd_master.*.network_interface.0.ip_address
}

# агенты для сборки 
output "cicd_agents_IP" {
  value = yandex_compute_instance.cicd_agent.*.network_interface.0.ip_address
}

output "cicd_agent_nat_IP" {
  value = yandex_compute_instance.cicd_agent.*.network_interface.0.nat_ip_address
}
