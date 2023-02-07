locals {
  workspace = "${terraform.workspace}"

  name = {
    stage = "stage"
    prod  = "prod"
  }

  networks = [
    {
      name      = "a"
      zone_name = "ru-central1-a"
      subnet    = ["10.0.10.0/24"]
    },
    {
      name      = "b"
      zone_name = "ru-central1-b"
      subnet    = ["10.0.20.0/24"]
    },
    {
      name      = "c"
      zone_name = "ru-central1-c"
      subnet    = ["10.0.30.0/24"]
    }
  ]
}


locals {
  # Определяем параметры будущих кластеров k8s в зависимости от текущего workspace
  k8s = {
    image_id    = var.yc_image_id
    preemptible = false
    disk_type   = "network-hdd"
    platform_id = "standard-v3"
    stage = {
      controls = {
        count         = 1
        cpu           = 2
        memory        = 4
        core_fraction = 20
        disk_size     = 20
      }
      workers = {
        count         = 3
        cpu           = 2
        memory        = 4
        core_fraction = 20
        disk_size     = 20
      }
    }
    prod = {
        controls = {
          count         = 3
          cpu           = 4
          memory        = 4
          core_fraction = 20
          disk_size     = 20
        }
        workers = {
          count         = 3
          cpu           = 2
          memory        = 2
          core_fraction = 20
          disk_size     = 15
        }
      }
    }
}




locals {
  # Определяем параметры будущих хостов cicd 
  cicd = {
    image_id    = var.yc_image_id_cicd
    preemptible = false
    disk_type   = "network-hdd"
    platform_id = "standard-v3"
    stage = {
      master = {
        count         = 1
        cpu           = 2
        memory        = 4
        core_fraction = 20
        disk_size     = 20
      }
      agent = {
        count         = 1
        cpu           = 2
        memory        = 4
        core_fraction = 20
        disk_size     = 20
      }
    }
    prod = {
        master = {
          count         = 0
          cpu           = 4
          memory        = 4
          core_fraction = 20
          disk_size     = 20
        }
        agent = {
          count         = 0
          cpu           = 2
          memory        = 2
          core_fraction = 20
          disk_size     = 15
        }
      }
    }
}
