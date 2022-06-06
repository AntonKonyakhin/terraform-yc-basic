variable "yc_zone" {
  description = "yandex cloud zone"
  type = string
  default = "ru-central1-a"
}

variable "yc_folder_id"{
  description = "folder_id"
  type = string
  default = "b1gtus05hgmcr750cbi3"
}
variable "image_id" {
  description = "image id"
  type = string
  default = "fd8hjvnsltkcdeqjom1n"
}

variable "subnet_1" {
  description = "subnet"
  type = tuple([string])
  default = ["192.168.10.0/24"]
}

variable count_format { default = "%01d" }

variable count_offset { default = 0 } 
