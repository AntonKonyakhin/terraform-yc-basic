### Задача 2. Инициализируем проект и создаем воркспейсы.  
1. Выполните terraform init:  
- если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице dynamodb.
- иначе будет создан локальный файл со стейтами.

```
root@anton-v-m:~/yandex-cloud-terraform-basic# terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.75.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
root@anton-v-m:~/yandex-cloud-terraform-basic# 

```
2. Создайте два воркспейса stage и prod.

создал
```
root@anton-v-m:~/yandex-cloud-terraform-basic# terraform workspace list
  default
  prod
* stage

```

3. В уже созданный aws_instance добавьте зависимость типа инстанса от воркспейса, что бы в разных ворскспейсах использовались разные instance_type.

добавил разное колич ядер и памяти в зависимости от воркспасе

4. Добавим count. Для stage должен создаться один экземпляр ec2, а для prod два.  
добавил
```
count = local.inst_count[terraform.workspace]
```
5. Создайте рядом еще один aws_instance, но теперь определите их количество при помощи for_each, а не count.  
создал
```
resource "yandex_compute_instance" "vm-2" {
  for_each = local.instances
  name = each.key
  allow_stopping_for_update = true
  resources {
    cores  = each.value
    memory = each.value
  }

```

6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр жизненного цикла create_before_destroy = true в один из рессурсов aws_instance.  
добавил
```
  lifecycle {
    create_before_destroy = true
   # prevent_destroy = true
   }

```

В виде результата работы пришлите:

Вывод команды terraform workspace list.

```
root@anton-v-m:~/yandex-cloud-terraform-basic# terraform workspace list
  default
* prod
  stage
```

Вывод команды terraform plan для воркспейса prod.

```
root@anton-v-m:~/yandex-cloud-terraform-basic# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1[0] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-key" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiHbIlWMrbT+N71YdNXTamjmnHF0qGJDF3TR32GjY1QqWMnPKEtwcmmTFhDNjcbj2wDNim2rXfRGFGYB5i48SZGIXS514SG/0bJdyP0D6lXzZeN7FD2+9uw5gZjp39/DxtWMjJ/7AguYMVkf/75dOIY/aldZxqjwutGiWANMOx5vWGuZrL9PpnPDudWjDlOfo8fTD3aYTZeRjJtzNeSNrKyWqLBGuW3XXipvbma+rA0om25/Akr4tUAIqUwjZdLWSkJFezgZh6pmdXfAv25f6L/vLZS0JaeV4OutPg7Fn69W13HM969igE8A2WfdOZw/0wTpDoYwimkUGSPUJbfYFz5/3rCIBwsdSjXWZ+7UVWWeqfcJit0hTJyEc3CTF0cI97/YyYzihvXDO4IF4ccle1jAi8exwGkbmaOS51NCd6cL3d2jeXVPk76tG8YRkUTph7K8i6ZzW/QV8tVVzBM03BLPwkGg3OVEMt0j+C9XIowzTGl0VsUGPc/ZeyuasHobM= root@anton-v-m
            EOT
        }
      + name                      = "terraform-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8hjvnsltkcdeqjom1n"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1[1] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-key" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiHbIlWMrbT+N71YdNXTamjmnHF0qGJDF3TR32GjY1QqWMnPKEtwcmmTFhDNjcbj2wDNim2rXfRGFGYB5i48SZGIXS514SG/0bJdyP0D6lXzZeN7FD2+9uw5gZjp39/DxtWMjJ/7AguYMVkf/75dOIY/aldZxqjwutGiWANMOx5vWGuZrL9PpnPDudWjDlOfo8fTD3aYTZeRjJtzNeSNrKyWqLBGuW3XXipvbma+rA0om25/Akr4tUAIqUwjZdLWSkJFezgZh6pmdXfAv25f6L/vLZS0JaeV4OutPg7Fn69W13HM969igE8A2WfdOZw/0wTpDoYwimkUGSPUJbfYFz5/3rCIBwsdSjXWZ+7UVWWeqfcJit0hTJyEc3CTF0cI97/YyYzihvXDO4IF4ccle1jAi8exwGkbmaOS51NCd6cL3d2jeXVPk76tG8YRkUTph7K8i6ZzW/QV8tVVzBM03BLPwkGg3OVEMt0j+C9XIowzTGl0VsUGPc/ZeyuasHobM= root@anton-v-m
            EOT
        }
      + name                      = "terraform-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8hjvnsltkcdeqjom1n"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["instance-1"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-key" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiHbIlWMrbT+N71YdNXTamjmnHF0qGJDF3TR32GjY1QqWMnPKEtwcmmTFhDNjcbj2wDNim2rXfRGFGYB5i48SZGIXS514SG/0bJdyP0D6lXzZeN7FD2+9uw5gZjp39/DxtWMjJ/7AguYMVkf/75dOIY/aldZxqjwutGiWANMOx5vWGuZrL9PpnPDudWjDlOfo8fTD3aYTZeRjJtzNeSNrKyWqLBGuW3XXipvbma+rA0om25/Akr4tUAIqUwjZdLWSkJFezgZh6pmdXfAv25f6L/vLZS0JaeV4OutPg7Fn69W13HM969igE8A2WfdOZw/0wTpDoYwimkUGSPUJbfYFz5/3rCIBwsdSjXWZ+7UVWWeqfcJit0hTJyEc3CTF0cI97/YyYzihvXDO4IF4ccle1jAi8exwGkbmaOS51NCd6cL3d2jeXVPk76tG8YRkUTph7K8i6ZzW/QV8tVVzBM03BLPwkGg3OVEMt0j+C9XIowzTGl0VsUGPc/ZeyuasHobM= root@anton-v-m
            EOT
        }
      + name                      = "instance-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8hjvnsltkcdeqjom1n"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["instance-2"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-key" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiHbIlWMrbT+N71YdNXTamjmnHF0qGJDF3TR32GjY1QqWMnPKEtwcmmTFhDNjcbj2wDNim2rXfRGFGYB5i48SZGIXS514SG/0bJdyP0D6lXzZeN7FD2+9uw5gZjp39/DxtWMjJ/7AguYMVkf/75dOIY/aldZxqjwutGiWANMOx5vWGuZrL9PpnPDudWjDlOfo8fTD3aYTZeRjJtzNeSNrKyWqLBGuW3XXipvbma+rA0om25/Akr4tUAIqUwjZdLWSkJFezgZh6pmdXfAv25f6L/vLZS0JaeV4OutPg7Fn69W13HM969igE8A2WfdOZw/0wTpDoYwimkUGSPUJbfYFz5/3rCIBwsdSjXWZ+7UVWWeqfcJit0hTJyEc3CTF0cI97/YyYzihvXDO4IF4ccle1jAi8exwGkbmaOS51NCd6cL3d2jeXVPk76tG8YRkUTph7K8i6ZzW/QV8tVVzBM03BLPwkGg3OVEMt0j+C9XIowzTGl0VsUGPc/ZeyuasHobM= root@anton-v-m
            EOT
        }
      + name                      = "instance-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8hjvnsltkcdeqjom1n"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
root@anton-v-m:~/yandex-cloud-terraform-basic# 

```